import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:mobile_app/services/contract_service.dart';
import 'package:mobile_app/services/wallet_service.dart';
import 'package:mobile_app/app/app.locator.dart';

class PorketSaveViewModel extends BaseViewModel {
  final ContractService _contractService = locator<ContractService>();
  final WalletService _walletService = locator<WalletService>();
  
  double _balance = 0.0;
  bool _isBalanceVisible = true;
  bool _isAutoSaveEnabled = false;
  String _walletAddress = '';
  String _autoSaveAmount = '0';
  String _nextAutoSaveDate = '';
  List<TransactionData> _transactions = [];
  bool _isLoading = false;

  // Getters
  String get balance => _isBalanceVisible ? '₦${_balance.toStringAsFixed(2)}' : '****';
  double get rawBalance => _balance;
  bool get isBalanceVisible => _isBalanceVisible;
  bool get isAutoSaveEnabled => _isAutoSaveEnabled;
  String get walletAddress => _walletAddress;
  String get autoSaveAmount => _autoSaveAmount;
  String get nextAutoSaveDate => _nextAutoSaveDate;
  List<TransactionData> get transactions => _transactions;
  bool get isLoading => _isLoading;

  void initialize() async {
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
        await _contractService.setupAutoSave(
          enabled: true,
          frequency: 'daily',
          amount: 100.0, // Default amount
          time: '08:00',
        );
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
      final userAddress = _walletService.currentAccount?.accountAddress.toHexString();
      if (userAddress != null) {
        _balance = await _contractService.getPorketBalance(userAddress);
      }
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
      _transactions = await _contractService.getTransactionHistory(limit: 10);
      notifyListeners();
    } catch (e) {
      print('Error loading transactions: $e');
      _transactions = [];
    }
  }

  Future<void> quickSave(double amount) async {
    if (amount <= 0) {
      print('Invalid amount');
      return;
    }

    setBusy(true);
    try {
      final success = await _contractService.depositPorket(amount);
      if (success) {
        await loadBalance();
        await loadTransactions();
        print('Quick save successful!');
      }
    } catch (e) {
      print('Quick save failed: $e');
    } finally {
      setBusy(false);
    }
  }

  Future<void> withdraw(double amount) async {
    if (amount <= 0 || amount > _balance) {
      print('Invalid withdrawal amount');
      return;
    }

    setBusy(true);
    try {
      final success = await _contractService.withdrawPorket(amount);
      if (success) {
        await loadBalance();
        await loadTransactions();
        print('Withdrawal successful!');
      }
    } catch (e) {
      print('Withdrawal failed: $e');
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
    // Navigate to create goal savings screen
  }
}
