import 'package:mobile_app/app/app.bottomsheets.dart';
import 'package:mobile_app/app/app.locator.dart';
import 'package:mobile_app/ui/views/bottom_nav/bottom_nav_viewmodel.dart';
import 'package:mobile_app/services/privy_service.dart';
import 'package:mobile_app/services/wallet_info_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class DashboardViewModel extends BaseViewModel {
  final _bottomSheetService = locator<BottomSheetService>();
  final _privyService = locator<PrivyService>();
  final _walletInfoService = locator<WalletInfoService>();

  String? _walletAddress;
  String? _userEmail;
  double? _walletBalance;
  bool _isBalanceVisible = true;

  String? get walletAddress => _walletAddress;
  String? get userEmail => _userEmail;
  double? get walletBalance => _walletBalance;
  bool get isBalanceVisible => _isBalanceVisible;

  String get displayWalletAddress => _walletInfoService.formattedWalletAddress;
  String get displayBalance => _isBalanceVisible
      ? (_walletBalance != null
          ? '\$${_walletBalance!.toStringAsFixed(2)}'
          : 'Loading...')
      : '••••••';

  bool get hasWalletInfo => _walletAddress != null && _userEmail != null;

  bool get isAuthenticated => _privyService.isAuthenticated;

  void initialize() {
    if (isAuthenticated) {
      _loadWalletInfo();
    }
  }

  Future<void> _loadWalletInfo() async {
    setBusy(true);
    try {
      _walletAddress = _walletInfoService.primaryWalletAddress;
      _userEmail = _walletInfoService.userEmail;
      _walletBalance = await _walletInfoService.getWalletBalance();
      notifyListeners();
    } catch (e) {
      print('Error loading wallet info: $e');
    } finally {
      setBusy(false);
    }
  }

  Future<void> refreshWalletInfo() async {
    await _loadWalletInfo();
  }

  void copyWalletAddress() {
    _walletInfoService.copyWalletAddress();
  }

  void toggleBalanceVisibility() {
    _isBalanceVisible = !_isBalanceVisible;
    notifyListeners();
  }

  void navigateToSavings() {
    // Switch to the Savings tab (index 1) to show the Savings View
    final bottomNavViewModel = locator<BottomNavViewModel>();
    bottomNavViewModel.setIndex(2);
  }

  void showDepositSheet() {
    _bottomSheetService.showCustomSheet(
        variant: BottomSheetType.depositSheet, barrierDismissible: false);
  }
}
