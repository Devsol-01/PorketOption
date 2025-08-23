import 'package:starknet/starknet.dart';
import 'package:starknet_provider/starknet_provider.dart';

void main() async {
  print('🔍 Testing USDC contract functions...');

  final provider = JsonRpcProvider(
      nodeUri: Uri.parse('https://starknet-sepolia.public.blastapi.io'));
  const usdcAddress =
      '0x053b40a647cedfca6ca84f542a0fe36736031905a9639a7f19a3c1e66bfd5080';
  const testAddress =
      '0x01efebf3c85438056a12f4090a22163de6a29719afba4fa70aed93699f111207';

  // Test common ERC20 functions
  final functions = [
    'approve',
    'transfer',
    'transferFrom',
    'balanceOf',
    'allowance',
    'name',
    'symbol',
    'decimals',
    'totalSupply',
  ];

  for (final functionName in functions) {
    try {
      print('\n📋 Testing function: $functionName');

      List<Felt> calldata = [];

      // Set appropriate calldata for each function
      switch (functionName) {
        case 'approve':
          calldata = [
            Felt.fromHexString(
                '0x059558cebd77449b35e278dd418afdb03a56b486f2abdbabbea184c3257478be'),
            Felt(BigInt.from(1000000)),
            Felt.zero,
          ];
          break;
        case 'transfer':
          calldata = [
            Felt.fromHexString(testAddress),
            Felt(BigInt.from(1000000)),
            Felt.zero,
          ];
          break;
        case 'balanceOf':
          calldata = [Felt.fromHexString(testAddress)];
          break;
        case 'allowance':
          calldata = [
            Felt.fromHexString(testAddress),
            Felt.fromHexString(
                '0x059558cebd77449b35e278dd418afdb03a56b486f2abdbabbea184c3257478be'),
          ];
          break;
        default:
          calldata = [];
      }

      final result = await provider.call(
        request: FunctionCall(
          contractAddress: Felt.fromHexString(usdcAddress),
          entryPointSelector: getSelectorByName(functionName),
          calldata: calldata,
        ),
        blockId: BlockId.latest,
      );

      result.when(
        result: (callResult) {
          print('✅ $functionName exists and returned: $callResult');
        },
        error: (error) {
          print('❌ $functionName failed: $error');
        },
      );
    } catch (e) {
      print('❌ $functionName error: $e');
    }
  }

  // Test if this is actually an ERC20 contract
  print('\n🔍 Testing contract class...');
  try {
    final classResult = await provider.getClassHashAt(
      contractAddress: Felt.fromHexString(usdcAddress),
      blockId: BlockId.latest,
    );

    classResult.when(
      result: (classHash) {
        print('✅ Contract class hash: ${classHash.toHexString()}');
      },
      error: (error) {
        print('❌ Failed to get class hash: $error');
      },
    );
  } catch (e) {
    print('❌ Class hash error: $e');
  }
}
