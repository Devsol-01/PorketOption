import 'package:starknet/starknet.dart';
import 'package:starknet_provider/starknet_provider.dart';

void main() async {
  print('🔍 CHECKING USDC BALANCE AND APPROVAL');

  final provider = JsonRpcProvider(
    nodeUri: Uri.parse('https://starknet-sepolia.public.blastapi.io'),
  );

  const contractAddress =
      '0x059558cebd77449b35e278dd418afdb03a56b486f2abdbabbea184c3257478be';

  // Common USDC addresses on Starknet Sepolia
  final usdcAddresses = [
    '0x053c91253bc9682c04929ca02ed00b3e423f6710d2ee7e0d5ebb06f3ecf368a8', // USDC Sepolia
    '0x049d36570d4e46f48e99674bd3fcc84644ddd6b96f7c741b1562b82f9e004dc7', // ETH (sometimes used as test token)
  ];

  // Your account address (replace with actual)
  const yourAccountAddress = 'YOUR_ACCOUNT_ADDRESS_HERE';

  for (final usdcAddress in usdcAddresses) {
    print('\n🧪 Testing USDC at: $usdcAddress');

    try {
      // Check USDC balance
      final balanceResult = await provider.call(
        request: FunctionCall(
          contractAddress: Felt.fromHexString(usdcAddress),
          entryPointSelector: getSelectorByName("balance_of"),
          calldata: [Felt.fromHexString(yourAccountAddress)],
        ),
        blockId: BlockId.latest,
      );

      balanceResult.when(
        result: (result) {
          print(
              '✅ USDC Balance: ${result[0]} (${result.length > 1 ? result[1] : 'N/A'})');
        },
        error: (error) {
          print('❌ Balance check failed: $error');
        },
      );

      // Check allowance
      final allowanceResult = await provider.call(
        request: FunctionCall(
          contractAddress: Felt.fromHexString(usdcAddress),
          entryPointSelector: getSelectorByName("allowance"),
          calldata: [
            Felt.fromHexString(yourAccountAddress), // owner
            Felt.fromHexString(contractAddress), // spender
          ],
        ),
        blockId: BlockId.latest,
      );

      allowanceResult.when(
        result: (result) {
          print(
              '✅ Allowance: ${result[0]} (${result.length > 1 ? result[1] : 'N/A'})');
        },
        error: (error) {
          print('❌ Allowance check failed: $error');
        },
      );
    } catch (e) {
      print('❌ Error testing $usdcAddress: $e');
    }
  }

  print('\n💡 SOLUTION:');
  print('1. Get USDC tokens for your account');
  print('2. Approve the SavingsVault contract to spend your USDC');
  print('3. Then try creating lock save again');
}
