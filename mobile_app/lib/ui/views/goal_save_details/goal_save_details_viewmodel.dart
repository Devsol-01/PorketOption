import 'package:mobile_app/app/app.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class GoalSaveDetailsViewModel extends BaseViewModel {
    final NavigationService _navigationService = locator<NavigationService>();

  void navigateBack() {
    _navigationService.back();
  }

  void showTopUpDialog() {
    // TODO: Implement top up dialog
    print('Show top up dialog');
  }

  void navigateToHistory() {
    // TODO: Navigate to history page
    print('Navigate to history');
  }

  void navigateToLock() {
    // TODO: Navigate to lock page
    print('Navigate to lock');
  }

  void navigateToSettings() {
    // TODO: Navigate to settings page
    print('Navigate to settings');
  }

  void navigateToPayment() {
    // TODO: Navigate to payment page
    print('Navigate to payment');
  }

  void navigateToBreak() {
    // TODO: Navigate to break page or show break dialog
    print('Navigate to break');
  }

  void navigateToUpdatePayment() {
    // TODO: Navigate to update payment page
    print('Navigate to update payment');
  }
}
