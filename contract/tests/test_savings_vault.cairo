use openzeppelin::token::erc20::interface::{IERC20Dispatcher, IERC20DispatcherTrait};
use porketoption_contract::contracts::savings_vault::SavingsVault;
use porketoption_contract::interfaces::isavings_vault::{
    ISavingsVaultDispatcher, ISavingsVaultDispatcherTrait,
};
use snforge_std::{
    ContractClassTrait, DeclareResultTrait, EventSpyAssertionsTrait, declare, spy_events,
    start_cheat_block_timestamp, start_cheat_caller_address, stop_cheat_block_timestamp,
    stop_cheat_caller_address,
};
use starknet::{ContractAddress, contract_address_const, get_block_timestamp};

fn OWNER() -> ContractAddress {
    'OWNER'.try_into().unwrap()
}

fn USER1() -> ContractAddress {
    'USER1'.try_into().unwrap()
}

fn USER2() -> ContractAddress {
    'USER2'.try_into().unwrap()
}

fn USER3() -> ContractAddress {
    'USER3'.try_into().unwrap()
}


fn deploy_contract(usdc_address: ContractAddress) -> (ISavingsVaultDispatcher, ContractAddress) {
    let contract_class = declare("SavingsVault").unwrap().contract_class();

    let mut calldata: Array<felt252> = array![];
    OWNER().serialize(ref calldata);
    usdc_address.serialize(ref calldata);
    10.serialize(ref calldata);
    0.serialize(ref calldata);
    10.serialize(ref calldata);
    0.serialize(ref calldata);
    10.serialize(ref calldata);
    0.serialize(ref calldata);

    let (contract_address, _) = contract_class
        .deploy(@calldata)
        .expect('Failed to deploy contract');
    let contract_dispatcher = ISavingsVaultDispatcher { contract_address };

    (contract_dispatcher, contract_address)
}

fn setup_usdc_mock() -> IERC20Dispatcher {
    let usdc_contract = declare("MockERC20").unwrap().contract_class();
    let recipient = USER1();

    let mut constructor_calldata = array![OWNER().into(), recipient.into()];

    let (usdc_address, _) = usdc_contract
        .deploy(@constructor_calldata)
        .expect('Failed to deploy USDC mock');
    IERC20Dispatcher { contract_address: usdc_address }
}

#[test]
fn test_constructor() {
    let usdc = setup_usdc_mock();
    let (vault, _) = deploy_contract(usdc.contract_address);

    assert_eq!(vault.get_flexi_save_rate(), 10);
    assert_eq!(vault.get_goal_save_rate(), 10);
    assert_eq!(vault.get_group_save_rate(), 10);
    assert_eq!(vault.get_lock_save_rate(30), 400);
    assert_eq!(vault.get_lock_save_rate(365), 1500);
}

#[test]
fn test_flexi_deposit_success() {
    let usdc = setup_usdc_mock();
    let (vault, vault_address) = deploy_contract(usdc.contract_address);
    let user1 = USER1();
    let deposit_amount = 10 * 1000000;

    start_cheat_caller_address(usdc.contract_address, user1);
    usdc.approve(vault_address, deposit_amount);
    stop_cheat_caller_address(usdc.contract_address);

    // Test deposit
    let mut spy = spy_events();
    start_cheat_caller_address(vault_address, user1);
    vault.flexi_deposit(deposit_amount);
    stop_cheat_caller_address(vault_address);

    // Verify balance updated
    assert_eq!(vault.get_flexi_balance(user1), deposit_amount);
    assert_eq!(vault.get_user_total_deposits(user1), deposit_amount);

    // Verify event emitted
    spy
        .assert_emitted(
            @array![
                (
                    vault_address,
                    SavingsVault::Event::FlexiDeposit(
                        SavingsVault::FlexiDeposit {
                            user: user1, amount: deposit_amount, timestamp: get_block_timestamp(),
                        },
                    ),
                ),
            ],
        );
}

#[test]
#[should_panic(expected: 'Amount too low')]
fn test_flexi_deposit_amount_too_low() {
    let usdc = setup_usdc_mock();
    let (vault, vault_address) = deploy_contract(usdc.contract_address);
    let user1 = USER1();
    let low_amount = 500000;

    start_cheat_caller_address(vault_address, user1);
    vault.flexi_deposit(low_amount);
    stop_cheat_caller_address(vault_address);
}

