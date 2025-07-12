import 'package:mobile_app/app/app.bottomsheets.dart';
import 'package:mobile_app/app/app.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

// class DepositSheetSheetModel extends BaseViewModel {
//     final _bottomSheetService = locator<BottomSheetService>();

// Future<void> onFiatTap(Function(SheetResponse) completer) async {
//   completer(SheetResponse(confirmed: false)); // close current sheet
//   await _bottomSheetService.showCustomSheet(
//     variant: BottomSheetType.fiatDeposit,
//     title: 'Deposit with Fiat',
//   );
// }

class DepositSheetSheetModel extends BaseViewModel {
  final _bottomSheetService = locator<BottomSheetService>();

  Future<void> onCryptoTap(Function(SheetResponse) completer) async {
    // Close the current sheet
    completer(SheetResponse(
        confirmed: true)); // `confirmed: true` means "user tapped crypto"

    // Now open the Crypto Deposit sheet
    final cryptoResponse = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.cryptoDepositSheet,
      title: 'Deposit with Crypto',
    );

    if (cryptoResponse?.confirmed == false) {
      // User hit "Back" on the crypto sheet → reopen this sheet again
      await _bottomSheetService.showCustomSheet(
        variant: BottomSheetType.depositSheet, // <--- open this sheet again
        title: 'Choose Deposit Method',
      );
    }
  }
}
