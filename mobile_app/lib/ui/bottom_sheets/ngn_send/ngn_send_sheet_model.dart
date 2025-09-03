import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class NgnSendSheetModel extends BaseViewModel {
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  String _selectedBank = 'OPay ✓';
  String _accountName = '';
  bool _isVerifying = false;

  String get selectedBank => _selectedBank;
  String get accountName => _accountName;
  bool get isVerifying => _isVerifying;

  bool get canContinue =>
      accountNumberController.text.isNotEmpty &&
      amountController.text.isNotEmpty &&
      _accountName.isNotEmpty;

  @override
  void dispose() {
    accountNumberController.dispose();
    amountController.dispose();
    super.dispose();
  }

  Future<void> onAccountNumberChanged(String value) async {
    if (value.length >= 10) {
      _isVerifying = true;
      notifyListeners();

      // Simulate account verification
      await Future.delayed(const Duration(seconds: 1));

      // Real account name lookup (placeholder implementation)
      _accountName = 'CHIKE ECHE'; // TODO: Implement real account lookup
      _isVerifying = false;
      notifyListeners();
    } else {
      _accountName = '';
      notifyListeners();
    }
  }

  Future<void> processSend(Function(SheetResponse) completer) async {
    if (!canContinue) return;

    // TODO: Implement actual NGN send logic
    completer(SheetResponse(
      confirmed: true,
      data: {
        'method': 'ngn_send',
        'bank': _selectedBank,
        'account_number': accountNumberController.text,
        'account_name': _accountName,
        'amount': amountController.text,
      },
    ));
  }
}
