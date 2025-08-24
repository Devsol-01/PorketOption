import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CryptoSendSheetModel extends BaseViewModel {
  final TextEditingController addressController = TextEditingController();

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }

  Future<void> pasteAddress() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData?.text != null) {
      addressController.text = clipboardData!.text!;
      notifyListeners();
    }
  }

  Future<void> processCryptoSend(Function(SheetResponse) completer) async {
    if (addressController.text.isEmpty) {
      return;
    }

    // TODO: Implement actual crypto send logic
    completer(SheetResponse(
      confirmed: true,
      data: {
        'method': 'crypto',
        'address': addressController.text,
      },
    ));
  }
}
