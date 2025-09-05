import 'dart:convert';
import 'dart:math';
import 'package:starknet/starknet.dart';
import 'package:starknet_provider/starknet_provider.dart';
import 'package:avnu_provider/avnu_provider.dart';
import 'package:mobile_app/services/wallet_service.dart';
import 'package:mobile_app/config/env_config.dart';

class ContractService {
  final WalletService _walletService;

  ContractService(this._walletService);

  /// Get contract address from config
  Felt get _contractAddress =>
      Felt.fromHexString(EnvConfig.savingsVaultContractAddress);

  /// Check if contract exists on chain
  Future<bool> _checkContractExists() async {
    try {
      final result =
          await _walletService.currentAccount?.provider.getClassHashAt(
        contractAddress: _contractAddress,
        blockId: BlockId.latest,
      );
      return result != null;
    } catch (e) {
      print('❌ CONTRACT SERVICE: Error checking contract existence: $e');
      return false;
    }
  }

  /// Approve USDC spending for the savings vault contract using wallet service
  Future<String> _approveUsdcSpending(BigInt amount) async {
    print('🔐 CONTRACT SERVICE: Approving USDC spending for amount: $amount');

    // Convert amount to USDC units (6 decimals)
    final amountInUsdc = amount.toDouble() / 1000000.0;
    print('🔢 CONTRACT SERVICE: Amount in USDC: $amountInUsdc');

    // Use the wallet service's approveUsdc method which is more robust
    final spenderAddress = _contractAddress.toHexString();
    print('🎯 CONTRACT SERVICE: Approving spender: $spenderAddress');

    return await _walletService.approveUsdc(
      spenderAddress: spenderAddress,
      amount: amountInUsdc,
    );
  }

  //functions for porket save

    /// Get flexi balance for current user
  Future<BigInt> getFlexiBalance() async {
    final account = _walletService.currentAccount;
    if (account == null) {
      throw Exception('Wallet not connected');
    }

    final userAddress = account.accountAddress;

    print(
        '🔍 CONTRACT SERVICE: Getting flexi balance for user: ${userAddress.toHexString()}');
    print('📞 CONTRACT SERVICE: Contract address: $_contractAddress');

    // Prepare function call for get_flexi_balance
    final functionCall = FunctionCall(
      contractAddress: _contractAddress,
      entryPointSelector: getSelectorByName('get_flexi_balance'),
      calldata: [userAddress],
    );

    print(
        '📋 CONTRACT SERVICE: Function call prepared: ${functionCall.entryPointSelector}');

    // Call the contract
    final response = await account.provider.call(
      request: functionCall,
      blockId: BlockId.latest,
    );

    return response.when(
      result: (result) {
        print('📊 CONTRACT SERVICE: Raw balance result: $result');

        if (result.length < 2) {
          print(
              '❌ CONTRACT SERVICE: Invalid balance response - not enough elements');
          throw Exception('Invalid balance response');
        }

        // Combine low and high parts for u256
        final low = result[0].toBigInt();
        final high = result[1].toBigInt();

        print('🔢 CONTRACT SERVICE: Low: $low, High: $high');

        final balance = low + (high << 128);
        print('✅ CONTRACT SERVICE: Combined balance: $balance');

        return balance;
      },
      error: (error) {
        print('❌ CONTRACT SERVICE: Failed to get flexi balance: $error');
        throw Exception('Failed to get flexi balance: $error');
      },
    );
  }




    /// Flexi deposit using AVNU provider for better transaction handling
  Future<String> flexiDepositWithAvnu({
    required double amount,
  }) async {
    final currentAccount = _walletService.currentAccount;
    final ownerSigner = _walletService.ownerSigner;
    final guardianSigner = _walletService.guardianSigner;
    final avnuProvider = _walletService.avnuProvider;

    if (currentAccount == null ||
        ownerSigner == null ||
        guardianSigner == null) {
      throw Exception('No wallet account available');
    }

    if (amount <= 0) {
      throw Exception('Amount must be greater than 0');
    }

    try {
      print('🏦 Initiating Flexi Deposit with AVNU: $amount USDC');

      // Check if account is deployed, deploy if necessary
      final deployResult = await currentAccount.provider.getClassHashAt(
        contractAddress: currentAccount.accountAddress,
        blockId: BlockId.latest,
      );
      final isDeployed = deployResult.when(
        result: (_) => true,
        error: (_) => false,
      );
      if (!isDeployed) {
        print('🚀 Account not deployed, deploying first...');
        await _walletService.deployAccount();
      }

      // Check USDC balance before depositing
      final currentBalance = await _walletService.getUsdcBalance();
      if (currentBalance < amount) {
        throw Exception(
            'Insufficient USDC balance. Available: ${_walletService.formatUsdcBalance(currentBalance)}, Required: ${_walletService.formatUsdcBalance(amount)}');
      }

      // Convert amount to raw USDC units (6 decimals)
      final rawAmount = BigInt.from((amount * pow(10, 6)).round());
      print('📊 Raw deposit amount: $rawAmount (${amount} USDC)');

      // Check current allowance for the contract
      final currentAllowance = await getUsdcAllowance(
        ownerAddress: currentAccount.accountAddress.toHexString(),
        spenderAddress: _contractAddress.toHexString(),
      );

      // If allowance is insufficient, approve first
      if (currentAllowance < amount) {
        print(
            '🔓 Insufficient allowance (${_walletService.formatUsdcBalance(currentAllowance)}), approving ${_walletService.formatUsdcBalance(amount)} USDC...');
        await _walletService.approveUsdc(
          spenderAddress: _contractAddress.toHexString(),
          amount: amount,
        );
        print('✅ USDC approval completed');

        // Small delay to ensure approval is processed
        await Future.delayed(Duration(milliseconds: 500));
      }

      // Prepare flexi_deposit call data
      final calls = [
        {
          'contractAddress': _contractAddress.toHexString(),
          'entrypoint': 'flexi_deposit',
          'calldata': [
            '0x${rawAmount.toRadixString(16)}',
            '0x0', // amount.high for amounts < 2^128
          ],
        },
      ];

      print('🔧 Building typed data with Avnu for deposit...');

      // Build typed data with AVNU
      final avnuBuildTypeDataResponse = await avnuProvider.buildTypedData(
        currentAccount.accountAddress.toHexString(),
        calls,
        '', // use sponsor gas token
        '', // use sponsor gas limit
        WalletService.argentClassHash.toHexString(),
      );

      if (avnuBuildTypeDataResponse is AvnuBuildTypedDataError) {
        throw Exception(
            'Failed to build typed data: $avnuBuildTypeDataResponse');
      }

      final avnuTypedData =
          avnuBuildTypeDataResponse as AvnuBuildTypedDataResult;

      // Create owner account signer
      final ownerAccountSigner = ArgentXGuardianAccountSigner(
        ownerSigner: ownerSigner,
        guardianSigner: guardianSigner,
      );

      // Compute message hash and sign it
      final hash = avnuTypedData.hash(currentAccount.accountAddress);
      final signature = await ownerAccountSigner.sign(hash, null);

      print('🚀 Executing Flexi Deposit with Avnu...');

      // Execute the transaction via AVNU provider
      final avnuExecute = await avnuProvider.execute(
        currentAccount.accountAddress.toHexString(),
        jsonEncode(avnuTypedData.toTypedData()),
        signature.map((e) => e.toHexString()).toList(),
        null, // account is already deployed
      );

      if (avnuExecute is AvnuExecuteError) {
        throw Exception('Flexi deposit failed: $avnuExecute');
      }

      final result = avnuExecute as AvnuExecuteResult;
      final transactionHash = result.transactionHash;

      if (transactionHash == null || transactionHash.isEmpty) {
        throw Exception('Transaction hash is null or empty');
      }

      print('✅ Flexi Deposit successful! TX: $transactionHash');
      return transactionHash;
    } catch (e) {
      print('❌ Flexi Deposit error: $e');
      throw Exception('Failed to complete flexi deposit: $e');
    }
  }

