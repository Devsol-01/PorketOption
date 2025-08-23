import 'package:starknet/starknet.dart';
import 'package:starknet_provider/starknet_provider.dart';

void main() async {
  print('🧪 TESTING WORKING TRANSACTION PATTERN');

  final provider = JsonRpcProvider(
    nodeUri: Uri.parse('https://starknet-sepolia.public.blastapi.io'),
  );

  // Use your wallet details (replace with actual values)
  const accountAddress = "YOUR_ACCOUNT_ADDRESS";
  const privateKey = "YOUR_PRIVATE_KEY";

  final account = getAccount(
    accountAddress: Felt.fromHexString(accountAddress),
    privateKey: Felt.fromHexString(privateKey),
    nodeUri: Uri.parse('https://starknet-sepolia.public.blastapi.io'),
  );

  // Test with the ERC20 contract that exists
  const contractAddress =
      '0x059558cebd77449b35e278dd418afdb03a56b486f2abdbabbea184c3257478be';

  try {
    print('📋 Testing transaction execution...');

    // Try calling name() function which exists
    final response = await account.execute(functionCalls: [
      FunctionCall(
        contractAddress: Felt.fromHexString(contractAddress),
        entryPointSelector: getSelectorByName("name"),
        calldata: [],
      ),
    ]);

    final txHash = response.when(
      result: (result) {
        print('✅ Transaction successful!');
        print('📋 Transaction hash: ${result.transaction_hash}');
        return result.transaction_hash;
      },
      error: (err) {
        print('❌ Transaction failed: $err');
        throw Exception("Failed to execute");
      },
    );

    print(
        '🎉 Your transaction system works! The issue is just the wrong contract address.');
  } catch (e) {
    print('❌ Transaction test failed: $e');
  }
}
