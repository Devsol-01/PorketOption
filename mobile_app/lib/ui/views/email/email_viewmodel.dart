import 'package:mobile_app/app/app.locator.dart';
import 'package:mobile_app/app/app.router.dart';
import 'package:mobile_app/services/privy_service.dart';
import 'package:privy_flutter/privy_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class EmailViewModel extends BaseViewModel {
  final _privyService = locator<PrivyService>();
  final _navigationService = locator<NavigationService>();

  String email = '';
  String verificationCode = '';
  bool codeSent = false;
  bool _isLocalLoading = false;

  // Reactive getters that will rebuild UI when service state changes
  bool get isLoading => _isLocalLoading || _privyService.isLoading;
  String? get errorMessage => _privyService.errorMessage;

  @override
  List<ListenableServiceMixin> get listenableServices => [_privyService];


  void updateEmail(String value) {
    email = value.trim();
    notifyListeners();
  }

  void updateVerificationCode(String value) {
    verificationCode = value.trim();
    notifyListeners();
  }

  Future<void> sendVerificationCode() async {
    print('sendVerificationCode called with email: "$email"');
    
    if (email.isEmpty) {
      print('Email is empty, showing error message');
      _showMessage('Please enter your email', isError: true);
      return;
    }

    // Set local loading state immediately for UI feedback
    _isLocalLoading = true;
    notifyListeners();
    print('Local loading state set to true');

    try {
      print('Calling _privyService.sendEmailCode with email: $email');
      final success = await _privyService.sendEmailCode(email);
      print('_privyService.sendEmailCode returned: $success');
      
      if (success) {
        codeSent = true;
        print('Code sent successfully to $email');
        _showMessage('Verification code sent to $email');
        
        // Navigate to verification page
        print('Navigating to verification page');
        _navigationService.navigateToVerificationView(email: email);
      } else {
        print('Failed to send code. Error: ${_privyService.errorMessage}');
        _showMessage(_privyService.errorMessage ?? 'Failed to send code', isError: true);
      }
    } finally {
      // Always reset local loading state
      _isLocalLoading = false;
      notifyListeners();
      print('Local loading state set to false');
    }
  }

  Future<void> verifyAndLogin() async {
    if (verificationCode.isEmpty) {
      _showMessage('Please enter the verification code', isError: true);
      return;
    }

    final success = await _privyService.loginWithEmailCode(email, verificationCode);
    if (success) {
      _showMessage('Authentication successful!');
      _navigationService.navigateToDashboardView();
    } else {
      _showMessage(_privyService.errorMessage ?? 'Login failed', isError: true);
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    // You can inject SnackbarService or use your preferred notification method
    // For now, this is a placeholder - implement based on your notification strategy
  }
}
