import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_auth_service.dart';
import 'wallet_service.dart';
import '../app/app.locator.dart';

/// Firebase-based User-Wallet Manager with extended registration support
class FirebaseWalletManagerService extends ChangeNotifier {
  late final FirebaseAuthService _authService;
  late final WalletService _walletService;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  bool _isLoading = false;
  String? _errorMessage;

  FirebaseWalletManagerService() {
    // Initialize services from locator
    _authService = locator<FirebaseAuthService>();
    _walletService = locator<WalletService>();

    // Listen to auth state changes
    _authService.addListener(_onAuthStateChanged);
  }

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  AppUser? get currentUser => _authService.currentUser;
  bool get isAuthenticated => _authService.isAuthenticated;
  bool get hasWallet => _walletService.hasWallet;
  WalletInfo? get walletInfo => _walletService.walletInfo;

  /// Initialize the wallet manager
  Future<void> initialize() async {
    try {
      _setLoading(true);
      _clearError();

      print('🚀 Initializing Firebase Wallet Manager...');

      // Initialize Firebase Auth Service
      await _authService.initialize();

      // If user is authenticated, try to load their wallet
      if (_authService.isAuthenticated) {
        await _loadUserWallet();
      }

      print('✅ Firebase Wallet Manager initialized successfully');
    } catch (e) {
      _setError('Failed to initialize wallet manager: $e');
      print('❌ Error initializing Firebase Wallet Manager: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Register new user with wallet creation
  Future<AppUser> registerUserWithWallet(
      RegistrationData registrationData) async {
    try {
      _setLoading(true);
      _clearError();

      print('📝 Registering user with wallet: ${registrationData.email}');

      // Step 1: Register user with Firebase Auth
      final user = await _authService.registerUser(registrationData);
      print('✅ User registered: ${user.fullName}');

      // Step 2: Create wallet for the user
      final walletInfo = await _walletService.createWallet();
      print('✅ Wallet created: ${walletInfo.address}');

      // Debug: Check if keys are available in WalletService
      print('🔍 Debug - Checking wallet keys after creation:');
      print(
          '   - Private key available: ${_walletService.currentPrivateKeyHex != null}');
      print(
          '   - Guardian key available: ${_walletService.currentGuardianKeyHex != null}');
      print(
          '   - App key available: ${_walletService.currentAppKeyHex != null}');

      // Step 3: Store wallet keys securely (local + cloud)
      print('🔍 Step 3: Storing wallet keys for user: ${user.id}');
      await _storeWalletKeysLocally(user.id, walletInfo);
      print('✅ Wallet keys stored locally and in cloud');

      // Verify keys were stored by trying to read them back
      print('🔍 Verification: Checking if keys were stored properly...');
      final verifyKeys = await _loadWalletKeysLocally(user.id);
      if (verifyKeys != null) {
        print('✅ Verification successful: Keys can be read back');
      } else {
        print('❌ Verification failed: Keys cannot be read back');
      }

      // Step 4: Update user with wallet address in Firestore
      final updatedUser =
          await _authService.updateUserWallet(walletInfo.address);
      print('✅ User updated with wallet address');

      // Step 5: Store wallet metadata in Firestore
      await _storeWalletMetadataInFirestore(updatedUser, walletInfo);
      print('✅ Wallet metadata stored in Firestore');

      print('🎉 User registration with wallet completed successfully!');
      return updatedUser;
    } catch (e) {
      _setError('Failed to register user with wallet: $e');
      print('❌ Error registering user with wallet: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Sign in user and load their wallet
  Future<AppUser> signInUserWithWallet(String email, String password) async {
    try {
      _setLoading(true);
      _clearError();

      print('🔐 Signing in user with wallet: $email');

      // Step 1: Sign in user
      final user = await _authService.signInWithEmail(email, password);
      print('✅ User signed in: ${user.fullName}');

      // Step 2: Load user's wallet
      await _loadUserWallet();
      print('✅ User wallet loaded');

      print('🎉 User sign in with wallet completed successfully!');
      return user;
    } catch (e) {
      _setError('Failed to sign in user with wallet: $e');
      print('❌ Error signing in user with wallet: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Sign out user and clear wallet data
  Future<void> signOutUser() async {
    try {
      _setLoading(true);
      _clearError();

      print('👋 Signing out user and clearing wallet...');

      // Clear wallet data
      await _walletService.clearWallet();
      print('✅ Wallet data cleared');

      // Sign out user
      await _authService.signOut();
      print('✅ User signed out');

      print('🎉 User sign out completed successfully!');
    } catch (e) {
      _setError('Failed to sign out user: $e');
      print('❌ Error signing out user: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Load user's wallet from stored keys and metadata
  Future<void> _loadUserWallet() async {
    final user = _authService.currentUser;
    if (user == null) {
      print('❌ No authenticated user found');
      return;
    }

    print('🔑 Loading wallet for user: ${user.fullName} (ID: ${user.id})');

    if (user.walletAddress == null) {
      print('❌ User has no wallet address in profile');
      print('❌ This user may need to create a new wallet');
      return;
    }

    try {
      // Load wallet keys from secure storage (local + cloud)
      print('🔍 Step 1: Loading wallet keys...');
      final walletKeys = await _loadWalletKeysLocally(user.id);
      if (walletKeys == null) {
        print('❌ No wallet keys found anywhere (local or cloud)');
        print('❌ User: ${user.fullName} needs wallet key recovery');
        return;
      }
      print('✅ Wallet keys loaded successfully');

      // Load wallet metadata from Firestore
      print('🔍 Step 2: Loading wallet metadata...');
      final walletMetadata = await _loadWalletMetadataFromFirestore(user.id);
      if (walletMetadata == null) {
        print('❌ No wallet metadata found in Firestore for user: ${user.id}');
        return;
      }
      print('✅ Wallet metadata loaded successfully');

      // Load wallet using keys and metadata
      print('🔍 Step 3: Loading wallet into WalletService...');
      await _walletService.loadWalletFromKeys(
        privateKey: walletKeys['privateKey']!,
        guardianKey: walletKeys['guardianKey']!,
        appKey: walletKeys['appKey']!,
        address: walletMetadata['address']!,
        publicKey: walletMetadata['publicKey']!,
        isDeployed: walletMetadata['isDeployed'] as bool,
      );

      print('✅ Wallet loaded successfully for user: ${user.fullName}');
      print('✅ Wallet address: ${walletMetadata['address']}');
    } catch (e) {
      print('❌ Error loading user wallet: $e');
      print('❌ Stack trace: ${StackTrace.current}');
      throw Exception('Failed to load user wallet: $e');
    }
  }

  /// Store wallet keys securely (both locally and encrypted in cloud)
  Future<void> _storeWalletKeysLocally(
      String userId, WalletInfo walletInfo) async {
    try {
      print('🔐 Attempting to store wallet keys for user: $userId');

      // Get current wallet keys from WalletService
      final privateKey = _walletService.currentPrivateKeyHex;
      final guardianKey = _walletService.currentGuardianKeyHex;
      final appKey = _walletService.currentAppKeyHex;

      print('🔍 Retrieved keys from WalletService:');
      print(
          '   - Private key: ${privateKey != null ? "✅ Available" : "❌ Missing"}');
      print(
          '   - Guardian key: ${guardianKey != null ? "✅ Available" : "❌ Missing"}');
      print('   - App key: ${appKey != null ? "✅ Available" : "❌ Missing"}');

      if (privateKey == null || guardianKey == null || appKey == null) {
        throw Exception(
            'Wallet keys not available from WalletService - privateKey: $privateKey, guardianKey: $guardianKey, appKey: $appKey');
      }

      // Store keys locally for quick access
      await _secureStorage.write(
          key: 'wallet_private_key_$userId', value: privateKey);
      await _secureStorage.write(
          key: 'wallet_guardian_key_$userId', value: guardianKey);
      await _secureStorage.write(key: 'wallet_app_key_$userId', value: appKey);

      // ALSO store encrypted keys in Firestore for multi-device access
      await _storeEncryptedKeysInFirestore(
          userId, privateKey, guardianKey, appKey);

      print(
          '✅ Wallet keys stored both locally and in encrypted cloud storage for user: $userId');
    } catch (e) {
      print('❌ Error storing wallet keys: $e');
      throw Exception('Failed to store wallet keys: $e');
    }
  }

  /// Store encrypted wallet keys in Firestore for multi-device access
  Future<void> _storeEncryptedKeysInFirestore(String userId, String privateKey,
      String guardianKey, String appKey) async {
    try {
      // Create a simple encryption using user's email as key (you can make this more sophisticated)
      final user = _authService.currentUser!;
      final encryptionKey = _generateEncryptionKey(user.email);

      final encryptedPrivateKey = _encryptString(privateKey, encryptionKey);
      final encryptedGuardianKey = _encryptString(guardianKey, encryptionKey);
      final encryptedAppKey = _encryptString(appKey, encryptionKey);

      await FirebaseFirestore.instance
          .collection('encrypted_wallets')
          .doc(userId)
          .set({
        'encryptedPrivateKey': encryptedPrivateKey,
        'encryptedGuardianKey': encryptedGuardianKey,
        'encryptedAppKey': encryptedAppKey,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print(
          '✅ Encrypted wallet keys stored in Firestore for multi-device access');
    } catch (e) {
      print('❌ Error storing encrypted keys in Firestore: $e');
      // Don't throw here - local storage should still work
    }
  }

  /// Generate encryption key from user email
  String _generateEncryptionKey(String email) {
    // Simple key derivation - in production, use proper key derivation functions
    return email.hashCode.toString().padLeft(32, '0').substring(0, 32);
  }

  /// Simple string encryption (XOR-based)
  String _encryptString(String text, String key) {
    final textBytes = text.codeUnits;
    final keyBytes = key.codeUnits;
    final encrypted = <int>[];

    for (int i = 0; i < textBytes.length; i++) {
      encrypted.add(textBytes[i] ^ keyBytes[i % keyBytes.length]);
    }

    return encrypted.map((e) => e.toRadixString(16).padLeft(2, '0')).join();
  }

  /// Simple string decryption (XOR-based)
  String _decryptString(String encryptedHex, String key) {
    final encryptedBytes = <int>[];
    for (int i = 0; i < encryptedHex.length; i += 2) {
      encryptedBytes
          .add(int.parse(encryptedHex.substring(i, i + 2), radix: 16));
    }

    final keyBytes = key.codeUnits;
    final decrypted = <int>[];

    for (int i = 0; i < encryptedBytes.length; i++) {
      decrypted.add(encryptedBytes[i] ^ keyBytes[i % keyBytes.length]);
    }

    return String.fromCharCodes(decrypted);
  }

  /// Load wallet keys from local storage or encrypted cloud storage
  Future<Map<String, String>?> _loadWalletKeysLocally(String userId) async {
    try {
      print('🔍 Attempting to load wallet keys for user: $userId');

      // First try to load from local storage (faster)
      final privateKey =
          await _secureStorage.read(key: 'wallet_private_key_$userId');
      final guardianKey =
          await _secureStorage.read(key: 'wallet_guardian_key_$userId');
      final appKey = await _secureStorage.read(key: 'wallet_app_key_$userId');

      if (privateKey != null && guardianKey != null && appKey != null) {
        print('✅ Wallet keys loaded from local storage');
        return {
          'privateKey': privateKey,
          'guardianKey': guardianKey,
          'appKey': appKey,
        };
      }

      print(
          '⚠️ No wallet keys found locally, trying encrypted cloud storage...');

      // If not found locally, try to load from encrypted Firestore
      return await _loadEncryptedKeysFromFirestore(userId);
    } catch (e) {
      print('❌ Error loading wallet keys: $e');
      return null;
    }
  }

  /// Load encrypted wallet keys from Firestore and decrypt them
  Future<Map<String, String>?> _loadEncryptedKeysFromFirestore(
      String userId) async {
    try {
      final user = _authService.currentUser;
      if (user == null) {
        print('❌ No authenticated user for decryption');
        return null;
      }

      final doc = await FirebaseFirestore.instance
          .collection('encrypted_wallets')
          .doc(userId)
          .get();

      if (!doc.exists) {
        print('❌ No encrypted wallet keys found in Firestore');
        return null;
      }

      final data = doc.data() as Map<String, dynamic>;
      final encryptionKey = _generateEncryptionKey(user.email);

      final privateKey =
          _decryptString(data['encryptedPrivateKey'], encryptionKey);
      final guardianKey =
          _decryptString(data['encryptedGuardianKey'], encryptionKey);
      final appKey = _decryptString(data['encryptedAppKey'], encryptionKey);

      // Store decrypted keys locally for future use
      await _secureStorage.write(
          key: 'wallet_private_key_$userId', value: privateKey);
      await _secureStorage.write(
          key: 'wallet_guardian_key_$userId', value: guardianKey);
      await _secureStorage.write(key: 'wallet_app_key_$userId', value: appKey);

      print(
          '✅ Wallet keys loaded from encrypted cloud storage and cached locally');

      return {
        'privateKey': privateKey,
        'guardianKey': guardianKey,
        'appKey': appKey,
      };
    } catch (e) {
      print('❌ Error loading encrypted keys from Firestore: $e');
      return null;
    }
  }

  /// Store wallet metadata in Firestore (public data only)
  Future<void> _storeWalletMetadataInFirestore(
      AppUser user, WalletInfo walletInfo) async {
    try {
      await FirebaseFirestore.instance.collection('wallets').doc(user.id).set({
        'userId': user.id,
        'address': walletInfo.address,
        'publicKey': walletInfo.publicKey,
        'isDeployed': walletInfo.isDeployed,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print('✅ Wallet metadata stored in Firestore for user: ${user.fullName}');
    } catch (e) {
      print('❌ Error storing wallet metadata in Firestore: $e');
      throw Exception('Failed to store wallet metadata in Firestore: $e');
    }
  }

  /// Load wallet metadata from Firestore
  Future<Map<String, dynamic>?> _loadWalletMetadataFromFirestore(
      String userId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('wallets')
          .doc(userId)
          .get();

      if (!doc.exists) {
        return null;
      }

      final data = doc.data() as Map<String, dynamic>;
      return {
        'address': data['address'],
        'publicKey': data['publicKey'],
        'isDeployed': data['isDeployed'] ?? false,
      };
    } catch (e) {
      print('❌ Error loading wallet metadata from Firestore: $e');
      return null;
    }
  }

  /// Clear wallet keys from local storage
  Future<void> _clearWalletKeysLocally(String userId) async {
    try {
      await _secureStorage.delete(key: 'wallet_private_key_$userId');
      await _secureStorage.delete(key: 'wallet_guardian_key_$userId');
      await _secureStorage.delete(key: 'wallet_app_key_$userId');
      print('✅ Wallet keys cleared locally for user: $userId');
    } catch (e) {
      print('❌ Error clearing wallet keys locally: $e');
    }
  }

  /// Handle auth state changes
  void _onAuthStateChanged() {
    if (!_authService.isAuthenticated) {
      // User signed out, clear wallet
      _walletService.clearWallet();
    }
    notifyListeners();
  }

  /// Update wallet deployment status
  Future<void> updateWalletDeploymentStatus(bool isDeployed) async {
    final user = _authService.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('wallets')
          .doc(user.id)
          .update({
        'isDeployed': isDeployed,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print('✅ Wallet deployment status updated: $isDeployed');
    } catch (e) {
      print('❌ Error updating wallet deployment status: $e');
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _authService.sendPasswordResetEmail(email);
    } catch (e) {
      _setError('Failed to send password reset email: $e');
      rethrow;
    }
  }

  /// Delete user account and wallet data
  Future<void> deleteUserAccount() async {
    final user = _authService.currentUser;
    if (user == null) return;

    try {
      _setLoading(true);
      _clearError();

      // Clear local wallet keys
      await _clearWalletKeysLocally(user.id);

      // Delete wallet metadata from Firestore
      await FirebaseFirestore.instance
          .collection('wallets')
          .doc(user.id)
          .delete();

      // Clear wallet service
      await _walletService.clearWallet();

      // Delete user account
      await _authService.deleteAccount();

      print('✅ User account and wallet data deleted successfully');
    } catch (e) {
      _setError('Failed to delete user account: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _authService.removeListener(_onAuthStateChanged);
    super.dispose();
  }
}
