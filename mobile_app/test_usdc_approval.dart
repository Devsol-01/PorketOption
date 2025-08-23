import 'package:starknet/starknet.dart';
import 'package:starknet_provider/starknet_provider.dart';

void main() async {
  print('🧪 Testing USDC Approval with u256 format...');

  final provider = JsonRpcProvider(
      nodeUri: Uri.parse('https://starknet-sepolia.public.blastapi.io'));
  const usdcAddress =
      '0x053b40a647cedfca6ca84f542a0fe36736031905a9639a7f19a3c1e66bfd5080';
  const savingsContract =
      '0x059558cebd77449b35e278dd418afdb03a56b486f2abdbabbea184c3257478be';

  // Test amount: 10 USDC = 10,000,000 (6 decimals)
  final testAmount = BigInt.from(10000000);

  print('📋 Testing approve function with u256 format:');
  print('   USDC Contract: $usdcAddress');
  print('   Spender: $savingsContract');
  print('   Amount: $testAmount');

  try {
    // Test the approve function call format
    final result = await provider.call(
      request: FunctionCall(
        contractAddress: Felt.fromHexString(usdcAddress),
        entryPointSelector: getSelectorByName('approve'),
        calldata: [
          Felt.fromHexString(savingsContract), // spender
          Felt(testAmount), // amount_low
          Felt.zero, // amount_high
        ],
      ),
      blockId: BlockId.latest,
    );

    result.when(
      result: (callResult) {
        print('✅ Approve function call simulation successful!');
        print('   Result: $callResult');
        print('   This means the function signature is correct.');
      },
      error: (error) {
        print('❌ Approve function call failed: $error');

        // Try with single parameter format
        print('🔄 Trying single parameter format...');
        testSingleParameterFormat(
            provider, usdcAddress, savingsContract, testAmount);
      },
    );
  } catch (e) {
    print('❌ Error testing approve: $e');
  }

  // Also test allowance function to verify format
  print('\n📋 Testing allowance function:');
  try {
    final allowanceResult = await provider.call(
      request: FunctionCall(
        contractAddress: Felt.fromHexString(usdcAddress),
        entryPointSelector: getSelectorByName('allowance'),
        calldata: [
          Felt.fromHexString(
              '0x01efebf3c85438056a12f4090a22163de6a29719afba4fa70aed93699f111207'), // owner
          Felt.fromHexString(savingsContract), // spender
        ],
      ),
      blockId: BlockId.latest,
    );

    allowanceResult.when(
      result: (callResult) {
        print('✅ Allowance function works!');
        print('   Current allowance: ${callResult[0].toBigInt()}');
      },
      error: (error) {
        print('❌ Allowance function failed: $error');
      },
    );
  } catch (e) {
    print('❌ Error testing allowance: $e');
  }
}

Future<void> testSingleParameterFormat(
  JsonRpcProvider provider,
  String usdcAddress,
  String savingsContract,
  BigInt testAmount,
) async {
  try {
    final result = await provider.call(
      request: FunctionCall(
        contractAddress: Felt.fromHexString(usdcAddress),
        entryPointSelector: getSelectorByName('approve'),
        calldata: [
          Felt.fromHexString(savingsContract), // spender
          Felt(testAmount), // amount (single parameter)
        ],
      ),
      blockId: BlockId.latest,
    );

    result.when(
      result: (callResult) {
        print('✅ Single parameter approve works!');
        print('   Result: $callResult');
      },
      error: (error) {
        print('❌ Single parameter approve also failed: $error');
      },
    );
  } catch (e) {
    print('❌ Single parameter test error: $e');
  }
}
