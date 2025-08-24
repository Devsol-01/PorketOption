import 'package:mobile_app/app/app.bottomsheets.dart';
import 'package:mobile_app/app/app.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class FiatSendSelectionSheetModel extends BaseViewModel {
  final _bottomSheetService = locator<BottomSheetService>();

  Future<void> onNGNTap(Function(SheetResponse) completer) async {
    completer(SheetResponse(confirmed: true, data: 'ngn'));
    
    // Show NGN send sheet
    final ngnResponse = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.ngnSend,
      title: 'Send NGN',
    );

    if (ngnResponse?.confirmed == false) {
      // User cancelled, go back to fiat send selection
      await _bottomSheetService.showCustomSheet(
        variant: BottomSheetType.fiatSendSelection,
        title: 'Send Fiat',
      );
    }
  }

  void showComingSoon(String currency) {
    // TODO: Show a snackbar or toast message
    // For now, just do nothing to indicate it's not available
  }
}
