import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';

class VerificationViewModel extends BaseViewModel {
  final String email;

  VerificationViewModel(this.email); 

  final List<TextEditingController> controllers =
      List.generate(6, (_) => TextEditingController());

  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  Timer? _timer;
  int _remainingTime = 59;
  int get remainingTime => _remainingTime;

  bool get isCodeComplete =>
      controllers.every((controller) => controller.text.isNotEmpty);

  void init() {
    _startTimer();
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

  void resendCode() {
    print('Resending code to $email');
    _startTimer();
  }

  String getVerificationCode() {
    return controllers.map((c) => c.text).join();
  }

  void verifyCode() {
    String code = getVerificationCode();
    print("Verifying code: $code");
    // Handle code verification logic here
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
