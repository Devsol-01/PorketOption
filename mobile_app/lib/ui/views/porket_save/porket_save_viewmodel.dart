import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:mobile_app/services/contract_service.dart';
import 'package:mobile_app/services/wallet_service.dart';
import 'package:mobile_app/services/firebase_wallet_manager_service.dart';
import 'package:mobile_app/ui/views/dashboard/dashboard_viewmodel.dart';
import 'package:mobile_app/app/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:mobile_app/app/app.router.dart';

class PorketSaveViewModel extends BaseViewModel {
  final ContractService _contractService = locator<ContractService>();
  final WalletService _walletService = locator<WalletService>();
  final FirebaseWalletManagerService _firebaseWalletManager =
      locator<FirebaseWalletManagerService>();
  final SnackbarService _snackbarService = locator<SnackbarService>();
  final NavigationService _navigationService = locator<NavigationService>();

  // Reference to dashboard viewmodel for balance updates
  DashboardViewModel? _dashboardViewModel;

  double _balance = 0.0;
  bool _isBalanceVisible = true;
  bool _isAutoSaveEnabled = false;
  String _walletAddress = '';
  String _autoSaveAmount = '1000';
  String _nextAutoSaveDate = '';
  List<Map<String, dynamic>> _transactions = [];
  bool _isLoading = false;

  // Getters
  String get balance =>
      _isBalanceVisible ? '${_balance.toStringAsFixed(2)}' : '****';
  double get rawBalance => _balance;
  bool get isBalanceVisible => _isBalanceVisible;
  bool get isAutoSaveEnabled => _isAutoSaveEnabled;
  String get walletAddress => _walletAddress;
  String get autoSaveAmount => _autoSaveAmount;
  String get nextAutoSaveDate => _nextAutoSaveDate;
  List<Map<String, dynamic>> get transactions => _transactions;
  bool get isLoading => _isLoading;

  // Public getter for dashboard viewmodel
  DashboardViewModel? get dashboardViewModel {
    print(
        '🔍 Porket save viewmodel accessing dashboard viewmodel: ${_dashboardViewModel?.hashCode}');
    return _dashboardViewModel;
  }

  void initialize([DashboardViewModel? dashboardViewModel]) async {
    print('🎯 Porket save viewmodel initialize called');
    print('🎯 Received dashboard viewmodel: ${dashboardViewModel?.hashCode}');
    _dashboardViewModel = dashboardViewModel;
    print('🎯 Stored dashboard viewmodel: ${_dashboardViewModel?.hashCode}');
    await loadBalance();
    await loadTransactions();
  }

  void toggleBalanceVisibility() {
    _isBalanceVisible = !_isBalanceVisible;
    notifyListeners();
  }

  Future<void> toggleAutoSave(bool value) async {
    _isAutoSaveEnabled = value;
    notifyListeners();

    if (value) {
      // Setup default autosave settings
      try {
        // TODO: Implement contract integration
        await Future.delayed(Duration(milliseconds: 500)); // Mock delay
      } catch (e) {
        print('Error setting up autosave: $e');
        _isAutoSaveEnabled = false;
        notifyListeners();
      }
    }
  }

  void onNotificationTap() {
    // Navigate to notifications screen
  }

  Future<void> loadBalance() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Check if wallet is available in WalletService first
      if (_walletService.currentAccount == null) {
        print('⚠️ No wallet in WalletService, checking Firebase...');

        // Check if user is authenticated with Firebase
        if (_firebaseWalletManager.isAuthenticated) {
          print(
              '✅ User authenticated, initializing Firebase wallet manager...');

          // Initialize Firebase wallet manager to load wallet
          await _firebaseWalletManager.initialize();

          // Check if wallet is now available
          if (_walletService.currentAccount == null) {
            print(
                '❌ Firebase initialization didn\'t load wallet, trying direct load...');

            // Try direct load as fallback
            try {
              await _walletService.loadWallet();
              if (_walletService.currentAccount == null) {
                print('❌ Still no wallet available after all attempts');
                _balance = 0.0;
                return;
              }
            } catch (e) {
              print('❌ Error in direct wallet load: $e');
              _balance = 0.0;
              return;
            }
          }
        } else {
          print('❌ User not authenticated with Firebase');
          _balance = 0.0;
          return;
        }
      }

