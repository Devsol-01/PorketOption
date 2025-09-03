import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:mobile_app/services/contract_service.dart';
import 'package:mobile_app/services/wallet_service.dart';
import 'package:mobile_app/ui/views/dashboard/dashboard_viewmodel.dart';
import 'package:mobile_app/app/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:mobile_app/app/app.router.dart';

class PorketSaveViewModel extends BaseViewModel {
  final ContractService _contractService = locator<ContractService>();
  final WalletService _walletService = locator<WalletService>();
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

  // AutoSave setup variables
  double _amount = 1000.0;
  String? _selectedFrequency = 'daily';

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

  void initialize([DashboardViewModel? dashboardViewModel]) async {
    _dashboardViewModel = dashboardViewModel;
    await loadBalance();
    await loadWalletInfo();
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
      // await _contractService.setupAutoSave(
      //   enabled: value,
      //   amount: _amount,
      //   frequency: _selectedFrequency ?? 'weekly',
      //   fundSource: 'Porket Wallet',
      // );
      await Future.delayed(Duration(milliseconds: 500)); // Mock delay
      } catch (e) {
        print('Error setting up autosave: $e');
        _isAutoSaveEnabled = false;
        notifyListeners();
      }
    }
  }

  void copyWalletAddress() {
    Clipboard.setData(ClipboardData(text: _walletAddress));
    // You can show a snackbar here to indicate successful copy
  }

  void onQRCodeTap() {
    // Navigate to QR code screen
  }

  void onNotificationTap() {
    // Navigate to notifications screen
  }

  Future<void> loadBalance() async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_walletService.currentAccount == null) {
        print('❌ Wallet service not initialized');
        return;
      }
      if (_contractService == null) {
        print('❌ Contract service not initialized');
        return;
      }
      final userAddress =
          _walletService.currentAccount!.accountAddress.toHexString();
      // TODO: Implement contract integration
      // final balance = await _contractService.getFlexiBalance();
      final balance = 0.0; // Mock data
      _balance = balance;
    } catch (e) {
      print('Error loading balance: $e');
      _balance = 0.0;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadWalletInfo() async {
    try {
      final account = _walletService.currentAccount;
      if (account != null) {
        _walletAddress = account.accountAddress.toHexString();
        notifyListeners();
      }
    } catch (e) {
      print('Error loading wallet info: $e');
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

    // Check if dashboard has sufficient balance
    if (_dashboardViewModel != null) {
      if (_dashboardViewModel!.dashboardBalance < amount) {
        _showErrorSnackbar('Insufficient balance in dashboard');
        return;
      }
    }

    setBusy(true);
    try {
      // Transfer from dashboard to flexi save
      if (_dashboardViewModel != null) {
        _dashboardViewModel!.transferToFlexiSave(amount);
      }

      // Simulate contract interaction
      await Future.delayed(Duration(milliseconds: 1500));
      // TODO: Implement contract integration
      // await _contractService.flexiDeposit(amount: amount);
      await Future.delayed(Duration(milliseconds: 500)); // Mock delay

      await loadBalance();
      await loadTransactions();

      _showSuccessSnackbar(
          '💰 Quick save successful! \$${amount.toStringAsFixed(2)} added to Porket Save');
    } catch (e) {
      print('Quick save failed: $e');
      _showErrorSnackbar('Quick save failed: $e');

      // Rollback the transfer on error
      if (_dashboardViewModel != null) {
        _dashboardViewModel!.transferFromFlexiSave(amount);
      }
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
      // Simulate contract interaction
      await Future.delayed(Duration(milliseconds: 1500));
      // TODO: Implement contract integration
      // final result = await _contractService.flexiWithdraw(amount: amount);
      final result = 'mock_tx_${DateTime.now().millisecondsSinceEpoch}';

      if (result.isNotEmpty) {
        // Transfer from flexi save back to dashboard
        if (_dashboardViewModel != null) {
          _dashboardViewModel!.transferFromFlexiSave(amount);
        }

        await loadBalance();
        await loadTransactions();

        _showSuccessSnackbar(
            '💸 Withdrawal successful! \$${amount.toStringAsFixed(2)} added to dashboard balance');
      }
    } catch (e) {
      print('Withdrawal failed: $e');
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

  Future<void> deposit(double amount, String fundSource) async {
    if (amount <= 0) {
      print('Invalid amount');
      return;
    }

    setBusy(true);
    try {
      // TODO: Implement contract integration
      // final result = await _contractService.flexiDeposit(amount: amount);
      final result = 'mock_tx_${DateTime.now().millisecondsSinceEpoch}';
      if (result.isNotEmpty) {
        await loadBalance();
        await loadTransactions();
        print('Deposit successful!');
      }
    } catch (e) {
      print('Deposit failed: $e');
    } finally {
      setBusy(false);
    }
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
