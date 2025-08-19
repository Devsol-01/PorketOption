#[starknet::contract]
pub mod AutomationScheduler {
    use openzeppelin::access::ownable::OwnableComponent;
    use openzeppelin::security::pausable::PausableComponent;
    use openzeppelin::token::erc20::{DefaultConfig, ERC20Component};
    use porketoption_contract::interfaces::iautomation_scheduler::IAutomationScheduler;
    use porketoption_contract::interfaces::isavings_vault::{
        ISavingsVaultDispatcher, ISavingsVaultDispatcherTrait,
    };
    use openzeppelin::token::erc20::interface::{IERC20Dispatcher, IERC20DispatcherTrait};
    use porketoption_contract::structs::autosave_structs::AutoSaveSchedule;
    use starknet::storage::{
        Map, StoragePathEntry, StoragePointerReadAccess, StoragePointerWriteAccess,
    };
    use starknet::{ContractAddress, get_block_timestamp, get_caller_address, get_contract_address, contract_address_const};

    component!(path: ERC20Component, storage: erc20, event: ERC20Event);
    component!(path: OwnableComponent, storage: ownable, event: OwnableEvent);
    component!(path: PausableComponent, storage: pausable, event: PausableEvent);

    #[abi(embed_v0)]
    impl OwnableMixinImpl = OwnableComponent::OwnableMixinImpl<ContractState>;

    impl OwnableInternalImpl = OwnableComponent::InternalImpl<ContractState>;

    // Pausable Mixin
    #[abi(embed_v0)]
    impl PausableImpl = PausableComponent::PausableImpl<ContractState>;

    impl PausableInternalImpl = PausableComponent::InternalImpl<ContractState>;

    #[abi(embed_v0)]
    impl ERC20MixinImpl = ERC20Component::ERC20MixinImpl<ContractState>;
    impl ERC20InternalImpl = ERC20Component::InternalImpl<ContractState>;

    #[storage]
    pub struct Storage {
        usdc_token: IERC20Dispatcher,
        savings_vault: ISavingsVaultDispatcher,
        // Automated savings schedules
        schedule_counter: u256,
        schedules: Map<u256, AutoSaveSchedule>,
        user_schedules: Map<(ContractAddress, u256), bool>,
        user_schedule_count: Map<ContractAddress, u256>,
        // Execution tracking
        last_execution: Map<u256, u64>,
        execution_failures: Map<u256, u64>,
        // Settings
        max_execution_gas: u64,
        execution_fee: u256,
        max_schedules_per_user: u256,
        // Components
        #[substorage(v0)]
        ownable: OwnableComponent::Storage,
        #[substorage(v0)]
        pausable: PausableComponent::Storage,
        #[substorage(v0)]
        erc20: ERC20Component::Storage,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        ScheduleCreated: ScheduleCreated,
        ScheduleExecuted: ScheduleExecuted,
        ScheduleFailed: ScheduleFailed,
        ScheduleUpdated: ScheduleUpdated,
        ScheduleCancelled: ScheduleCancelled,
        #[flat]
        OwnableEvent: OwnableComponent::Event,
        #[flat]
        PausableEvent: PausableComponent::Event,
        #[flat]
        ERC20Event: ERC20Component::Event,
    }

    #[derive(Drop, starknet::Event)]
    struct ScheduleCreated {
        schedule_id: u256,
        user: ContractAddress,
        save_type: u8,
        amount: u256,
        frequency: u8,
    }

    #[derive(Drop, starknet::Event)]
    struct ScheduleExecuted {
        schedule_id: u256,
        user: ContractAddress,
        amount: u256,
        timestamp: u64,
    }

    #[derive(Drop, starknet::Event)]
    struct ScheduleFailed {
        schedule_id: u256,
        user: ContractAddress,
        reason: felt252,
        timestamp: u64,
    }

    #[derive(Drop, starknet::Event)]
    struct ScheduleUpdated {
        schedule_id: u256,
        user: ContractAddress,
        new_amount: u256,
        new_frequency: u8,
    }

    #[derive(Drop, starknet::Event)]
    struct ScheduleCancelled {
        schedule_id: u256,
        user: ContractAddress,
        timestamp: u64,
    }

    #[constructor]
    fn constructor(
        ref self: ContractState, savings_vault_address: ContractAddress, owner: ContractAddress,
    ) {
        self.ownable.initializer(owner);
        self.usdc_token.write(IERC20Dispatcher{contract_address: contract_address_const::<0x053b40a647cedfca6ca84f542a0fe36736031905a9639a7f19a3c1e66bfd5080>()});
        self
            .savings_vault
            .write(ISavingsVaultDispatcher { contract_address: savings_vault_address });
        self.max_execution_gas.write(1000000); // 1M gas units
        self.execution_fee.write(1000000); // 1 USDC (6 decimals)
        self.max_schedules_per_user.write(10);
    }

