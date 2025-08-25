import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CardDepositSheetModel extends BaseViewModel {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController cardholderController = TextEditingController();

  @override
  void dispose() {
    amountController.dispose();
    cardNumberController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    cardholderController.dispose();
    super.dispose();
  }

  Future<void> processCardDeposit(Function(SheetResponse) completer) async {
    if (!_validateForm()) {
      return;
    }

    setBusy(true);

    try {
      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Integrate with actual payment processor (Paystack, Flutterwave, etc.)

      completer(SheetResponse(
        confirmed: true,
        data: {
          'method': 'card',
          'amount': amountController.text,
          'card_last_four': cardNumberController.text
              .replaceAll(' ', '')
              .substring(
                  cardNumberController.text.replaceAll(' ', '').length - 4),
        },
      ));
    } catch (e) {
      // Handle error
      completer(SheetResponse(confirmed: false, data: {'error': e.toString()}));
    } finally {
      setBusy(false);
    }
  }

  bool _validateForm() {
    if (amountController.text.isEmpty) {
      // TODO: Show error message
      return false;
    }

    if (cardNumberController.text.isEmpty) {
      // TODO: Show error message
      return false;
    }

    if (expiryController.text.isEmpty) {
      // TODO: Show error message
      return false;
    }

    if (cvvController.text.isEmpty) {
      // TODO: Show error message
      return false;
    }

    if (cardholderController.text.isEmpty) {
      // TODO: Show error message
      return false;
    }

    return true;
  }
}
