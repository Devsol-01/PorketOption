

// 1. Create a Privy Service (services/privy_service.dart)
import 'package:privy_flutter/privy_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:mobile_app/config/env_config.dart';

class PrivyService with ListenableServiceMixin {
  // Private Privy instance
  Privy? _privySdk;
  
  // Reactive properties
  final _isInitialized = ReactiveValue<bool>(false);
  final _isAuthenticated = ReactiveValue<bool>(false);
  final _currentUser = ReactiveValue<PrivyUser?>(null);
  final _isLoading = ReactiveValue<bool>(false);
  final _errorMessage = ReactiveValue<String?>(null);

  // Getters for reactive values
  bool get isInitialized => _isInitialized.value;
  bool get isAuthenticated => _isAuthenticated.value;
  PrivyUser? get currentUser => _currentUser.value;
  bool get isLoading => _isLoading.value;
  String? get errorMessage => _errorMessage.value;

  // Getter for Privy instance
  Privy get privy {
    if (_privySdk == null) {
      throw Exception('PrivyService not initialized. Call initialize() first.');
    }
    return _privySdk!;
  }

  PrivyService() {
    // Register reactive values for listening
    listenToReactiveValues([
      _isInitialized,
      _isAuthenticated,
      _currentUser,
      _isLoading,
      _errorMessage,
    ]);
  }

  /// Initialize Privy SDK
  Future<void> initialize() async {
    try {
      _setLoading(true);
      
      final privyConfig = PrivyConfig(
        appId: EnvConfig.privyAppId,
        appClientId: EnvConfig.privyClientId,
        logLevel: PrivyLogLevel.debug,
      );

      _privySdk = Privy.init(config: privyConfig);
      _isInitialized.value = true;
      
      // Check if user is already authenticated
      await _checkAuthenticationStatus();
      
      _setLoading(false);
      _clearError();
    } catch (e) {
      _setError('Failed to initialize Privy: $e');
      _setLoading(false);
      rethrow;
    }
  }

  /// Send email verification code
  Future<bool> sendEmailCode(String email) async {
    try {
      _setLoading(true);
      _clearError();

      final result = await privy.email.sendCode(email);
      
      bool success = false;
      result.fold(
        onSuccess: (_) {
          success = true;
          _setLoading(false);
        },
        onFailure: (error) {
          success = false;
          _setError('Failed to send code: ${error.message}');
          _setLoading(false);
        },
      );
      
      return success;
    } catch (e) {
      _setError('Unexpected error: $e');
      _setLoading(false);
      return false;
    }
  }

  /// Login with email and code
  Future<bool> loginWithEmailCode(String email, String code) async {
    try {
      _setLoading(true);
      _clearError();

      final result = await privy.email.loginWithCode(
        email: email,
        code: code,
      );

      bool success = false;
      result.fold(
        onSuccess: (user) {
          _currentUser.value = user;
          _isAuthenticated.value = true;
          success = true;
          _setLoading(false);
        },
        onFailure: (error) {
          success = false;
          _setError('Login failed: ${error.message}');
          _setLoading(false);
        },
      );
      
      return success;
    } catch (e) {
      _setError('Unexpected error: $e');
      _setLoading(false);
      return false;
    }
  }

  /// Create Solana wallet
  Future<dynamic> createSolanaWallet() async {
    if (!isAuthenticated || currentUser == null) {
      _setError('User not authenticated');
      return null;
    }

    try {
      _setLoading(true);
      _clearError();

      final result = await currentUser!.createSolanaWallet();

      dynamic wallet;
      result.fold(
        onSuccess: (createdWallet) {
          wallet = createdWallet;
          _setLoading(false);
          // Refresh user data
          _refreshUserData();
        },
        onFailure: (error) {
          wallet = null;
          _setError('Failed to create Solana wallet: ${error.message}');
          _setLoading(false);
        },
      );
      
      return wallet;
    } catch (e) {
      _setError('Unexpected error: $e');
      _setLoading(false);
      return null;
    }
  }

  /// Logout user
  Future<bool> logout() async {
    try {
      _setLoading(true);
      _clearError();

      await privy.logout();
      
      _currentUser.value = null;
      _isAuthenticated.value = false;
      _setLoading(false);
      
      return true;
    } catch (e) {
      _setError('Logout failed: $e');
      _setLoading(false);
      return false;
    }
  }

  /// Private helper methods
  void _setLoading(bool loading) {
    _isLoading.value = loading;
  }

  void _setError(String error) {
    _errorMessage.value = error;
  }

  void _clearError() {
    _errorMessage.value = null;
  }

  Future<void> _checkAuthenticationStatus() async {
    try {
      final user = privy.user;
      if (user != null) {
        _currentUser.value = user;
        _isAuthenticated.value = true;
      }
    } catch (e) {
      // User not authenticated or other error
      _isAuthenticated.value = false;
      _currentUser.value = null;
    }
  }

  void _refreshUserData() {
    // Refresh current user data from Privy
    final user = privy.user;
    if (user != null) {
      _currentUser.value = user;
    }
  }
}