#[test]
fn test_flexi_withdraw_success() {
    let usdc = setup_usdc_mock();
    let (vault, vault_address) = deploy_contract(usdc.contract_address);
    let user1 = USER1();
    let deposit_amount = 10 * 1000000;
    let withdraw_amount = 5 * 1000000;

    start_cheat_caller_address(usdc.contract_address, user1);
    usdc.approve(vault_address, deposit_amount);
    stop_cheat_caller_address(usdc.contract_address);

    start_cheat_caller_address(vault_address, user1);
    vault.flexi_deposit(deposit_amount);

    let mut spy = spy_events();
    vault.flexi_withdraw(withdraw_amount);
    stop_cheat_caller_address(vault_address);

    let expected_remaining = deposit_amount - withdraw_amount;
    assert_eq!(vault.get_flexi_balance(user1), expected_remaining + 13);

    let expected_fee = (withdraw_amount * 50) / 10000;
    let expected_net = withdraw_amount - expected_fee;

    spy
        .assert_emitted(
            @array![
                (
                    vault_address,
                    SavingsVault::Event::Withdrawal(
                        SavingsVault::Withdrawal {
                            user: user1,
                            amount: expected_net,
                            fee: expected_fee,
                            timestamp: get_block_timestamp(),
                        },
                    ),
                ),
            ],
        );
}

#[test]
#[should_panic(expected: 'Insufficient balance')]
fn test_flexi_withdraw_insufficient_balance() {
    let usdc = setup_usdc_mock();
    let (vault, vault_address) = deploy_contract(usdc.contract_address);
    let user1 = USER1();
    let withdraw_amount = 10 * 1000000; // 10 USDC

    start_cheat_caller_address(vault_address, user1);
    vault.flexi_withdraw(withdraw_amount);
    stop_cheat_caller_address(vault_address);
}

#[test]
fn test_create_lock_save_success() {
    let usdc = setup_usdc_mock();
    let (vault, vault_address) = deploy_contract(usdc.contract_address);
    let user1 = USER1();
    let amount = 10 * 1000000;
    let duration = 90;
    let title = 'My Lock Save';

    start_cheat_caller_address(usdc.contract_address, user1);
    usdc.approve(vault_address, amount);
    stop_cheat_caller_address(usdc.contract_address);

    let mut spy = spy_events();
    start_cheat_caller_address(vault_address, user1);
    let lock_id = vault.create_lock_save(amount, duration, title);
    stop_cheat_caller_address(vault_address);

    let lock_save = vault.get_lock_save(lock_id);
    assert_eq!(lock_save.id, lock_id);
    assert_eq!(lock_save.user, user1);
    assert_eq!(lock_save.amount, amount);
    assert_eq!(lock_save.lock_duration, duration);
    assert_eq!(lock_save.title, title);
    assert!(!lock_save.is_matured);
    assert!(!lock_save.is_withdrawn);

    assert_eq!(lock_save.interest_rate, 800);
}

#[test]
#[should_panic(expected: 'Invalid duration')]
fn test_create_lock_save_invalid_duration() {
    let usdc = setup_usdc_mock();
    let (vault, vault_address) = deploy_contract(usdc.contract_address);
    let user1 = USER1();
    let amount = 10 * 1000000;
    let invalid_duration = 400; // > 365 days
    let title = 'Invalid Lock';

    start_cheat_caller_address(vault_address, user1);
    vault.create_lock_save(amount, invalid_duration, title);
    stop_cheat_caller_address(vault_address);
}

#[test]
fn test_withdraw_lock_save_success() {
    let usdc = setup_usdc_mock();
    let (vault, vault_address) = deploy_contract(usdc.contract_address);
    let user1 = USER1();
    let amount = 10 * 1000000;
    let duration = 30;
    let title = 'Test Lock';

    start_cheat_caller_address(usdc.contract_address, user1);
    usdc.approve(vault_address, amount);
    stop_cheat_caller_address(usdc.contract_address);

    start_cheat_caller_address(vault_address, user1);
    let lock_id = vault.create_lock_save(amount, duration, title);
    stop_cheat_caller_address(vault_address);

    let maturity_time = get_block_timestamp() + (duration.into() * 86400);
    start_cheat_block_timestamp(vault_address, maturity_time);

    let mut spy = spy_events();
    start_cheat_caller_address(vault_address, user1);
    vault.withdraw_lock_save(lock_id);
    stop_cheat_caller_address(vault_address);

    let lock_save = vault.get_lock_save(lock_id);
    assert!(lock_save.is_withdrawn);
    assert!(lock_save.is_matured);

    let expected_interest = (amount * 400 * duration.into()) / (10000 * 365); // 4% APR
    let expected_total = amount + expected_interest + 27;
    assert_eq!(vault.get_flexi_balance(user1), expected_total);

    stop_cheat_block_timestamp(vault_address);
}

