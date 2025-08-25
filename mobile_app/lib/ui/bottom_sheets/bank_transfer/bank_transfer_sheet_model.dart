import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

class BankTransferSheetModel extends BaseViewModel {
  // Generate a unique reference for this transfer
  String get transferReference =>
      'PKT${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

  Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    // TODO: Show snackbar or toast notification
  }
}