    #[abi(embed_v0)]
    pub impl IAutomationSchedulerImpl of IAutomationScheduler<ContractState> {
        fn create_schedule(
            ref self: ContractState,
            save_type: u8,
            target_id: u256,
            amount: u256,
            frequency: u8,
            execution_time: u64,
            start_date: u64,
            end_date: u64,
        ) -> u256 {
            self.pausable.assert_not_paused();
            let caller = get_caller_address();

            // Validate inputs
            assert(save_type >= 1 && save_type <= 3, 'Invalid save type');
            assert(frequency >= 1 && frequency <= 3, 'Invalid frequency');
            assert(execution_time < 86400, 'Invalid execution time');
            assert(start_date <= end_date, 'Invalid date range');
            assert(amount > 0, 'Amount must be positive');

            // Check user schedule limit
            let user_count = self.user_schedule_count.entry(caller).read();
            assert(user_count < self.max_schedules_per_user.read(), 'Too many schedules');

            // Create new schedule
            let schedule_id = self.schedule_counter.read() + 1;
            self.schedule_counter.write(schedule_id);

            let schedule = AutoSaveSchedule {
                id: schedule_id,
                user: caller,
                save_type,
                target_id,
                amount,
                frequency,
                execution_time,
                start_date,
                end_date,
                is_active: true,
                created_at: get_block_timestamp(),
            };

            self.schedules.entry(schedule_id).write(schedule);
            self.user_schedules.entry((caller, schedule_id)).write(true);
            self.user_schedule_count.entry(caller).write(user_count + 1);

            self.emit(ScheduleCreated { schedule_id, user: caller, save_type, amount, frequency });

            schedule_id
        }

        fn execute_schedule(ref self: ContractState, schedule_id: u256) -> bool {
            self.pausable.assert_not_paused();

            let mut schedule = self.schedules.entry(schedule_id).read();
            assert(schedule.is_active, 'Schedule not active');

            let current_time = get_block_timestamp();
            assert(current_time >= schedule.start_date, 'Schedule not started');
            assert(current_time <= schedule.end_date, 'Schedule expired');

            // Check if execution is due
            let last_exec = self.last_execution.entry(schedule_id).read();
            let time_since_last = current_time - last_exec;
            let required_interval = self._get_frequency_interval(schedule.frequency);

            assert(time_since_last >= required_interval, 'Too early to execute');

            // Execute the savings action
            let success = self._execute_savings_action(schedule);

            if success {
                self.last_execution.entry(schedule_id).write(current_time);
                self
                    .emit(
                        ScheduleExecuted {
                            schedule_id,
                            user: schedule.user,
                            amount: schedule.amount,
                            timestamp: current_time,
                        },
                    );
            } else {
                let failures = self.execution_failures.entry(schedule_id).read();
                self.execution_failures.entry(schedule_id).write(failures + 1);
                self
                    .emit(
                        ScheduleFailed {
                            schedule_id,
                            user: schedule.user,
                            reason: 'Execution failed',
                            timestamp: current_time,
                        },
                    );
            }

            success
        }

        fn update_schedule(
            ref self: ContractState, schedule_id: u256, new_amount: u256, new_frequency: u8,
        ) {
            self.pausable.assert_not_paused();
            let caller = get_caller_address();

            let mut schedule = self.schedules.entry(schedule_id).read();
            assert(schedule.user == caller, 'Not your schedule');
            assert(schedule.is_active, 'Schedule not active');
            assert(new_frequency >= 1 && new_frequency <= 3, 'Invalid frequency');
            assert(new_amount > 0, 'Amount must be positive');

            schedule.amount = new_amount;
            schedule.frequency = new_frequency;
            self.schedules.entry(schedule_id).write(schedule);

            self.emit(ScheduleUpdated { schedule_id, user: caller, new_amount, new_frequency });
        }

        fn cancel_schedule(ref self: ContractState, schedule_id: u256) {
            self.pausable.assert_not_paused();
            let caller = get_caller_address();

            let mut schedule = self.schedules.entry(schedule_id).read();
            assert(schedule.user == caller, 'Not your schedule');
            assert(schedule.is_active, 'Schedule already cancelled');

            schedule.is_active = false;
            self.schedules.entry(schedule_id).write(schedule);

            let user_count = self.user_schedule_count.entry(caller).read();
            self.user_schedule_count.entry(caller).write(user_count - 1);

            self
                .emit(
                    ScheduleCancelled {
                        schedule_id, user: caller, timestamp: get_block_timestamp(),
                    },
                );
        }

        fn execute_batch_schedules(
            ref self: ContractState, schedule_ids: Array<u256>,
        ) -> Array<bool> {
            self.pausable.assert_not_paused();
            let mut results: Array<bool> = ArrayTrait::new();
            let mut i = 0;

            loop {
                if i >= schedule_ids.len() {
                    break;
                }

                let success = self.execute_schedule(*schedule_ids.at(i));
                results.append(success);
                i += 1;
            }

            results
        }

