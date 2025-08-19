import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:mobile_app/services/contract_service.dart';
import 'package:mobile_app/services/wallet_service.dart';
import 'package:mobile_app/app/app.locator.dart';

class LockSaveViewModel extends BaseViewModel {
  // Services
  final ContractService _contractService = locator<ContractService>();
  final WalletService _walletService = locator<WalletService>();
  final NavigationService _navigationService = NavigationService();
  
  // State properties
  bool _isOngoingSelected = true;
  bool _isBalanceVisible = true;
  double _lockSaveBalance = 0.0;
  List<LockSaveData> _ongoingLocks = [];
  List<LockSaveData> _completedLocks = [];
  List<Map<String, dynamic>> _legacyOngoingLocks = [];
  List<Map<String, dynamic>> _legacyCompletedLocks = [];

  // Lock period configurations with interest rates
  final List<Map<String, dynamic>> _lockPeriods = [
    {
      'id': '10-30',
      'label': '10-30 days',
      'minDays': 10,
      'maxDays': 30,
      'interestRate': 5.5,
      'color': 0xFF4CAF50,
    },
    {
      'id': '31-60',
      'label': '31-60 days',
      'minDays': 31,
      'maxDays': 60,
      'interestRate': 6.2,
      'color': 0xFF2196F3,
    },
    {
      'id': '91-180',
      'label': '91-180 days',
      'minDays': 91,
      'maxDays': 180,
      'interestRate': 7.8,
      'color': 0xFF9C27B0,
    },
    {
      'id': '181-270',
      'label': '181-270 days',
      'minDays': 181,
      'maxDays': 270,
      'interestRate': 9.1,
      'color': 0xFFFF9800,
    },
    {
      'id': '271-365',
      'label': '271-365 days',
      'minDays': 271,
      'maxDays': 365,
      'interestRate': 12.5,
      'color': 0xFFE91E63,
    },
    {
      'id': '366-730',
      'label': '1-2 years',
      'minDays': 366,
      'maxDays': 730,
      'interestRate': 15.8,
      'color': 0xFF673AB7,
    },
    {
      'id': '731+',
      'label': 'Above 2 years',
      'minDays': 731,
      'maxDays': 1095, // 3 years max
      'interestRate': 18.5,
      'color': 0xFF795548,
    },
  ];

  LockSaveViewModel() {
    initialize();
  }
  
  Future<void> initialize() async {
    await loadLockSaveBalance();
    await loadUserLocks();
    // Keep sample data for UI testing until contract is fully deployed
    initializeSampleData();
  }

  // Getters
  bool get isOngoingSelected => _isOngoingSelected;
  bool get isBalanceVisible => _isBalanceVisible;
  double get lockSaveBalance => _lockSaveBalance;
  List<LockSaveData> get ongoingLocks => _ongoingLocks;
  List<LockSaveData> get completedLocks => _completedLocks;
  List<Map<String, dynamic>> get lockPeriods => _lockPeriods;
  
  // Legacy getters for UI compatibility
  List<Map<String, dynamic>> get legacyOngoingLocks => _legacyOngoingLocks;
  List<Map<String, dynamic>> get legacyCompletedLocks => _legacyCompletedLocks;

  List<dynamic> get currentLocks =>
      _isOngoingSelected ? _ongoingLocks : _completedLocks;

  void setOngoingSelected(bool value) {
    _isOngoingSelected = value;
    notifyListeners();
  }

  void toggleBalanceVisibility() {
    _isBalanceVisible = !_isBalanceVisible;
    notifyListeners();
  }

  void navigateBack() {
    _navigationService.back();
  }

  // void navigateToCreateLock() {
  //   // Navigate to CreateLockView page with first period as default
  //   _navigationService.navigateToView(
  //     CreateLockView(selectedPeriod: _lockPeriods.first),
  //   );
  // }

  void navigateToCreateLockWithPeriod(Map<String, dynamic> period) {
    // Navigate to create lock page with selected period
    // TODO: Implement proper navigation when routes are set up
    // _navigationService.navigateTo('/create-lock', arguments: period);
  }

  // Load lock save balance from contract
  Future<void> loadLockSaveBalance() async {
    try {
      final totalBalance = await _contractService.getUserTotalBalance();
      // For now, assume lock save is part of total balance
      // TODO: Add specific lock save balance query to contract
      _lockSaveBalance = totalBalance * 0.3; // Placeholder calculation
      notifyListeners();
    } catch (e) {
      print('Error loading lock save balance: $e');
      _lockSaveBalance = 0.0;
    }
  }
  
  // Load user locks from contract
  Future<void> loadUserLocks() async {
    try {
      final locks = await _contractService.getUserLocks();
      _ongoingLocks = locks.where((lock) => !lock.isMatured).toList();
      _completedLocks = locks.where((lock) => lock.isMatured).toList();
      notifyListeners();
    } catch (e) {
      print('Error loading user locks: $e');
      _ongoingLocks = [];
      _completedLocks = [];
    }
  }