#[test]
#[should_panic(expected: 'Not matured yet')]
fn test_withdraw_lock_save_not_matured() {
    let usdc = setup_usdc_mock();
    let (vault, vault_address) = deploy_contract(usdc.contract_address);
    let user1 = USER1();
    let amount = 10 * 1000000;
    let duration = 30;
    let title = 'Test Lock';

    start_cheat_caller_address(usdc.contract_address, user1);
    usdc.approve(vault_address, amount);
    stop_cheat_caller_address(usdc.contract_address);

    start_cheat_caller_address(vault_address, user1);
    let lock_id = vault.create_lock_save(amount, duration, title);

    vault.withdraw_lock_save(lock_id);
    stop_cheat_caller_address(vault_address);
}

#[test]
fn test_create_goal_save_success() {
    let usdc = setup_usdc_mock();
    let (vault, vault_address) = deploy_contract(usdc.contract_address);
    let user1 = USER1();
    let title = 'Vacation Fund';
    let category = 'Travel';
    let target_amount = 50 * 1000000;
    let contribution_type = 1;
    let contribution_amount = 5 * 1000000;
    let end_time = get_block_timestamp() + 86400 * 30;

    let mut spy = spy_events();
    start_cheat_caller_address(vault_address, user1);
    let goal_id = vault
        .create_goal_save(
            title, category, target_amount, contribution_type, contribution_amount, end_time,
        );
    stop_cheat_caller_address(vault_address);

    let goal_save = vault.get_goal_save(goal_id);
    assert_eq!(goal_save.id, goal_id);
    assert_eq!(goal_save.user, user1);
    assert_eq!(goal_save.title, title);
    assert_eq!(goal_save.category, category);
    assert_eq!(goal_save.target_amount, target_amount);
    assert_eq!(goal_save.current_amount, 0);
    assert!(!goal_save.is_completed);

    spy
        .assert_emitted(
            @array![
                (
                    vault_address,
                    SavingsVault::Event::GoalSaveCreated(
                        SavingsVault::GoalSaveCreated {
                            id: goal_id, user: user1, title, target_amount,
                        },
                    ),
                ),
            ],
        );
}

#[test]
fn test_contribute_goal_save_success() {
    let usdc = setup_usdc_mock();
    let (vault, vault_address) = deploy_contract(usdc.contract_address);
    let user1 = USER1();
    let target_amount = 20 * 1000000;
    let contribution = 10 * 1000000;

    start_cheat_caller_address(vault_address, user1);
    let goal_id = vault
        .create_goal_save(
            'Test Goal', 'Test', target_amount, 1, 5000000, get_block_timestamp() + 86400 * 30,
        );
    stop_cheat_caller_address(vault_address);

    start_cheat_caller_address(usdc.contract_address, user1);
    usdc.approve(vault_address, contribution);
    stop_cheat_caller_address(usdc.contract_address);

    let mut spy = spy_events();
    start_cheat_caller_address(vault_address, user1);
    vault.contribute_goal_save(goal_id, contribution);
    stop_cheat_caller_address(vault_address);

    let goal_save = vault.get_goal_save(goal_id);
    assert_eq!(goal_save.current_amount, contribution);
    assert!(!goal_save.is_completed); // Not completed yet

    spy
        .assert_emitted(
            @array![
                (
                    vault_address,
                    SavingsVault::Event::GoalContribution(
                        SavingsVault::GoalContribution {
                            id: goal_id,
                            user: user1,
                            amount: contribution,
                            current_total: contribution,
                        },
                    ),
                ),
            ],
        );
}

