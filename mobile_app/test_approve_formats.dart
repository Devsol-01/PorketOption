import 'package:starknet/starknet.dart';
import 'package:starknet_provider/starknet_provider.dart';

void main() async {
  print('🔍 TESTING APPROVE FUNCTION PARAMETER FORMATS');

  final provider = JsonRpcProvider(
    nodeUri: Uri.parse('https://starknet-sepolia.public.blastapi.io'),
  );

  const usdcAddress =
      '0x053b40a647cedfca6ca84f542a0fe36736031905a9639a7f19a3c1e66bfd5080';
  const spenderAddress =
      '0x059558cebd77449b35e278dd418afdb03a56b486f2abdbabbea184c3257478be';
  final amount = BigInt.from(4000000000000000000); // 4 tokens

  // Test different approve parameter formats
  final testFormats = [
    {
      'name': 'Format 1: [spender, amount_low, amount_high]',
      'calldata': [
        Felt.fromHexString(spenderAddress),
        Felt(amount),
        Felt.zero,
      ]
    },
    {
      'name': 'Format 2: [spender, amount]',
      'calldata': [
        Felt.fromHexString(spenderAddress),
        Felt(amount),
      ]
    },
    {
      'name': 'Format 3: [spender, amount_low, amount_high] (reversed)',
      'calldata': [
        Felt.fromHexString(spenderAddress),
        Felt.zero,
        Felt(amount),
      ]
    },
  ];

  for (final format in testFormats) {
    print('\n🧪 Testing: ${format['name']}');

    try {
      final result = await provider.call(
        request: FunctionCall(
          contractAddress: Felt.fromHexString(usdcAddress),
          entryPointSelector: getSelectorByName("approve"),
          calldata: format['calldata'] as List<Felt>,
        ),
        blockId: BlockId.latest,
      );

      result.when(
        result: (result) {
          print('✅ ${format['name']} - Simulation successful!');
        },
        error: (error) {
          print('❌ ${format['name']} - Failed: $error');
        },
      );
    } catch (e) {
      print('❌ ${format['name']} - Error: $e');
    }
  }
}
