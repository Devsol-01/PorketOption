import 'package:flutter/material.dart';
import 'package:mobile_app/services/firebase_auth_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:mobile_app/app/app.router.dart';
import '../../../app/app.locator.dart'; // Ensure this import is present

class LoginViewModel extends BaseViewModel {
  final _firebaseAuthService = locator<FirebaseAuthService>();
  final _navigationService = locator<NavigationService>();

  // Form controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Password visibility
  bool _isPasswordVisible = false;

  bool get isPasswordVisible => _isPasswordVisible;

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  /// Login user
  Future<void> login() async {
    if (!_validateForm()) return;

    try {
      setBusy(true);
      await _firebaseAuthService.signInWithEmail(
        emailController.text.trim(),
        passwordController.text,
      );

      // Navigate to bottom navigation view after successful login
      _navigationService.clearStackAndShow(Routes.bottomNavView);
    } catch (e) {
      // Handle login error
      _showError(e.toString());
    } finally {
      setBusy(false);
    }
  }

  /// Validate login form
  bool _validateForm() {
    if (emailController.text.trim().isEmpty) {
      _showError('Please enter your email address');
      return false;
    }

    if (passwordController.text.isEmpty) {
      _showError('Please enter your password');
      return false;
    }

    return true;
  }

  /// Show error message
  void _showError(String message) {
    // Implement error handling (e.g., show dialog or snackbar)
  }

  /// Navigate to registration screen
  void navigateToRegister() {
    // Implement navigation to registration screen
    // Example: Navigator.pushNamed(context, Routes.registerView);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
