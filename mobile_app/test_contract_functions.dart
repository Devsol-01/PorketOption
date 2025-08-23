import 'package:starknet/starknet.dart';
import 'package:starknet_provider/starknet_provider.dart';

void main() async {
  print('🔍 Testing deployed contract functions...');

  final provider = JsonRpcProvider(
      nodeUri: Uri.parse('https://starknet-sepolia.public.blastapi.io'));
  const contractAddress =
      '0x059558cebd77449b35e278dd418afdb03a56b486f2abdbabbea184c3257478be';
  const testUserAddress =
      '0x01efebf3c85438056a12f4090a22163de6a29719afba4fa70aed93699f111207';

  // Test common lock save function names
  final lockFunctions = [
    'create_lock_save',
    'create_lock',
    'lock_save',
    'deposit_lock',
    'create_safelock',
    'lock_deposit',
    'flexi_deposit', // This one works from logs
  ];

  for (final functionName in lockFunctions) {
    try {
      print('\n📋 Testing function: $functionName');

      List<Felt> calldata = [];

      // Set appropriate test calldata
      switch (functionName) {
        case 'create_lock_save':
        case 'create_lock':
        case 'lock_save':
        case 'deposit_lock':
        case 'create_safelock':
        case 'lock_deposit':
          calldata = [
            Felt(BigInt.from(1000000)), // amount (1 USDC in 6 decimals)
            Felt(BigInt.from(10)), // duration (10 days)
            Felt.fromString('test'), // title
          ];
          break;
        case 'flexi_deposit':
          calldata = [
            Felt(BigInt.from(1000000)), // amount
            Felt.zero, // amount_high
          ];
          break;
        default:
          calldata = [];
      }

      final result = await provider.call(
        request: FunctionCall(
          contractAddress: Felt.fromHexString(contractAddress),
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
          if (error.toString().contains('Entry point') &&
              error.toString().contains('not found')) {
            print('❌ $functionName does not exist in contract');
          } else {
            print('⚠️ $functionName exists but failed with: $error');
          }
        },
      );
    } catch (e) {
      print('❌ $functionName error: $e');
    }
  }

  // Test if contract has any external functions
  print('\n🔍 Testing contract class...');
  try {
    final classResult = await provider.getClassHashAt(
      contractAddress: Felt.fromHexString(contractAddress),
      blockId: BlockId.latest,
    );

    classResult.when(
      result: (classHash) {
        print(
            '✅ Contract deployed with class hash: ${classHash.toHexString()}');
      },
      error: (error) {
        print('❌ Failed to get class hash: $error');
      },
    );
  } catch (e) {
    print('❌ Class hash error: $e');
  }
}
