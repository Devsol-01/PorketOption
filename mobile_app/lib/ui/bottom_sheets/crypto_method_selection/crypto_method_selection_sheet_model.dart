import 'package:mobile_app/app/app.bottomsheets.dart';
import 'package:mobile_app/app/app.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CryptoMethodSelectionSheetModel extends BaseViewModel {
  final _bottomSheetService = locator<BottomSheetService>();

  Future<void> onAppWalletTap(Function(SheetResponse) completer) async {
    completer(SheetResponse(confirmed: true));

    // Show crypto send sheet
    final cryptoResponse = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.cryptoDeposit,
      title: 'Deposit with Crypto',
    );

    if (cryptoResponse?.confirmed == false) {
      // User cancelled, go back to send sheet
      await _bottomSheetService.showCustomSheet(
        variant: BottomSheetType.cryptoMethodSelection,
        title: 'CryptoMethodSelection',
      );
    }
  }

  Future<void> onOtherChainTap(Function(SheetResponse) completer) async {
    // Close current sheet
    completer(SheetResponse(confirmed: true, data: 'other_chain'));

    // Show chain selection sheet
    final chainResponse = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.chainSelection,
      title: 'Select Chain',
    );

    if (chainResponse?.confirmed == false) {
      // After chain selection, show crypto deposit
      await _bottomSheetService.showCustomSheet(
        variant: BottomSheetType.cryptoMethodSelection,
        title: 'Deposit with Crypto',
      );
    }
  }
}
