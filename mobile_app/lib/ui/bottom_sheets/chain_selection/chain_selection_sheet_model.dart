import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ChainSelectionSheetModel extends BaseViewModel {
  void onChainSelected(String chainId, Function(SheetResponse) completer) {
    // Close sheet with selected chain data
    completer(SheetResponse(confirmed: true, data: chainId));
  }
}
