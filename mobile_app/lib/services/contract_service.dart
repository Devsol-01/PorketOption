import 'dart:convert';
import 'package:starknet/starknet.dart';
import 'package:starknet_provider/starknet_provider.dart';
import 'package:mobile_app/services/wallet_service.dart';
import 'package:mobile_app/config/env_config.dart';

class ContractService {
  final WalletService _walletService;

  ContractService(this._walletService);

  /// Get contract address from config
  Felt get _contractAddress => Felt.fromHexString(EnvConfig.savingsVaultContractAddress);

  /// Flexi deposit function to interact with the contract's flexi_deposit
  Future<String> flexiDeposit(BigInt amount) async {
    final account = _walletService.currentAccount;
    if (account == null) {
      throw Exception('Wallet not connected');
    }

    // Validate minimum deposit
    if (amount < BigInt.from(EnvConfig.minimumDeposit)) {
      throw Exception('Amount below minimum deposit of ${EnvConfig.minimumDeposit} USDC units');
    }

    // Convert amount to u256 format (low, high)
    final low = Felt(amount & BigInt.parse('0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'));
    final high = Felt(amount >> 128);

    // Prepare function call for flexi_deposit
    final functionCall = FunctionCall(
      contractAddress: _contractAddress,
      entryPointSelector: getSelectorByName('flexi_deposit'),
      calldata: [low, high],
    );

    // Execute the flexi_deposit function on the contract
    final response = await account.execute(functionCalls: [functionCall]);

    return response.when(
      result: (result) => result.transaction_hash,
      error: (error) => throw Exception('Flexi deposit failed: $error'),
    );
  }

  /// Flexi withdraw function
  Future<String> flexiWithdraw(BigInt amount) async {
    final account = _walletService.currentAccount;
    if (account == null) {
      throw Exception('Wallet not connected');
    }

    // Convert amount to u256 format (low, high)
    final low = Felt(amount & BigInt.parse('0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'));
    final high = Felt(amount >> 128);

    // Prepare function call for flexi_withdraw
    final functionCall = FunctionCall(
      contractAddress: _contractAddress,
      entryPointSelector: getSelectorByName('flexi_withdraw'),
      calldata: [low, high],
    );

    // Execute the flexi_withdraw function on the contract
    final response = await account.execute(functionCalls: [functionCall]);

    return response.when(
      result: (result) => result.transaction_hash,
      error: (error) => throw Exception('Flexi withdraw failed: $error'),
    );
  }

  /// Get flexi balance for current user
  Future<BigInt> getFlexiBalance() async {
    final account = _walletService.currentAccount;
    if (account == null) {
      throw Exception('Wallet not connected');
    }

    final userAddress = account.accountAddress;

    // Prepare function call for get_flexi_balance
    final functionCall = FunctionCall(
      contractAddress: _contractAddress,
      entryPointSelector: getSelectorByName('get_flexi_balance'),
      calldata: [userAddress],
    );

    // Call the contract
    final response = await account.provider.call(
      request: functionCall,
      blockId: BlockId.latest,
    );

    return response.when(
      result: (result) {
        if (result.length < 2) {
          throw Exception('Invalid balance response');
        }
        // Combine low and high parts for u256
        final low = result[0].toBigInt();
        final high = result[1].toBigInt();
        return low + (high << 128);
      },
      error: (error) => throw Exception('Failed to get flexi balance: $error'),
    );
  }

  /// Get user total deposits
  Future<BigInt> getUserTotalDeposits() async {
    final account = _walletService.currentAccount;
    if (account == null) {
      throw Exception('Wallet not connected');
    }

    final userAddress = account.accountAddress;

    // Prepare function call for get_user_total_deposits
    final functionCall = FunctionCall(
      contractAddress: _contractAddress,
      entryPointSelector: getSelectorByName('get_user_total_deposits'),
      calldata: [userAddress],
    );

    // Call the contract
    final response = await account.provider.call(
      request: functionCall,
      blockId: BlockId.latest,
    );

    return response.when(
      result: (result) {
        if (result.length < 2) {
          throw Exception('Invalid deposits response');
        }
        // Combine low and high parts for u256
        final low = result[0].toBigInt();
        final high = result[1].toBigInt();
        return low + (high << 128);
      },
      error: (error) => throw Exception('Failed to get total deposits: $error'),
    );
  }

  /// Get user savings streak
  Future<int> getUserSavingsStreak() async {
    final account = _walletService.currentAccount;
    if (account == null) {
      throw Exception('Wallet not connected');
    }

    final userAddress = account.accountAddress;

    // Prepare function call for get_user_savings_streak
    final functionCall = FunctionCall(
      contractAddress: _contractAddress,
      entryPointSelector: getSelectorByName('get_user_savings_streak'),
      calldata: [userAddress],
    );

    // Call the contract
    final response = await account.provider.call(
      request: functionCall,
      blockId: BlockId.latest,
    );

    return response.when(
      result: (result) {
        if (result.isEmpty) {
          throw Exception('Invalid streak response');
        }
        return result[0].toBigInt().toInt();
      },
      error: (error) => throw Exception('Failed to get savings streak: $error'),
    );
  }
}
