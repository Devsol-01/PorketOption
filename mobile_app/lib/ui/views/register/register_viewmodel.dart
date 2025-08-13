import 'package:flutter/material.dart';
import 'package:mobile_app/services/firebase_wallet_manager_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/firebase_auth_service.dart';
class RegisterViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _snackbarService = locator<SnackbarService>();
  final _firebaseWalletManager = locator<FirebaseWalletManagerService>();

  // Form controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController referralCodeController = TextEditingController();

  // Password visibility
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  bool get isPasswordVisible => _isPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    notifyListeners();
  }

  /// Register new user with wallet
  Future<void> register() async {
    if (!_validateForm()) return;

    try {
      setBusy(true);

      // Create registration data
      final registrationData = RegistrationData(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        referralCode: referralCodeController.text.trim().isEmpty
            ? null
            : referralCodeController.text.trim(),
      );

      // Register user with wallet
      final user =
          await _firebaseWalletManager.registerUserWithWallet(registrationData);

      // Show success message
      _snackbarService.showSnackbar(
        message: 'Welcome ${user.fullName}! Your wallet has been created.',
        duration: const Duration(seconds: 3),
      );

      // Navigate to main app
      _navigationService.clearStackAndShow(Routes.dashboardView);
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    } catch (e) {
      _dialogService.showDialog(
        title: 'Registration Failed',
        description: 'An unexpected error occurred: ${e.toString()}',
      );
    } finally {
      setBusy(false);
    }
  }

  /// Validate registration form
  bool _validateForm() {
    // Check if all required fields are filled
    if (firstNameController.text.trim().isEmpty) {
      _showError('Please enter your first name');
      return false;
    }

    if (lastNameController.text.trim().isEmpty) {
      _showError('Please enter your last name');
      return false;
    }

    if (emailController.text.trim().isEmpty) {
      _showError('Please enter your email address');
      return false;
    }

    if (!_isValidEmail(emailController.text.trim())) {
      _showError('Please enter a valid email address');
      return false;
    }

    if (passwordController.text.isEmpty) {
      _showError('Please enter a password');
      return false;
    }

    if (passwordController.text.length < 6) {
      _showError('Password must be at least 6 characters long');
      return false;
    }

    if (passwordController.text != confirmPasswordController.text) {
      _showError('Passwords do not match');
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
      case 'invalid-referral-code':
        message = 'The referral code provided is invalid.';
        break;
      default:
        message = e.message;
    }

    _showError(message);
  }

  /// Show error message
  void _showError(String message) {
    _dialogService.showDialog(
      title: 'Registration Error',
      description: message,
    );
  }

  /// Navigate to login screen
  void navigateToLogin() {
    _navigationService.navigateTo(Routes.dashboardView);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    referralCodeController.dispose();
    super.dispose();
  }
}
