import 'dart:convert';
import 'package:starknet/starknet.dart';
import 'package:starknet_provider/starknet_provider.dart';
import 'lib/services/wallet_service.dart';

void main() async {
  print('🔍 DEBUG: Testing USDC approval step by step...');

  final walletService = WalletService();

  try {
    // 1. Load wallet
    print('📱 Loading wallet...');
    final walletInfo = await walletService.loadWallet();
    if (walletInfo == null) {
      print('❌ No wallet found');
      return;
    }
    print('✅ Wallet loaded: ${walletInfo.address}');

    // 2. Check if account exists
    final account = walletService.currentAccount;
    if (account == null) {
      print('❌ No current account');
      return;
    }
    print('✅ Account found: ${account.accountAddress.toHexString()}');

    // 3. Test simple balance check first
    print('💰 Checking USDC balance...');
    final balance = await walletService.getUsdcBalance();
    print('✅ USDC balance: $balance');

    // 4. Try a minimal approve call
    print('🔄 Testing minimal approve call...');
    const usdcAddress =
        '0x053b40a647cedfca6ca84f542a0fe36736031905a9639a7f19a3c1e66bfd5080';
    const contractAddress =
        '0x059558cebd77449b35e278dd418afdb03a56b486f2abdbabbea184c3257478be';

    final call = FunctionCall(
      contractAddress: Felt.fromHexString(usdcAddress),
      entryPointSelector: getSelectorByName('approve'),
      calldata: [
        Felt.fromHexString(contractAddress), // spender
        Felt(BigInt.from(1000000)), // 1 USDC (1e6)
        Felt.zero, // amount high
      ],
    );

    print('📋 Call details:');
    print('   Contract: $usdcAddress');
    print('   Function: approve');
    print('   Spender: $contractAddress');
    print('   Amount: 1000000 (1 USDC)');

    // 5. Execute and catch detailed error
    print('🚀 Executing transaction...');
    final response = await account.execute(functionCalls: [call]);

    print('📊 Response received: ${response.runtimeType}');
    print('📊 Response: $response');
  } catch (e, stackTrace) {
    print('❌ Error: $e');
    print('📍 Error type: ${e.runtimeType}');
    print('📍 Stack trace: $stackTrace');
  }
}