  /// Flexi deposit with approval in one call
  Future<String> flexiDepositWithApproval({
    required double amount,
  }) async {
    try {
      print('🔄 Starting approve + deposit flow...');

      // First approve
      final approvalTx = await _walletService.approveUsdc(
        spenderAddress: _contractAddress.toHexString(),
        amount: amount,
      );
      print('✅ Approval TX: $approvalTx');

      // Wait a bit for approval to be processed
      await Future.delayed(Duration(seconds: 2));

      // Then deposit
      final depositTx = await flexiDepositWithAvnu(amount: amount);
      print('✅ Deposit TX: $depositTx');

      return depositTx;
    } catch (e) {
      print('❌ Approve + Deposit flow error: $e');
      rethrow;
    }
  }

  /// Flexi withdraw using AVNU provider for better transaction handling
  Future<String> flexiWithdrawWithAvnu({
    required double amount,
  }) async {
    final currentAccount = _walletService.currentAccount;
    final ownerSigner = _walletService.ownerSigner;
    final guardianSigner = _walletService.guardianSigner;
    final avnuProvider = _walletService.avnuProvider;

    if (currentAccount == null ||
        ownerSigner == null ||
        guardianSigner == null) {
      throw Exception('No wallet account available');
    }

    if (amount <= 0) {
      throw Exception('Amount must be greater than 0');
    }

    try {
      print('🏦 Initiating Flexi Withdraw with AVNU: $amount USDC');

      // Check if account is deployed, deploy if necessary
      final deployResult = await currentAccount.provider.getClassHashAt(
        contractAddress: currentAccount.accountAddress,
        blockId: BlockId.latest,
      );
      final isDeployed = deployResult.when(
        result: (_) => true,
        error: (_) => false,
      );
      if (!isDeployed) {
        print('🚀 Account not deployed, deploying first...');
        await _walletService.deployAccount();
      }

      // Check USDC balance before depositing
      final currentBalance = await _walletService.getUsdcBalance();
      if (currentBalance < amount) {
        throw Exception(
            'Insufficient USDC balance. Available: ${_walletService.formatUsdcBalance(currentBalance)}, Required: ${_walletService.formatUsdcBalance(amount)}');
      }

      // Convert amount to raw USDC units (6 decimals)
      final rawAmount = BigInt.from((amount * pow(10, 6)).round());
      print('📊 Raw deposit amount: $rawAmount (${amount} USDC)');

      // Check current allowance for the contract
      final currentAllowance = await getUsdcAllowance(
        ownerAddress: currentAccount.accountAddress.toHexString(),
        spenderAddress: _contractAddress.toHexString(),
      );

      // If allowance is insufficient, approve first
      if (currentAllowance < amount) {
        print(
            '🔓 Insufficient allowance (${_walletService.formatUsdcBalance(currentAllowance)}), approving ${_walletService.formatUsdcBalance(amount)} USDC...');
        await _walletService.approveUsdc(
          spenderAddress: _contractAddress.toHexString(),
          amount: amount,
        );
        print('✅ USDC approval completed');

        // Small delay to ensure approval is processed
        await Future.delayed(Duration(milliseconds: 500));
      }

      // Prepare flexi_deposit call data
      final calls = [
        {
          'contractAddress': _contractAddress.toHexString(),
          'entrypoint': 'flexi_withdraw',
          'calldata': [
            '0x${rawAmount.toRadixString(16)}',
            '0x0', // amount.high for amounts < 2^128
          ],
        },
      ];

      print('🔧 Building typed data with Avnu for deposit...');

      // Build typed data with AVNU
      final avnuBuildTypeDataResponse = await avnuProvider.buildTypedData(
        currentAccount.accountAddress.toHexString(),
        calls,
        '', // use sponsor gas token
        '', // use sponsor gas limit
        WalletService.argentClassHash.toHexString(),
      );

      if (avnuBuildTypeDataResponse is AvnuBuildTypedDataError) {
        throw Exception(
            'Failed to build typed data: $avnuBuildTypeDataResponse');
      }

      final avnuTypedData =
          avnuBuildTypeDataResponse as AvnuBuildTypedDataResult;

      // Create owner account signer
      final ownerAccountSigner = ArgentXGuardianAccountSigner(
        ownerSigner: ownerSigner,
        guardianSigner: guardianSigner,
      );

      // Compute message hash and sign it
      final hash = avnuTypedData.hash(currentAccount.accountAddress);
      final signature = await ownerAccountSigner.sign(hash, null);

      print('🚀 Executing Flexi Withdraw with Avnu...');

      // Execute the transaction via AVNU provider
      final avnuExecute = await avnuProvider.execute(
        currentAccount.accountAddress.toHexString(),
        jsonEncode(avnuTypedData.toTypedData()),
        signature.map((e) => e.toHexString()).toList(),
        null, // account is already deployed
      );

      if (avnuExecute is AvnuExecuteError) {
        throw Exception('Flexi Withdraw failed: $avnuExecute');
      }

      final result = avnuExecute as AvnuExecuteResult;
      final transactionHash = result.transactionHash;

      if (transactionHash == null || transactionHash.isEmpty) {
        throw Exception('Transaction hash is null or empty');
      }

      print('✅ Flexi withdraw successful! TX: $transactionHash');
      return transactionHash;
    } catch (e) {
      print('❌ Flexi Withdraw error: $e');
      throw Exception('Failed to complete flexi Withdraw: $e');
    }
  }

  /// Flexi deposit with approval in one call
  Future<String> flexiWithdrawWithApproval({
    required double amount,
  }) async {
    try {
      print('🔄 Starting approve + deposit flow...');

      // First approve
      final approvalTx = await _walletService.approveUsdc(
        spenderAddress: _contractAddress.toHexString(),
        amount: amount,
      );
      print('✅ Approval TX: $approvalTx');

      // Wait a bit for approval to be processed
      await Future.delayed(Duration(seconds: 2));

      // Then deposit
      final depositTx = await flexiWithdrawWithAvnu(amount: amount);
      print('✅ Deposit TX: $depositTx');

      return depositTx;
    } catch (e) {
      print('❌ Approve + Deposit flow error: $e');
      rethrow;
    }
  }









