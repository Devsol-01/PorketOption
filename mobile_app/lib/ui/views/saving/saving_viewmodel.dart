import 'package:mobile_app/ui/views/goal_save/goal_save_view.dart';
import 'package:mobile_app/ui/views/lock_save/lock_save_view.dart';
import 'package:mobile_app/ui/views/group_save/group_save_view.dart';
import 'package:mobile_app/ui/views/porket_save/porket_save_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SavingViewModel extends BaseViewModel {
  final NavigationService _navigationService = NavigationService();

  void navigateToPorketSave() {
    _navigationService.navigateToView(const PorketSaveView());
  }

  void navigateToGoalSave() {
    _navigationService.navigateToView(const GoalSaveView());
  }

  void navigateToLockSave() {
    _navigationService.navigateToView(const LockSaveView());
  }

  void navigateToGroupSave() {
    _navigationService.navigateToView(const GroupSaveView());
  }
}
