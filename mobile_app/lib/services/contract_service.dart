import 'dart:convert';
import 'dart:math';
import 'package:starknet/starknet.dart';
import 'package:starknet_provider/starknet_provider.dart';
import 'wallet_service.dart';

class ContractService {
  // TODO: Replace with actual deployed contract address
  static const String _contractAddress = 
      '0x0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef';
  
  final WalletService _walletService;
  late final JsonRpcProvider _provider;
  // late final AvnuJsonRpcProvider _avnuProvider; // TODO: Re-enable for Avnu sponsored gas
  
  ContractService(this._walletService) {
    _provider = JsonRpcProvider(
      nodeUri: Uri.parse('https://starknet-sepolia.public.blastapi.io')
    );
    // TODO: Re-enable Avnu provider for sponsored gas
    // _avnuProvider = AvnuJsonRpcProvider(
    //   nodeUri: Uri.parse('https://sepolia.api.avnu.fi'),
    //   apiKey: '4c75a944-a3ff-4292-bce0-7738608bf9da',
    // );
  }

  /// Get contract address as Felt
  Felt get contractAddress => Felt.fromHexString(_contractAddress);

  /// Execute contract call with Avnu sponsored gas
  Future<String> _executeWithSponsoredGas({
    required String functionName,
    required List<Felt> calldata,
  }) async {
    final account = _walletService.currentAccount;
    if (account == null) {
      throw ContractException('No wallet account available');
    }

    try {
      print('🚀 Executing $functionName with Avnu sponsored gas...');

      // For now, use direct contract execution until Avnu integration is fully configured
      final functionCall = FunctionCall(
        contractAddress: contractAddress,
        entryPointSelector: getSelectorByName(functionName),
        calldata: calldata,
      );

      final response = await account.execute(functionCalls: [functionCall]);

      return response.when(
        result: (result) {
          print('✅ $functionName executed successfully! TX: ${result.transaction_hash}');
          return result.transaction_hash;
        },
        error: (error) => throw ContractException('Contract execution failed: $error'),
      );
    } catch (e) {
      print('❌ Error executing $functionName: $e');
      throw ContractException('Failed to execute $functionName: $e');
    }
  }

  /// Execute read-only contract call (no gas needed)
  Future<List<Felt>> _callView({
    required String functionName,
    required List<Felt> calldata,
  }) async {
    try {
      final result = await _provider.call(
        request: FunctionCall(
          contractAddress: contractAddress,
          entryPointSelector: getSelectorByName(functionName),
          calldata: calldata,
        ),
        blockId: BlockId.latest,
      );

      return result.when(
        result: (callResult) => callResult,
        error: (error) => throw ContractException('View call failed: $error'),
      );
    } catch (e) {
      throw ContractException('Failed to call $functionName: $e');
    }
  }

  /// Execute contract call (unified method for both gas and view calls)
  Future<List<Felt>?> _executeContractCall(
    String functionName,
    List<dynamic> calldata, {
    required bool requiresGas,
  }) async {
    try {
      // Convert calldata to proper Felt format
      final feltCalldata = calldata.map((item) {
        if (item is BigInt) {
          return Felt(item);
        } else if (item is Felt) {
          return item;
        } else if (item is int) {
          return Felt(BigInt.from(item));
        } else {
          return item as Felt;
        }
      }).toList();

      if (requiresGas) {
        // Execute with gas (state-changing function)
        final account = _walletService.currentAccount;
        if (account == null) {
          throw ContractException('No wallet account available');
        }

        final functionCall = FunctionCall(
          contractAddress: contractAddress,
          entryPointSelector: getSelectorByName(functionName),
          calldata: feltCalldata,
        );

        final response = await account.execute(functionCalls: [functionCall]);
        return response.when(
          result: (result) {
            print('✅ $functionName executed successfully! TX: ${result.transaction_hash}');
            return [Felt.fromHexString(result.transaction_hash)];
          },
          error: (error) => throw ContractException('Contract execution failed: $error'),
        );
      } else {
        // View call (read-only)
        return await _callView(
          functionName: functionName,
          calldata: feltCalldata,
        );
      }
    } catch (e) {
      print('❌ Error executing $functionName: $e');
      return null;
    }
  }

  /// Convert double to wei (BigInt with 6 decimals)
  BigInt _convertToWei(double amount) {
    return BigInt.from((amount * pow(10, 6)).round());
  }

  /// Convert wei (BigInt) back to double
  double _convertFromWei(BigInt wei) {
    return wei.toDouble() / pow(10, 6);
  }

