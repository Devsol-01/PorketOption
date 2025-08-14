use porketoption_contract::structs::save_structs::{GoalSave, GroupSave, LockSave};
use starknet::ContractAddress;

#[starknet::interface]
pub trait ISavingsVault<TContractState> {
    fn flexi_deposit(ref self: TContractState, amount: u256);
    fn flexi_withdraw(ref self: TContractState, amount: u256);
    fn create_lock_save(
        ref self: TContractState, amount: u256, duration: u64, title: felt252,
    ) -> u256;
    fn withdraw_lock_save(ref self: TContractState, lock_id: u256);
    fn create_goal_save(
        ref self: TContractState,
        title: felt252,
        category: felt252,
        target_amount: u256,
        contribution_type: u8,
        contribution_amount: u256,
        end_time: u64,
    ) -> u256;
    fn contribute_goal_save(ref self: TContractState, goal_id: u256, amount: u256);
    fn create_group_save(
        ref self: TContractState,
        title: felt252,
        description: felt252,
        category: felt252,
        target_amount: u256,
        contribution_type: u8,
        contribution_amount: u256,
        is_public: bool,
        end_time: u64,
    ) -> u256;
    fn join_group_save(ref self: TContractState, group_id: u256);
    fn contribute_to_group_save(ref self: TContractState, group_id: u256, amount: u256);
    fn get_flexi_balance(self: @TContractState, user: ContractAddress) -> u256;
    fn get_lock_save(self: @TContractState, lock_id: u256) -> LockSave;
    fn get_goal_save(self: @TContractState, goal_id: u256) -> GoalSave;
    fn get_group_save(self: @TContractState, group_id: u256) -> GroupSave;
    fn get_user_total_deposits(self: @TContractState, user: ContractAddress) -> u256;
    fn get_user_total_interest(self: @TContractState, user: ContractAddress) -> u256;
    fn get_user_savings_streak(self: @TContractState, user: ContractAddress) -> u64;
    fn get_lock_save_rate(self: @TContractState, duration_days: u64) -> u256;
    fn get_flexi_save_rate(self: @TContractState) -> u256;
    fn get_goal_save_rate(self: @TContractState) -> u256;
    fn get_group_save_rate(self: @TContractState) -> u256;
    fn is_group_member(self: @TContractState, group_id: u256, user: ContractAddress) -> bool;
    fn get_group_member_contribution(
        self: @TContractState, group_id: u256, user: ContractAddress,
    ) -> u256;
    fn calculate_lock_save_maturity(self: @TContractState, lock_id: u256) -> (u256, u256);
    fn set_interest_rates(
        ref self: TContractState, flexi_rate: u256, goal_rate: u256, group_rate: u256,
    );
    fn set_lock_save_rate(ref self: TContractState, duration_days: u64, rate: u256);
    fn set_platform_settings(
        ref self: TContractState, minimum_deposit: u256, withdrawal_fee: u256, platform_fee: u256,
    );
    fn emergency_pause(ref self: TContractState);
    fn emergency_unpause(ref self: TContractState);
    fn emergency_withdraw(ref self: TContractState, amount: u256);
}
