import 'dart:convert';
import 'dart:math';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_app/services/wallet_service.dart';

class MockDataService {
  static const _storage = FlutterSecureStorage();
  static const String _balancesKey = 'mock_balances';
  static const String _transactionsKey = 'mock_transactions';
  static const String _lockSavesKey = 'mock_lock_saves';
  static const String _goalSavesKey = 'mock_goal_saves';
  static const String _groupSavesKey = 'mock_group_saves';
  static const String _userGroupsKey = 'mock_user_groups';
  static const String _autoSaveKey = 'mock_auto_save';

  // Singleton pattern
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  MockDataService._internal();

  // In-memory cache
  Map<String, dynamic>? _balances;
  List<Map<String, dynamic>>? _transactions;
  List<Map<String, dynamic>>? _lockSaves;
  List<Map<String, dynamic>>? _goalSaves;
  List<Map<String, dynamic>>? _groupSaves;
  List<String>? _userGroups;
  Map<String, dynamic>? _autoSave;

  // Initialize with default data
  Future<void> initialize() async {
    await _loadAllData();
    if (_balances == null || _lockSaves == null || _goalSaves == null) {
      await _initializeDefaultData();
    }
  }

  Future<void> _loadAllData() async {
    try {
      final balancesJson = await _storage.read(key: _balancesKey);
      final transactionsJson = await _storage.read(key: _transactionsKey);
      final lockSavesJson = await _storage.read(key: _lockSavesKey);
      final goalSavesJson = await _storage.read(key: _goalSavesKey);
      final groupSavesJson = await _storage.read(key: _groupSavesKey);
      final userGroupsJson = await _storage.read(key: _userGroupsKey);
      final autoSaveJson = await _storage.read(key: _autoSaveKey);

      _balances = balancesJson != null ? jsonDecode(balancesJson) : null;
      _transactions = transactionsJson != null
          ? List<Map<String, dynamic>>.from(jsonDecode(transactionsJson))
          : null;
      _lockSaves = lockSavesJson != null
          ? List<Map<String, dynamic>>.from(jsonDecode(lockSavesJson))
          : null;
      _goalSaves = goalSavesJson != null
          ? List<Map<String, dynamic>>.from(jsonDecode(goalSavesJson))
          : null;
      _groupSaves = groupSavesJson != null
          ? List<Map<String, dynamic>>.from(jsonDecode(groupSavesJson))
          : null;
      _userGroups = userGroupsJson != null
          ? List<String>.from(jsonDecode(userGroupsJson))
          : null;
      _autoSave = autoSaveJson != null ? jsonDecode(autoSaveJson) : null;
    } catch (e) {
      print('Error loading mock data: $e');
    }
  }