  // =============================================================================
  // PORKET SAVE FUNCTIONS (formerly Flexi Save)
  // =============================================================================
  Future<bool> depositPorket(double amount) async {
    try {
      final amountInWei = _convertToWei(amount);
      
      final calldata = [amountInWei];
      
      final result = await _executeContractCall(
        'flexi_deposit',
        calldata,
        requiresGas: true,
      );
      
      return result != null;
    } catch (e) {
      print('Error depositing to Porket Save: $e');
      return false;
    }
  }

  Future<bool> withdrawPorket(double amount) async {
    try {
      final amountInWei = _convertToWei(amount);
      
      final calldata = [amountInWei];
      
      final result = await _executeContractCall(
        'flexi_withdraw',
        calldata,
        requiresGas: true,
      );
      
      return result != null;
    } catch (e) {
      print('Error withdrawing from Porket Save: $e');
      return false;
    }
  }

  Future<double> getPorketBalance(String userAddress) async {
    try {
      final userAddressFelt = Felt.fromHexString(userAddress);
      
      final calldata = [userAddressFelt];
      
      final result = await _executeContractCall(
        'get_flexi_balance',
        calldata,
        requiresGas: false,
      );
      
      if (result != null && result.isNotEmpty) {
        return _convertFromWei(result[0] as BigInt);
      }
      return 0.0;
    } catch (e) {
      print('Error getting Porket Save balance: $e');
      return 0.0;
    }
  }

  /// Setup AutoSave
  Future<String> setupAutoSave({
    required bool enabled,
    required String frequency,
    required double amount,
    required String time,
    String? dayOfWeek,
    int? dayOfMonth,
  }) async {
    final rawAmount = _convertToRawAmount(amount);
    
    return await _executeWithSponsoredGas(
      functionName: 'setup_autosave',
      calldata: [
        Felt(BigInt.from(enabled ? 1 : 0)), // enabled
        _stringToFelt(frequency), // frequency
        Felt(rawAmount), // amount.low
        Felt.zero, // amount.high
        _stringToFelt(time), // time
        _stringToFelt(dayOfWeek ?? ''), // day_of_week
        Felt(BigInt.from(dayOfMonth ?? 0)), // day_of_month
      ],
    );
  }

  /// Toggle AutoSave status
  Future<String> toggleAutoSave({
    required String autosaveId,
    required bool enabled,
  }) async {
    return await _executeWithSponsoredGas(
      functionName: 'toggle_autosave',
      calldata: [
        Felt.fromHexString(autosaveId), // autosave_id
        Felt(BigInt.from(enabled ? 1 : 0)), // enabled
      ],
    );
  }

  /// Get Flexi Save balance
  Future<double> getFlexiBalance() async {
    final account = _walletService.currentAccount;
    if (account == null) throw ContractException('No wallet account available');

    final result = await _callView(
      functionName: 'get_user_flexi_balance',
      calldata: [account.accountAddress],
    );

    return _convertFromRawAmount(result);
  }

  // =============================================================================
  // LOCK SAVE FUNCTIONS
  // =============================================================================

  // =============================================================================
  // LOCK SAVE FUNCTIONS
  // =============================================================================

  /// Create Lock Save
  Future<String?> createLockSave(double amount, int durationDays, String title) async {
    try {
      final amountInWei = _convertToWei(amount);
      final durationBigInt = BigInt.from(durationDays);
      final titleFelt = _stringToFelt(title);
      
      final calldata = [amountInWei, durationBigInt, titleFelt];
      
      final result = await _executeContractCall(
        'create_lock_save',
        calldata,
        requiresGas: true,
      );
      
      if (result != null && result.isNotEmpty) {
        return result[0].toString(); // Return lock ID
      }
      return null;
    } catch (e) {
      print('Error creating lock save: $e');
      return null;
    }
  }

  /// Confirm Lock Creation
  Future<String> confirmLockCreation({
    required String lockId,
    required bool interestUpfront,
  }) async {
    return await _executeWithSponsoredGas(
      functionName: 'confirm_lock_creation',
      calldata: [
        Felt.fromHexString(lockId), // lock_id
        Felt(BigInt.from(interestUpfront ? 1 : 0)), // interest_upfront
      ],
    );
  }

