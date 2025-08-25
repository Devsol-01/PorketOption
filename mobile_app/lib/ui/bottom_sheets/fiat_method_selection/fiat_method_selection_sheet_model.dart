import 'package:mobile_app/app/app.bottomsheets.dart';
import 'package:mobile_app/app/app.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class FiatMethodSelectionSheetModel extends BaseViewModel {
  final _bottomSheetService = locator<BottomSheetService>();

  Future<void> onCardTap(Function(SheetResponse) completer) async {
    completer(SheetResponse(confirmed: true, data: 'card'));

    // Show card deposit form
    final cardResponse = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.cardDeposit,
      title: 'Card Deposit',
    );

    if (cardResponse?.confirmed == false) {
      // User cancelled, go back to fiat method selection
      await _bottomSheetService.showCustomSheet(
        variant: BottomSheetType.fiatMethodSelection,
        title: 'Fiat Deposit',
      );
    }
  }

  Future<void> onBankTransferTap(Function(SheetResponse) completer) async {
    completer(SheetResponse(confirmed: true, data: 'bank_transfer'));

    // Show bank transfer details
    final bankResponse = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.bankTransfer,
      title: 'Bank Transfer',
    );

    if (bankResponse?.confirmed == false) {
      // User cancelled, go back to fiat method selection
      await _bottomSheetService.showCustomSheet(
        variant: BottomSheetType.fiatMethodSelection,
        title: 'Fiat Deposit',
      );
    }
  }

  Future<void> onVirtualAccountTap(Function(SheetResponse) completer) async {
    completer(SheetResponse(confirmed: true, data: 'virtual_account'));

    // Show virtual account creation
    final virtualResponse = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.virtualAccount,
      title: 'Virtual Account',
    );

    if (virtualResponse?.confirmed == false) {
      // User cancelled, go back to fiat method selection
      await _bottomSheetService.showCustomSheet(
        variant: BottomSheetType.fiatMethodSelection,
        title: 'Fiat Deposit',
      );
    }
  }
}