  Future<void> _initializeDefaultData() async {
    _balances = {
      'flexi': 2500.0,
      'lock': 8750.0,
      'goal': 3200.0,
      'group': 1800.0,
      'usdc': 15000.0, // Total USDC balance
    };

    _transactions = [
      {
        'id': '1',
        'type': 'deposit',
        'amount': 1000.0,
        'plan': 'flexi',
        'date': DateTime.now().subtract(Duration(days: 2)).toIso8601String(),
        'status': 'completed',
        'hash': '0x1a2b3c4d5e6f7890abcdef1234567890',
      },
      {
        'id': '2',
        'type': 'lock_create',
        'amount': 5000.0,
        'plan': 'lock',
        'date': DateTime.now().subtract(Duration(days: 5)).toIso8601String(),
        'status': 'completed',
        'hash': '0x9876543210fedcba0987654321abcdef',
        'details': {'duration': 90, 'title': 'Vacation Fund'},
      },
    ];

    _lockSaves = [
      {
        'id': '1',
        'amount': 5000.0,
        'title': 'Vacation Fund',
        'duration': 90,
        'interestRate': 0.078,
        'createdDate':
            DateTime.now().subtract(Duration(days: 5)).toIso8601String(),
        'maturityDate':
            DateTime.now().add(Duration(days: 85)).toIso8601String(),
        'status': 'active',
        'projectedReturn': 5000.0 * 0.078 * (90 / 365),
      },
      {
        'id': '2',
        'amount': 3750.0,
        'title': 'Emergency Fund',
        'duration': 180,
        'interestRate': 0.091,
        'createdDate':
            DateTime.now().subtract(Duration(days: 30)).toIso8601String(),
        'maturityDate':
            DateTime.now().add(Duration(days: 150)).toIso8601String(),
        'status': 'active',
        'projectedReturn': 3750.0 * 0.091 * (180 / 365),
      },
    ];

    _goalSaves = [
      {
        'id': '1',
        'title': 'New Car',
        'category': 'car',
        'targetAmount': 25000.0,
        'currentAmount': 3200.0,
        'frequency': 'monthly',
        'contributionAmount': 800.0,
        'startDate':
            DateTime.now().subtract(Duration(days: 120)).toIso8601String(),
        'endDate': DateTime.now().add(Duration(days: 600)).toIso8601String(),
        'status': 'active',
        'progress': 0.128, // 3200 / 25000
      },
    ];

    _groupSaves = [
      {
        'id': '1',
        'title': 'Tech Startup Fund',
        'description': 'Saving together for our startup dreams',
        'category': 'business',
        'targetAmount': 100000.0,
        'currentAmount': 45600.0,
        'memberCount': 12,
        'isPublic': true,
        'createdDate':
            DateTime.now().subtract(Duration(days: 60)).toIso8601String(),
        'endDate': DateTime.now().add(Duration(days: 300)).toIso8601String(),
        'status': 'active',
        'progress': 0.456,
        'rank': 3, // User's rank in the group
        'userContribution': 1800.0,
      },
      {
        'id': '2',
        'title': 'Community School Fund',
        'description': 'Building a better future for our children',
        'category': 'education',
        'targetAmount': 50000.0,
        'currentAmount': 28900.0,
        'memberCount': 25,
        'isPublic': true,
        'createdDate':
            DateTime.now().subtract(Duration(days: 90)).toIso8601String(),
        'endDate': DateTime.now().add(Duration(days: 270)).toIso8601String(),
        'status': 'active',
        'progress': 0.578,
        'rank': null, // Not a member
        'userContribution': 0.0,
      },
    ];

    _userGroups = ['1']; // User is member of group 1

    _autoSave = {
      'enabled': true,
      'amount': 200.0,
      'frequency': 'weekly',
      'fundSource': 'Porket Wallet',
      'nextExecution': DateTime.now().add(Duration(days: 3)).toIso8601String(),
    };

    await _saveAllData();
  }

  Future<void> _saveAllData() async {
    try {
      await _storage.write(key: _balancesKey, value: jsonEncode(_balances));
      await _storage.write(
          key: _transactionsKey, value: jsonEncode(_transactions));
      await _storage.write(key: _lockSavesKey, value: jsonEncode(_lockSaves));
      await _storage.write(key: _goalSavesKey, value: jsonEncode(_goalSaves));
      await _storage.write(key: _groupSavesKey, value: jsonEncode(_groupSaves));
      await _storage.write(key: _userGroupsKey, value: jsonEncode(_userGroups));
      await _storage.write(key: _autoSaveKey, value: jsonEncode(_autoSave));
    } catch (e) {
      print('Error saving mock data: $e');
    }
  }

  // Balance operations
  Future<Map<String, dynamic>> getBalances() async {
    await initialize();
    return Map<String, dynamic>.from(_balances!);
  }

  Future<double> getBalance(String plan) async {
    await initialize();
    return (_balances![plan] ?? 0.0).toDouble();
  }

  Future<void> updateBalance(String plan, double amount,
      {bool isDebit = false}) async {
    await initialize();
    final currentBalance = (_balances![plan] ?? 0.0).toDouble();
    _balances![plan] =
        isDebit ? currentBalance - amount : currentBalance + amount;

    // Also update USDC balance
    final currentUsdc = (_balances!['usdc'] ?? 0.0).toDouble();
    _balances!['usdc'] = isDebit ? currentUsdc + amount : currentUsdc - amount;

    await _saveAllData();
  }

  // Transaction operations
  Future<List<Map<String, dynamic>>> getTransactions() async {
    await initialize();
    return List<Map<String, dynamic>>.from(_transactions!);
  }

  Future<String> addTransaction({
    required String type,
    required double amount,
    required String plan,
    String? status = 'completed',
    Map<String, dynamic>? details,
  }) async {
    await initialize();

    final transaction = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'type': type,
      'amount': amount,
      'plan': plan,
      'date': DateTime.now().toIso8601String(),
      'status': status,
      'hash': _generateMockHash(),
      if (details != null) 'details': details,
    };

