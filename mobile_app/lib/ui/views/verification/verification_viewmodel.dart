import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:mobile_app/app/app.locator.dart';
import 'package:mobile_app/app/app.router.dart';
import 'package:mobile_app/services/privy_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class VerificationViewModel extends BaseViewModel {
  final _privyService = locator<PrivyService>();
  final _navigationService = locator<NavigationService>();

  final List<TextEditingController> controllers =
      List.generate(6, (_) => TextEditingController());

  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  Timer? _timer;
  int _remainingTime = 59;
  int get remainingTime => _remainingTime;
  
  String _email = '';
  bool _isLocalLoading = false;
  
  // Getters
  bool get isCodeComplete =>
      controllers.every((controller) => controller.text.isNotEmpty);
  bool get isLoading => _isLocalLoading || _privyService.isLoading;
  String? get errorMessage => _privyService.errorMessage;
  
  // Reactive services
  @override
  List<ListenableServiceMixin> get listenableServices => [_privyService];

  void init() {
    _startTimer();
  }
  
  void setEmail(String email) {
    _email = email;
    print('Email set in VerificationViewModel: $_email');
  }

  void _startTimer() {
    _timer?.cancel();
    _remainingTime = 59;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        _remainingTime--;
        notifyListeners();
      } else {
        timer.cancel();
        notifyListeners();
      }
    });
  }

  void onDigitChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      focusNodes[index + 1].requestFocus();
    }
    notifyListeners();
  }

  void onDigitBackspace(int index) {
    if (index > 0) {
      controllers[index - 1].clear();
      focusNodes[index - 1].requestFocus();
      notifyListeners();
    }
  }

  Future<void> resendCode() async {
    print('Resending code to $_email');
    
    if (_email.isEmpty) {
      print('Email is empty, cannot resend code');
      return;
    }
    
    _isLocalLoading = true;
    notifyListeners();
    
    try {
      final success = await _privyService.sendEmailCode(_email);
      if (success) {
        print('Code resent successfully to $_email');
        _startTimer(); // Restart the timer
      } else {
        print('Failed to resend code. Error: ${_privyService.errorMessage}');
      }
    } finally {
      _isLocalLoading = false;
      notifyListeners();
    }
  }

  String getVerificationCode() {
    return controllers.map((c) => c.text).join();
  }


  Future<void> verifyCode() async {
    String code = getVerificationCode();
    print("Verifying code: $code with email: $_email");
    
    if (code.length != 6) {
      print('Code must be 6 digits');
      return;
    }
    
    if (_email.isEmpty) {
      print('Email is empty, cannot verify code');
      return;
    }
    
    _isLocalLoading = true;
    notifyListeners();
    
    try {
      final success = await _privyService.loginWithEmailCode(_email, code);
      if (success) {
        print('Verification successful! Creating Solana wallet...');
        
        // Create Solana wallet for the user
        final wallet = await _privyService.createSolanaWallet();
        if (wallet != null) {
          print('Solana wallet created successfully!');
          print('Wallet address: ${wallet.toString()}');
        } else {
          print('Failed to create Solana wallet, but continuing to dashboard');
        }
        
        print('Navigating to dashboard');
        _navigationService.navigateToBottomNavView();
      } else {
        print('Verification failed. Error: ${_privyService.errorMessage}');
        // You can add error handling here, like showing a snackbar
      }
    } finally {
      _isLocalLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }
}
