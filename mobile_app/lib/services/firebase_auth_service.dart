import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Enhanced User model with additional registration fields
class AppUser {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? walletAddress;
  final String? referralCode;
  final DateTime createdAt;
  final DateTime lastLoginAt;

  AppUser({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.walletAddress,
    this.referralCode,
    required this.createdAt,
    required this.lastLoginAt,
  });

  String get fullName => '$firstName $lastName';
  String get displayName => fullName;

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUser(
      id: doc.id,
      email: data['email'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      walletAddress: data['walletAddress'],
      referralCode: data['referralCode'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastLoginAt:
          (data['lastLoginAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'walletAddress': walletAddress,
      'referralCode': referralCode,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLoginAt': Timestamp.fromDate(lastLoginAt),
    };
  }

  AppUser copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? walletAddress,
    String? referralCode,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      walletAddress: walletAddress ?? this.walletAddress,
      referralCode: referralCode ?? this.referralCode,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }
}

/// Registration data model
class RegistrationData {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String? referralCode;

  RegistrationData({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    this.referralCode,
  });

  bool get hasReferralCode => referralCode != null && referralCode!.isNotEmpty;
}

/// Firebase Authentication Service with extended user management
class FirebaseAuthService extends ChangeNotifier {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AppUser? _currentUser;
  bool _isLoading = false;

  // Getters
  AppUser? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get currentUserId => _currentUser?.id;

  /// Initialize service and restore user session
  Future<void> initialize() async {
    try {
      _setLoading(true);

      // Listen to auth state changes
      _auth.authStateChanges().listen(_onAuthStateChanged);

      // Check if user is already signed in
      final firebaseUser = _auth.currentUser;
      if (firebaseUser != null) {
        await _loadUserData(firebaseUser.uid);
      }
    } catch (e) {
      print('❌ Error initializing Firebase Auth Service: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Register new user with extended information
  Future<AppUser> registerUser(RegistrationData registrationData) async {
    try {
      _setLoading(true);
      print('📝 Registering user: ${registrationData.email}');

      // Validate referral code if provided
      if (registrationData.hasReferralCode) {
        final isValidReferral =
            await _validateReferralCode(registrationData.referralCode!);
        if (!isValidReferral) {
          throw FirebaseAuthException(
            code: 'invalid-referral-code',
            message: 'The referral code provided is invalid.',
          );
        }
      }

      // Create Firebase Auth user
      final credential = await _auth.createUserWithEmailAndPassword(
        email: registrationData.email,
        password: registrationData.password,
      );

      if (credential.user == null) {
        throw FirebaseAuthException(
          code: 'user-creation-failed',
          message: 'Failed to create user account.',
        );
      }

      // Update Firebase Auth display name
      await credential.user!.updateDisplayName(
        '${registrationData.firstName} ${registrationData.lastName}',
      );

      // Create user document in Firestore
      final now = DateTime.now();
      final newUser = AppUser(
        id: credential.user!.uid,
        email: registrationData.email,
        firstName: registrationData.firstName,
        lastName: registrationData.lastName,
        referralCode: registrationData.referralCode,
        createdAt: now,
        lastLoginAt: now,
      );

      await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .set(newUser.toFirestore());

      // Process referral if provided
      if (registrationData.hasReferralCode) {
        await _processReferral(newUser.id, registrationData.referralCode!);
      }

      _currentUser = newUser;
      notifyListeners();

      print('✅ User registered successfully: ${newUser.fullName}');
      return newUser;
    } on firebase_auth.FirebaseAuthException catch (e) {
      print('❌ Firebase Auth Error: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      print('❌ Registration Error: $e');
      throw FirebaseAuthException(
        code: 'registration-failed',
        message: 'Failed to register user: $e',
      );
    } finally {
      _setLoading(false);
    }
  }

  /// Sign in user with email and password
  Future<AppUser> signInWithEmail(String email, String password) async {
    try {
      _setLoading(true);
      print('🔐 Signing in user: $email');

      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw FirebaseAuthException(
          code: 'sign-in-failed',
          message: 'Failed to sign in user.',
        );
      }

      // Load and update user data
      await _loadUserData(credential.user!.uid);

      // Update last login time
      if (_currentUser != null) {
        final updatedUser = _currentUser!.copyWith(lastLoginAt: DateTime.now());
        await _updateUserData(updatedUser);
        _currentUser = updatedUser;
        notifyListeners();
      }

      print('✅ User signed in successfully: ${_currentUser?.fullName}');
      return _currentUser!;
    } on firebase_auth.FirebaseAuthException catch (e) {
      print('❌ Sign in Error: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      print('❌ Sign in Error: $e');
      throw FirebaseAuthException(
        code: 'sign-in-failed',
        message: 'Failed to sign in: $e',
      );
    } finally {
      _setLoading(false);
    }
  }

  /// Update user wallet address
  Future<AppUser> updateUserWallet(String walletAddress) async {
    if (_currentUser == null) {
      throw FirebaseAuthException(
        code: 'user-not-authenticated',
        message: 'User must be authenticated to update wallet.',
      );
    }

    try {
      print('💰 Updating wallet for user: ${_currentUser!.fullName}');

      final updatedUser = _currentUser!.copyWith(walletAddress: walletAddress);
      await _updateUserData(updatedUser);

      _currentUser = updatedUser;
      notifyListeners();

      print('✅ Wallet updated successfully');
      return updatedUser;
    } catch (e) {
      print('❌ Error updating wallet: $e');
      throw FirebaseAuthException(
        code: 'wallet-update-failed',
        message: 'Failed to update wallet: $e',
      );
    }
  }

  /// Sign out current user
  Future<void> signOut() async {
    try {
      print('👋 Signing out user: ${_currentUser?.fullName}');
      await _auth.signOut();
      _currentUser = null;
      notifyListeners();
      print('✅ User signed out successfully');
    } catch (e) {
      print('❌ Error signing out: $e');
      throw FirebaseAuthException(
        code: 'sign-out-failed',
        message: 'Failed to sign out: $e',
      );
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print('✅ Password reset email sent to: $email');
    } on firebase_auth.FirebaseAuthException catch (e) {
      print('❌ Password reset error: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    }
  }

  /// Delete current user account
  Future<void> deleteAccount() async {
    if (_currentUser == null) return;

    try {
      final userId = _currentUser!.id;

      // Delete user document from Firestore
      await _firestore.collection('users').doc(userId).delete();

      // Delete Firebase Auth user
      await _auth.currentUser?.delete();

      _currentUser = null;
      notifyListeners();

      print('✅ User account deleted successfully');
    } catch (e) {
      print('❌ Error deleting account: $e');
      throw FirebaseAuthException(
        code: 'account-deletion-failed',
        message: 'Failed to delete account: $e',
      );
    }
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> _onAuthStateChanged(firebase_auth.User? firebaseUser) async {
    if (firebaseUser != null && _currentUser == null) {
      await _loadUserData(firebaseUser.uid);
    } else if (firebaseUser == null && _currentUser != null) {
      _currentUser = null;
      notifyListeners();
    }
  }

  Future<void> _loadUserData(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        _currentUser = AppUser.fromFirestore(doc);
        notifyListeners();
      }
    } catch (e) {
      print('❌ Error loading user data: $e');
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      print('✅ User logged out successfully');
    } catch (e) {
      print('❌ Error logging out: $e');
      throw Exception('Failed to logout: $e');
    }
  }

  Future<void> _updateUserData(AppUser user) async {
    await _firestore
        .collection('users')
        .doc(user.id)
        .update(user.toFirestore());
  }

  Future<bool> _validateReferralCode(String referralCode) async {
    try {
      // Check if referral code exists in referrals collection
      final query = await _firestore
          .collection('referrals')
          .where('code', isEqualTo: referralCode)
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();

      return query.docs.isNotEmpty;
    } catch (e) {
      print('❌ Error validating referral code: $e');
      return false;
    }
  }

  Future<void> _processReferral(String userId, String referralCode) async {
    try {
      // Record referral usage
      await _firestore.collection('referral_usage').add({
        'userId': userId,
        'referralCode': referralCode,
        'usedAt': Timestamp.now(),
      });

      print('✅ Referral processed: $referralCode');
    } catch (e) {
      print('❌ Error processing referral: $e');
    }
  }

  FirebaseAuthException _handleAuthException(
      firebase_auth.FirebaseAuthException e) {
    String message;

    switch (e.code) {
      case 'weak-password':
        message = 'The password provided is too weak.';
        break;
      case 'email-already-in-use':
        message = 'An account already exists for this email.';
        break;
      case 'invalid-email':
        message = 'The email address is not valid.';
        break;
      case 'user-not-found':
        message = 'No user found for this email.';
        break;
      case 'wrong-password':
        message = 'Wrong password provided.';
        break;
      case 'user-disabled':
        message = 'This user account has been disabled.';
        break;
      case 'too-many-requests':
        message = 'Too many requests. Try again later.';
        break;
      case 'operation-not-allowed':
        message = 'Email/password accounts are not enabled.';
        break;
      default:
        message = e.message ?? 'An authentication error occurred.';
    }

    return FirebaseAuthException(code: e.code, message: message);
  }
}

/// Custom Firebase Auth Exception
class FirebaseAuthException implements Exception {
  final String code;
  final String message;

  FirebaseAuthException({required this.code, required this.message});

  @override
  String toString() => 'FirebaseAuthException: $code - $message';
}
