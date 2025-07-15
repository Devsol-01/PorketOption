import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class GroupSaveViewModel extends BaseViewModel {
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

  void createGroupSave() {
    // TODO: Implement create group save logic
    print('Create group save tapped');
  }

  void findMoreGroups() {
    // TODO: Implement find more groups logic
    print('Find more groups tapped');
  }

  void joinSavingsGroup(String groupId) {
    // TODO: Implement join savings group logic
    print('Join savings group: $groupId');
  }
}