  /// Withdraw from Lock Save
  Future<bool> withdrawLockSave(String lockId) async {
    try {
      final lockIdBigInt = BigInt.parse(lockId);
      
      final calldata = [lockIdBigInt];
      
      final result = await _executeContractCall(
        'withdraw_lock_save',
        calldata,
        requiresGas: true,
      );
      
      return result != null;
    } catch (e) {
      print('Error withdrawing lock save: $e');
      return false;
    }
  }

  /// Break lock (emergency withdrawal with penalty)
  Future<bool> breakLockSave(String lockId) async {
    try {
      final lockIdBigInt = BigInt.parse(lockId);
      
      final calldata = [lockIdBigInt];
      
      final result = await _executeContractCall(
        'break_lock_save',
        calldata,
        requiresGas: true,
      );
      
      return result != null;
    } catch (e) {
      print('Error breaking lock save: $e');
      return false;
    }
  }

  /// Calculate lock interest preview
  Future<LockInterestPreview> calculateLockInterest({
    required double amount,
    required int durationDays,
    required String periodId,
  }) async {
    final rawAmount = _convertToRawAmount(amount);
    
    final result = await _callView(
      functionName: 'calculate_lock_interest',
      calldata: [
        Felt(rawAmount), // amount.low
        Felt.zero, // amount.high
        Felt(BigInt.from(durationDays)), // duration_days
        _stringToFelt(periodId), // period_id
      ],
    );

    // Parse result: (interest_amount, total_payout, maturity_timestamp)
    final interestAmount = _convertFromRawAmountBigInt(result[0].toBigInt(), result[1].toBigInt());
    final totalPayout = _convertFromRawAmountBigInt(result[2].toBigInt(), result[3].toBigInt());
    final maturityTimestamp = result[4].toBigInt().toInt();

    return LockInterestPreview(
      interestAmount: interestAmount,
      totalPayout: totalPayout,
      maturityDate: DateTime.fromMillisecondsSinceEpoch(maturityTimestamp * 1000),
    );
  }

  /// Get user locks
  Future<List<LockSaveData>> getUserLocks() async {
    final account = _walletService.currentAccount;
    if (account == null) throw ContractException('No wallet account available');

    final result = await _callView(
      functionName: 'get_user_locks',
      calldata: [account.accountAddress],
    );

    // Parse array of locks - this is simplified, actual parsing depends on contract structure
    return _parseLockSaveArray(result);
  }

  // =============================================================================
  // GOAL SAVE FUNCTIONS
  // =============================================================================

  /// Create Goal Save
  Future<String> createGoalSave({
    required String purpose,
    required String category,
    required double targetAmount,
    required String frequency,
    required double contributionAmount,
    required DateTime startDate,
    required DateTime endDate,
    required String fundSource,
  }) async {
    final rawTargetAmount = _convertToRawAmount(targetAmount);
    final rawContributionAmount = _convertToRawAmount(contributionAmount);
    
    return await _executeWithSponsoredGas(
      functionName: 'create_goal_save',
      calldata: [
        _stringToFelt(purpose), // purpose
        _stringToFelt(category), // category
        Felt(rawTargetAmount), // target_amount.low
        Felt.zero, // target_amount.high
        _stringToFelt(frequency), // frequency
        Felt(rawContributionAmount), // contribution_amount.low
        Felt.zero, // contribution_amount.high
        Felt(BigInt.from(startDate.millisecondsSinceEpoch ~/ 1000)), // start_date
        Felt(BigInt.from(endDate.millisecondsSinceEpoch ~/ 1000)), // end_date
        _stringToFelt(fundSource), // fund_source
      ],
    );
  }

  /// Contribute to Goal Save
  Future<String> contributeGoalSave({
    required String goalId,
    required double amount,
  }) async {
    final rawAmount = _convertToRawAmount(amount);
    
    return await _executeWithSponsoredGas(
      functionName: 'contribute_goal_save',
      calldata: [
        Felt.fromHexString(goalId), // goal_id
        Felt(rawAmount), // amount.low
        Felt.zero, // amount.high
      ],
    );
  }

  /// Withdraw from Goal Save
  Future<String> withdrawGoalSave({
    required String goalId,
    required double amount,
  }) async {
    final rawAmount = _convertToRawAmount(amount);
    
    return await _executeWithSponsoredGas(
      functionName: 'withdraw_goal_save',
      calldata: [
        Felt.fromHexString(goalId), // goal_id
        Felt(rawAmount), // amount.low
        Felt.zero, // amount.high
      ],
    );
  }