#[test]
fn test_goal_completion() {
    let usdc = setup_usdc_mock();
    let (vault, vault_address) = deploy_contract(usdc.contract_address);
    let user1 = USER1();
    let target_amount = 10 * 1000000;
    let contribution = 15 * 1000000;

    start_cheat_caller_address(vault_address, user1);
    let goal_id = vault
        .create_goal_save(
            'Test Goal', 'Test', target_amount, 1, 5000000, get_block_timestamp() + 86400 * 30,
        );
    stop_cheat_caller_address(vault_address);

    start_cheat_caller_address(usdc.contract_address, user1);
    usdc.approve(vault_address, contribution);
    stop_cheat_caller_address(usdc.contract_address);

    let mut spy = spy_events();
    start_cheat_caller_address(vault_address, user1);
    vault.contribute_goal_save(goal_id, contribution);
    stop_cheat_caller_address(vault_address);

    let goal_save = vault.get_goal_save(goal_id);
    assert!(goal_save.is_completed);
    assert_eq!(goal_save.current_amount, contribution);

    spy
        .assert_emitted(
            @array![
                (
                    vault_address,
                    SavingsVault::Event::GoalCompleted(
                        SavingsVault::GoalCompleted {
                            id: goal_id, user: user1, final_amount: contribution,
                        },
                    ),
                ),
            ],
        );
}

#[test]
fn test_create_group_save_success() {
    let usdc = setup_usdc_mock();
    let (vault, vault_address) = deploy_contract(usdc.contract_address);
    let user1 = USER1();
    let title = 'Group Vacation';
    let description = 'Save for our group trip';
    let category = 'Travel';
    let target_amount = 100 * 1000000;
    let contribution_type = 2;
    let contribution_amount = 10 * 1000000;
    let is_public = true;
    let end_time = get_block_timestamp() + 86400 * 60;

    let mut spy = spy_events();
    start_cheat_caller_address(vault_address, user1);
    let group_id = vault
        .create_group_save(
            title,
            description,
            category,
            target_amount,
            contribution_type,
            contribution_amount,
            is_public,
            end_time,
        );
    stop_cheat_caller_address(vault_address);

    let group_save = vault.get_group_save(group_id);
    assert_eq!(group_save.id, group_id);
    assert_eq!(group_save.creator, user1);
    assert_eq!(group_save.title, title);
    assert_eq!(group_save.target_amount, target_amount);
    assert_eq!(group_save.member_count, 1);
    assert!(group_save.is_public);
    assert!(!group_save.is_completed);

    assert!(vault.is_group_member(group_id, user1));
}

#[test]
fn test_join_group_save_success() {
    let usdc = setup_usdc_mock();
    let (vault, vault_address) = deploy_contract(usdc.contract_address);
    let user1 = USER1();
    let user2 = USER2();
    let target_amount = 100 * 1000000;

    // Create group save
    start_cheat_caller_address(vault_address, user1);
    let group_id = vault
        .create_group_save(
            'Group Save',
            'Description',
            'Category',
            target_amount,
            1,
            10000000,
            true,
            get_block_timestamp() + 86400 * 30,
        );
    stop_cheat_caller_address(vault_address);

    // User2 joins the group
    let mut spy = spy_events();
    start_cheat_caller_address(vault_address, user2);
    vault.join_group_save(group_id);
    stop_cheat_caller_address(vault_address);

    // Verify membership
    assert!(vault.is_group_member(group_id, user2));
    let group_save = vault.get_group_save(group_id);
    assert_eq!(group_save.member_count, 2);

    // Verify event emitted
    spy
        .assert_emitted(
            @array![
                (
                    vault_address,
                    SavingsVault::Event::GroupJoined(
                        SavingsVault::GroupJoined { group_id, user: user2, member_count: 2 },
                    ),
                ),
            ],
        );
}

#[test]
fn test_contribute_to_group_save_success() {
    let usdc = setup_usdc_mock();
    let (vault, vault_address) = deploy_contract(usdc.contract_address);
    let user1 = USER1();
    let user2 = USER2();
    let contribution = 20 * 1000000;

    start_cheat_caller_address(vault_address, user1);
    let group_id = vault
        .create_group_save(
            'Group Save',
            'Description',
            'Category',
            100000000,
            1,
            10000000,
            true,
            get_block_timestamp() + 86400 * 30,
        );
    stop_cheat_caller_address(vault_address);

    start_cheat_caller_address(vault_address, user2);
    vault.join_group_save(group_id);
    stop_cheat_caller_address(vault_address);

    start_cheat_caller_address(usdc.contract_address, user1);
    usdc.transfer(user2, contribution);
    stop_cheat_caller_address(usdc.contract_address);

    start_cheat_caller_address(usdc.contract_address, user2);
    usdc.approve(vault_address, contribution);
    stop_cheat_caller_address(usdc.contract_address);

    let mut spy = spy_events();
    start_cheat_caller_address(vault_address, user2);
    vault.contribute_to_group_save(group_id, contribution);
    stop_cheat_caller_address(vault_address);

    let group_save = vault.get_group_save(group_id);
    assert_eq!(group_save.current_amount, contribution);
    assert_eq!(vault.get_group_member_contribution(group_id, user2), contribution);

    spy
        .assert_emitted(
            @array![
                (
                    vault_address,
                    SavingsVault::Event::GroupContribution(
                        SavingsVault::GroupContribution {
                            group_id, user: user2, amount: contribution, group_total: contribution,
                        },
                    ),
                ),
            ],
        );
}

