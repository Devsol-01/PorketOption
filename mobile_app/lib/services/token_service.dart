import 'dart:math';
import 'package:starknet/starknet.dart';
import 'package:starknet_provider/starknet_provider.dart';

class TokenInfo {
  final String name;
  final String symbol;
  final String contractAddress;
  final int decimals;

  TokenInfo({
    required this.name,
    required this.symbol,
    required this.contractAddress,
    required this.decimals,
  });
}

class TokenService {
  late final JsonRpcProvider _provider;

  // Starknet Sepolia USDC contract address (official)
  static const String _usdcContractAddress =
      '0x053b40a647cedfca6ca84f542a0fe36736031905a9639a7f19a3c1e66bfd5080';

  TokenService() {
    _provider = JsonRpcProvider(
        nodeUri: Uri.parse('https://starknet-sepolia.public.blastapi.io'));
  }

  /// Helper: Format address to 66 characters (0x + 64 hex digits) for compatibility
  String _formatAddressTo66Chars(String address) {
    if (address.isEmpty) {
      throw ArgumentError('Address cannot be empty');
    }

    // Remove 0x prefix if present
    String cleanAddress =
        address.startsWith('0x') ? address.substring(2) : address;

    if (cleanAddress.isEmpty) {
      throw ArgumentError('Address cannot be just "0x"');
    }

    // Pad with leading zeros to make it 64 characters
    cleanAddress = cleanAddress.padLeft(64, '0');
    // Add 0x prefix
    return '0x$cleanAddress';
  }

  static final TokenInfo usdc = TokenInfo(
    name: 'USD Coin',
    symbol: 'USDC',
    contractAddress: _usdcContractAddress,
    decimals: 6,
  );

  static final TokenInfo eth = TokenInfo(
    name: 'Ethereum',
    symbol: 'ETH',
    contractAddress:
        '0x049d36570d4e46f48e99674bd3fcc84644ddd6b96f7c741b1562b82f9e004dc7',
    decimals: 18,
  );

  /// Get USDC balance for an account (REAL blockchain call)
  Future<double> getUsdcBalance(String accountAddress) async {
    try {
      print('🔍 TokenService: Starting USDC balance check...');

      if (accountAddress.isEmpty) {
        print('❌ TokenService: Empty account address provided');
        return 0.0;
      }

      // Format address properly
      final formattedAddress = _formatAddressTo66Chars(accountAddress);
      print('📍 TokenService: Formatted address: $formattedAddress');

      // Format USDC contract address
      final formattedUsdcContract =
          _formatAddressTo66Chars(_usdcContractAddress);
      print('📞 TokenService: USDC contract: $formattedUsdcContract');

      final usdcContractAddress = Felt.fromHexString(formattedUsdcContract);

      final result = await _provider.call(
        request: FunctionCall(
          contractAddress: usdcContractAddress,
          entryPointSelector: getSelectorByName('balanceOf'),
          calldata: [Felt.fromHexString(formattedAddress)],
        ),
        blockId: BlockId.latest,
      );

      // Handle the result and convert to USDC amount
      return result.when(
        result: (callResult) {
          print('📊 TokenService: Raw balance result: $callResult');
          if (callResult.isNotEmpty) {
            // USDC uses Uint256 format (low, high)
            final balanceLow = callResult[0].toBigInt();
            final balanceHigh =
                callResult.length > 1 ? callResult[1].toBigInt() : BigInt.zero;

            // Combine low and high parts
            final fullBalance = balanceLow + (balanceHigh << 128);

            // Convert from raw balance (6 decimals for USDC) to double
            final balanceInUsdc =
                fullBalance.toDouble() / pow(10, usdc.decimals);
            print('✅ TokenService: USDC Balance: $balanceInUsdc USDC');
            return balanceInUsdc;
          }
          print('⚠️ TokenService: Empty balance result');
          return 0.0;
        },
        error: (error) {
          print('❌ TokenService: USDC balance call error: $error');
          return 0.0;
        },
      );
    } catch (e) {
      print('❌ TokenService: Error getting USDC balance: $e');
      return 0.0;
    }
  }

  /// Get token info for any ERC-20 token (placeholder)
  Future<TokenInfo?> getTokenInfo(String contractAddress) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      // Placeholder implementation
      if (contractAddress == _usdcContractAddress) {
        return usdc;
      }
      return TokenInfo(
        name: 'Unknown Token',
        symbol: 'UNK',
        contractAddress: contractAddress,
        decimals: 18,
      );
    } catch (e) {
      print('Error getting token info: $e');
      return null;
    }
  }

  /// Format token amount for display
  String formatTokenAmount(double amount, TokenInfo token) {
    return '${amount.toStringAsFixed(token.decimals)} ${token.symbol}';
  }

  /// Parse token amount from string input
  double parseTokenAmount(String input, TokenInfo token) {
    try {
      final amount = double.parse(input);
      return amount;
    } catch (e) {
      return 0.0;
    }
  }

  /// Validate token amount
  bool isValidAmount(String input, double maxAmount) {
    try {
      final amount = double.parse(input);
      return amount > 0 && amount <= maxAmount;
    } catch (e) {
      return false;
    }
  }

  /// Validate Starknet address
  bool isValidStarknetAddress(String address) {
    try {
      if (!address.startsWith('0x')) return false;
      if (address.length < 3 || address.length > 66) return false;
      BigInt.parse(address.substring(2), radix: 16);
      return true;
    } catch (e) {
      return false;
    }
  }
}
