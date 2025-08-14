use porketoption_contract::structs::autosave_structs::AutoSaveSchedule;
use starknet::ContractAddress;

#[starknet::interface]
pub trait IAutomationScheduler<TContractState> {
    // Schedule management
    fn create_schedule(
        ref self: TContractState,
        save_type: u8,
        target_id: u256,
        amount: u256,
        frequency: u8,
        execution_time: u64,
        start_date: u64,
        end_date: u64,
    ) -> u256;
    fn execute_schedule(ref self: TContractState, schedule_id: u256) -> bool;
    fn update_schedule(
        ref self: TContractState, schedule_id: u256, new_amount: u256, new_frequency: u8,
    );
    fn cancel_schedule(ref self: TContractState, schedule_id: u256);
    // Batch operations
    fn execute_batch_schedules(ref self: TContractState, schedule_ids: Array<u256>) -> Array<bool>;
    fn get_due_schedules(self: @TContractState, limit: u32) -> Array<u256>;
    // View functions
    fn get_schedule(self: @TContractState, schedule_id: u256) -> AutoSaveSchedule;
    fn get_user_schedules(self: @TContractState, user: ContractAddress) -> Array<u256>;
    fn is_schedule_due(self: @TContractState, schedule_id: u256) -> bool;
    fn get_execution_failures(self: @TContractState, schedule_id: u256) -> u64;
    fn get_last_execution(self: @TContractState, schedule_id: u256) -> u64;
    // Admin functions
fn set_execution_settings(
    ref self: TContractState, max_gas: u64, execution_fee: u256, max_schedules: u256,
);
fn emergency_pause_schedule(ref self: TContractState, schedule_id: u256);
fn withdraw_fees(ref self: TContractState, amount: u256);
}
