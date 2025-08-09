// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedBottomsheetGenerator
// **************************************************************************

import 'package:stacked_services/stacked_services.dart';

import 'app.locator.dart';
import '../ui/bottom_sheets/crypto_deposit_sheet/crypto_deposit_sheet_sheet.dart';
import '../ui/bottom_sheets/deposit_sheet/deposit_sheet_sheet.dart';
import '../ui/bottom_sheets/group_save_selection/group_save_selection_sheet.dart';
import '../ui/bottom_sheets/withdraw_sheet/withdraw_sheet_sheet.dart';

enum BottomSheetType {
  depositSheet,
  cryptoDepositSheet,
  withdrawSheet,
  groupSaveSelection,
}

void setupBottomSheetUi() {
  final bottomsheetService = locator<BottomSheetService>();

  final Map<BottomSheetType, SheetBuilder> builders = {
    BottomSheetType.depositSheet: (context, request, completer) =>
        DepositSheetSheet(request: request, completer: completer),
    BottomSheetType.cryptoDepositSheet: (context, request, completer) =>
        CryptoDepositSheetSheet(request: request, completer: completer),
    BottomSheetType.withdrawSheet: (context, request, completer) =>
        WithdrawSheetSheet(request: request, completer: completer),
    BottomSheetType.groupSaveSelection: (context, request, completer) =>
        GroupSaveSelectionSheet(request: request, completer: completer),
  };

  bottomsheetService.setCustomSheetBuilders(builders);
}
