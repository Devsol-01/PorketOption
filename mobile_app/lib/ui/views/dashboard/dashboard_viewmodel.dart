import 'package:mobile_app/app/app.bottomsheets.dart';
import 'package:mobile_app/app/app.locator.dart';
import 'package:mobile_app/ui/views/bottom_nav/bottom_nav_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class DashboardViewModel extends BaseViewModel {
  final _bottomSheetService = locator<BottomSheetService>();

  void navigateToSavings() {
    // Switch to the Savings tab (index 1) to show the Savings View
    final bottomNavViewModel = locator<BottomNavViewModel>();
    bottomNavViewModel.setIndex(2);
  }

  void showDepositSheet() {
    _bottomSheetService.showCustomSheet(
        variant: BottomSheetType.depositSheet, barrierDismissible: false);
  }

}
