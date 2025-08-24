import 'package:starknet/starknet.dart';
import 'package:starknet_provider/starknet_provider.dart';

void main() async {
  print('🔍 TESTING DIFFERENT PARAMETER FORMATS');

  final provider = JsonRpcProvider(
    nodeUri: Uri.parse('https://starknet-sepolia.public.blastapi.io'),
  );

  const contractAddress =
      '0x059558cebd77449b35e278dd418afdb03a56b486f2abdbabbea184c3257478be';

  // Test different parameter formats for create_lock_save
  print('\n🧪 Testing create_lock_save parameter formats...');

  // Format 1: Current format (amount: u256, duration: u64, title: felt252)
  print('\n1️⃣ Testing current format: [amount, duration, title]');
  try {
    final result = await provider.call(
      request: FunctionCall(
        contractAddress: Felt.fromHexString(contractAddress),
        entryPointSelector: getSelectorByName("create_lock_save"),
        calldata: [
          Felt(BigInt.from(1000000000000000000)), // amount: u256
          Felt(BigInt.from(10)), // duration: u64
          Felt.fromString("test"), // title: felt252
        ],
      ),
      blockId: BlockId.latest,
    );

    result.when(
      result: (result) => print('✅ Format 1 successful!'),
      error: (error) => print(
          '❌ Format 1 failed: ${error.toString().contains('Failed to deserialize param') ? 'Parameter format issue' : error}'),
    );
  } catch (e) {
    print('❌ Format 1 error: $e');
  }

  // Format 2: u256 as low/high (amount_low, amount_high, duration, title)
  print(
      '\n2️⃣ Testing u256 split format: [amount_low, amount_high, duration, title]');
  try {
    final result = await provider.call(
      request: FunctionCall(
        contractAddress: Felt.fromHexString(contractAddress),
        entryPointSelector: getSelectorByName("create_lock_save"),
        calldata: [
          Felt(BigInt.from(1000000000000000000)), // amount_low
          Felt.zero, // amount_high
          Felt(BigInt.from(10)), // duration
          Felt.fromString("test"), // title
        ],
      ),
      blockId: BlockId.latest,
    );

    result.when(
      result: (result) => print('✅ Format 2 successful!'),
      error: (error) => print(
          '❌ Format 2 failed: ${error.toString().contains('Failed to deserialize param') ? 'Parameter format issue' : error}'),
    );
  } catch (e) {
    print('❌ Format 2 error: $e');
  }

  // Format 3: Different title encoding
  print('\n3️⃣ Testing different title encoding');
  try {
    final titleBytes = 'test'.codeUnits;
    final titleFelt = Felt(BigInt.from(
        titleBytes.fold<int>(0, (prev, byte) => (prev << 8) + byte)));

    final result = await provider.call(
      request: FunctionCall(
        contractAddress: Felt.fromHexString(contractAddress),
        entryPointSelector: getSelectorByName("create_lock_save"),
        calldata: [
          Felt(BigInt.from(1000000000000000000)), // amount
          Felt(BigInt.from(10)), // duration
          titleFelt, // title with different encoding
        ],
      ),
      blockId: BlockId.latest,
    );

    result.when(
      result: (result) => print('✅ Format 3 successful!'),
      error: (error) => print(
          '❌ Format 3 failed: ${error.toString().contains('Failed to deserialize param') ? 'Parameter format issue' : error}'),
    );
  } catch (e) {
    print('❌ Format 3 error: $e');
  }
}
