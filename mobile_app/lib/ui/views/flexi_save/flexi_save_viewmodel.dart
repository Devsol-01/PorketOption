import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class FlexiSaveViewModel extends BaseViewModel {
  // State properties
  bool _isAutoSaveEnabled = true;
  bool _isOngoingSelected = true;
  final NavigationService _navigationService = NavigationService();

  // Getters for state properties
  bool get isAutoSaveEnabled => _isAutoSaveEnabled;
  bool get isOngoingSelected => _isOngoingSelected;

  // Methods to update state
  void toggleAutoSave(bool value) {
    _isAutoSaveEnabled = value;
    notifyListeners(); // Notify UI to rebuild
  }

  void setOngoingSelected(bool value) {
    _isOngoingSelected = value;
    notifyListeners(); // Notify UI to rebuild
  }

  void navigateBack(){
    _navigationService.back();
  }
}