  /// Claim completed goal
  Future<String> claimCompletedGoal({required String goalId}) async {
    return await _executeWithSponsoredGas(
      functionName: 'claim_completed_goal',
      calldata: [Felt.fromHexString(goalId)],
    );
  }

  /// Get user goals
  Future<List<GoalSaveData>> getUserGoals() async {
    final account = _walletService.currentAccount;
    if (account == null) throw ContractException('No wallet account available');

    final result = await _callView(
      functionName: 'get_user_goals',
      calldata: [account.accountAddress],
    );

    return _parseGoalSaveArray(result);
  }

  // =============================================================================
  // GROUP SAVE FUNCTIONS
  // =============================================================================

  /// Create Group Save (Public or Private)
  Future<String> createGroupSave({
    required String name,
    required String description,
    required String category,
    required double targetAmount,
    required String frequency,
    required double contributionAmount,
    required DateTime startDate,
    required DateTime endDate,
    required bool isPublic,
    String? groupCode,
  }) async {
    final rawTargetAmount = _convertToRawAmount(targetAmount);
    final rawContributionAmount = _convertToRawAmount(contributionAmount);
    
    return await _executeWithSponsoredGas(
      functionName: 'create_group_save',
      calldata: [
        _stringToFelt(name), // name
        _stringToFelt(description), // description
        _stringToFelt(category), // category
        Felt(rawTargetAmount), // target_amount.low
        Felt.zero, // target_amount.high
        _stringToFelt(frequency), // frequency
        Felt(rawContributionAmount), // contribution_amount.low
        Felt.zero, // contribution_amount.high
        Felt(BigInt.from(startDate.millisecondsSinceEpoch ~/ 1000)), // start_date
        Felt(BigInt.from(endDate.millisecondsSinceEpoch ~/ 1000)), // end_date
        Felt(isPublic ? 1 : 0), // is_public
        _stringToFelt(groupCode ?? ''), // group_code
      ],
    );
  }

  /// Join Group Save
  Future<String> joinGroupSave({
    required String groupId,
    String? groupCode,
  }) async {
    return await _executeWithSponsoredGas(
      functionName: 'join_group_save',
      calldata: [
        Felt.fromHexString(groupId), // group_id
        _stringToFelt(groupCode ?? ''), // group_code
      ],
    );
  }

  /// Contribute to Group Save
  Future<String> contributeGroupSave({
    required String groupId,
    required double amount,
  }) async {
    final rawAmount = _convertToRawAmount(amount);
    
    return await _executeWithSponsoredGas(
      functionName: 'contribute_group_save',
      calldata: [
        Felt.fromHexString(groupId), // group_id
        Felt(rawAmount), // amount.low
        Felt.zero, // amount.high
      ],
    );
  }

  /// Leave Group Save
  Future<String> leaveGroupSave({required String groupId}) async {
    return await _executeWithSponsoredGas(
      functionName: 'leave_group_save',
      calldata: [Felt.fromHexString(groupId)],
    );
  }

  /// Get public groups
  Future<List<GroupSaveData>> getPublicGroups({
    int limit = 20,
    int offset = 0,
  }) async {
    final result = await _callView(
      functionName: 'get_public_groups',
      calldata: [
        Felt(BigInt.from(limit)),
        Felt(BigInt.from(offset)),
      ],
    );

    return _parseGroupSaveArray(result);
  }

  /// Get user groups
  Future<List<GroupSaveData>> getUserGroups() async {
    final account = _walletService.currentAccount;
    if (account == null) throw ContractException('No wallet account available');

    final result = await _callView(
      functionName: 'get_user_groups',
      calldata: [account.accountAddress],
    );

    return _parseGroupSaveArray(result);
  }

  // =============================================================================
  // INVESTMENT FUNCTIONS
  // =============================================================================

  /// Invest in protocol
  Future<String> investInProtocol({
    required String protocolId,
    required double amount,
  }) async {
    final rawAmount = _convertToRawAmount(amount);
    
    return await _executeWithSponsoredGas(
      functionName: 'invest_in_protocol',
      calldata: [
        _stringToFelt(protocolId), // protocol_id
        Felt(rawAmount), // amount.low
        Felt.zero, // amount.high
      ],
    );
  }

  /// Withdraw investment
  Future<String> withdrawInvestment({required String investmentId}) async {
    return await _executeWithSponsoredGas(
      functionName: 'withdraw_investment',
      calldata: [Felt.fromHexString(investmentId)],
    );
  }