    _transactions!.insert(0, transaction);
    await _saveAllData();
    return transaction['hash'] as String;
  }

  // Lock Save operations
  Future<List<Map<String, dynamic>>> getLockSaves() async {
    await initialize();
    print('🔍 GETTING LOCKS: Found ${_lockSaves!.length} locks in storage');
    for (var lock in _lockSaves!) {
      print('🔍 Lock: ${lock['id']} - ${lock['title']} - \$${lock['amount']}');
    }
    return List<Map<String, dynamic>>.from(_lockSaves!);
  }

  Future<String> createLockSave({
    required double amount,
    required String title,
    required int durationDays,
  }) async {
    await initialize();

    final interestRate = _calculateInterestRate(durationDays);
    final projectedReturn = amount * interestRate * (durationDays / 365);

    final lockSave = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'amount': amount,
      'title': title,
      'duration': durationDays,
      'interestRate': interestRate,
      'createdDate': DateTime.now().toIso8601String(),
      'maturityDate':
          DateTime.now().add(Duration(days: durationDays)).toIso8601String(),
      'status': 'active',
      'projectedReturn': projectedReturn,
    };

    _lockSaves!.add(lockSave);

    // Update balances - save to storage
    await updateBalance('lock', amount);
    await _saveAllData();
    print(
        '🔒 LOCK SAVE CREATED: ${lockSave['id']} - ${lockSave['title']} - \$${lockSave['amount']}');
    print('🔒 TOTAL LOCKS NOW: ${_lockSaves!.length}');

    // Add transaction
    await addTransaction(
      type: 'lock_create',
      amount: amount,
      plan: 'lock',
      details: {'duration': durationDays, 'title': title},
    );

    return _generateMockHash();
  }

  double _calculateInterestRate(int durationDays) {
    if (durationDays <= 30) return 0.055;
    if (durationDays <= 60) return 0.062;
    if (durationDays <= 180) return 0.078;
    if (durationDays <= 270) return 0.091;
    return 0.125;
  }

  // Goal Save operations
  Future<List<Map<String, dynamic>>> getGoalSaves() async {
    await initialize();
    return List<Map<String, dynamic>>.from(_goalSaves!);
  }

  Future<String> createGoalSave({
    required String title,
    required String category,
    required double targetAmount,
    required String frequency,
    required double contributionAmount,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    await initialize();

    final goalSave = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': title,
      'category': category,
      'targetAmount': targetAmount,
      'currentAmount': 0.0,
      'frequency': frequency,
      'contributionAmount': contributionAmount,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': 'active',
      'progress': 0.0,
      'interestRate': 12.0, // Default interest rate for goal saves
    };

    _goalSaves!.add(goalSave);
    await _saveAllData();
    return _generateMockHash();
  }

  Future<String> contributeToGoal(String goalId, double amount) async {
    await initialize();

    final goalIndex = _goalSaves!.indexWhere((g) => g['id'] == goalId);
    if (goalIndex != -1) {
      final goal = _goalSaves![goalIndex];
      final newAmount = (goal['currentAmount'] as double) + amount;
      final progress = newAmount / (goal['targetAmount'] as double);

      _goalSaves![goalIndex] = {
        ...goal,
        'currentAmount': newAmount,
        'progress': progress.clamp(0.0, 1.0),
        'status': progress >= 1.0 ? 'completed' : 'active',
      };

      // Update balances
      await updateBalance('goal', amount);

      // Add transaction
      await addTransaction(
        type: 'goal_contribute',
        amount: amount,
        plan: 'goal',
        details: {'goalId': goalId, 'goalTitle': goal['title']},
      );
    }

    return _generateMockHash();
  }

  // Group Save operations
  Future<List<Map<String, dynamic>>> getGroupSaves() async {
    await initialize();
    return List<Map<String, dynamic>>.from(_groupSaves!);
  }

  Future<List<Map<String, dynamic>>> getPublicGroups() async {
    await initialize();
    return _groupSaves!.where((g) => g['isPublic'] == true).toList();
  }

  Future<List<Map<String, dynamic>>> getUserGroups() async {
    await initialize();
    return _groupSaves!.where((g) => _userGroups!.contains(g['id'])).toList();
  }

  Future<String> joinGroup(String groupId) async {
    await initialize();

    if (!_userGroups!.contains(groupId)) {
      _userGroups!.add(groupId);

      // Update group member count
      final groupIndex = _groupSaves!.indexWhere((g) => g['id'] == groupId);
      if (groupIndex != -1) {
        _groupSaves![groupIndex]['memberCount'] =
            (_groupSaves![groupIndex]['memberCount'] as int) + 1;
      }

      await _saveAllData();
    }

    return _generateMockHash();
  }

  Future<String> createGroupSave({
    required String title,
    required String description,
    required String category,
    required double targetAmount,
    required String contributionType,
    double? contributionAmount,
    DateTime? startDate,
    DateTime? endDate,
    required bool isPublic,
    String? groupCode,
  }) async {
    await initialize();

    final groupSave = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': title,
      'description': description,
      'category': category,
      'targetAmount': targetAmount,
      'currentAmount': 0.0,
      'userContribution': 0.0,
      'contributionType': contributionType,
      'contributionAmount': contributionAmount ?? 0.0,
      'startDate': (startDate ?? DateTime.now()).toIso8601String(),
      'endDate': (endDate ?? DateTime.now().add(Duration(days: 365)))
          .toIso8601String(),
      'isPublic': isPublic,
      'groupCode': groupCode,
      'status': 'active',
      'progress': 0.0,
      'memberCount': 1,
      'interestRate': 8.0,
    };

    _groupSaves!.add(groupSave);
    _userGroups!.add(groupSave['id'] as String);

    await _saveAllData();
    return _generateMockHash();
  }

  Future<String> contributeToGroup(String groupId, double amount) async {
    await initialize();

    final groupIndex = _groupSaves!.indexWhere((g) => g['id'] == groupId);
    if (groupIndex != -1) {
      final group = _groupSaves![groupIndex];
      final newAmount = (group['currentAmount'] as double) + amount;
      final userContribution = (group['userContribution'] as double) + amount;
      final progress = newAmount / (group['targetAmount'] as double);

      _groupSaves![groupIndex] = {
        ...group,
        'currentAmount': newAmount,
        'userContribution': userContribution,
        'progress': progress.clamp(0.0, 1.0),
        'status': progress >= 1.0 ? 'completed' : 'active',
      };

      // Update balances
      await updateBalance('group', amount);

      // Add transaction
      await addTransaction(
        type: 'group_contribute',
        amount: amount,
        plan: 'group',
        details: {'groupId': groupId, 'groupTitle': group['title']},
      );
    }

    return _generateMockHash();
  }

  // Auto Save operations
  Future<Map<String, dynamic>> getAutoSave() async {
    await initialize();
    return Map<String, dynamic>.from(_autoSave!);
  }

  Future<void> updateAutoSave({
    required bool enabled,
    required double amount,
    required String frequency,
    required String fundSource,
  }) async {
    await initialize();

    _autoSave = {
      'enabled': enabled,
      'amount': amount,
      'frequency': frequency,
      'fundSource': fundSource,
      'nextExecution': enabled ? _calculateNextExecution(frequency) : null,
    };

    await _saveAllData();
  }

  String _calculateNextExecution(String frequency) {
    final now = DateTime.now();
    switch (frequency) {
      case 'daily':
        return now.add(Duration(days: 1)).toIso8601String();
      case 'weekly':
        return now.add(Duration(days: 7)).toIso8601String();
      case 'monthly':
        return DateTime(now.year, now.month + 1, now.day).toIso8601String();
      default:
        return now.add(Duration(days: 7)).toIso8601String();
    }
  }

  // Flexi Save operations
  Future<String> depositToFlexi(double amount, String fundSource) async {
    await initialize();

    // Update balance
    await updateBalance('flexi', amount);

    // Add transaction
    await addTransaction(
      type: 'deposit',
      amount: amount,
      plan: 'flexi',
      details: {'fundSource': fundSource},
    );

    return _generateMockHash();
  }

  Future<String> withdrawFromFlexi(double amount) async {
    await initialize();

    final currentBalance = await getBalance('flexi');
    if (currentBalance < amount) {
      throw Exception('Insufficient balance');
    }

    // Update balance
    await updateBalance('flexi', amount, isDebit: true);

    // Add transaction
    await addTransaction(
      type: 'withdrawal',
      amount: amount,
      plan: 'flexi',
    );

    return _generateMockHash();
  }

  // Utility methods
  String _generateMockHash() {
    final random = Random();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomPart =
        random.nextInt(0xFFFFFF).toRadixString(16).padLeft(6, '0');
    return '0x${timestamp.toRadixString(16)}${randomPart}';
  }

  // Reset all data (for testing)
  Future<void> resetAllData() async {
    await _storage.deleteAll();
    _balances = null;
    _transactions = null;
    _lockSaves = null;
    _goalSaves = null;
    _groupSaves = null;
    _userGroups = null;
    _autoSave = null;
    await initialize();
  }
}