  // Create a new safelock using contract service
  Future<void> createSafelock(
    double amount,
    String title,
    int lockDays,
    String fundSource,
    Map<String, dynamic> period,
  ) async {
    if (amount <= 0) {
      print('Invalid amount');
      return;
    }

    setBusy(true);
    try {
      final lockId = await _contractService.createLockSave(amount, lockDays, title);
      if (lockId != null) {
        print('Lock save created successfully with ID: $lockId');
        // Refresh data
        await loadLockSaveBalance();
        await loadUserLocks();
      } else {
        print('Failed to create lock save');
      }
    } catch (e) {
      print('Error creating lock save: $e');
    } finally {
      setBusy(false);
    }
  }

  // Calculate interest for preview using contract service
  Future<Map<String, dynamic>> calculateLockPreview(
    double amount,
    int lockDays,
    String periodId,
  ) async {
    try {
      final preview = await _contractService.calculateLockInterest(
        amount: amount,
        durationDays: lockDays,
        periodId: periodId,
      );
      
      return {
        'interest': preview.interestAmount,
        'totalPayout': preview.totalPayout,
        'maturityDate': '${preview.maturityDate.day}/${preview.maturityDate.month}/${preview.maturityDate.year}',
      };
    } catch (e) {
      print('Error calculating lock preview: $e');
      // Fallback to local calculation
      final period = _lockPeriods.firstWhere((p) => p['id'] == periodId);
      final rate = period['interestRate'] / 100;
      final interest = (amount * rate * lockDays) / 365;
      final maturityDate = DateTime.now().add(Duration(days: lockDays));

      return {
        'interest': interest,
        'totalPayout': amount + interest,
        'maturityDate': '${maturityDate.day}/${maturityDate.month}/${maturityDate.year}',
      };
    }
  }

  // Withdraw from matured lock using contract service
  Future<void> withdrawLock(String lockId) async {
    setBusy(true);
    try {
      final success = await _contractService.withdrawLockSave(lockId);
      if (success) {
        print('Lock withdrawal successful');
        // Refresh data
        await loadLockSaveBalance();
        await loadUserLocks();
      } else {
        print('Lock withdrawal failed');
      }
    } catch (e) {
      print('Error withdrawing lock: $e');
    } finally {
      setBusy(false);
    }
  }

  // Break lock early (with penalty) using contract service
  Future<void> breakLock(String lockId) async {
    setBusy(true);
    try {
      final success = await _contractService.breakLockSave(lockId);
      if (success) {
        print('Lock break successful (with penalty)');
        // Refresh data
        await loadLockSaveBalance();
        await loadUserLocks();
      } else {
        print('Lock break failed');
      }
    } catch (e) {
      print('Error breaking lock: $e');
    } finally {
      setBusy(false);
    }
  }

  // Initialize with sample data for UI testing
  void initializeSampleData() {
    if (_lockSaveBalance == 0.0) {
      _lockSaveBalance = 2500.75;
    }

    _legacyOngoingLocks = [
      {
        'id': '1',
        'title': 'Emergency Fund Lock',
        'amount': 1000.0,
        'interestRate': 7.8,
        'interestEarned': 39.45,
        'lockDays': 120,
        'periodId': '91-180',
        'periodLabel': '91-180 days',
        'fundSource': 'Porket Wallet',
        'createdAt': DateTime.now().subtract(const Duration(days: 30)),
        'maturityDate':
            '${DateTime.now().add(const Duration(days: 90)).day}/${DateTime.now().add(const Duration(days: 90)).month}/${DateTime.now().add(const Duration(days: 90)).year}',
        'status': 'ongoing',
        'color': 0xFF9C27B0,
        'totalPayout': 1000.0 + 39.45,
      },
      {
        'id': '2',
        'title': 'Vacation Savings',
        'amount': 500.0,
        'interestRate': 6.2,
        'interestEarned': 5.11,
        'lockDays': 45,
        'periodId': '31-60',
        'periodLabel': '31-60 days',
        'fundSource': 'External Wallet',
        'createdAt': DateTime.now().subtract(const Duration(days: 15)),
        'maturityDate':
            '${DateTime.now().add(const Duration(days: 30)).day}/${DateTime.now().add(const Duration(days: 30)).month}/${DateTime.now().add(const Duration(days: 30)).year}',
        'status': 'ongoing',
        'color': 0xFF2196F3,
        'totalPayout': 500.0 + 5.11,
      },
    ];

    _legacyCompletedLocks = [
      {
        'id': '3',
        'title': 'Short Term Lock',
        'amount': 200.0,
        'interestRate': 5.5,
        'interestEarned': 3.01,
        'lockDays': 20,
        'periodId': '10-30',
        'periodLabel': '10-30 days',
        'fundSource': 'Porket Wallet',
        'createdAt': DateTime.now().subtract(const Duration(days: 25)),
        'maturityDate':
            '${DateTime.now().subtract(const Duration(days: 5)).day}/${DateTime.now().subtract(const Duration(days: 5)).month}/${DateTime.now().subtract(const Duration(days: 5)).year}',
        'status': 'completed',
        'withdrawnAt': DateTime.now().subtract(const Duration(days: 5)),
        'color': 0xFF4CAF50,
        'totalPayout': 200.0 + 3.01,
      },
    ];

    notifyListeners();
  }
}
