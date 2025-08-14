use starknet::ContractAddress;

#[derive(Drop, Copy, Serde, starknet::Store)]
pub struct AutoSaveSchedule {
    pub id: u256,
    pub user: ContractAddress,
    pub save_type: u8, // 1=flexi, 2=goal, 3=group
    pub target_id: u256, // goal_id or group_id (0 for flexi)
    pub amount: u256,
    pub frequency: u8, // 1=daily, 2=weekly, 3=monthly
    pub execution_time: u64, // Time of day in seconds (0-86399)
    pub start_date: u64,
    pub end_date: u64,
    pub is_active: bool,
    pub created_at: u64,
}
