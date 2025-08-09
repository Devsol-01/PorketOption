import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:mobile_app/app/app.locator.dart';
import 'package:mobile_app/services/wallet_info_service.dart';

class CryptoDepositSheetSheetModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();
  final _walletInfoService = locator<WalletInfoService>();

  bool _isCopied = false;
  bool get isCopied => _isCopied;

  String? get walletAddress => _walletInfoService.primaryWalletAddress;
  String get displayWalletAddress => _walletInfoService.formattedWalletAddress;

  bool get hasWalletAddress =>
      walletAddress != null && walletAddress!.isNotEmpty;

  /// Copies the wallet address to clipboard
  Future<void> copyAddress() async {
    if (!hasWalletAddress) {
      _snackbarService.showSnackbar(
        message: 'No wallet address available',
        duration: const Duration(seconds: 2),
      );
      return;
    }

    try {
      await Clipboard.setData(ClipboardData(text: walletAddress!));
      _isCopied = true;
      notifyListeners();

      // Show success message
      _snackbarService.showSnackbar(
        message: 'Address copied to clipboard',
        duration: const Duration(seconds: 2),
      );

      // Reset copy state after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        _isCopied = false;
        notifyListeners();
      });
    } catch (e) {
      _snackbarService.showSnackbar(
        message: 'Failed to copy address',
        duration: const Duration(seconds: 2),
      );
    }
  }

  /// Navigates back to previous screen
  void goBack() {
    _navigationService.back();
  }
}
