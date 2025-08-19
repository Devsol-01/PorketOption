import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
//import 'create_lock_view.dart';

class LockSaveViewModel extends BaseViewModel {
  // State properties
  bool _isOngoingSelected = true;
  bool _isBalanceVisible = true;
  double _lockSaveBalance = 0.0;
  List<Map<String, dynamic>> _ongoingLocks = [];
  List<Map<String, dynamic>> _completedLocks = [];

  final NavigationService _navigationService = NavigationService();

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
    initializeSampleData();
  }

  // Getters
  bool get isOngoingSelected => _isOngoingSelected;
  bool get isBalanceVisible => _isBalanceVisible;
  double get lockSaveBalance => _lockSaveBalance;
  List<Map<String, dynamic>> get ongoingLocks => _ongoingLocks;
  List<Map<String, dynamic>> get completedLocks => _completedLocks;
  List<Map<String, dynamic>> get lockPeriods => _lockPeriods;

  List<Map<String, dynamic>> get currentLocks =>
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

  // Create a new safelock
  void createSafelock(
    double amount,
    String title,
    int lockDays,
    String fundSource,
    Map<String, dynamic> period,
  ) {
    final interestRate = period['interestRate'] / 100;
    final interestEarned = (amount * interestRate * lockDays) / 365;
    final maturityDate = DateTime.now().add(Duration(days: lockDays));

    final safelock = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': title,
      'amount': amount,
      'interestRate': period['interestRate'],
      'interestEarned': interestEarned,
      'lockDays': lockDays,
      'periodId': period['id'],
      'periodLabel': period['label'],
      'fundSource': fundSource,
      'createdAt': DateTime.now(),
      'maturityDate':
          '${maturityDate.day}/${maturityDate.month}/${maturityDate.year}',
      'status': 'ongoing',
      'color': period['color'],
      'totalPayout': amount + interestEarned,
    };

    _ongoingLocks.add(safelock);
    _lockSaveBalance += amount;
    notifyListeners();
  }

  // Calculate interest for preview
  Map<String, dynamic> calculateLockPreview(
    double amount,
    int lockDays,
    double interestRate,
  ) {
    final rate = interestRate / 100;
    final interest = (amount * rate * lockDays) / 365;
    final maturityDate = DateTime.now().add(Duration(days: lockDays));

    return {
      'interest': interest,
      'totalPayout': amount + interest,
      'maturityDate':
          '${maturityDate.day}/${maturityDate.month}/${maturityDate.year}',
    };
  }

  // Withdraw from matured lock
  void withdrawLock(String lockId) {
    final lockIndex = _ongoingLocks.indexWhere((lock) => lock['id'] == lockId);
    if (lockIndex != -1) {
      final lock = _ongoingLocks[lockIndex];

      // Move to completed
      lock['status'] = 'completed';
      lock['withdrawnAt'] = DateTime.now();
      _completedLocks.insert(0, lock);
      _ongoingLocks.removeAt(lockIndex);

      // Update balance
      _lockSaveBalance -= lock['amount'];

      notifyListeners();
    }
  }

  // Break lock early (with penalty)
  void breakLock(String lockId) {
    final lockIndex = _ongoingLocks.indexWhere((lock) => lock['id'] == lockId);
    if (lockIndex != -1) {
      final lock = _ongoingLocks[lockIndex];

      // Apply penalty (lose interest, keep principal)
      lock['status'] = 'broken';
      lock['interestEarned'] = 0.0;
      lock['brokenAt'] = DateTime.now();
      _completedLocks.insert(0, lock);
      _ongoingLocks.removeAt(lockIndex);

      // Update balance
      _lockSaveBalance -= lock['amount'];

      notifyListeners();
    }
  }

  // Initialize with sample data
  void initializeSampleData() {
    _lockSaveBalance = 2500.75;

    _ongoingLocks = [
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

    _completedLocks = [
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
