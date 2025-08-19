import 'package:mobile_app/app/app.locator.dart';
import 'package:mobile_app/services/firebase_auth_service.dart';
import 'package:mobile_app/services/firebase_wallet_manager_service.dart';
import 'package:mobile_app/services/token_service.dart';
import 'package:mobile_app/services/wallet_service.dart';
import 'package:mobile_app/services/contract_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class DashboardViewModel extends BaseViewModel {
  final _firebaseWalletManager = locator<FirebaseWalletManagerService>();
  final _walletService = locator<WalletService>();
  final _snackbarService = locator<SnackbarService>();
  final _authService = locator<FirebaseAuthService>();

  late final TokenService _tokenService;
  late final ContractService _contractService;

  WalletInfo? _walletInfo;
  WalletInfo? get walletInfo => _walletInfo;

  BigInt _balance = BigInt.zero;
  BigInt get balance => _balance;

  double _usdcBalance = 0.0;
  double get usdcBalance => _usdcBalance;
  String get formattedBalance => formatBalance(_balance);

  /// Format balance for display (in ETH by default)
  String formatBalance(BigInt balance, {int decimals = 18}) {
    if (balance == BigInt.zero) return '0.0';
    final divisor = BigInt.from(10).pow(decimals);
    final whole = balance ~/ divisor;
    final fraction = (balance % divisor).toString().padLeft(decimals, '0');
    final trimmedFraction = fraction.replaceAll(RegExp(r'0*$'), '');
    return '$whole${trimmedFraction.isNotEmpty ? '.${trimmedFraction}' : ''}';
  }

  bool get hasWallet => _walletInfo != null;

  /// Initialize - load wallet from Firebase system
  Future<void> initialize() async {
    setBusy(true);

    try {
      _tokenService = TokenService();
      _contractService = ContractService(_walletService);

      // Check if user is authenticated
      if (_firebaseWalletManager.isAuthenticated) {
        print('✅ User is authenticated, loading wallet...');

        // First try to get wallet info from WalletService
        _walletInfo = _walletService.walletInfo;

        if (_walletInfo != null) {
          print('✅ Wallet found in WalletService: ${_walletInfo!.address}');
          await loadBalance();
        } else {
          print('⚠️ No wallet in WalletService, triggering wallet load...');

          // If no wallet in WalletService, trigger the Firebase wallet loading
          await _firebaseWalletManager.initialize();

          // Try again after initialization
          _walletInfo = _walletService.walletInfo;

          if (_walletInfo != null) {
            print(
                '✅ Wallet loaded after initialization: ${_walletInfo!.address}');
            await loadBalance();
          } else {
            print('❌ Still no wallet found after initialization');
            _showErrorSnackbar(
                'Unable to load wallet. Please try logging in again.');
          }
        }
      } else {
        print('❌ User not authenticated');
        _showErrorSnackbar('User not authenticated. Please log in.');
      }
    } catch (e) {
      print('❌ Error in HoneViewModel initialize: $e');
      _showErrorSnackbar('Error loading wallet: $e');
    } finally {
      setBusy(false);
    }
  }

  /// Load wallet balance - Focus on USDC only
  Future<void> loadBalance() async {
    if (_walletInfo == null) return;

    try {
      // Load USDC balance as primary balance
      _usdcBalance = await _tokenService.getUsdcBalance(_walletInfo!.address);

      // Keep ETH balance for deployment checks only (not displayed)
      _balance = await _walletService.getEthBalance(_walletInfo!.address);
      
      // Load total savings balance from contract
      await loadSavingsBalance();
      
      notifyListeners();
    } catch (e) {
      _showErrorSnackbar('Error loading balance: $e');
    }
  }

  Future<void> loadUsdcBalance() async {
    if (_walletInfo == null) return;

    try {
      _usdcBalance = await _tokenService.getUsdcBalance(_walletInfo!.address);
      notifyListeners();
    } catch (e) {
      _showErrorSnackbar('Error loading USDC balance: $e');
    }
  }

  /// Refresh wallet data - Focus on ETH
  Future<void> refresh() async {
    await loadBalance(); // This now loads ETH as primary
  }

  /// Navigate to send USDC screen
  void navigateToSendUsdc() {
    if (_walletInfo == null) {
      _showErrorSnackbar('No wallet found');
      return;
    }

    // For now, show a placeholder message since we need to add routing
    _showInfoSnackbar('Send USDC feature coming soon!');
  }

  /// Deploy account (needed for sending transactions)
  Future<void> deployAccount() async {
    if (_walletInfo == null || _walletInfo!.isDeployed) return;

    setBusy(true);

    try {
      final txHash = await _walletService.deployAccount();
      _showSuccessSnackbar(
          'Account deployment initiated!\nTx: ${txHash.substring(0, 10)}...');

      // Reload wallet info to update deployment status
      _walletInfo = await _walletService.loadWallet();
      notifyListeners();
    } catch (e) {
      _showErrorSnackbar('Failed to deploy account: $e');
    } finally {
      setBusy(false);
    }
  }

  /// Delete wallet
  Future<void> deleteWallet() async {
    setBusy(true);

    try {
      await _walletService.deleteWallet();
      _walletInfo = null;
      _balance = BigInt.zero;
      _showInfoSnackbar('Wallet deleted successfully');
    } catch (e) {
      _showErrorSnackbar('Error deleting wallet: $e');
    } finally {
      setBusy(false);
    }
  }

  // Helper methods for snackbars
  void _showSuccessSnackbar(String message) {
    _snackbarService.showSnackbar(
      message: message,
      duration: Duration(seconds: 4),
    );
  }

  void _showErrorSnackbar(String message) {
    _snackbarService.showSnackbar(
      message: message,
      duration: Duration(seconds: 4),
    );
  }

  void _showInfoSnackbar(String message) {
    _snackbarService.showSnackbar(
      message: message,
      duration: Duration(seconds: 2),
    );
  }

  // Savings-related properties
  double _totalSavingsBalance = 0.0;
  double get totalSavingsBalance => _totalSavingsBalance;
  
  UserStats? _userStats;
  UserStats? get userStats => _userStats;
  
  List<TransactionData> _recentTransactions = [];
  List<TransactionData> get recentTransactions => _recentTransactions;

  /// Load total savings balance from contract
  Future<void> loadSavingsBalance() async {
    try {
      _totalSavingsBalance = await _contractService.getUserTotalBalance();
    } catch (e) {
      print('⚠️ Error loading savings balance: $e');
      // Don't show error to user as this is supplementary data
    }
  }

  /// Load user statistics from contract
  Future<void> loadUserStats() async {
    try {
      _userStats = await _contractService.getUserStats();
      notifyListeners();
    } catch (e) {
      print('⚠️ Error loading user stats: $e');
    }
  }

  /// Load recent transactions from contract
  Future<void> loadRecentTransactions() async {
    try {
      _recentTransactions = await _contractService.getTransactionHistory(limit: 10);
      notifyListeners();
    } catch (e) {
      print('⚠️ Error loading recent transactions: $e');
    }
  }

  /// Refresh all dashboard data
  Future<void> refreshDashboard() async {
    await Future.wait([
      loadBalance(),
      loadUserStats(),
      loadRecentTransactions(),
    ]);
  }

  Future<void> logout() async {
    setBusy(true);

    try {
      _authService.logout();
    } catch (e) {
      print('❌ Error during logout: $e');
      _showErrorSnackbar('Error logging out: $e');
    } finally {
      setBusy(false);
    }
  }
}