  /// Get Savings balance for current user
  Future<BigInt> getSavingsBalance() async {
    final account = _walletService.currentAccount;
    if (account == null) {
      throw Exception('Wallet not connected');
    }

    final userAddress = account.accountAddress;

    print(
        '🔍 CONTRACT SERVICE: Getting Savings balance for user: ${userAddress.toHexString()}');
    print('📞 CONTRACT SERVICE: Contract address: $_contractAddress');

    // Prepare function call for get_flexi_balance
    final functionCall = FunctionCall(
      contractAddress: _contractAddress,
      entryPointSelector: getSelectorByName('get_user_total_deposits'),
      calldata: [userAddress],
    );

    print(
        '📋 CONTRACT SERVICE: Function call prepared: ${functionCall.entryPointSelector}');

    // Call the contract
    final response = await account.provider.call(
      request: functionCall,
      blockId: BlockId.latest,
    );

    return response.when(
      result: (result) {
        print('📊 CONTRACT SERVICE: Raw balance result: $result');

        if (result.length < 2) {
          print(
              '❌ CONTRACT SERVICE: Invalid balance response - not enough elements');
          throw Exception('Invalid balance response');
        }

        // Combine low and high parts for u256
        final low = result[0].toBigInt();
        final high = result[1].toBigInt();

        print('🔢 CONTRACT SERVICE: Low: $low, High: $high');

        final balance = low + (high << 128);
        print('✅ CONTRACT SERVICE: Combined balance: $balance');

        return balance;
      },
      error: (error) {
        print('❌ CONTRACT SERVICE: Failed to get savings balance: $error');
        throw Exception('Failed to get savings balance: $error');
      },
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

  /// Get USDC allowance for a spender
  Future<double> getUsdcAllowance({
    required String ownerAddress,
    required String spenderAddress,
  }) async {
    try {
      final usdcContract =
          Felt.fromHexString(_walletService.usdcContractAddress);
      final owner = Felt.fromHexString(ownerAddress);
      final spender = Felt.fromHexString(spenderAddress);

      final result = await _walletService.currentAccount?.provider.call(
        request: FunctionCall(
          contractAddress: usdcContract,
          entryPointSelector: getSelectorByName('allowance'),
          calldata: [owner, spender],
        ),
        blockId: BlockId.latest,
      );

      if (result == null) {
        return 0.0;
      }

      return result.when(
        result: (callResult) {
          if (callResult.isEmpty) {
            return 0.0;
          }

          // Allowance is returned as Uint256 (low, high)
          final allowanceLow = callResult[0].toBigInt();
          final allowanceHigh =
              callResult.length > 1 ? callResult[1].toBigInt() : BigInt.zero;

          // Combine low and high parts
          final fullAllowance = allowanceLow + (allowanceHigh << 128);

          // Convert from raw USDC units (6 decimals) to readable format
          final allowanceInUsdc = fullAllowance.toDouble() / pow(10, 6);

          return allowanceInUsdc;
        },
        error: (error) {
          print('❌ Failed to get USDC allowance: $error');
          return 0.0;
        },
      );
    } catch (e) {
      print('❌ Error getting USDC allowance: $e');
      return 0.0;
    }
  }


  /// Create a lock save
  Future<String> createLockSave({
    required double amount,
    required int durationDays,
    required String title,
  }) async {
    final account = _walletService.currentAccount;
    if (account == null) {
      throw Exception('Wallet not connected');
    }

    try {
      print('🔒 Creating lock save: $amount USDC for $durationDays days');

      // Convert amount to raw USDC units (6 decimals)
      final rawAmount = BigInt.from((amount * pow(10, 6)).round());
      print('📊 Raw amount: $rawAmount (${amount} USDC)');

      // Convert title to felt252 (first 31 characters)
      final titleFelt =
          Felt.fromString(title.length > 31 ? title.substring(0, 31) : title);
      final titleHex = '0x${titleFelt.toBigInt().toRadixString(16)}';

      // Check USDC balance before creating lock save
      final currentBalance = await _walletService.getUsdcBalance();
      if (currentBalance < amount) {
        throw Exception(
            'Insufficient USDC balance. Available: ${_walletService.formatUsdcBalance(currentBalance)}, Required: ${_walletService.formatUsdcBalance(amount)}');
      }

      // Check current allowance for the contract
      final currentAllowance = await getUsdcAllowance(
        ownerAddress: account.accountAddress.toHexString(),
        spenderAddress: _contractAddress.toHexString(),
      );

      // If allowance is insufficient, approve first
      if (currentAllowance < amount) {
        print(
            '🔓 Insufficient allowance (${_walletService.formatUsdcBalance(currentAllowance)}), approving ${_walletService.formatUsdcBalance(amount)} USDC...');
        await _walletService.approveUsdc(
          spenderAddress: _contractAddress.toHexString(),
          amount: amount,
        );
        print('✅ USDC approval completed');

        // Small delay to ensure approval is processed
        await Future.delayed(Duration(milliseconds: 500));
      }

      // Prepare create_lock_save call data
      final calls = [
        {
          'contractAddress': _contractAddress.toHexString(),
          'entrypoint': 'create_lock_save',
          'calldata': [
            '0x${rawAmount.toRadixString(16)}',
            '0x0',
            '0x${BigInt.from(durationDays).toRadixString(16)}',
            titleHex,
          ],
        },
      ];

      print('🔧 Building typed data with Avnu for lock save creation...');

      // Build typed data with AVNU
      final avnuBuildTypeDataResponse =
          await _walletService.avnuProvider.buildTypedData(
        account.accountAddress.toHexString(),
        calls,
        '', // use sponsor gas token
        '', // use sponsor gas limit
        WalletService.argentClassHash.toHexString(),
      );

      if (avnuBuildTypeDataResponse is AvnuBuildTypedDataError) {
        throw Exception(
            'Failed to build typed data: $avnuBuildTypeDataResponse');
      }

      final avnuTypedData =
          avnuBuildTypeDataResponse as AvnuBuildTypedDataResult;

      // Create owner account signer
      final ownerAccountSigner = ArgentXGuardianAccountSigner(
        ownerSigner: _walletService.ownerSigner!,
        guardianSigner: _walletService.guardianSigner!,
      );

      // Compute message hash and sign it
      final hash = avnuTypedData.hash(account.accountAddress);
      final signature = await ownerAccountSigner.sign(hash, null);

      print('🚀 Executing lock save creation with Avnu...');

      // Execute the transaction via AVNU provider
      final avnuExecute = await _walletService.avnuProvider.execute(
        account.accountAddress.toHexString(),
        jsonEncode(avnuTypedData.toTypedData()),
        signature.map((e) => e.toHexString()).toList(),
        null, // account is already deployed
      );

      if (avnuExecute is AvnuExecuteError) {
        throw Exception('Lock save creation failed: $avnuExecute');
      }

      final result = avnuExecute as AvnuExecuteResult;
      final transactionHash = result.transactionHash;

      if (transactionHash == null || transactionHash.isEmpty) {
        throw Exception('Transaction hash is null or empty');
      }

      print('✅ Lock save created successfully! TX: $transactionHash');
      return transactionHash;
    } catch (e) {
      print('❌ Lock save creation error: $e');
      throw Exception('Failed to create lock save: $e');
    }
  }

  /// Withdraw from a lock save
  Future<String> withdrawLockSave({
    required BigInt lockId,
  }) async {
    final account = _walletService.currentAccount;
    if (account == null) {
      throw Exception('Wallet not connected');
    }

    try {
      print('🔓 Withdrawing from lock save ID: $lockId');

      // Convert BigInt lockId to u256 format (low, high)
      final low = lockId & BigInt.parse('0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
      final high = lockId >> 128;

      // Prepare withdraw_lock_save call data
      final calls = [
        {
          'contractAddress': _contractAddress.toHexString(),
          'entrypoint': 'withdraw_lock_save',
          'calldata': [
            '0x${low.toRadixString(16)}',
            '0x${high.toRadixString(16)}',
          ],
        },
      ];

      print('🔧 Building typed data with Avnu for lock save withdrawal...');

      // Build typed data with AVNU
      final avnuBuildTypeDataResponse =
          await _walletService.avnuProvider.buildTypedData(
        account.accountAddress.toHexString(),
        calls,
        '', // use sponsor gas token
        '', // use sponsor gas limit
        WalletService.argentClassHash.toHexString(),
      );

      if (avnuBuildTypeDataResponse is AvnuBuildTypedDataError) {
        throw Exception(
            'Failed to build typed data: $avnuBuildTypeDataResponse');
      }

      final avnuTypedData =
          avnuBuildTypeDataResponse as AvnuBuildTypedDataResult;

      // Create owner account signer
      final ownerAccountSigner = ArgentXGuardianAccountSigner(
        ownerSigner: _walletService.ownerSigner!,
        guardianSigner: _walletService.guardianSigner!,
      );

      // Compute message hash and sign it
      final hash = avnuTypedData.hash(account.accountAddress);
      final signature = await ownerAccountSigner.sign(hash, null);

      print('🚀 Executing lock save withdrawal with Avnu...');

      // Execute the transaction via AVNU provider
      final avnuExecute = await _walletService.avnuProvider.execute(
        account.accountAddress.toHexString(),
        jsonEncode(avnuTypedData.toTypedData()),
        signature.map((e) => e.toHexString()).toList(),
        null, // account is already deployed
      );

      if (avnuExecute is AvnuExecuteError) {
        throw Exception('Lock save withdrawal failed: $avnuExecute');
      }

      final result = avnuExecute as AvnuExecuteResult;
      final transactionHash = result.transactionHash;

      if (transactionHash == null || transactionHash.isEmpty) {
        throw Exception('Transaction hash is null or empty');
      }

      print('✅ Lock save withdrawal successful! TX: $transactionHash');
      return transactionHash;
    } catch (e) {
      print('❌ Lock save withdrawal error: $e');
      throw Exception('Failed to withdraw from lock save: $e');
    }
  }

  /// Get lock save details
  Future<Map<String, dynamic>> getLockSave({
    required BigInt lockId,
  }) async {
    final account = _walletService.currentAccount;
    if (account == null) {
      throw Exception('Wallet not connected');
    }

    try {
      print('🔍 Getting lock save details for ID: $lockId');

      // Convert BigInt lockId to u256 format (low, high)
      final low =
          Felt(lockId & BigInt.parse('0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'));
      final high = Felt(lockId >> 128);

      // Prepare function call for get_lock_save
      final functionCall = FunctionCall(
        contractAddress: _contractAddress,
        entryPointSelector: getSelectorByName('get_lock_save'),
        calldata: [low, high],
      );

      // Call the contract
      final response = await account.provider.call(
        request: functionCall,
        blockId: BlockId.latest,
      );

      return response.when(
        result: (result) {
          print('📊 Lock save result: $result');

          if (result.length < 8) {
            throw Exception('Invalid lock save response');
          }

          // Parse the LockSave struct
          final lockSaveData = {
            'id': result[0].toBigInt(),
            'user': result[1].toHexString(),
            'amount': result[2].toBigInt(),
            'interest_rate': result[3].toBigInt(),
            'lock_duration': result[4].toBigInt().toInt(),
            'start_time': result[5].toBigInt().toInt(),
            'maturity_time': result[6].toBigInt().toInt(),
            'title':
                result[7].toString(), // This might need adjustment for felt252
            'is_matured':
                result.length > 8 ? result[8].toBigInt() == BigInt.one : false,
            'is_withdrawn':
                result.length > 9 ? result[9].toBigInt() == BigInt.one : false,
          };

          print('✅ Lock save details retrieved: $lockSaveData');
          return lockSaveData;
        },
        error: (error) {
          print('❌ Failed to get lock save: $error');
          throw Exception('Failed to get lock save: $error');
        },
      );
    } catch (e) {
      print('❌ Error getting lock save details: $e');
      throw Exception('Failed to get lock save details: $e');
    }
  }

  /// Get lock save interest rate for duration
  Future<double> getLockSaveRate({
    required int durationDays,
  }) async {
    final account = _walletService.currentAccount;
    if (account == null) {
      throw Exception('Wallet not connected');
    }

    try {
      print('📊 Getting lock save rate for $durationDays days');

      // Prepare function call for get_lock_save_rate
      final functionCall = FunctionCall(
        contractAddress: _contractAddress,
        entryPointSelector: getSelectorByName('get_lock_save_rate'),
        calldata: [Felt(BigInt.from(durationDays))],
      );

      // Call the contract
      final response = await account.provider.call(
        request: functionCall,
        blockId: BlockId.latest,
      );

      return response.when(
        result: (result) {
          if (result.isEmpty) {
            throw Exception('Invalid rate response');
          }

          // Rate is in basis points (10000 = 100%)
          final rateBasisPoints = result[0].toBigInt().toDouble();
          final ratePercent = rateBasisPoints / 100.0;

          print('✅ Lock save rate: $ratePercent% for $durationDays days');
          return ratePercent;
        },
        error: (error) {
          print('❌ Failed to get lock save rate: $error');
          throw Exception('Failed to get lock save rate: $error');
        },
      );
    } catch (e) {
      print('❌ Error getting lock save rate: $e');
      throw Exception('Failed to get lock save rate: $e');
    }
  }

  /// Calculate lock save maturity amount
  Future<Map<String, BigInt>> calculateLockSaveMaturity({
    required BigInt lockId,
  }) async {
    final account = _walletService.currentAccount;
    if (account == null) {
      throw Exception('Wallet not connected');
    }

    try {
      print('🧮 Calculating lock save maturity for ID: $lockId');

      // Convert BigInt lockId to u256 format (low, high)
      final low =
          Felt(lockId & BigInt.parse('0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'));
      final high = Felt(lockId >> 128);

      // Prepare function call for calculate_lock_save_maturity
      final functionCall = FunctionCall(
        contractAddress: _contractAddress,
        entryPointSelector: getSelectorByName('calculate_lock_save_maturity'),
        calldata: [low, high],
      );

      // Call the contract
      final response = await account.provider.call(
        request: functionCall,
        blockId: BlockId.latest,
      );

      return response.when(
        result: (result) {
          if (result.length < 2) {
            throw Exception('Invalid maturity calculation response');
          }

          final principal = result[0].toBigInt();
          final interest = result[1].toBigInt();
          final total = principal + interest;

          print(
              '✅ Maturity calculation - Principal: $principal, Interest: $interest, Total: $total');
          return {
            'principal': principal,
            'interest': interest,
            'total': total,
          };
        },
        error: (error) {
          print('❌ Failed to calculate lock save maturity: $error');
          throw Exception('Failed to calculate lock save maturity: $error');
        },
      );
    } catch (e) {
      print('❌ Error calculating lock save maturity: $e');
      throw Exception('Failed to calculate lock save maturity: $e');
    }
  }

  /// Get all lock saves for the current user
  Future<List<Map<String, dynamic>>> getUserLockSaves() async {
    // Temporarily return empty list to stop terminal spam
    return [];
  }

  /// Create a goal save
  Future<String> createGoalSave({
    required String title,
    required String category,
    required double targetAmount,
    required int contributionType, // 1=daily, 2=weekly, 3=monthly, 4=manual
    required double contributionAmount,
    required DateTime endDate,
  }) async {
    final account = _walletService.currentAccount;
    if (account == null) {
      throw Exception('Wallet not connected');
    }

    try {
      print('🎯 Creating goal save: $title, Target: $targetAmount USDC');

      // Convert amounts to raw USDC units (6 decimals)
      final rawTargetAmount = BigInt.from((targetAmount * pow(10, 6)).round());
      final rawContributionAmount =
          BigInt.from((contributionAmount * pow(10, 6)).round());
      print(
          '📊 Raw target amount: $rawTargetAmount, Raw contribution: $rawContributionAmount');

      // Convert title and category to felt252
      final titleFelt =
          Felt.fromString(title.length > 31 ? title.substring(0, 31) : title);
      final categoryFelt = Felt.fromString(
          category.length > 31 ? category.substring(0, 31) : category);

      // Convert end date to timestamp
      final endTimestamp = (endDate.millisecondsSinceEpoch / 1000).round();

      // Check current allowance for the contract
      final currentAllowance = await getUsdcAllowance(
        ownerAddress: account.accountAddress.toHexString(),
        spenderAddress: _contractAddress.toHexString(),
      );

      // If allowance is insufficient, approve first
      if (currentAllowance < contributionAmount) {
        print(
            '🔓 Insufficient allowance (${_walletService.formatUsdcBalance(currentAllowance)}), approving ${_walletService.formatUsdcBalance(contributionAmount)} USDC...');
        await _walletService.approveUsdc(
          spenderAddress: _contractAddress.toHexString(),
          amount: contributionAmount,
        );
        print('✅ USDC approval completed');

        // Small delay to ensure approval is processed
        await Future.delayed(Duration(milliseconds: 500));
      }

      // Prepare create_goal_save call data
      final calls = [
        {
          'contractAddress': _contractAddress.toHexString(),
          'entrypoint': 'create_goal_save',
          'calldata': [
            '0x${titleFelt.toBigInt().toRadixString(16)}',
            '0x${categoryFelt.toBigInt().toRadixString(16)}',
            '0x${rawTargetAmount.toRadixString(16)}',
            '0x0', // target_amount.high (assuming < 2^128)
            '0x${contributionType.toRadixString(16)}',
            '0x${rawContributionAmount.toRadixString(16)}',
            '0x0', // contribution_amount.high (assuming < 2^128)
            '0x${endTimestamp.toRadixString(16)}',
          ],
        },
      ];

      print('🔧 Building typed data with Avnu for goal save creation...');

      // Build typed data with AVNU
      final avnuBuildTypeDataResponse =
          await _walletService.avnuProvider.buildTypedData(
        account.accountAddress.toHexString(),
        calls,
        '', // use sponsor gas token
        '', // use sponsor gas limit
        WalletService.argentClassHash.toHexString(),
      );

      if (avnuBuildTypeDataResponse is AvnuBuildTypedDataError) {
        throw Exception(
            'Failed to build typed data: $avnuBuildTypeDataResponse');
      }

      final avnuTypedData =
          avnuBuildTypeDataResponse as AvnuBuildTypedDataResult;

      // Create owner account signer
      final ownerAccountSigner = ArgentXGuardianAccountSigner(
        ownerSigner: _walletService.ownerSigner!,
        guardianSigner: _walletService.guardianSigner!,
      );

      // Compute message hash and sign it
      final hash = avnuTypedData.hash(account.accountAddress);
      final signature = await ownerAccountSigner.sign(hash, null);

      print('🚀 Executing goal save creation with Avnu...');

      // Execute the transaction via AVNU provider
      final avnuExecute = await _walletService.avnuProvider.execute(
        account.accountAddress.toHexString(),
        jsonEncode(avnuTypedData.toTypedData()),
        signature.map((e) => e.toHexString()).toList(),
        null, // account is already deployed
      );

      if (avnuExecute is AvnuExecuteError) {
        throw Exception('Goal save creation failed: $avnuExecute');
      }

      final result = avnuExecute as AvnuExecuteResult;
      final transactionHash = result.transactionHash;

      if (transactionHash == null || transactionHash.isEmpty) {
        throw Exception('Transaction hash is null or empty');
      }

      print('✅ Goal save created successfully! TX: $transactionHash');
      return transactionHash;
    } catch (e) {
      print('❌ Goal save creation error: $e');
      throw Exception('Failed to create goal save: $e');
    }
  }

  /// Contribute to a goal save
  Future<String> contributeGoalSave({
    required BigInt goalId,
    required double amount,
  }) async {
    final account = _walletService.currentAccount;
    if (account == null) {
      throw Exception('Wallet not connected');
    }

    try {
      print('💰 Contributing $amount USDC to goal save ID: $goalId');

      // Convert amount to raw USDC units (6 decimals)
      final rawAmount = BigInt.from((amount * pow(10, 6)).round());
      print('📊 Raw contribution amount: $rawAmount (${amount} USDC)');

      // Check USDC balance before contributing
      final currentBalance = await _walletService.getUsdcBalance();
      if (currentBalance < amount) {
        throw Exception(
            'Insufficient USDC balance. Available: ${_walletService.formatUsdcBalance(currentBalance)}, Required: ${_walletService.formatUsdcBalance(amount)}');
      }

      // Check current allowance for the contract
      final currentAllowance = await getUsdcAllowance(
        ownerAddress: account.accountAddress.toHexString(),
        spenderAddress: _contractAddress.toHexString(),
      );

      // If allowance is insufficient, approve first
      if (currentAllowance < amount) {
        print(
            '🔓 Insufficient allowance (${_walletService.formatUsdcBalance(currentAllowance)}), approving ${_walletService.formatUsdcBalance(amount)} USDC...');
        await _walletService.approveUsdc(
          spenderAddress: _contractAddress.toHexString(),
          amount: amount,
        );
        print('✅ USDC approval completed');

        // Small delay to ensure approval is processed
        await Future.delayed(Duration(milliseconds: 500));
      }

      // Convert BigInt goalId to u256 format (low, high)
      final low = goalId & BigInt.parse('0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
      final high = goalId >> 128;

      // Prepare contribute_goal_save call data
      final calls = [
        {
          'contractAddress': _contractAddress.toHexString(),
          'entrypoint': 'contribute_goal_save',
          'calldata': [
            '0x${low.toRadixString(16)}',
            '0x${high.toRadixString(16)}',
            '0x${rawAmount.toRadixString(16)}',
            '0x0', // amount.high (assuming < 2^128)
          ],
        },
      ];

      print('🔧 Building typed data with Avnu for goal contribution...');

      // Build typed data with AVNU
      final avnuBuildTypeDataResponse =
          await _walletService.avnuProvider.buildTypedData(
        account.accountAddress.toHexString(),
        calls,
        '', // use sponsor gas token
        '', // use sponsor gas limit
        WalletService.argentClassHash.toHexString(),
      );

      if (avnuBuildTypeDataResponse is AvnuBuildTypedDataError) {
        throw Exception(
            'Failed to build typed data: $avnuBuildTypeDataResponse');
      }

      final avnuTypedData =
          avnuBuildTypeDataResponse as AvnuBuildTypedDataResult;

      // Create owner account signer
      final ownerAccountSigner = ArgentXGuardianAccountSigner(
        ownerSigner: _walletService.ownerSigner!,
        guardianSigner: _walletService.guardianSigner!,
      );

      // Compute message hash and sign it
      final hash = avnuTypedData.hash(account.accountAddress);
      final signature = await ownerAccountSigner.sign(hash, null);

      print('🚀 Executing goal contribution with Avnu...');

      // Execute the transaction via AVNU provider
      final avnuExecute = await _walletService.avnuProvider.execute(
        account.accountAddress.toHexString(),
        jsonEncode(avnuTypedData.toTypedData()),
        signature.map((e) => e.toHexString()).toList(),
        null, // account is already deployed
      );

      if (avnuExecute is AvnuExecuteError) {
        throw Exception('Goal contribution failed: $avnuExecute');
      }

      final result = avnuExecute as AvnuExecuteResult;
      final transactionHash = result.transactionHash;

      if (transactionHash == null || transactionHash.isEmpty) {
        throw Exception('Transaction hash is null or empty');
      }

      print('✅ Goal contribution successful! TX: $transactionHash');
      return transactionHash;
    } catch (e) {
      print('❌ Goal contribution error: $e');
      throw Exception('Failed to contribute to goal save: $e');
    }
  }

  /// Get goal save details
  Future<Map<String, dynamic>> getGoalSave({
    required BigInt goalId,
  }) async {
    final account = _walletService.currentAccount;
    if (account == null) {
      throw Exception('Wallet not connected');
    }

    try {
      print('🔍 Getting goal save details for ID: $goalId');

      // Convert BigInt goalId to u256 format (low, high)
      final low = goalId & BigInt.parse('0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
      final high = goalId >> 128;

      // Prepare function call for get_goal_save
      final functionCall = FunctionCall(
        contractAddress: _contractAddress,
        entryPointSelector: getSelectorByName('get_goal_save'),
        calldata: [Felt(low), Felt(high)],
      );

      // Call the contract
      final response = await account.provider.call(
        request: functionCall,
        blockId: BlockId.latest,
      );

      return response.when(
        result: (result) {
          print('📊 Goal save result: $result');

          if (result.length < 10) {
            throw Exception('Invalid goal save response');
          }

          // Parse the GoalSave struct
          final goalSaveData = {
            'id': result[0].toBigInt(),
            'user': result[1].toHexString(),
            'title': result[2].toString(), // felt252
            'category': result[3].toString(), // felt252
            'target_amount': result[4].toBigInt(),
            'current_amount': result[5].toBigInt(),
            'contribution_type': result[6].toBigInt().toInt(),
            'contribution_amount': result[7].toBigInt(),
            'start_time': result[8].toBigInt().toInt(),
            'end_time': result[9].toBigInt().toInt(),
            'is_completed': result.length > 10
                ? result[10].toBigInt() == BigInt.one
                : false,
          };

          print('✅ Goal save details retrieved: $goalSaveData');
          return goalSaveData;
        },
        error: (error) {
          print('❌ Failed to get goal save: $error');
          throw Exception('Failed to get goal save: $error');
        },
      );
    } catch (e) {
      print('❌ Error getting goal save details: $e');
      throw Exception('Failed to get goal save details: $e');
    }
  }

  /// Get all goal saves for the current user
  Future<List<Map<String, dynamic>>> getUserGoalSaves() async {
    // Temporarily return empty list to stop terminal spam
    return [];
  }

  /// Create a group save (public or private)
  Future<String> createGroupSave({
    required String title,
    required String description,
    required String category,
    required double targetAmount,
    required int contributionType, // 1=daily, 2=weekly, 3=monthly, 4=manual
    required double contributionAmount,
    required bool isPublic,
    required DateTime endDate,
  }) async {
    final account = _walletService.currentAccount;
    if (account == null) {
      throw Exception('Wallet not connected');
    }

    try {
      print(
          '👥 Creating ${isPublic ? 'public' : 'private'} group save: $title, Target: $targetAmount USDC');

      // Convert amounts to raw USDC units (6 decimals)
      final rawTargetAmount = BigInt.from((targetAmount * pow(10, 6)).round());
      final rawContributionAmount =
          BigInt.from((contributionAmount * pow(10, 6)).round());
      print(
          '📊 Raw target amount: $rawTargetAmount, Raw contribution: $rawContributionAmount');

      // Convert strings to felt252
      final titleFelt =
          Felt.fromString(title.length > 31 ? title.substring(0, 31) : title);
      final descriptionFelt = Felt.fromString(
          description.length > 31 ? description.substring(0, 31) : description);
      final categoryFelt = Felt.fromString(
          category.length > 31 ? category.substring(0, 31) : category);

      // Convert end date to timestamp
      final endTimestamp = (endDate.millisecondsSinceEpoch / 1000).round();

      // Check current allowance for the contract
      final currentAllowance = await getUsdcAllowance(
        ownerAddress: account.accountAddress.toHexString(),
        spenderAddress: _contractAddress.toHexString(),
      );

      // If allowance is insufficient, approve first
      if (currentAllowance < contributionAmount) {
        print(
            '🔓 Insufficient allowance (${_walletService.formatUsdcBalance(currentAllowance)}), approving ${_walletService.formatUsdcBalance(contributionAmount)} USDC...');
        await _walletService.approveUsdc(
          spenderAddress: _contractAddress.toHexString(),
          amount: contributionAmount,
        );
        print('✅ USDC approval completed');

        // Small delay to ensure approval is processed
        await Future.delayed(Duration(milliseconds: 500));
      }

      // Prepare create_group_save call data
      final calls = [
        {
          'contractAddress': _contractAddress.toHexString(),
          'entrypoint': 'create_group_save',
          'calldata': [
            '0x${titleFelt.toBigInt().toRadixString(16)}',
            '0x${descriptionFelt.toBigInt().toRadixString(16)}',
            '0x${categoryFelt.toBigInt().toRadixString(16)}',
            '0x${rawTargetAmount.toRadixString(16)}',
            '0x0', // target_amount.high (assuming < 2^128)
            '0x${contributionType.toRadixString(16)}',
            '0x${rawContributionAmount.toRadixString(16)}',
            '0x0', // contribution_amount.high (assuming < 2^128)
            isPublic ? '0x1' : '0x0', // is_public as bool
            '0x${endTimestamp.toRadixString(16)}',
          ],
        },
      ];

      print('🔧 Building typed data with Avnu for group save creation...');

      // Build typed data with AVNU
      final avnuBuildTypeDataResponse =
          await _walletService.avnuProvider.buildTypedData(
        account.accountAddress.toHexString(),
        calls,
        '', // use sponsor gas token
        '', // use sponsor gas limit
        WalletService.argentClassHash.toHexString(),
      );

      if (avnuBuildTypeDataResponse is AvnuBuildTypedDataError) {
        throw Exception(
            'Failed to build typed data: $avnuBuildTypeDataResponse');
      }

      final avnuTypedData =
          avnuBuildTypeDataResponse as AvnuBuildTypedDataResult;

      // Create owner account signer
      final ownerAccountSigner = ArgentXGuardianAccountSigner(
        ownerSigner: _walletService.ownerSigner!,
        guardianSigner: _walletService.guardianSigner!,
      );

      // Compute message hash and sign it
      final hash = avnuTypedData.hash(account.accountAddress);
      final signature = await ownerAccountSigner.sign(hash, null);

      print('🚀 Executing group save creation with Avnu...');

      // Execute the transaction via AVNU provider
      final avnuExecute = await _walletService.avnuProvider.execute(
        account.accountAddress.toHexString(),
        jsonEncode(avnuTypedData.toTypedData()),
        signature.map((e) => e.toHexString()).toList(),
        null, // account is already deployed
      );

      if (avnuExecute is AvnuExecuteError) {
        throw Exception('Group save creation failed: $avnuExecute');
      }

      final result = avnuExecute as AvnuExecuteResult;
      final transactionHash = result.transactionHash;

      if (transactionHash == null || transactionHash.isEmpty) {
        throw Exception('Transaction hash is null or empty');
      }

      print('✅ Group save created successfully! TX: $transactionHash');
      return transactionHash;
    } catch (e) {
      print('❌ Group save creation error: $e');
      throw Exception('Failed to create group save: $e');
    }
  }

  /// Join a group save
  Future<String> joinGroupSave({
    required BigInt groupId,
  }) async {
    final account = _walletService.currentAccount;
    if (account == null) {
      throw Exception('Wallet not connected');
    }

    try {
      print('🤝 Joining group save ID: $groupId');

      // Convert BigInt groupId to u256 format (low, high)
      final low = groupId & BigInt.parse('0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
      final high = groupId >> 128;

      // Prepare join_group_save call data
      final calls = [
        {
          'contractAddress': _contractAddress.toHexString(),
          'entrypoint': 'join_group_save',
          'calldata': [
            '0x${low.toRadixString(16)}',
            '0x${high.toRadixString(16)}',
          ],
        },
      ];

      print('🔧 Building typed data with Avnu for joining group save...');

      // Build typed data with AVNU
      final avnuBuildTypeDataResponse =
          await _walletService.avnuProvider.buildTypedData(
        account.accountAddress.toHexString(),
        calls,
        '', // use sponsor gas token
        '', // use sponsor gas limit
        WalletService.argentClassHash.toHexString(),
      );

      if (avnuBuildTypeDataResponse is AvnuBuildTypedDataError) {
        throw Exception(
            'Failed to build typed data: $avnuBuildTypeDataResponse');
      }

      final avnuTypedData =
          avnuBuildTypeDataResponse as AvnuBuildTypedDataResult;

      // Create owner account signer
      final ownerAccountSigner = ArgentXGuardianAccountSigner(
        ownerSigner: _walletService.ownerSigner!,
        guardianSigner: _walletService.guardianSigner!,
      );

      // Compute message hash and sign it
      final hash = avnuTypedData.hash(account.accountAddress);
      final signature = await ownerAccountSigner.sign(hash, null);

      print('🚀 Executing join group save with Avnu...');

      // Execute the transaction via AVNU provider
      final avnuExecute = await _walletService.avnuProvider.execute(
        account.accountAddress.toHexString(),
        jsonEncode(avnuTypedData.toTypedData()),
        signature.map((e) => e.toHexString()).toList(),
        null, // account is already deployed
      );

      if (avnuExecute is AvnuExecuteError) {
        throw Exception('Join group save failed: $avnuExecute');
      }

      final result = avnuExecute as AvnuExecuteResult;
      final transactionHash = result.transactionHash;

      if (transactionHash == null || transactionHash.isEmpty) {
        throw Exception('Transaction hash is null or empty');
      }

      print('✅ Joined group save successfully! TX: $transactionHash');
      return transactionHash;
    } catch (e) {
      print('❌ Join group save error: $e');
      throw Exception('Failed to join group save: $e');
    }
  }

  /// Contribute to a group save
  Future<String> contributeToGroupSave({
    required BigInt groupId,
    required double amount,
  }) async {
    final account = _walletService.currentAccount;
    if (account == null) {
      throw Exception('Wallet not connected');
    }

    try {
      print('💰 Contributing $amount USDC to group save ID: $groupId');

      // Convert amount to raw USDC units (6 decimals)
      final rawAmount = BigInt.from((amount * pow(10, 6)).round());
      print('📊 Raw contribution amount: $rawAmount (${amount} USDC)');

      // Check current allowance for the contract
      final currentAllowance = await getUsdcAllowance(
        ownerAddress: account.accountAddress.toHexString(),
        spenderAddress: _contractAddress.toHexString(),
      );

      // If allowance is insufficient, approve first
      if (currentAllowance < amount) {
        print(
            '🔓 Insufficient allowance (${_walletService.formatUsdcBalance(currentAllowance)}), approving ${_walletService.formatUsdcBalance(amount)} USDC...');
        await _walletService.approveUsdc(
          spenderAddress: _contractAddress.toHexString(),
          amount: amount,
        );
        print('✅ USDC approval completed');

        // Small delay to ensure approval is processed
        await Future.delayed(Duration(milliseconds: 500));
      }

      // Convert BigInt groupId to u256 format (low, high)
      final low = groupId & BigInt.parse('0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
      final high = groupId >> 128;

      // Prepare contribute_to_group_save call data
      final calls = [
        {
          'contractAddress': _contractAddress.toHexString(),
          'entrypoint': 'contribute_to_group_save',
          'calldata': [
            '0x${low.toRadixString(16)}',
            '0x${high.toRadixString(16)}',
            '0x${rawAmount.toRadixString(16)}',
            '0x0', // amount.high (assuming < 2^128)
          ],
        },
      ];

      print('🔧 Building typed data with Avnu for group contribution...');

      // Build typed data with AVNU
      final avnuBuildTypeDataResponse =
          await _walletService.avnuProvider.buildTypedData(
        account.accountAddress.toHexString(),
        calls,
        '', // use sponsor gas token
        '', // use sponsor gas limit
        WalletService.argentClassHash.toHexString(),
      );

      if (avnuBuildTypeDataResponse is AvnuBuildTypedDataError) {
        throw Exception(
            'Failed to build typed data: $avnuBuildTypeDataResponse');
      }

      final avnuTypedData =
          avnuBuildTypeDataResponse as AvnuBuildTypedDataResult;

      // Create owner account signer
      final ownerAccountSigner = ArgentXGuardianAccountSigner(
        ownerSigner: _walletService.ownerSigner!,
        guardianSigner: _walletService.guardianSigner!,
      );

      // Compute message hash and sign it
      final hash = avnuTypedData.hash(account.accountAddress);
      final signature = await ownerAccountSigner.sign(hash, null);

      print('🚀 Executing group contribution with Avnu...');

      // Execute the transaction via AVNU provider
      final avnuExecute = await _walletService.avnuProvider.execute(
        account.accountAddress.toHexString(),
        jsonEncode(avnuTypedData.toTypedData()),
        signature.map((e) => e.toHexString()).toList(),
        null, // account is already deployed
      );

      if (avnuExecute is AvnuExecuteError) {
        throw Exception('Group contribution failed: $avnuExecute');
      }

      final result = avnuExecute as AvnuExecuteResult;
      final transactionHash = result.transactionHash;

      if (transactionHash == null || transactionHash.isEmpty) {
        throw Exception('Transaction hash is null or empty');
      }

      print('✅ Group contribution successful! TX: $transactionHash');
      return transactionHash;
    } catch (e) {
      print('❌ Group contribution error: $e');
      throw Exception('Failed to contribute to group save: $e');
    }
  }

  /// Get group save details
  Future<Map<String, dynamic>> getGroupSave({
    required BigInt groupId,
  }) async {
    final account = _walletService.currentAccount;
    if (account == null) {
      throw Exception('Wallet not connected');
    }

    try {
      print('🔍 Getting group save details for ID: $groupId');

      // Convert BigInt groupId to u256 format (low, high)
      final low = groupId & BigInt.parse('0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
      final high = groupId >> 128;

      // Prepare function call for get_group_save
      final functionCall = FunctionCall(
        contractAddress: _contractAddress,
        entryPointSelector: getSelectorByName('get_group_save'),
        calldata: [Felt(low), Felt(high)],
      );

      // Call the contract
      final response = await account.provider.call(
        request: functionCall,
        blockId: BlockId.latest,
      );

      return response.when(
        result: (result) {
          print('📊 Group save result: $result');

          if (result.length < 12) {
            throw Exception('Invalid group save response');
          }

          // Parse the GroupSave struct
          final groupSaveData = {
            'id': result[0].toBigInt(),
            'creator': result[1].toHexString(),
            'title': result[2].toString(), // felt252
            'description': result[3].toString(), // felt252
            'category': result[4].toString(), // felt252
            'target_amount': result[5].toBigInt(),
            'current_amount': result[6].toBigInt(),
            'contribution_type': result[7].toBigInt().toInt(),
            'contribution_amount': result[8].toBigInt(),
            'is_public': result[9].toBigInt() == BigInt.one,
            'member_count': result[10].toBigInt().toInt(),
            'start_time': result[11].toBigInt().toInt(),
            'end_time': result[12].toBigInt().toInt(),
            'is_completed': result.length > 13
                ? result[13].toBigInt() == BigInt.one
                : false,
          };

          print('✅ Group save details retrieved: $groupSaveData');
          return groupSaveData;
        },
        error: (error) {
          print('❌ Failed to get group save: $error');
          throw Exception('Failed to get group save: $error');
        },
      );
    } catch (e) {
      print('❌ Error getting group save details: $e');
      throw Exception('Failed to get group save details: $e');
    }
  }

  /// Check if user is a member of a group save
  Future<bool> isGroupMember({
    required BigInt groupId,
    required String userAddress,
  }) async {
    final account = _walletService.currentAccount;
    if (account == null) {
      throw Exception('Wallet not connected');
    }

    try {
      // Convert BigInt groupId to u256 format (low, high)
      final groupLow =
          groupId & BigInt.parse('0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
      final groupHigh = groupId >> 128;

      final user = Felt.fromHexString(userAddress);

      // Prepare function call for is_group_member
      final functionCall = FunctionCall(
        contractAddress: _contractAddress,
        entryPointSelector: getSelectorByName('is_group_member'),
        calldata: [Felt(groupLow), Felt(groupHigh), user],
      );

      // Call the contract
      final response = await account.provider.call(
        request: functionCall,
        blockId: BlockId.latest,
      );

      return response.when(
        result: (result) {
          if (result.isEmpty) {
            return false;
          }
          return result[0].toBigInt() == BigInt.one;
        },
        error: (error) => false,
      );
    } catch (e) {
      print('❌ Error checking group membership: $e');
      return false;
    }
  }

  /// Get user's contribution to a group save
  Future<BigInt> getGroupMemberContribution({
    required BigInt groupId,
    required String userAddress,
  }) async {
    final account = _walletService.currentAccount;
    if (account == null) {
      throw Exception('Wallet not connected');
    }

    try {
      // Convert BigInt groupId to u256 format (low, high)
      final groupLow =
          groupId & BigInt.parse('0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
      final groupHigh = groupId >> 128;

      final user = Felt.fromHexString(userAddress);

      // Prepare function call for get_group_member_contribution
      final functionCall = FunctionCall(
        contractAddress: _contractAddress,
        entryPointSelector: getSelectorByName('get_group_member_contribution'),
        calldata: [Felt(groupLow), Felt(groupHigh), user],
      );

      // Call the contract
      final response = await account.provider.call(
        request: functionCall,
        blockId: BlockId.latest,
      );

      return response.when(
        result: (result) {
          if (result.length < 2) {
            return BigInt.zero;
          }
          // Combine low and high parts for u256
          final low = result[0].toBigInt();
          final high = result[1].toBigInt();
          return low + (high << 128);
        },
        error: (error) => BigInt.zero,
      );
    } catch (e) {
      print('❌ Error getting group member contribution: $e');
      return BigInt.zero;
    }
  }

  /// Get group save rate
  Future<double> getGroupSaveRate() async {
    final account = _walletService.currentAccount;
    if (account == null) {
      throw Exception('Wallet not connected');
    }

    try {
      print('📊 Getting group save rate');

      // Prepare function call for get_group_save_rate
      final functionCall = FunctionCall(
        contractAddress: _contractAddress,
        entryPointSelector: getSelectorByName('get_group_save_rate'),
        calldata: [],
      );

      // Call the contract
      final response = await account.provider.call(
        request: functionCall,
        blockId: BlockId.latest,
      );

      return response.when(
        result: (result) {
          if (result.isEmpty) {
            throw Exception('Invalid rate response');
          }

          // Rate is in basis points (10000 = 100%)
          final rateBasisPoints = result[0].toBigInt().toDouble();
          final ratePercent = rateBasisPoints / 100.0;

          print('✅ Group save rate: $ratePercent%');
          return ratePercent;
        },
        error: (error) {
          print('❌ Failed to get group save rate: $error');
          throw Exception('Failed to get group save rate: $error');
        },
      );
    } catch (e) {
      print('❌ Error getting group save rate: $e');
      throw Exception('Failed to get group save rate: $e');
    }
  }
}
