import 'package:mobile_app/app/app.bottomsheets.dart';
import 'package:mobile_app/app/app.locator.dart';
import 'package:mobile_app/services/firebase_auth_service.dart';
import 'package:mobile_app/services/firebase_wallet_manager_service.dart';
import 'package:mobile_app/services/token_service.dart';
import 'package:mobile_app/services/wallet_service.dart';
import 'package:mobile_app/services/contract_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class DashboardViewModel extends BaseViewModel {
  final _bottomSheetService = locator<BottomSheetService>();
  final _firebaseWalletManager = locator<FirebaseWalletManagerService>();
  final _walletService = locator<WalletService>();
  final _snackbarService = locator<SnackbarService>();
  final _authService = locator<FirebaseAuthService>();

  bool _isOngoingSelected = true;

  late final TokenService _tokenService;
  late final ContractService _contractService;

  bool get isOngoingSelected => _isOngoingSelected;

  WalletInfo? _walletInfo;
  WalletInfo? get walletInfo => _walletInfo;

  BigInt _balance = BigInt.zero;
  BigInt get balance => _balance;

  double _usdcBalance = 3000.0; // Initial dashboard balance
  double _dashboardBalance = 3000.0; // Available balance for deposits

  double get usdcBalance => _usdcBalance;
  double get dashboardBalance => _dashboardBalance;
  String get formattedBalance => formatBalance(_balance);
  String get formattedDashboardBalance =>
      '\$${_dashboardBalance.toStringAsFixed(2)}';
  String get formattedTotalSavingsBalance =>
      '\$${_totalSavingsBalance.toStringAsFixed(2)}';

  /// Format balance for display (in ETH by default)
  String formatBalance(BigInt balance, {int decimals = 18}) {
    if (balance == BigInt.zero) return '0.0';
    final divisor = BigInt.from(10).pow(decimals);
    final whole = balance ~/ divisor;
    final fraction = (balance % divisor).toString().padLeft(decimals, '0');
    final trimmedFraction = fraction.replaceAll(RegExp(r'0*$'), '');
    return '$whole${trimmedFraction.isNotEmpty ? '.$trimmedFraction' : ''}';
  }

  bool get hasWallet => _walletInfo != null;

  /// Initialize - load wallet from Firebase system
  Future<void> initialize() async {
    setBusy(true);

    try {
      _tokenService = TokenService();
      _contractService = ContractService(_walletService);

      // Check if user is authenticated
      if (_firebaseWalletManager.isAuthenticated) {
        print('✅ User is authenticated, loading wallet...');

        // First try to get wallet info from WalletService
        _walletInfo = _walletService.walletInfo;

        if (_walletInfo != null) {
          print('✅ Wallet found in WalletService: ${_walletInfo!.address}');
          await loadBalance();
        } else {
          print('⚠️ No wallet in WalletService, triggering wallet load...');

          // If no wallet in WalletService, trigger the Firebase wallet loading
          await _firebaseWalletManager.initialize();

          // Try again after initialization
          _walletInfo = _walletService.walletInfo;

          if (_walletInfo != null) {
            print(
                '✅ Wallet loaded after initialization: ${_walletInfo!.address}');
            await loadBalance();
          } else {
            print('❌ Still no wallet found after initialization');
            _showErrorSnackbar(
                'Unable to load wallet. Please try logging in again.');
          }
        }
      } else {
        print('❌ User not authenticated');
        _showErrorSnackbar('User not authenticated. Please log in.');
      }
    } catch (e) {
      print('❌ Error in DashboardViewModel initialize: $e');
      _showErrorSnackbar('Error loading wallet: $e');
    } finally {
      setBusy(false);
    }
  }

  /// Load wallet balance - Focus on USDC only
  Future<void> loadBalance() async {
    if (_walletInfo == null) return;

    try {
      // Use fixed dashboard balance for demo
      _usdcBalance = _dashboardBalance;

      // Keep ETH balance for deployment checks only (not displayed)
      _balance = await _walletService.getEthBalance(_walletInfo!.address);

      // Load total savings balance from contract
      await loadSavingsBalance();

      notifyListeners();
    } catch (e) {
      _showErrorSnackbar('Error loading balance: $e');
    }
  }

  void setOngoingSelected(bool value) {
    _isOngoingSelected = value;
    notifyListeners(); // Notify UI to rebuild
  }

  Future<void> loadUsdcBalance() async {
    if (_walletInfo == null) return;

    try {
      _usdcBalance = await _tokenService.getUsdcBalance(_walletInfo!.address);
      notifyListeners();
    } catch (e) {
      _showErrorSnackbar('Error loading USDC balance: $e');
    }
  }

  /// Refresh wallet data - Focus on ETH
  Future<void> refresh() async {
    await loadBalance(); // This now loads ETH as primary
  }

  /// Navigate to send USDC screen
  void navigateToSendUsdc() {
    if (_walletInfo == null) {
      _showErrorSnackbar('No wallet found');
      return;
    }

    // For now, show a placeholder message since we need to add routing
    _showInfoSnackbar('Send USDC feature coming soon!');
  }

  /// Deploy account (needed for sending transactions)
  Future<void> deployAccount() async {
    if (_walletInfo == null || _walletInfo!.isDeployed) return;

    setBusy(true);

    try {
      final txHash = await _walletService.deployAccount();
      _showSuccessSnackbar(
          'Account deployment initiated!\nTx: ${txHash.substring(0, 10)}...');

      // Reload wallet info to update deployment status
      _walletInfo = await _walletService.loadWallet();
      notifyListeners();
    } catch (e) {
      _showErrorSnackbar('Failed to deploy account: $e');
    } finally {
      setBusy(false);
    }
  }

  /// Delete wallet
  Future<void> deleteWallet() async {
    setBusy(true);

    try {
      await _walletService.deleteWallet();
      _walletInfo = null;
      _balance = BigInt.zero;
      _showInfoSnackbar('Wallet deleted successfully');
    } catch (e) {
      _showErrorSnackbar('Error deleting wallet: $e');
    } finally {
      setBusy(false);
    }
  }

  // Helper methods for snackbars
  void _showSuccessSnackbar(String message) {
    _snackbarService.showSnackbar(
      message: message,
      duration: Duration(seconds: 4),
    );
  }

  void _showErrorSnackbar(String message) {
    _snackbarService.showSnackbar(
      message: message,
      duration: Duration(seconds: 4),
    );
  }

  void _showInfoSnackbar(String message) {
    _snackbarService.showSnackbar(
      message: message,
      duration: Duration(seconds: 2),
    );
  }

  // Savings-related properties
  double _totalSavingsBalance = 0.0;
  double _flexiSaveBalance = 0.0;
  double _lockSaveBalance = 0.0;
  double _goalSaveBalance = 0.0;
  double _groupSaveBalance = 0.0;

  double get totalSavingsBalance => _totalSavingsBalance;
  double get flexiSaveBalance => _flexiSaveBalance;
  double get lockSaveBalance => _lockSaveBalance;
  double get goalSaveBalance => _goalSaveBalance;
  double get groupSaveBalance => _groupSaveBalance;

  // Calculate total savings as sum of all individual balances
  void _updateTotalSavingsBalance() {
    _totalSavingsBalance = _flexiSaveBalance +
        _lockSaveBalance +
        _goalSaveBalance +
        _groupSaveBalance;
    notifyListeners();
  }

  Map<String, dynamic>? _userStats;
  Map<String, dynamic>? get userStats => _userStats;

  List<Map<String, dynamic>> _recentTransactions = [];
  List<Map<String, dynamic>> get recentTransactions => _recentTransactions;

  /// Load total savings balance from contract
  Future<void> loadSavingsBalance() async {
    try {
      print('🧪 Testing contract functions...');

      // Test 1: Get total deposits
      final totalDeposits = await _contractService.getUserTotalBalance();
      print('✅ Total deposits: $totalDeposits');

      // Test 2: Get flexi balance
      final flexiBalance = await _contractService.getFlexiBalance();
      print('✅ Flexi balance: $flexiBalance');

      // Test 3: Get lock save data (commented out as method doesn't exist yet)
      // final lockSaveData = await _contractService.getLockSave('0x1');
      // print('✅ Lock save data: $lockSaveData');
      // Test 3: Get interest rates
      final flexiRate = await _contractService.getFlexiSaveRate();
      print('✅ Flexi save rate: $flexiRate%');

      final goalRate = await _contractService.getGoalSaveRate();
      print('✅ Goal save rate: $goalRate%');

      final groupRate = await _contractService.getGroupSaveRate();
      print('✅ Group save rate: $groupRate%');

      // Test 4: Get lock save rates for different durations
      final lockRate30 =
          await _contractService.getLockSaveRate(durationDays: 30);
      print('✅ Lock save rate (30 days): $lockRate30%');

      final lockRate180 =
          await _contractService.getLockSaveRate(durationDays: 180);
      print('✅ Lock save rate (180 days): $lockRate180%');

      final userGoals = await _contractService.getUserGoals();
      print('✅ User goals retrieved: $userGoals');

      final userGroups = await _contractService.getUserGroups();
      print('✅ User groups retrieved: $userGroups');

      final userLocks = await _contractService.getLockSave();
      print('✅ User locks retrieved: $userLocks');

      // Calculate actual balances from contract data
      _flexiSaveBalance = flexiBalance;

      // Handle locks (List<Map<String, dynamic>>)
      if (userLocks is List) {
        _lockSaveBalance = (userLocks as List).fold(0.0,
            (sum, lock) => sum + ((lock as Map)['amount'] as double? ?? 0.0));
      } else {
        _lockSaveBalance = 0.0;
      }

      // Handle goals (List<Map<String, dynamic>>)
      if (userGoals is List) {
        _goalSaveBalance = (userGoals as List).fold(
            0.0,
            (sum, goal) =>
                sum + ((goal as Map)['currentAmount'] as double? ?? 0.0));
      } else {
        _goalSaveBalance = 0.0;
      }

      // Handle groups (List<Map<String, dynamic>>)
      if (userGroups is List) {
        _groupSaveBalance = (userGroups as List).fold(
            0.0,
            (sum, group) =>
                sum + ((group as Map)['currentAmount'] as double? ?? 0.0));
      } else {
        _groupSaveBalance = 0.0;
      }

      _updateTotalSavingsBalance();

      print('🎉 All contract read functions working correctly!');
    } catch (e) {
      print('❌ Contract test failed: $e');
    }
  }

  /// Load user statistics from contract
  Future<void> loadUserStats() async {
    try {
      // Mock user stats since getUserStats doesn't exist yet
      _userStats = {
        'dayStreak': 7,
        'tokensEarned': 150.0,
        'totalReturns': 25.5,
        'achievements': 3
      };
      notifyListeners();
    } catch (e) {
      print('⚠️ Error loading user stats: $e');
    }
  }

  /// Load recent transactions from contract
  Future<void> loadRecentTransactions() async {
    try {
      _recentTransactions = await _contractService.getTransactionHistory();
      notifyListeners();
    } catch (e) {
      print('⚠️ Error loading recent transactions: $e');
    }
  }

  /// Refresh all dashboard data
  Future<void> refreshDashboard() async {
    await Future.wait([
      loadBalance(),
      loadUserStats(),
      loadRecentTransactions(),
    ]);
  }

  Future<void> logout() async {
    setBusy(true);

    try {
      _authService.logout();
    } catch (e) {
      print('❌ Error during logout: $e');
      _showErrorSnackbar('Error logging out: $e');
    } finally {
      setBusy(false);
    }
  }

  void showDepositSheet() {
    _bottomSheetService.showCustomSheet(
        variant: BottomSheetType.deposit, barrierDismissible: false);
  }

  void showSendSheet() {
    _bottomSheetService.showCustomSheet(
        variant: BottomSheetType.send, barrierDismissible: false);
  }

  // Balance transfer methods for unified balance system

  /// Transfer money from dashboard to flexi save
  bool transferToFlexiSave(double amount) {
    if (_dashboardBalance >= amount) {
      _dashboardBalance -= amount;
      _flexiSaveBalance += amount;
      _usdcBalance = _dashboardBalance; // Keep USDC balance in sync
      _updateTotalSavingsBalance();
      notifyListeners(); // Trigger UI update
      return true;
    }
    return false;
  }

  /// Transfer money from flexi save back to dashboard
  bool transferFromFlexiSave(double amount) {
    if (_flexiSaveBalance >= amount) {
      _flexiSaveBalance -= amount;
      _dashboardBalance += amount;
      _usdcBalance = _dashboardBalance;
      _updateTotalSavingsBalance();
      notifyListeners(); // Trigger UI update
      return true;
    }
    return false;
  }

  /// Transfer money from dashboard to lock save
  bool transferToLockSave(double amount) {
    if (_dashboardBalance >= amount) {
      _dashboardBalance -= amount;
      _lockSaveBalance += amount;
      _usdcBalance = _dashboardBalance;
      _updateTotalSavingsBalance();
      print(
          '💰 Dashboard balance updated: \$${_dashboardBalance} (reduced by \$${amount})');
      notifyListeners(); // Trigger UI update
      return true;
    }
    print(
        '❌ Insufficient dashboard balance: \$${_dashboardBalance} < \$${amount}');
    return false;
  }

  /// Transfer money from dashboard to goal save
  bool transferToGoalSave(double amount) {
    if (_dashboardBalance >= amount) {
      _dashboardBalance -= amount;
      _goalSaveBalance += amount;
      _usdcBalance = _dashboardBalance;
      _updateTotalSavingsBalance();
      notifyListeners(); // Trigger UI update
      return true;
    }
    return false;
  }

  /// Transfer money from goal save back to dashboard
  bool transferFromGoalSave(double amount) {
    if (_goalSaveBalance >= amount) {
      _goalSaveBalance -= amount;
      _dashboardBalance += amount;
      _usdcBalance = _dashboardBalance;
      _updateTotalSavingsBalance();
      notifyListeners(); // Trigger UI update
      return true;
    }
    return false;
  }

  /// Deposit to savings - reduces dashboard balance
  Future<void> depositToSavings(double amount) async {
    if (amount <= 0 || amount > _dashboardBalance) return;

    setBusy(true);
    try {
      _dashboardBalance -= amount;
      _usdcBalance = _dashboardBalance; // Keep in sync
      notifyListeners();

      // 3 second loading for demo
      await Future.delayed(Duration(seconds: 3));
    } finally {
      setBusy(false);
    }
  }

  /// Withdraw from savings - increases dashboard balance
  Future<void> withdrawFromSavings(double amount) async {
    if (amount <= 0) return;

    setBusy(true);
    try {
      _dashboardBalance += amount;
      _usdcBalance = _dashboardBalance; // Keep in sync
      notifyListeners();

      // Quick operation for demo
      await Future.delayed(Duration(milliseconds: 500));
    } finally {
      setBusy(false);
    }
  }

  /// Transfer money from dashboard to group save
  bool transferToGroupSave(double amount) {
    if (_dashboardBalance >= amount) {
      _dashboardBalance -= amount;
      _groupSaveBalance += amount;
      _usdcBalance = _dashboardBalance;
      _updateTotalSavingsBalance();
      notifyListeners(); // Trigger UI update
      return true;
    }
    return false;
  }

  /// Transfer money from group save back to dashboard
  bool transferFromGroupSave(double amount) {
    if (_groupSaveBalance >= amount) {
      _groupSaveBalance -= amount;
      _dashboardBalance += amount;
      _usdcBalance = _dashboardBalance;
      _updateTotalSavingsBalance();
      notifyListeners(); // Trigger UI update
      return true;
    }
    return false;
  }

  // Formatted getters for display
  String get formattedFlexiSaveBalance =>
      '\$${_flexiSaveBalance.toStringAsFixed(2)}';
  String get formattedLockSaveBalance =>
      '\$${_lockSaveBalance.toStringAsFixed(2)}';
  String get formattedGoalSaveBalance =>
      '\$${_goalSaveBalance.toStringAsFixed(2)}';
  String get formattedGroupSaveBalance =>
      '\$${_groupSaveBalance.toStringAsFixed(2)}';

  // Portfolio value calculation (dashboard + savings)
  double get totalPortfolioValue => _dashboardBalance + _totalSavingsBalance;
  String get formattedPortfolioValue =>
      '\$${totalPortfolioValue.toStringAsFixed(2)}';

  // Loading states for refresh
  bool _isRefreshing = false;
  bool get isRefreshing => _isRefreshing;

  /// Refresh dashboard with animation
  Future<void> refreshDashboardWithAnimation() async {
    _isRefreshing = true;
    notifyListeners();

    await Future.delayed(
        Duration(milliseconds: 1500)); // Realistic loading time
    await refreshDashboard();

    _isRefreshing = false;
    notifyListeners();
  }
}
