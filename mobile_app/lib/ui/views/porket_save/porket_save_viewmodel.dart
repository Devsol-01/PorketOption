import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

class PorketSaveViewModel extends BaseViewModel {
  String _balance = '7500';
  bool _isBalanceVisible = true;
  bool _isAutoSaveEnabled = true;
  String _walletAddress = '0xs39C7.....1BDf6';
  String _autoSaveAmount = '1,000';
  String _nextAutoSaveDate = '3rd October 2025, by 8:00 am';

  // Getters
  String get balance => _balance;
  bool get isBalanceVisible => _isBalanceVisible;
  bool get isAutoSaveEnabled => _isAutoSaveEnabled;
  String get walletAddress => _walletAddress;
  String get autoSaveAmount => _autoSaveAmount;
  String get nextAutoSaveDate => _nextAutoSaveDate;

  void toggleBalanceVisibility() {
    _isBalanceVisible = !_isBalanceVisible;
    notifyListeners();
  }

  void toggleAutoSave(bool value) {
    _isAutoSaveEnabled = value;
    notifyListeners();
    // Add logic to enable/disable auto save
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

  void onQuickSave() {
    // Navigate to quick save screen
  }

  void onWithdrawal() {
    // Navigate to withdrawal screen
  }

  void onSettings() {
    // Navigate to settings screen
  }

  void onCreateGoalSavings() {
    // Navigate to create goal savings screen
  }
}
