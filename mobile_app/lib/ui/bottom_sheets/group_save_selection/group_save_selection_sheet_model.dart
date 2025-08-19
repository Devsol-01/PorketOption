import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class GroupSaveSelectionSheetModel extends BaseViewModel {
  Future<void> onPublicTap(Function(SheetResponse) completer) async {
    // Close the current sheet
    completer(SheetResponse(confirmed: true, data: 'public'));
    print('Public group save selected');
  }

  Future<void> onPrivateTap(Function(SheetResponse) completer) async {
    // Close the current sheet
    completer(SheetResponse(confirmed: true, data: 'private'));
    print('Private group save selected');
  }
}
