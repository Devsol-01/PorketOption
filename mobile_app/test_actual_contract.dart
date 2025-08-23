import 'package:starknet/starknet.dart';
import 'package:starknet_provider/starknet_provider.dart';

void main() async {
  print('🔍 TESTING ACTUAL SAVINGS VAULT CONTRACT FUNCTIONS');

  final provider = JsonRpcProvider(
    nodeUri: Uri.parse('https://starknet-sepolia.public.blastapi.io'),
  );

  const contractAddress =
      '0x059558cebd77449b35e278dd418afdb03a56b486f2abdbabbea184c3257478be';

  // Test SavingsVault specific functions that should exist
  final savingsFunctionsToTest = [
    'create_lock_save',
    'create_goal_save',
    'create_group_save',
    'deposit_flexi',
    'withdraw_flexi',
    'get_user_balance',
    'get_flexi_balance',
    'get_lock_details',
    'get_goal_details',
    'get_group_details',
    'minimum_deposit',
    'flexi_save_rate',
    'lock_save_rates',
    'usdc_token',
    'flexi_balances'
  ];

  print('\n📋 Testing SavingsVault functions...');

  for (final functionName in savingsFunctionsToTest) {
    try {
      final result = await provider.call(
        request: FunctionCall(
          contractAddress: Felt.fromHexString(contractAddress),
          entryPointSelector: getSelectorByName(functionName),
          calldata: [],
        ),
        blockId: BlockId.latest,
      );

      result.when(
        result: (result) {
          print('✅ $functionName EXISTS');
        },
        error: (error) {
          print(
              '❌ $functionName NOT FOUND - ${error.toString().contains('INVALID_MESSAGE_SELECTOR') ? 'Function does not exist' : error}');
        },
      );
    } catch (e) {
      print('❌ $functionName ERROR: $e');
    }
  }

  // Test if we can call create_lock_save with parameters
  print('\n🧪 Testing create_lock_save with parameters...');
  try {
    final result = await provider.call(
      request: FunctionCall(
        contractAddress: Felt.fromHexString(contractAddress),
        entryPointSelector: getSelectorByName("create_lock_save"),
        calldata: [
          Felt(BigInt.from(1000000000000000000)), // 1 token
          Felt(BigInt.from(10)), // 10 days
          Felt.fromString("test"), // title
        ],
      ),
      blockId: BlockId.latest,
    );

    result.when(
      result: (result) {
        print('✅ create_lock_save call simulation successful!');
      },
      error: (error) {
        print('❌ create_lock_save simulation failed: $error');
      },
    );
  } catch (e) {
    print('❌ create_lock_save test error: $e');
  }
}
