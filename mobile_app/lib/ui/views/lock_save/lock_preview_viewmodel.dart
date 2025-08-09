import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class LockPreviewViewModel extends BaseViewModel {
  final NavigationService _navigationService = NavigationService();

  bool _isInterestUpfront = false;
  bool _agreedToTerms1 = false;
  bool _agreedToTerms2 = false;

  // Getters
  bool get isInterestUpfront => _isInterestUpfront;
  bool get agreedToTerms1 => _agreedToTerms1;
  bool get agreedToTerms2 => _agreedToTerms2;
  bool get canCreateLock => _agreedToTerms1 && _agreedToTerms2;

  void navigateBack() {
    _navigationService.back();
  }

  void setInterestUpfront(bool value) {
    _isInterestUpfront = value;
    notifyListeners();
  }

  void setAgreedToTerms1(bool value) {
    _agreedToTerms1 = value;
    notifyListeners();
  }

  void setAgreedToTerms2(bool value) {
    _agreedToTerms2 = value;
    notifyListeners();
  }

  void createSafeLock(Map<String, dynamic> lockData) {
    if (!canCreateLock) return;

    // Here we would create the actual safelock
    // For now, we'll just navigate back to the lock save page
    // and show a success message

    // Navigate back to Lock Save page
    _navigationService.clearStackAndShow('/lock-save');

    // TODO: Add the created lock to the Lock Save viewmodel
    // TODO: Show success message/dialog
  }
}
