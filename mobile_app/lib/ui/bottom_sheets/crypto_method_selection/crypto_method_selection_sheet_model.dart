import 'package:mobile_app/app/app.bottomsheets.dart';
import 'package:mobile_app/app/app.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CryptoMethodSelectionSheetModel extends BaseViewModel {
  final _bottomSheetService = locator<BottomSheetService>();

  Future<void> onAppWalletTap(Function(SheetResponse) completer) async {
    // Close current sheet
    completer(SheetResponse(confirmed: true, data: 'app_wallet'));

    // Navigate directly to crypto deposit (QR/Address)
    await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.cryptoDeposit,
      title: 'Deposit with Crypto',
    );
  }

  Future<void> onOtherChainTap(Function(SheetResponse) completer) async {
    // Close current sheet
    completer(SheetResponse(confirmed: true, data: 'other_chain'));

    // Show chain selection sheet
    final chainResponse = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.chainSelection,
      title: 'Select Chain',
    );

    if (chainResponse?.confirmed == true) {
      // After chain selection, show crypto deposit
      await _bottomSheetService.showCustomSheet(
        variant: BottomSheetType.cryptoDeposit,
        title: 'Deposit with Crypto',
      );
    }
  }
}
