import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:mobile_app/app/app.locator.dart';
import 'package:mobile_app/services/wallet_service.dart';

class CryptoSendSheetModel extends BaseViewModel {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  
  final _walletService = locator<WalletService>();

  @override
  void dispose() {
    addressController.dispose();
    amountController.dispose();
    super.dispose();
  }

  /// Check if form is valid for sending
  bool get canSend {
    return addressController.text.isNotEmpty && 
           amountController.text.isNotEmpty &&
           double.tryParse(amountController.text) != null &&
           double.parse(amountController.text) > 0;
  }

  Future<void> pasteAddress() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData?.text != null) {
      addressController.text = clipboardData!.text!;
      notifyListeners();
    }
  }

  Future<void> processCryptoSend(Function(SheetResponse) completer) async {
    if (!canSend) {
      return;
    }

    setBusy(true);
    
    try {
      final amount = double.parse(amountController.text);
      final address = addressController.text.trim();
      
      print('🚀 Attempting to send $amount USDC to $address');
      
      // Call wallet service to send USDC
      final txHash = await _walletService.sendUsdc(
        recipientAddress: address,
        amount: amount,
      );
      
      print('✅ Transfer successful! TX: $txHash');
      
      completer(SheetResponse(
        confirmed: true,
        data: {
          'method': 'crypto',
          'address': address,
          'amount': amount,
          'txHash': txHash,
          'success': true,
        },
      ));
    } catch (e) {
      print('❌ Transfer failed: $e');
      
      completer(SheetResponse(
        confirmed: false,
        data: {
          'method': 'crypto',
          'error': e.toString(),
          'success': false,
        },
      ));
    } finally {
      setBusy(false);
    }
  }
}
