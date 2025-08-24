import 'package:starknet/starknet.dart';
import 'package:starknet_provider/starknet_provider.dart';

void main() async {
  print('🔍 TESTING SIMPLE CONTRACT FUNCTIONS');

  final provider = JsonRpcProvider(
    nodeUri: Uri.parse('https://starknet-sepolia.public.blastapi.io'),
  );

  const contractAddress =
      '0x059558cebd77449b35e278dd418afdb03a56b486f2abdbabbea184c3257478be';

  // Test common functions that might exist
  final functionsToTest = [
    'get_balance',
    'balance_of',
    'total_supply',
    'name',
    'symbol',
    'owner',
    'get_flexi_balance',
    'flexi_balances',
    'minimum_deposit',
    'lock_save_counter',
    'goal_save_counter',
    'group_save_counter'
  ];

  for (final functionName in functionsToTest) {
    try {
      print('\n🧪 Testing: $functionName');

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
          print(
              '✅ $functionName EXISTS - Result: ${result.length > 0 ? result[0] : 'empty'}');
        },
        error: (error) {
          print('❌ $functionName NOT FOUND');
        },
      );
    } catch (e) {
      print('❌ $functionName ERROR: $e');
    }
  }

  print(
      '\n🔍 CONCLUSION: Check which functions actually exist in your deployed contract');
}
