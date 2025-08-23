import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class WithdrawSheetModel extends BaseViewModel {

  Future<void> onCryptoWithdrawTap(Function(SheetResponse) completer) async {
    // Close current sheet
    completer(SheetResponse(confirmed: true, data: 'crypto_withdraw'));
    
    // Show crypto withdrawal form/details
    // TODO: Implement crypto withdrawal sheet
  }

  Future<void> onBankWithdrawTap(Function(SheetResponse) completer) async {
    // Close current sheet
    completer(SheetResponse(confirmed: true, data: 'bank_withdraw'));
    
    // Show bank withdrawal form/details
    // TODO: Implement bank withdrawal sheet
  }
}
