# PorketOption - Flexi Save Integration TODO

## ✅ Completed Tasks

### 1. USDC Transfer Functionality
- [x] Fixed null type cast error in sendUsdc method
- [x] Implemented AVNU provider approach for sponsored transactions
- [x] Added proper error handling and validation
- [x] Integrated with wallet service for seamless USDC transfers

### 2. Contract Service Implementation
- [x] Created ContractService class with wallet service dependency
- [x] Implemented flexiDeposit method for depositing USDC to flexi save
- [x] Added flexiWithdraw method for withdrawing from flexi save
- [x] Implemented getFlexiBalance method to query current balance
- [x] Added getUserTotalDeposits method for total deposit tracking
- [x] Implemented getUserSavingsStreak method for streak tracking
- [x] Added proper u256 handling for Starknet amounts
- [x] Integrated with dependency injection (locator)

### 3. Configuration Setup
- [x] Created EnvConfig class for contract addresses and settings
- [x] Added savings vault contract address configuration
- [x] Added minimum deposit validation
- [x] Added network configuration

### 4. Integration & Dependencies
- [x] Fixed locator to properly inject WalletService into ContractService
- [x] Added proper imports for Starknet libraries
- [x] Resolved all compilation errors

## 🔄 Next Steps

### UI Integration
- [ ] Create FlexiSaveViewModel to handle UI state
- [ ] Implement deposit/withdraw UI components
- [ ] Add balance display widgets
- [ ] Create savings streak visualization
- [ ] Add transaction history view

### Additional Contract Functions
- [ ] Implement lock save functionality (create_lock_save, withdraw_lock_save)
- [ ] Add goal save features (create_goal_save, contribute_goal_save)
- [ ] Implement group save functionality
- [ ] Add interest calculation and display methods

### Error Handling & UX
- [ ] Add loading states for contract interactions
- [ ] Implement retry mechanisms for failed transactions
- [ ] Add transaction confirmation dialogs
- [ ] Create error handling UI components

### Testing
- [ ] Write unit tests for ContractService methods
- [ ] Add integration tests for contract interactions
- [ ] Test edge cases (insufficient balance, network errors)
- [ ] Add mock data for testing scenarios

### Advanced Features
- [ ] Add transaction history tracking
- [ ] Implement push notifications for savings milestones
- [ ] Add analytics for savings patterns
- [ ] Create referral system integration

## 📋 Usage Example

```dart
// In a ViewModel or Controller
final contractService = locator<ContractService>();

// Deposit to flexi save
final txHash = await contractService.flexiDeposit(BigInt.from(1000000)); // 1 USDC

// Get current balance
final balance = await contractService.getFlexiBalance();

// Withdraw from flexi save
final withdrawTx = await contractService.flexiWithdraw(BigInt.from(500000)); // 0.5 USDC
```

## 🔧 Configuration Required

Before using the contract service, update the contract address in `env_config.dart`:

```dart
static const String savingsVaultContractAddress = '0xYOUR_ACTUAL_CONTRACT_ADDRESS_HERE';
```

## 📊 Contract Functions Available

- `flexi_deposit(amount: u256)` - Deposit USDC to flexi save
- `flexi_withdraw(amount: u256)` - Withdraw USDC from flexi save
- `get_flexi_balance(user: ContractAddress)` - Get current flexi balance
- `get_user_total_deposits(user: ContractAddress)` - Get total deposits
- `get_user_savings_streak(user: ContractAddress)` - Get savings streak