  /// Get available investment protocols
  Future<List<InvestmentProtocol>> getAvailableProtocols() async {
    final result = await _callView(
      functionName: 'get_available_protocols',
      calldata: [],
    );

    return _parseInvestmentProtocolArray(result);
  }

  // =============================================================================
  // DASHBOARD/QUERY FUNCTIONS
  // =============================================================================

  /// Get user total balance across all savings plans
  Future<double> getUserTotalBalance() async {
    final account = _walletService.currentAccount;
    if (account == null) throw ContractException('No wallet account available');

    final result = await _callView(
      functionName: 'get_user_balance',
      calldata: [account.accountAddress],
    );

    return _convertFromRawAmount(result);
  }

  /// Get user statistics
  Future<UserStats> getUserStats() async {
    final account = _walletService.currentAccount;
    if (account == null) throw ContractException('No wallet account available');

    final result = await _callView(
      functionName: 'get_user_stats',
      calldata: [account.accountAddress],
    );

    // Parse result: (day_streak, tokens_earned, total_returns, achievement_count)
    return UserStats(
      dayStreak: result[0].toBigInt().toInt(),
      tokensEarned: _convertFromRawAmountBigInt(result[1].toBigInt(), result.length > 2 ? result[2].toBigInt() : BigInt.zero),
      totalReturns: _convertFromRawAmountBigInt(result.length > 3 ? result[3].toBigInt() : BigInt.zero, result.length > 4 ? result[4].toBigInt() : BigInt.zero),
      achievementCount: result.length > 5 ? result[5].toBigInt().toInt() : 0,
    );
  }

  /// Get transaction history
  Future<List<TransactionData>> getTransactionHistory({
    int limit = 50,
    int offset = 0,
  }) async {
    final account = _walletService.currentAccount;
    if (account == null) throw ContractException('No wallet account available');

    final result = await _callView(
      functionName: 'get_user_transactions',
      calldata: [
        account.accountAddress,
        Felt(BigInt.from(limit)),
        Felt(BigInt.from(offset)),
      ],
    );

    return _parseTransactionArray(result);
  }

  /// Get dynamic interest rates for Lock Save
  Future<List<InterestRate>> getDynamicInterestRates() async {
    final result = await _callView(
      functionName: 'get_dynamic_interest_rates',
      calldata: [],
    );

    return _parseInterestRateArray(result);
  }

  // =============================================================================
  // UTILITY FUNCTIONS
  // =============================================================================

  /// Convert double amount to raw BigInt (assuming 6 decimals like USDC)
  BigInt _convertToRawAmount(double amount) {
    return BigInt.from((amount * pow(10, 6)).round());
  }

  /// Convert raw amount result to double
  double _convertFromRawAmount(List<Felt> result) {
    if (result.isEmpty) return 0.0;
    
    final balanceLow = result[0].toBigInt();
    final balanceHigh = result.length > 1 ? result[1].toBigInt() : BigInt.zero;
    
    final fullBalance = balanceLow + (balanceHigh << 128);
    return fullBalance.toDouble() / pow(10, 6);
  }

  /// Convert raw amount from BigInt parts to double
  double _convertFromRawAmountBigInt(BigInt low, BigInt high) {
    final fullBalance = low + (high << 128);
    return fullBalance.toDouble() / pow(10, 6);
  }

  /// Convert string to Felt (Cairo felt252)
  Felt _stringToFelt(String str) {
    if (str.isEmpty) return Felt.zero;
    
    // Convert string to bytes and then to BigInt
    final bytes = utf8.encode(str);
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return Felt.fromHexString('0x$hex');
  }

  // =============================================================================
  // PARSING FUNCTIONS (Simplified - adjust based on actual contract structure)
  // =============================================================================

  List<LockSaveData> _parseLockSaveArray(List<Felt> result) {
    // Simplified parsing - adjust based on actual contract array structure
    final locks = <LockSaveData>[];
    // TODO: Implement proper array parsing based on contract structure
    return locks;
  }

  List<LockSaveData> _parseLockSaves(List<Felt> result) {
    return _parseLockSaveArray(result);
  }

  LockSaveData? _parseSingleLockSave(List<Felt> result) {
    if (result.length < 8) return null;
    
    return LockSaveData(
      id: result[0].toBigInt().toString(),
      title: 'Lock Save', // TODO: Parse actual title from contract
      amount: _convertFromWei(result[2].toBigInt()),
      interestRate: result[3].toBigInt().toDouble() / 100, // Convert basis points to percentage
      maturityDate: DateTime.fromMillisecondsSinceEpoch(result[6].toBigInt().toInt() * 1000),
      isMatured: result[7].toBigInt() == BigInt.one,
      status: result[7].toBigInt() == BigInt.one ? 'Matured' : 'Active',
    );
  }

