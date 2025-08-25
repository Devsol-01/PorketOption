import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

class VirtualAccountSheetModel extends BaseViewModel {
  // Generate a unique virtual account number for the user
  String get virtualAccountNumber =>
      '9${DateTime.now().millisecondsSinceEpoch.toString().substring(3, 12)}';

  Future<void> copyAccountDetails() async {
    final accountDetails = '''
Account Number: $virtualAccountNumber
Bank Name: Wema Bank
Account Name: PorketOption Limited
''';

    await Clipboard.setData(ClipboardData(text: accountDetails));
    // TODO: Show snackbar or toast notification
  }

  Future<void> shareAccountDetails() async {
    final accountDetails = '''
PorketOption Virtual Account Details:

Account Number: $virtualAccountNumber
Bank Name: Wema Bank
Account Name: PorketOption Limited

Transfer to this account to fund your PorketOption wallet instantly!
''';

    // TODO: Implement native share functionality
    await Clipboard.setData(ClipboardData(text: accountDetails));
    // For now, copy to clipboard instead of sharing
  }
}
