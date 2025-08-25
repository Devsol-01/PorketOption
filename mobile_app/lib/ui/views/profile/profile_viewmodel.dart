import 'package:mobile_app/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:mobile_app/services/firebase_auth_service.dart';
import 'package:mobile_app/app/app.locator.dart';

class ProfileViewModel extends BaseViewModel {
  final NavigationService _navigationService = NavigationService();
  final FirebaseAuthService _authService = locator<FirebaseAuthService>();

  void navigateToBadges() {
    _navigationService.navigateToBadgesView();
  }

  void logout() async {
    await _authService.logout();
    _navigationService.clearStackAndShow(Routes.loginView);
  }
}
