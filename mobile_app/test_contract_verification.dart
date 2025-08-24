import 'package:starknet/starknet.dart';
import 'package:starknet_provider/starknet_provider.dart';

void main() async {
  print('🔍 VERIFYING CONTRACT DEPLOYMENT AND FUNCTIONS');

  final provider = JsonRpcProvider(
    nodeUri: Uri.parse('https://starknet-sepolia.public.blastapi.io'),
  );

  const contractAddress =
      '0x059558cebd77449b35e278dd418afdb03a56b486f2abdbabbea184c3257478be';

  try {
    // 1. Check if contract exists
    print('\n1️⃣ Checking if contract exists...');
    final contractResult = await provider.getClassAt(
      contractAddress: Felt.fromHexString(contractAddress),
      blockId: BlockId.latest,
    );

    contractResult.when(
      result: (classDefinition) {
        print('✅ Contract exists at address: $contractAddress');
        print('📋 Contract class found');
      },
      error: (error) {
        print('❌ Contract NOT found at address: $contractAddress');
        print('📋 Error: $error');
        return;
      },
    );

    // 2. Try to call a simple read function to verify contract is working
    print('\n2️⃣ Testing simple contract call...');

    // Try calling lock_save_counter (should be a simple read function)
    final result = await provider.call(
      request: FunctionCall(
        contractAddress: Felt.fromHexString(contractAddress),
        entryPointSelector: getSelectorByName("lock_save_counter"),
        calldata: [],
      ),
      blockId: BlockId.latest,
    );

    result.when(
      result: (result) {
        print('✅ Contract call successful!');
        print('📋 lock_save_counter result: ${result[0]}');
      },
      error: (error) {
        print('❌ Contract call failed: $error');
      },
    );

    // 3. Check if create_lock_save function selector is correct
    print('\n3️⃣ Verifying function selector...');
    final selector = getSelectorByName("create_lock_save");
    print('📋 create_lock_save selector: $selector');
    print(
        '📋 Expected selector from logs: 0x2fc823a771538c6b59a22e25b29717fc0a036449982b840b3f768647a721bbf');

    if (selector.toHexString() ==
        '0x2fc823a771538c6b59a22e25b29717fc0a036449982b840b3f768647a721bbf') {
      print('✅ Function selector matches!');
    } else {
      print('❌ Function selector mismatch!');
    }
  } catch (e) {
    print('❌ Verification failed: $e');
  }
}
