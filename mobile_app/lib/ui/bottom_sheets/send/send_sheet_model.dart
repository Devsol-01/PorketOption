import 'package:mobile_app/app/app.bottomsheets.dart';
import 'package:mobile_app/app/app.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SendSheetModel extends BaseViewModel {
  final _bottomSheetService = locator<BottomSheetService>();

  Future<void> onCryptoTap(Function(SheetResponse) completer) async {
    completer(SheetResponse(confirmed: true));

    // Show crypto send sheet
    final cryptoResponse = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.cryptoSend,
      title: 'Send Crypto',
    );

    if (cryptoResponse?.confirmed == false) {
      // User cancelled, go back to send sheet
      await _bottomSheetService.showCustomSheet(
        variant: BottomSheetType.send,
        title: 'Send',
      );
    }
  }

  Future<void> onFiatTap(Function(SheetResponse) completer) async {
    completer(SheetResponse(confirmed: true));

    // Show fiat send selection sheet
    final fiatResponse = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.fiatSendSelection,
      title: 'Send Fiat',
    );

    if (fiatResponse?.confirmed == false) {
      // User cancelled, go back to send sheet
      await _bottomSheetService.showCustomSheet(
        variant: BottomSheetType.send,
        title: 'Send',
      );
    }
  }
}
