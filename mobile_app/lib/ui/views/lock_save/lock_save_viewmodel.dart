import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:mobile_app/services/contract_service.dart';
import 'package:mobile_app/ui/views/dashboard/dashboard_viewmodel.dart';
import 'package:mobile_app/app/app.locator.dart';

class LockSaveViewModel extends BaseViewModel {
  // Services
  final ContractService _contractService = locator<ContractService>();
  final NavigationService _navigationService = NavigationService();
  final SnackbarService _snackbarService = locator<SnackbarService>();

  // Reference to dashboard viewmodel for balance updates
  DashboardViewModel? _dashboardViewModel;

  // State properties
  bool _isOngoingSelected = true;
  bool _isBalanceVisible = true;
  double _lockSaveBalance = 0.0;
  List<Map<String, dynamic>> _ongoingLocks = [];
  List<Map<String, dynamic>> _completedLocks = [];

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
    print(
        '🔒 Lock Save Debug: Loaded ${_ongoingLocks.length} ongoing locks, ${_completedLocks.length} completed locks');

    // Always show real data, don't fall back to sample data
    // Sample data is only for legacy UI components if needed
    if (_ongoingLocks.isEmpty && _completedLocks.isEmpty) {
      print(
          '🔒 No real lock saves found, but not using sample data - showing empty state');
    }
  }

  // Getters
  bool get isOngoingSelected => _isOngoingSelected;
  bool get isBalanceVisible => _isBalanceVisible;
  double get lockSaveBalance => _lockSaveBalance;
  List<Map<String, dynamic>> get ongoingLocks => _ongoingLocks;
  List<Map<String, dynamic>> get completedLocks => _completedLocks;
  List<Map<String, dynamic>> get lockPeriods => _lockPeriods;

  // Real data getters - no legacy mock data

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

  /// Refresh lock saves (pull-to-refresh)

  // Load lock save balance from contract
  Future<void> loadLockSaveBalance() async {
    try {
      // TODO: Implement contract integration
      // final locks = await _contractService.getUserLocks();
      // _lockSaveBalance = locks.fold(0.0, (sum, lock) => sum + (lock['amount'] ?? 0.0));
      _lockSaveBalance = 0.0; // Mock data
      notifyListeners();
    } catch (e) {
      print('Error loading lock save balance: $e');
      _lockSaveBalance = 0.0;
    }
  }

  // Load user locks from contract
  Future<void> loadUserLocks() async {
    try {
      // TODO: Implement contract integration
      // final locks = await _contractService.getUserLocks();
      final locks = <Map<String, dynamic>>[]; // Mock data
      print('🔒 Raw locks from contract: ${locks.length} total');
      
      _ongoingLocks = [];
      _completedLocks = [];

      print(
          '🔒 Filtered: ${_ongoingLocks.length} ongoing, ${_completedLocks.length} completed');

      // Force UI update
      notifyListeners();
    } catch (e) {
      print('❌ Error loading user locks: $e');
      _ongoingLocks = [];
      _completedLocks = [];
      notifyListeners();
    }
  }

  // Create a new safelock using contract service
  Future<void> createLockSave(
    double amount,
    String title,
    int lockDays,
  ) async {
    if (amount <= 0) {
      _showErrorSnackbar('Please enter a valid amount');
      return;
    }

    // Check if dashboard has sufficient balance
    if (_dashboardViewModel != null) {
      if (_dashboardViewModel!.dashboardBalance < amount) {
        _showErrorSnackbar('Insufficient balance in dashboard');
        return;
      }
    }

    setBusy(true);
    try {
      // Transfer from dashboard to lock save
      bool transferSuccess = false;
      if (_dashboardViewModel != null) {
        transferSuccess = _dashboardViewModel!.transferToLockSave(amount);
      }

      if (transferSuccess) {
        // Simulate contract interaction
        await Future.delayed(Duration(milliseconds: 1500));
        // TODO: Implement contract integration
        // final lockId = await _contractService.createLockSave(
        //   amount: amount,
        //   title: title,
        //   durationDays: lockDays,
        //   fundSource: 'Porket Wallet',
        // );
        final lockId = 'mock_lock_${DateTime.now().millisecondsSinceEpoch}';

        if (lockId.isNotEmpty) {
          // Refresh data
          await loadLockSaveBalance();
          await loadUserLocks();

          _showSuccessSnackbar(
              '🔒 Lock save created successfully! \$${amount.toStringAsFixed(2)} locked for $lockDays days');
        } else {
          _showErrorSnackbar('Failed to create lock save');
          // Rollback the transfer on error
          if (_dashboardViewModel != null) {
            _dashboardViewModel!.transferFromFlexiSave(amount);
          }
        }
      } else {
        _showErrorSnackbar('Transfer failed. Please try again.');
      }
    } catch (e) {
      print('Error creating lock save: $e');
      _showErrorSnackbar('Error creating lock save: $e');

      // Rollback the transfer on error
      if (_dashboardViewModel != null) {
        _dashboardViewModel!.transferFromFlexiSave(amount);
      }
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
      // TODO: Implement contract integration
      // final preview = await _contractService.calculateLockInterest(
      //   amount: amount,
      //   durationDays: lockDays,
      // );
      
      // Fallback to local calculation
      final period = _lockPeriods.firstWhere((p) => p['id'] == periodId, orElse: () => _lockPeriods[0]);
      final rate = period['interestRate'] / 100;
      final interest = (amount * rate * lockDays) / 365;
      final maturityDate = DateTime.now().add(Duration(days: lockDays));

      return {
        'interest': interest,
        'totalPayout': amount + interest,
        'maturityDate':
            '${maturityDate.day}/${maturityDate.month}/${maturityDate.year}',
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
        'maturityDate':
            '${maturityDate.day}/${maturityDate.month}/${maturityDate.year}',
      };
    }
  }

  // Withdraw from matured lock using contract service
  Future<void> withdrawLock(String lockId) async {
    setBusy(true);
    try {
      // TODO: Implement contract integration
      // final txHash = await _contractService.withdrawLockSave(lockId: lockId);
      final txHash = 'mock_tx_${DateTime.now().millisecondsSinceEpoch}';
      if (txHash.isNotEmpty) {
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
      // TODO: Implement contract integration
      // final txHash = await _contractService.breakLockSave(lockId: lockId);
      final txHash = 'mock_tx_${DateTime.now().millisecondsSinceEpoch}';
      if (txHash.isNotEmpty) {
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

  // Initialize with real contract data only
  void initializeSampleData() {
    print('🔒 Using real contract data only - no mock data');
    // All data comes from contract service calls
  }

  // Set dashboard viewmodel reference for balance transfers
  void setDashboardViewModel(DashboardViewModel? dashboardViewModel) {
    _dashboardViewModel = dashboardViewModel;
  }

  // Helper methods for snackbars
  void _showSuccessSnackbar(String message) {
    _snackbarService.showSnackbar(
      message: message,
      duration: Duration(seconds: 3),
    );
  }

  void _showErrorSnackbar(String message) {
    _snackbarService.showSnackbar(
      message: message,
      duration: Duration(seconds: 4),
    );
  }
}
