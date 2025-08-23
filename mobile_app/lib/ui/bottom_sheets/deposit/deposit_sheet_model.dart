import 'package:mobile_app/app/app.bottomsheets.dart';
import 'package:mobile_app/app/app.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class DepositSheetModel extends BaseViewModel {
    final _bottomSheetService = locator<BottomSheetService>();

  Future<void> onCryptoTap(Function(SheetResponse) completer) async {
    // Close the current sheet
    completer(SheetResponse(confirmed: true));

    // Show crypto method selection sheet first
    final methodResponse = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.cryptoMethodSelection,
      title: 'Crypto Deposit',
    );

    if (methodResponse?.confirmed == false) {
      // User hit "Back" on the method selection → reopen this sheet again
      await _bottomSheetService.showCustomSheet(
        variant: BottomSheetType.deposit,
        title: 'Choose Deposit Method',
      );
    }
  }

  Future<void> onFiatTap(Function(SheetResponse) completer) async {
    // Close the current sheet
    completer(SheetResponse(confirmed: true));

    // Show fiat method selection sheet
    final methodResponse = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.fiatMethodSelection,
      title: 'Fiat Deposit',
    );

    if (methodResponse?.confirmed == false) {
      // User hit "Back" on the method selection → reopen this sheet again
      await _bottomSheetService.showCustomSheet(
        variant: BottomSheetType.deposit,
        title: 'Choose Deposit Method',
      );
    }
  }
}