        fn get_due_schedules(self: @ContractState, limit: u32) -> Array<u256> {
            let current_time = get_block_timestamp();
            let mut due_schedules: Array<u256> = ArrayTrait::new();
            let mut count = 0;
            let total_schedules = self.schedule_counter.read();
            let mut schedule_id = 1;

            loop {
                if schedule_id > total_schedules || count >= limit {
                    break;
                }

                let schedule = self.schedules.entry(schedule_id).read();
                if schedule.is_active && self._is_schedule_due(schedule_id, current_time) {
                    due_schedules.append(schedule_id);
                    count += 1;
                }

                schedule_id += 1;
            }

            due_schedules
        }

        fn get_schedule(self: @ContractState, schedule_id: u256) -> AutoSaveSchedule {
            self.schedules.entry(schedule_id).read()
        }

        fn get_user_schedules(self: @ContractState, user: ContractAddress) -> Array<u256> {
            let user_count = self.user_schedule_count.entry(user).read();
            let mut schedules: Array<u256> = ArrayTrait::new();
            let total_schedules = self.schedule_counter.read();
            let mut schedule_id = 1;

            loop {
                if schedule_id > total_schedules {
                    break;
                }

                if self.user_schedules.entry((user, schedule_id)).read() {
                    schedules.append(schedule_id);
                }

                schedule_id += 1;
            }

            schedules
        }

        fn is_schedule_due(self: @ContractState, schedule_id: u256) -> bool {
            let current_time = get_block_timestamp();
            self._is_schedule_due(schedule_id, current_time)
        }

        fn get_execution_failures(self: @ContractState, schedule_id: u256) -> u64 {
            self.execution_failures.entry(schedule_id).read()
        }

        fn get_last_execution(self: @ContractState, schedule_id: u256) -> u64 {
            self.last_execution.entry(schedule_id).read()
        }

        fn set_execution_settings(
            ref self: ContractState,
            max_gas: u64,
            execution_fee: u256,
            max_schedules: u256,
        ) {
            self.ownable.assert_only_owner();
            self.max_execution_gas.write(max_gas);
            self.execution_fee.write(execution_fee);
            self.max_schedules_per_user.write(max_schedules);
        }

        fn emergency_pause_schedule(ref self: ContractState, schedule_id: u256) {
            self.ownable.assert_only_owner();
            let mut schedule = self.schedules.entry(schedule_id).read();
            schedule.is_active = false;
            self.schedules.entry(schedule_id).write(schedule);
        }

        fn withdraw_fees(ref self: ContractState, amount: u256) {
            self.ownable.assert_only_owner();
            let usdc = self.usdc_token.read();
            usdc.transfer(self.ownable.owner(), amount);
        }
    }

    impl ERC20HooksImpl of ERC20Component::ERC20HooksTrait<ContractState> {
        fn before_update(
            ref self: ERC20Component::ComponentState<ContractState>,
            from: ContractAddress,
            recipient: ContractAddress,
            amount: u256,
        ) {
            let contract_state = self.get_contract();
            contract_state.pausable.assert_not_paused();
        }
    }

    #[generate_trait]
    impl InternalFunctions of InternalFunctionsTrait {
        fn _execute_savings_action(ref self: ContractState, schedule: AutoSaveSchedule) -> bool {
            let vault = self.savings_vault.read();

            // Check user has sufficient USDC balance
            let usdc = self.usdc_token.read();
            let user_balance = usdc.balance_of(schedule.user);
            if user_balance < schedule.amount {
                return false;
            }

            // Check user has approved this contract
            let allowance = self.erc20.allowance(schedule.user, starknet::get_contract_address());
            if allowance < schedule.amount {
                return false;
            }

            // Execute the appropriate savings action
            match schedule.save_type {
                0 => {
                    // Flexi Save
                    vault.flexi_deposit(schedule.amount);
                    true
                },
                1 => {
                    // Goal Save contribution
                    vault.contribute_goal_save(schedule.target_id, schedule.amount);
                    true
                },
                2 => {
                    // Group Save contribution
                    vault.contribute_to_group_save(schedule.target_id, schedule.amount);
                    true
                },
                _ => false,
            }
        }

        fn _get_frequency_interval(self: @ContractState, frequency: u8) -> u64 {
            match frequency {
                0 => 86400, // Daily: 24 hours
                1 => 604800, // Weekly: 7 days
                2 => 2592000, // Monthly: 30 days (approximate)
                _ => 86400 // Default to daily
            }
        }

        fn _is_schedule_due(self: @ContractState, schedule_id: u256, current_time: u64) -> bool {
            let schedule = self.schedules.entry(schedule_id).read();

            if !schedule.is_active
                || current_time < schedule.start_date
                || current_time > schedule.end_date {
                return false;
            }

            let last_exec = self.last_execution.entry(schedule_id).read();
            let time_since_last = current_time - last_exec;
            let required_interval = self._get_frequency_interval(schedule.frequency);

            time_since_last >= required_interval
        }

        fn _calculate_next_execution(self: @ContractState, schedule: AutoSaveSchedule) -> u64 {
            let last_exec = self.last_execution.entry(schedule.id).read();
            let interval = self._get_frequency_interval(schedule.frequency);

            if last_exec == 0 {
                // First execution
                schedule.start_date + schedule.execution_time
            } else {
                last_exec + interval
            }
        }
    }
}
