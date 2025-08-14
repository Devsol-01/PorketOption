use starknet::ContractAddress;


#[derive(Drop, Serde, starknet::Store)]
pub struct LockSave {
    pub id: u256,
    pub user: ContractAddress,
    pub amount: u256,
    pub interest_rate: u256,
    pub lock_duration: u64,
    pub start_time: u64,
    pub maturity_time: u64,
    pub title: felt252,
    pub is_matured: bool,
    pub is_withdrawn: bool,
}

#[derive(Drop, Copy, Serde, starknet::Store)]
pub struct GoalSave {
    pub id: u256,
    pub user: ContractAddress,
    pub title: felt252,
    pub category: felt252,
    pub target_amount: u256,
    pub current_amount: u256,
    pub contribution_type: u8, // 1=daily, 2=weekly, 3=monthly, 4=manual
    pub contribution_amount: u256,
    pub start_time: u64,
    pub end_time: u64,
    pub is_completed: bool,
}

#[derive(Drop, Copy, Serde, starknet::Store)]
pub struct GroupSave {
    pub id: u256,
    pub creator: ContractAddress,
    pub title: felt252,
    pub description: felt252,
    pub category: felt252,
    pub target_amount: u256,
    pub current_amount: u256,
    pub contribution_type: u8,
    pub contribution_amount: u256,
    pub is_public: bool,
    pub member_count: u256,
    pub start_time: u64,
    pub end_time: u64,
    pub is_completed: bool,
}