      print('💰 Loading flexi save balance from contract...');

      // Get real flexi balance from contract
      final balanceBigInt = await _contractService.getFlexiBalance();

      final balance = balanceBigInt.toDouble() /
          1000000; // Convert from USDC units to readable format
      print('✅ Flexi save balance loaded: $balance USDC');
      _balance = balance;
    } catch (e) {
      print('❌ Error loading balance: $e');
      print('⚠️ Using zero balance due to error');
      _balance = 0.0;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadTransactions() async {
    try {
      // TODO: Implement contract integration
      // final transactions = await _contractService.getTransactionHistory();
      final transactions = <Map<String, dynamic>>[];
      _transactions = transactions;
      notifyListeners();
    } catch (e) {
      print('Error loading transactions: $e');
      _transactions = [];
    }
  }

  Future<void> quickSave(double amount, String fundSource) async {
    if (amount <= 0) {
      _showErrorSnackbar('Please enter a valid amount');
      return;
    }

    setBusy(true);
    try {
      print('💰 Starting quick save: \$${amount} from $fundSource');

      // Call the contract service to perform flexi deposit with approval
      final txHash =
          await _contractService.flexiDepositWithApproval(amount: amount);

      print('✅ Quick save successful! TX: $txHash');

      // Update balance after successful deposit
      await loadBalance();

      // Transfer from dashboard to flexi save (safely handle disposed viewmodel)
      try {
        if (_dashboardViewModel != null) {
          _dashboardViewModel!.transferToFlexiSave(amount);
        }
      } catch (e) {
        print('⚠️ Dashboard viewmodel disposed, skipping transfer update: $e');
      }

      await loadTransactions();

      _showSuccessSnackbar(
          '💰 Quick save successful! \$${amount.toStringAsFixed(2)} saved to Porket Save');
    } catch (e) {
      print('❌ Quick save failed: $e');
      _showErrorSnackbar('Quick save failed: $e');
    } finally {
      setBusy(false);
    }
  }

  Future<void> withdraw(double amount) async {
    if (amount <= 0) {
      _showErrorSnackbar('Please enter a valid amount');
      return;
    }

    if (amount > _balance) {
      _showErrorSnackbar('Insufficient balance in Porket Save');
      return;
    }

    setBusy(true);
    try {
      print('💸 Starting flexi save withdrawal: \$${amount}');

      // Call the contract service to perform flexi withdraw
      final txHash =
          await _contractService.flexiWithdrawWithApproval(amount: amount);

      print('✅ Flexi withdraw successful! TX: $txHash');

      await loadBalance();
      // Transfer from flexi save back to dashboard
      try {
        if (_dashboardViewModel != null) {
          _dashboardViewModel!.transferFromFlexiSave(amount);
        }
      } catch (e) {
        print('⚠️ Dashboard viewmodel disposed, skipping transfer update: $e');
      }

      await loadTransactions();

      _showSuccessSnackbar(
          '💸 Withdrawal successful! \$${amount.toStringAsFixed(2)} added to dashboard balance');
    } catch (e) {
      print('❌ Withdrawal failed: $e');
      _showErrorSnackbar('Withdrawal failed: $e');
    } finally {
      setBusy(false);
    }
  }

  void onQuickSave() {
    // This will be called by the UI to show quick save dialog
  }

  void onWithdrawal() {
    // This will be called by the UI to show withdrawal dialog
  }

  void onSettings() {
    // Navigate to settings screen
  }

  void onCreateGoalSavings() {
    // Navigate to create porket savings screen
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

  // Navigation methods for goal and group details
  void navigateToGoalDetail(Map<String, dynamic> goal) {
    _navigationService.navigateToGoalSaveDetailsView(goal: goal);
  }

  void navigateToGroupDetail(Map<String, dynamic> group) {
    _navigationService.navigateToGroupSaveDetailsView(group: group);
  }
}
