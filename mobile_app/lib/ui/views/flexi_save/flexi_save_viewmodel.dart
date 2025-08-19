import 'package:stacked/stacked.dart';
import 'package:mobile_app/app/app.locator.dart';
import 'package:mobile_app/services/contract_service.dart';
import 'package:mobile_app/services/wallet_service.dart';
import 'package:stacked_services/stacked_services.dart';

class FlexiSaveViewModel extends BaseViewModel {
  final _walletService = locator<WalletService>();
  final _snackbarService = locator<SnackbarService>();
  late final ContractService _contractService;

  // State properties
  bool _isBalanceVisible = true;
  double _flexiBalance = 0.0;
  bool _isAutoSaveEnabled = false;
  List<Map<String, dynamic>> _transactions = [];

  // Getters
  bool get isBalanceVisible => _isBalanceVisible;
  double get flexiBalance => _flexiBalance;
  bool get isAutoSaveEnabled => _isAutoSaveEnabled;
  List<Map<String, dynamic>> get transactions => _transactions;
  String get formattedBalance => '₦${_flexiBalance.toStringAsFixed(2)}';

  FlexiSaveViewModel() {
    _contractService = ContractService(_walletService);
    initialize();
  }

  /// Initialize Flexi Save data
  Future<void> initialize() async {
    setBusy(true);
    try {
      await loadFlexiBalance();
      await loadTransactions();
    } catch (e) {
      _showErrorSnackbar('Error initializing Flexi Save: $e');
    } finally {
      setBusy(false);
    }
  }

  /// Toggle balance visibility
  void toggleBalanceVisibility() {
    _isBalanceVisible = !_isBalanceVisible;
    notifyListeners();
  }

  /// Toggle AutoSave status
  void toggleAutoSave() {
    _isAutoSaveEnabled = !_isAutoSaveEnabled;
    notifyListeners();
    // TODO: Call contract to update AutoSave status
  }

  /// Load Flexi Save balance from contract
  Future<void> loadFlexiBalance() async {
    try {
      _flexiBalance = await _contractService.getFlexiBalance();
      notifyListeners();
    } catch (e) {
      print('⚠️ Error loading Flexi balance: $e');
      // Use mock data for now
      _flexiBalance = 1250.75;
      notifyListeners();
    }
  }

  /// Load transaction history
  Future<void> loadTransactions() async {
    try {
      final contractTransactions = await _contractService.getTransactionHistory(limit: 20);
      _transactions = contractTransactions.map((tx) => {
        'id': tx.id,
        'type': tx.type,
        'amount': tx.amount,
        'timestamp': tx.timestamp,
        'status': tx.status,
        'description': tx.description ?? '',
      }).toList();
      notifyListeners();
    } catch (e) {
      print('⚠️ Error loading transactions: $e');
      // Use mock data for now
      _initializeMockTransactions();
    }
  }

  /// Quick Save - Deposit to Flexi Save
  Future<void> quickSave(double amount, String fundSource) async {
    if (amount <= 0) {
      _showErrorSnackbar('Please enter a valid amount');
      return;
    }

    setBusy(true);
    try {
      final success = await _contractService.depositPorket(amount);
      _showSuccessSnackbar('Quick Save successful!');
      // Refresh balance
      await loadFlexiBalance();
      await loadTransactions();
    } catch (e) {
      _showErrorSnackbar('Quick Save failed: $e');
    } finally {
      setBusy(false);
    }
  }

  /// Withdraw from Flexi Save
  Future<void> withdraw(double amount) async {
    if (amount <= 0) {
      _showErrorSnackbar('Please enter a valid amount');
      return;
    }

    if (amount > _flexiBalance) {
      _showErrorSnackbar('Insufficient balance');
      return;
    }

    setBusy(true);
    try {
      final success = await _contractService.withdrawPorket(amount);
      _showSuccessSnackbar('Withdrawal successful!');
      // Refresh balance
      await loadFlexiBalance();
      await loadTransactions();
    } catch (e) {
      _showErrorSnackbar('Withdrawal failed: $e');
    } finally {
      setBusy(false);
    }
  }

  /// Setup AutoSave
  Future<void> setupAutoSave({
    required bool enabled,
    required String frequency,
    required double amount,
    required String time,
    String? dayOfWeek,
    int? dayOfMonth,
  }) async {
    setBusy(true);
    try {
      final txHash = await _contractService.setupAutoSave(
        enabled: enabled,
        frequency: frequency,
        amount: amount,
        time: time,
        dayOfWeek: dayOfWeek,
        dayOfMonth: dayOfMonth,
      );
      
      _showSuccessSnackbar('AutoSave setup successful! TX: ${txHash.substring(0, 10)}...');
      _isAutoSaveEnabled = enabled;
      notifyListeners();
    } catch (e) {
      _showErrorSnackbar('AutoSave setup failed: $e');
    } finally {
      setBusy(false);
    }
  }

  /// Show info dialog
  void showInfo() {
    _showInfoSnackbar('Flexi Save: Flexible savings with 18% per annum interest');
  }

  /// Navigate to AutoSave settings
  void navigateToAutoSaveSettings() {
    // TODO: Implement navigation to AutoSave settings
    _showInfoSnackbar('AutoSave Settings coming soon!');
  }

  /// Navigate to withdrawal settings
  void navigateToWithdrawalSettings() {
    // TODO: Implement navigation to withdrawal settings
    _showInfoSnackbar('Withdrawal Settings coming soon!');
  }

  /// Refresh all data
  Future<void> refresh() async {
    await Future.wait([
      loadFlexiBalance(),
      loadTransactions(),
    ]);
  }

  /// Initialize mock transactions for testing
  void _initializeMockTransactions() {
    _transactions = [
      {
        'id': '1',
        'type': 'Quick Save',
        'amount': 500.0,
        'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
        'status': 'completed',
        'description': 'Quick save from Porket Wallet',
      },
      {
        'id': '2',
        'type': 'AutoSave',
        'amount': 100.0,
        'timestamp': DateTime.now().subtract(const Duration(days: 1)),
        'status': 'completed',
        'description': 'Daily AutoSave',
      },
      {
        'id': '3',
        'type': 'Withdrawal',
        'amount': -250.0,
        'timestamp': DateTime.now().subtract(const Duration(days: 3)),
        'status': 'completed',
        'description': 'Emergency withdrawal',
      },
    ];
    notifyListeners();
  }

  // Helper methods for snackbars
  void _showSuccessSnackbar(String message) {
    _snackbarService.showSnackbar(
      message: message,
      duration: const Duration(seconds: 4),
    );
  }

  void _showErrorSnackbar(String message) {
    _snackbarService.showSnackbar(
      message: message,
      duration: const Duration(seconds: 4),
    );
  }

  void _showInfoSnackbar(String message) {
    _snackbarService.showSnackbar(
      message: message,
      duration: const Duration(seconds: 2),
    );
  }
}
