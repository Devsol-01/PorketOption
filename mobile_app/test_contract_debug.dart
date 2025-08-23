import 'dart:io';
import 'lib/services/wallet_service.dart';
import 'lib/services/contract_service.dart';

void main() async {
  print('🧪 Testing Contract Service - Debug Mode');

  try {
    // Initialize services
    final walletService = WalletService();
    final contractService = ContractService(walletService);

    // Check if wallet is initialized
    print('🔍 Checking wallet initialization...');
    final account = walletService.currentAccount;

    if (account == null) {
      print('❌ No wallet account found - wallet not initialized');
      print('💡 Please ensure wallet is set up before testing contract calls');
      exit(1);
    }

    print('✅ Wallet account found: ${account.accountAddress.toHexString()}');

    // Test USDC balance check (read-only call)
    print('\n🔍 Testing USDC balance check...');
    try {
      final balance = await contractService.getUsdcBalance();
      print('✅ USDC Balance: $balance');
    } catch (e) {
      print('❌ USDC balance check failed: $e');
    }

    // Test USDC allowance check (read-only call)
    print('\n🔍 Testing USDC allowance check...');
    try {
      final allowance = await contractService.getUsdcAllowance();
      print('✅ USDC Allowance: $allowance');
    } catch (e) {
      print('❌ USDC allowance check failed: $e');
    }

    // Test small USDC approval (write call)
    print('\n🔍 Testing small USDC approval (0.01 USDC)...');
    try {
      final txHash = await contractService.approveUsdc(amount: 0.01);
      print('✅ USDC Approval successful: $txHash');
    } catch (e) {
      print('❌ USDC approval failed: $e');
      print('📋 Error details: ${e.toString()}');
    }
  } catch (e) {
    print('❌ Test failed: $e');
    exit(1);
  }

  print('\n🎉 Contract debug test completed');
}
