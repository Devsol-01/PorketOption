import 'lib/services/contract_service.dart';
import 'lib/services/wallet_service.dart';

void main() async {
  print('🚀 TESTING USDC APPROVAL AND LOCK SAVE CREATION');

  // Initialize services
  final walletService = WalletService();
  final contractService = ContractService(walletService);

  try {
    // Step 1: Approve USDC spending (approve 1 USDC)
    print('\n1️⃣ Approving USDC spending...');
    final result = await contractService.approveUsdc(amount: 1.0);
    print('✅ USDC approval successful!');
    print('📋 Approval transaction hash: $result');

    // Wait a moment for transaction to be processed
    await Future.delayed(Duration(seconds: 3));

    // Step 2: Create lock save (2 USDC for 11 days)
    print('\n2️⃣ Creating lock save...');
    final lockTxHash = await contractService.createLockSave(
      amount: 2.0,
      title: 'Test Lock',
      durationDays: 11,
      fundSource: 'Porket Wallet',
    );
    print('✅ Lock save creation successful!');
    print('📋 Lock save transaction hash: $lockTxHash');

    print('\n🎉 SUCCESS! Both approval and lock save creation worked!');
  } catch (e) {
    print('❌ Error during approval/lock process: $e');
  }
}
