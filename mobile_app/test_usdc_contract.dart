import 'package:starknet/starknet.dart';
import 'package:starknet_provider/starknet_provider.dart';

void main() async {
  print('🔍 TESTING USDC CONTRACT AND APPROVE FUNCTION');

  final provider = JsonRpcProvider(
    nodeUri: Uri.parse('https://starknet-sepolia.public.blastapi.io'),
  );

  // Test different USDC contract addresses on Sepolia
  final usdcAddresses = [
    '0x053c91253bc9682c04929ca02ed00b3e423f6710d2ee7e0d5ebb06f3ecf368a8', // Current one
    '0x049d36570d4e46f48e99674bd3fcc84644ddd6b96f7c741b1562b82f9e004dc7', // ETH (common testnet token)
    '0x04718f5a0fc34cc1af16a1cdee98ffb20c31f5cd61d6ab07201858f4287c938d', // Another USDC variant
  ];

  for (final usdcAddress in usdcAddresses) {
    print('\n🧪 Testing USDC at: $usdcAddress');

    try {
      // Test basic functions
      final nameResult = await provider.call(
        request: FunctionCall(
          contractAddress: Felt.fromHexString(usdcAddress),
          entryPointSelector: getSelectorByName("name"),
          calldata: [],
        ),
        blockId: BlockId.latest,
      );

      nameResult.when(
        result: (result) => print('✅ name() works'),
        error: (error) => print('❌ name() failed: $error'),
      );

      // Test approve function signature
      print(
          '📋 approve selector: ${getSelectorByName("approve").toHexString()}');
    } catch (e) {
      print('❌ Error testing $usdcAddress: $e');
    }
  }

  // Check if we're using the right approve parameters
  print('\n🔍 APPROVE FUNCTION ANALYSIS:');
  print('Current parameters: [spender, amount, amount_high]');
  print('Standard ERC20: approve(spender, amount)');
  print('Starknet u256: might need [amount_low, amount_high] or just [amount]');
}
