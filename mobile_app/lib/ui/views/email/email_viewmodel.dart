import 'package:mobile_app/app/app.locator.dart';
import 'package:mobile_app/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class EmailViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  void navigate() {
    _navigationService
        .navigateToEmailView(); 
  }
}
