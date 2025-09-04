import 'package:mobile_app/app/app.locator.dart';
import 'package:mobile_app/services/contract_service.dart';
import 'package:mobile_app/services/wallet_service.dart';
import 'package:mobile_app/ui/views/goal_save/goal_save_view.dart';
import 'package:mobile_app/ui/views/lock_save/lock_save_view.dart';
import 'package:mobile_app/ui/views/group_save/group_save_view.dart';
import 'package:mobile_app/ui/views/porket_save/porket_save_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SavingViewModel extends BaseViewModel {
  final ContractService _contractService = locator<ContractService>();
  final WalletService _walletService = locator<WalletService>();
  final SnackbarService _snackbarService = locator<SnackbarService>();
  final NavigationService _navigationService = locator<NavigationService>();

  double _balance = 0.0;
  bool _isLoading = false;
  bool _isBalanceVisible = true;

  String get balance =>
      _isBalanceVisible ? '${_balance.toStringAsFixed(2)}' : '****';
  bool get isBalanceVisible => _isBalanceVisible;
  double get rawBalance => _balance;
  bool get isLoading => _isLoading;

    void initialize() async {
    print('🎯 Savings viewmodel initialize called');
    await loadBalance();
  }

  void navigateToPorketSave() {
    _navigationService.navigateToView(const PorketSaveView());
  }

  void navigateToGoalSave() {
    _navigationService.navigateToView(const GoalSaveView());
  }

  void navigateToLockSave() {
    _navigationService.navigateToView(const LockSaveView());
  }

  void navigateToGroupSave() {
    _navigationService.navigateToView(const GroupSaveView());
  }

  void toggleBalanceVisibility() {
    _isBalanceVisible = !_isBalanceVisible;
    notifyListeners();
  }

  Future<void> loadBalance() async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_walletService.currentAccount == null) {
        print('❌ Wallet service not initialized');
        return;
      }

      print('💰 Loading flexi save balance from contract...');

      // Get real savings balance from contract
      final balanceBigInt = await _contractService.getSavingsBalance();
      final balance = balanceBigInt.toDouble() /
          1000000; // Convert from USDC units to readable format

      print('✅ Total savings balance loaded: $balance USDC');
      _balance = balance;
    } catch (e) {
      print('❌ Error loading balance: $e');
      print('⚠️ Using mock balance due to contract error');
      _balance = 0.0; // Mock balance for now
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