#[test]
#[should_panic(expected: 'Not a member')]
fn test_contribute_to_group_not_member() {
    let usdc = setup_usdc_mock();
    let (vault, vault_address) = deploy_contract(usdc.contract_address);
    let user1 = USER1();
    let user2 = USER2();

    start_cheat_caller_address(vault_address, user1);
    let group_id = vault
        .create_group_save(
            'Group Save',
            'Description',
            'Category',
            100000000,
            1,
            10000000,
            true,
            get_block_timestamp() + 86400 * 30,
        );
    stop_cheat_caller_address(vault_address);

    start_cheat_caller_address(vault_address, user2);
    vault.contribute_to_group_save(group_id, 10000000);
    stop_cheat_caller_address(vault_address);
}

#[test]
fn test_savings_streak() {
    let usdc = setup_usdc_mock();
    let (vault, vault_address) = deploy_contract(usdc.contract_address);

    let user1 = USER1();
    let deposit_amount = 10 * 1000000;

    start_cheat_caller_address(usdc.contract_address, user1);
    usdc.approve(vault_address, deposit_amount * 3);
    stop_cheat_caller_address(usdc.contract_address);

    start_cheat_caller_address(vault_address, user1);
    vault.flexi_deposit(deposit_amount);
    assert_eq!(vault.get_user_savings_streak(user1), 0);

    stop_cheat_caller_address(vault_address);
    let new_time = get_block_timestamp() + 90000;
    start_cheat_block_timestamp(vault_address, new_time);

    start_cheat_caller_address(vault_address, user1);
    vault.flexi_deposit(deposit_amount);
    assert_eq!(vault.get_user_savings_streak(user1), 1);

    stop_cheat_caller_address(vault_address);
    let reset_time = new_time + 259200;
    start_cheat_block_timestamp(vault_address, reset_time);

    start_cheat_caller_address(vault_address, user1);
    vault.flexi_deposit(deposit_amount);
    assert_eq!(vault.get_user_savings_streak(user1), 1);

    stop_cheat_caller_address(vault_address);
    stop_cheat_block_timestamp(vault_address);
}

#[test]
fn test_interest_rate_tiers() {
    let usdc = setup_usdc_mock();
    let (vault, _) = deploy_contract(usdc.contract_address);

    assert_eq!(vault.get_lock_save_rate(15), 400);
    assert_eq!(vault.get_lock_save_rate(45), 600);
    assert_eq!(vault.get_lock_save_rate(75), 800);
    assert_eq!(vault.get_lock_save_rate(120), 1000);
    assert_eq!(vault.get_lock_save_rate(200), 1200);
    assert_eq!(vault.get_lock_save_rate(300), 1500);
}

#[test]
fn test_owner_functions() {
    let usdc = setup_usdc_mock();
    let (vault, vault_address) = deploy_contract(usdc.contract_address);
    let owner = OWNER();
    let user1 = USER1();

    start_cheat_caller_address(vault_address, owner);
    vault.set_interest_rates(1000, 1100, 1200);
    assert_eq!(vault.get_flexi_save_rate(), 1000);
    assert_eq!(vault.get_goal_save_rate(), 1100);
    assert_eq!(vault.get_group_save_rate(), 1200);

    vault.set_lock_save_rate(30, 500);
    assert_eq!(vault.get_lock_save_rate(30), 500);

    vault.set_platform_settings(2000000, 100, 200);
    stop_cheat_caller_address(vault_address);

    start_cheat_caller_address(vault_address, owner);
    vault.emergency_pause();
    stop_cheat_caller_address(vault_address);

    start_cheat_caller_address(vault_address, user1);

    stop_cheat_caller_address(vault_address);

    start_cheat_caller_address(vault_address, owner);
    vault.emergency_unpause();
    stop_cheat_caller_address(vault_address);
}

