// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedBottomsheetGenerator
// **************************************************************************

import 'package:stacked_services/stacked_services.dart';

import 'app.locator.dart';
import '../ui/bottom_sheets/crypto_deposit/crypto_deposit_sheet.dart';
import '../ui/bottom_sheets/deposit/deposit_sheet.dart';
import '../ui/bottom_sheets/group_save_selection/group_save_selection_sheet.dart';
import '../ui/bottom_sheets/withdraw/withdraw_sheet.dart';

enum BottomSheetType {
  cryptoDeposit,
  deposit,
  withdraw,
  groupSaveSelection,
  groupSaveSelection,
}

void setupBottomSheetUi() {
  final bottomsheetService = locator<BottomSheetService>();

  final Map<BottomSheetType, SheetBuilder> builders = {
    BottomSheetType.cryptoDeposit: (context, request, completer) =>
        CryptoDepositSheet(request: request, completer: completer),
    BottomSheetType.deposit: (context, request, completer) =>
        DepositSheet(request: request, completer: completer),
    BottomSheetType.withdraw: (context, request, completer) =>
        WithdrawSheet(request: request, completer: completer),
    BottomSheetType.groupSaveSelection: (context, request, completer) =>
        GroupSaveSelectionSheet(request: request, completer: completer),
    BottomSheetType.groupSaveSelection: (context, request, completer) =>
        GroupSaveSelectionSheet(request: request, completer: completer),
  };

  bottomsheetService.setCustomSheetBuilders(builders);
}