  List<GoalSaveData> _parseGoalSaveArray(List<Felt> result) {
    final goals = <GoalSaveData>[];
    // TODO: Implement proper array parsing based on contract structure
    return goals;
  }

  List<GroupSaveData> _parseGroupSaveArray(List<Felt> result) {
    final groups = <GroupSaveData>[];
    // TODO: Implement proper array parsing based on contract structure
    return groups;
  }

  List<InvestmentProtocol> _parseInvestmentProtocolArray(List<Felt> result) {
    final protocols = <InvestmentProtocol>[];
    // TODO: Implement proper array parsing based on contract structure
    return protocols;
  }

  List<TransactionData> _parseTransactionArray(List<Felt> result) {
    final transactions = <TransactionData>[];
    // TODO: Implement proper array parsing based on contract structure
    return transactions;
  }

  List<InterestRate> _parseInterestRateArray(List<Felt> result) {
    final rates = <InterestRate>[];
    // TODO: Implement proper array parsing based on contract structure
    return rates;
  }
}

// =============================================================================
// DATA MODELS
// =============================================================================

class LockInterestPreview {
  final double interestAmount;
  final double totalPayout;
  final DateTime maturityDate;

  LockInterestPreview({
    required this.interestAmount,
    required this.totalPayout,
    required this.maturityDate,
  });
}

class LockSaveData {
  final String id;
  final String title;
  final double amount;
  final double interestRate;
  final DateTime maturityDate;
  final bool isMatured;
  final String status;

  LockSaveData({
    required this.id,
    required this.title,
    required this.amount,
    required this.interestRate,
    required this.maturityDate,
    required this.isMatured,
    required this.status,
  });
}

class GoalSaveData {
  final String id;
  final String purpose;
  final String category;
  final double targetAmount;
  final double currentAmount;
  final double contributionAmount;
  final String frequency;
  final DateTime startDate;
  final DateTime endDate;
  final bool isCompleted;

  GoalSaveData({
    required this.id,
    required this.purpose,
    required this.category,
    required this.targetAmount,
    required this.currentAmount,
    required this.contributionAmount,
    required this.frequency,
    required this.startDate,
    required this.endDate,
    required this.isCompleted,
  });

  double get progressPercentage => 
      targetAmount > 0 ? (currentAmount / targetAmount * 100).clamp(0, 100) : 0;
}

class GroupSaveData {
  final String id;
  final String name;
  final String description;
  final String category;
  final double targetAmount;
  final double currentAmount;
  final int memberCount;
  final bool isPublic;
  final DateTime startDate;
  final DateTime endDate;
  final bool isCompleted;

  GroupSaveData({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.targetAmount,
    required this.currentAmount,
    required this.memberCount,
    required this.isPublic,
    required this.startDate,
    required this.endDate,
    required this.isCompleted,
  });

  double get progressPercentage => 
      targetAmount > 0 ? (currentAmount / targetAmount * 100).clamp(0, 100) : 0;
}

class InvestmentProtocol {
  final String id;
  final String name;
  final String description;
  final double apy;
  final double minimumAmount;
  final int lockPeriodDays;

  InvestmentProtocol({
    required this.id,
    required this.name,
    required this.description,
    required this.apy,
    required this.minimumAmount,
    required this.lockPeriodDays,
  });
}

class UserStats {
  final int dayStreak;
  final double tokensEarned;
  final double totalReturns;
  final int achievementCount;

  UserStats({
    required this.dayStreak,
    required this.tokensEarned,
    required this.totalReturns,
    required this.achievementCount,
  });
}

class TransactionData {
  final String id;
  final String type;
  final double amount;
  final DateTime timestamp;
  final String status;
  final String? description;

  TransactionData({
    required this.id,
    required this.type,
    required this.amount,
    required this.timestamp,
    required this.status,
    this.description,
  });
}

class InterestRate {
  final String periodId;
  final int durationDays;
  final double annualRate;
  final DateTime date;
  final double dailyRate;

  InterestRate({
    required this.periodId,
    required this.durationDays,
    required this.annualRate,
    required this.date,
    required this.dailyRate,
  });
}

class ContractException implements Exception {
  final String message;
  ContractException(this.message);

  @override
  String toString() => 'ContractException: $message';
}