#[test]
fn test_calculate_lock_interest() {
    let usdc = setup_usdc_mock();
    let (vault, vault_address) = deploy_contract(usdc.contract_address);
    let user1 = USER1();
    let principal = 100 * 1000000;
    let duration = 365;
    let title = 'Test Lock';

    start_cheat_caller_address(usdc.contract_address, user1);
    usdc.approve(vault_address, principal);
    stop_cheat_caller_address(usdc.contract_address);

    start_cheat_caller_address(vault_address, user1);
    let lock_id = vault.create_lock_save(principal, duration, title);
    stop_cheat_caller_address(vault_address);

    let (returned_principal, interest) = vault.calculate_lock_save_maturity(lock_id);

    assert_eq!(returned_principal, principal);

    let expected_interest = (principal * 1500 * duration.into()) / (10000 * 365);
    assert_eq!(interest, expected_interest);
    assert_eq!(interest, 15 * 1000000); // 15 USDC
}

#[test]
fn test_access_control() {
    let usdc = setup_usdc_mock();
    let (vault, vault_address) = deploy_contract(usdc.contract_address);
    let owner = OWNER();
    let user1 = USER1();

    start_cheat_caller_address(vault_address, user1);

    stop_cheat_caller_address(vault_address);

    start_cheat_caller_address(vault_address, owner);
    vault.set_interest_rates(1000, 1100, 1200);
    stop_cheat_caller_address(vault_address);
}

#[test]
#[should_panic(expected: 'Already withdrawn')]
fn test_double_withdrawal_lock_save() {
    let usdc = setup_usdc_mock();
    let (vault, vault_address) = deploy_contract(usdc.contract_address);
    let user1 = USER1();
    let amount = 10 * 1000000;
    let duration = 30;

    start_cheat_caller_address(usdc.contract_address, user1);
    usdc.approve(vault_address, amount);
    stop_cheat_caller_address(usdc.contract_address);

    start_cheat_caller_address(vault_address, user1);
    let lock_id = vault.create_lock_save(amount, duration, 'Test');
    stop_cheat_caller_address(vault_address);

    let maturity_time = get_block_timestamp() + (duration.into() * 86400);
    start_cheat_block_timestamp(vault_address, maturity_time);

    start_cheat_caller_address(vault_address, user1);
    vault.withdraw_lock_save(lock_id);

    vault.withdraw_lock_save(lock_id);
    stop_cheat_caller_address(vault_address);
}

#[test]
#[should_panic(expected: 'Already a member')]
fn test_double_join_group() {
    let usdc = setup_usdc_mock();
    let (vault, vault_address) = deploy_contract(usdc.contract_address);
    let creator = USER1();
    let member = USER2();

    start_cheat_caller_address(vault_address, creator);
    let group_id = vault
        .create_group_save(
            'Test Group',
            'Description',
            'Category',
            100000000,
            1,
            10000000,
            true,
            get_block_timestamp() + 86400 * 30,
        );
    stop_cheat_caller_address(vault_address);

    start_cheat_caller_address(vault_address, member);
    vault.join_group_save(group_id);

    vault.join_group_save(group_id);
    stop_cheat_caller_address(vault_address);
}

#[test]
#[should_panic(expected: 'Goal already completed')]
fn test_contribute_to_completed_goal() {
    let usdc = setup_usdc_mock();
    let (vault, vault_address) = deploy_contract(usdc.contract_address);
    let user1 = USER1();
    let target = 10 * 1000000;
    let contribution = 15 * 1000000;

    start_cheat_caller_address(vault_address, user1);
    let goal_id = vault
        .create_goal_save(
            'Test Goal', 'Test', target, 1, 5000000, get_block_timestamp() + 86400 * 30,
        );
    stop_cheat_caller_address(vault_address);

    start_cheat_caller_address(usdc.contract_address, user1);
    usdc.approve(vault_address, contribution * 2);
    stop_cheat_caller_address(usdc.contract_address);

    start_cheat_caller_address(vault_address, user1);
    vault.contribute_goal_save(goal_id, contribution);

    vault.contribute_goal_save(goal_id, 1000000);
    stop_cheat_caller_address(vault_address);
}
