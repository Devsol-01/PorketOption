import 'package:flutter/material.dart';
import 'package:mobile_app/services/firebase_wallet_manager_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/firebase_auth_service.dart';
class AuthViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _snackbarService = locator<SnackbarService>();
  final _firebaseWalletManager = locator<FirebaseWalletManagerService>();

  // Form controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController referralCodeController = TextEditingController();

  // State
  bool _isLoginMode = true;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Getters
  bool get isLoginMode => _isLoginMode;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;

  void setLoginMode(bool isLogin) {
    _isLoginMode = isLogin;
    _clearForm();
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    notifyListeners();
  }

  /// Sign in existing user
  Future<void> signIn() async {
    if (!_validateLoginForm()) return;

    try {
      setBusy(true);

      final user = await _firebaseWalletManager.signInUserWithWallet(
        emailController.text.trim(),
        passwordController.text,
      );

      _snackbarService.showSnackbar(
        message: 'Welcome back, ${user.fullName}!',
        duration: const Duration(seconds: 2),
      );

      // Navigate to main wallet view
      print('🚀 Navigating to HoneView after successful login');
      _navigationService.clearStackAndShow(Routes.dashboardView);
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    } catch (e) {
      _showError(
          'Sign In Failed', 'An unexpected error occurred: ${e.toString()}');
    } finally {
      setBusy(false);
    }
  }

  /// Register new user with wallet
  Future<void> register() async {
    if (!_validateRegisterForm()) return;

    try {
      setBusy(true);

      final registrationData = RegistrationData(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        referralCode: referralCodeController.text.trim().isEmpty
            ? null
            : referralCodeController.text.trim(),
      );

      final user =
          await _firebaseWalletManager.registerUserWithWallet(registrationData);

      _snackbarService.showSnackbar(
        message: 'Welcome ${user.fullName}! Your wallet has been created.',
        duration: const Duration(seconds: 3),
      );

      // Navigate to main wallet view
      _navigationService.clearStackAndShow(Routes.dashboardView);
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    } catch (e) {
      _showError('Registration Failed',
          'An unexpected error occurred: ${e.toString()}');
    } finally {
      setBusy(false);
    }
  }

  /// Show forgot password dialog
  Future<void> showForgotPasswordDialog() async {
    final email = await _dialogService.showCustomDialog(
      variant: DialogType.form,
      title: 'Reset Password',
      description: 'Enter your email address to receive a password reset link.',
      mainButtonTitle: 'Send Reset Link',
      secondaryButtonTitle: 'Cancel',
      data: {
        'hint': 'Email address',
        'keyboardType': TextInputType.emailAddress,
      },
    );

    if (email?.data != null && email!.data.isNotEmpty) {
      try {
        setBusy(true);
        await _firebaseWalletManager.sendPasswordResetEmail(email.data);

        _snackbarService.showSnackbar(
          message: 'Password reset link sent to ${email.data}',
          duration: const Duration(seconds: 3),
        );
      } catch (e) {
        _showError('Reset Failed',
            'Failed to send password reset email: ${e.toString()}');
      } finally {
        setBusy(false);
      }
    }
  }

  /// Validate login form
  bool _validateLoginForm() {
    if (emailController.text.trim().isEmpty) {
      _showError('Validation Error', 'Please enter your email address');
      return false;
    }

    if (!_isValidEmail(emailController.text.trim())) {
      _showError('Validation Error', 'Please enter a valid email address');
      return false;
    }

    if (passwordController.text.isEmpty) {
      _showError('Validation Error', 'Please enter your password');
      return false;
    }

    return true;
  }

  /// Validate registration form
  bool _validateRegisterForm() {
    if (firstNameController.text.trim().isEmpty) {
      _showError('Validation Error', 'Please enter your first name');
      return false;
    }

    if (lastNameController.text.trim().isEmpty) {
      _showError('Validation Error', 'Please enter your last name');
      return false;
    }

    if (emailController.text.trim().isEmpty) {
      _showError('Validation Error', 'Please enter your email address');
      return false;
    }

    if (!_isValidEmail(emailController.text.trim())) {
      _showError('Validation Error', 'Please enter a valid email address');
      return false;
    }

    if (passwordController.text.isEmpty) {
      _showError('Validation Error', 'Please enter a password');
      return false;
    }

    if (passwordController.text.length < 6) {
      _showError(
          'Validation Error', 'Password must be at least 6 characters long');
      return false;
    }

    if (passwordController.text != confirmPasswordController.text) {
      _showError('Validation Error', 'Passwords do not match');
      return false;
    }

    return true;
  }

  /// Validate email format
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Handle Firebase Auth errors
  void _handleAuthError(FirebaseAuthException e) {
    String message;

    switch (e.code) {
      case 'email-already-in-use':
        message = 'An account already exists with this email address.';
        break;
      case 'weak-password':
        message = 'The password provided is too weak.';
        break;
      case 'invalid-email':
        message = 'The email address is not valid.';
        break;
      case 'user-not-found':
        message = 'No user found for this email address.';
        break;
      case 'wrong-password':
        message = 'Wrong password provided for that user.';
        break;
      case 'user-disabled':
        message = 'This user account has been disabled.';
        break;
      case 'too-many-requests':
        message = 'Too many requests. Try again later.';
        break;
      case 'invalid-referral-code':
        message = 'The referral code provided is invalid.';
        break;
      default:
        message = e.message;
    }

    _showError('Authentication Error', message);
  }

  /// Show error dialog
  void _showError(String title, String message) {
    _dialogService.showDialog(
      title: title,
      description: message,
    );
  }

  /// Clear form fields
  void _clearForm() {
    emailController.clear();
    passwordController.clear();
    firstNameController.clear();
    lastNameController.clear();
    confirmPasswordController.clear();
    referralCodeController.clear();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    confirmPasswordController.dispose();
    referralCodeController.dispose();
    super.dispose();
  }
}

enum DialogType { form }
