import 'package:flutter/material.dart';
import 'lib/services/contract_service.dart';
import 'lib/services/wallet_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  final walletService = WalletService();
  final contractService = ContractService(walletService);

  print('🧪 Testing REAL Starknet Contract Integration');
  print(
      '📋 Contract Address: 0x059558cebd77449b35e278dd418afdb03a56b486f2abdbabbea184c3257478be');
  print('🌐 Network: Starknet Sepolia');

  try {
    // Test 1: Get Flexi Balance (Read Function)
    print('\n📊 TEST 1: Getting Flexi Balance...');
    final balance = await contractService.getFlexiBalance();
    print('✅ Flexi Balance: $balance USDC');

    // Test 2: Get Interest Rates (Read Functions)
    print('\n💰 TEST 2: Getting Interest Rates...');
    final flexiRate = await contractService.getFlexiSaveRate();
    final goalRate = await contractService.getGoalSaveRate();
    final groupRate = await contractService.getGroupSaveRate();
    final lockRate = await contractService.getLockSaveRate(durationDays: 30);

    print('✅ Flexi Save Rate: ${flexiRate * 100}%');
    print('✅ Goal Save Rate: ${goalRate * 100}%');
    print('✅ Group Save Rate: ${groupRate * 100}%');
    print('✅ Lock Save Rate (30 days): ${lockRate * 100}%');

    // Test 3: Get Total Deposits (Read Function)
    print('\n💼 TEST 3: Getting Total Deposits...');
    final totalBalance = await contractService.getUserTotalBalance();
    print('✅ Total Deposits: $totalBalance USDC');

    print('\n🎉 ALL REAL CONTRACT CALLS SUCCESSFUL!');
    print('🚀 Ready for deposit transactions!');
  } catch (e) {
    print('❌ Contract test failed: $e');
    print('🔍 This indicates either:');
    print('   - Contract functions don\'t exist');
    print('   - Wrong function signatures');
    print('   - Network connectivity issues');
    print('   - Wallet not connected');
  }
}
