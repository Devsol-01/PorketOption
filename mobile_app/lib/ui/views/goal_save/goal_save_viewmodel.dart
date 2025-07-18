import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class GoalSaveViewModel extends BaseViewModel {
  // State properties
  bool _isOngoingSelected = true;
  final NavigationService _navigationService = NavigationService();

  // Getters for state properties
  bool get isOngoingSelected => _isOngoingSelected;

  void setOngoingSelected(bool value) {
    _isOngoingSelected = value;
    notifyListeners(); // Notify UI to rebuild
  }

  void navigateBack() {
    _navigationService.back();
  }
}
