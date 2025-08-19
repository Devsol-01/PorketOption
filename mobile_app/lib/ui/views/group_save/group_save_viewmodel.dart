import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:mobile_app/app/app.bottomsheets.dart';
import 'package:mobile_app/app/app.locator.dart';
import 'package:mobile_app/app/app.router.dart';

class GroupSaveViewModel extends BaseViewModel {
  // State properties
  bool _isOngoingSelected = true;
  final NavigationService _navigationService = NavigationService();
  final _bottomSheetService = locator<BottomSheetService>();

  List<Map<String, dynamic>> _liveGroups = [];
  List<Map<String, dynamic>> _completedGroups = [];

  // Getters for state properties
  bool get isOngoingSelected => _isOngoingSelected;
  List<Map<String, dynamic>> get liveGroups => _liveGroups;
  List<Map<String, dynamic>> get completedGroups => _completedGroups;

  GroupSaveViewModel() {
    _initializeSampleData();
  }

  void _initializeSampleData() {
    // Sample live groups
    _liveGroups = [
      {
        'id': '1',
        'name': 'Back to School 2025',
        'category': 'Education',
        'targetAmount': 250000.0,
        'currentAmount': 229200.0,
        'memberCount': 6515,
        'contributionAmount': 2976.0,
        'frequency': 'Daily',
        'startDate': DateTime.now().subtract(const Duration(days: 45)),
        'endDate': DateTime.now().add(const Duration(days: 31)),
        'isCompleted': false,
        'progress': 0.14,
      },
      {
        'id': '2',
        'name': 'Summer Vacation Fund',
        'category': 'Vacation',
        'targetAmount': 500000.0,
        'currentAmount': 125000.0,
        'memberCount': 1200,
        'contributionAmount': 1000.0,
        'frequency': 'Weekly',
        'startDate': DateTime.now().subtract(const Duration(days: 60)),
        'endDate': DateTime.now().add(const Duration(days: 90)),
        'isCompleted': false,
        'progress': 0.25,
      },
    ];

    // Sample completed groups
    _completedGroups = [
      {
        'id': '3',
        'name': 'Christmas Shopping 2024',
        'category': 'Events',
        'targetAmount': 100000.0,
        'currentAmount': 100000.0,
        'memberCount': 850,
        'contributionAmount': 500.0,
        'frequency': 'Weekly',
        'startDate': DateTime.now().subtract(const Duration(days: 150)),
        'endDate': DateTime.now().subtract(const Duration(days: 30)),
        'isCompleted': true,
        'progress': 1.0,
        'completedAt': DateTime.now().subtract(const Duration(days: 30)),
      },
    ];
  }

  void setOngoingSelected(bool value) {
    _isOngoingSelected = value;
    notifyListeners(); // Notify UI to rebuild
  }

  void navigateBack() {
    _navigationService.back();
  }

  Future<void> createGroupSave() async {
    print('Create group save button tapped!');

    try {
      // Show our custom group save selection bottom sheet
      print('Showing group save selection bottom sheet...');
      final response = await _bottomSheetService.showCustomSheet(
        variant: BottomSheetType.groupSaveSelection,
        title: 'Create Group Save',
      );
      print('Group save bottom sheet call completed');

      // Handle the response
      if (response?.confirmed == true) {
        final data = response?.data as String?;
        if (data == 'public') {
          print('Navigating to public group save form...');
          // Navigate to public group save form
          _navigationService.navigateToCreatePublicGroupSaveView();
        } else if (data == 'private') {
          print('Navigating to private group save form...');
          // Navigate to private group save form
          _navigationService.navigateToCreatePrivateGroupSaveView();
        }
      }
    } catch (e) {
      print('Error with group save bottom sheet: $e');
      // Fallback to simple dialog
      showDialog(
        context: StackedService.navigatorKey!.currentContext!,
        builder: (context) => AlertDialog(
          title: const Text('Group Save'),
          content:
              const Text('Group save bottom sheet failed, but button works!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void findMoreGroups() {
    // TODO: Implement find more groups logic
    print('Find more groups tapped');
  }

  void joinSavingsGroup(String groupId) {
    // TODO: Implement join savings group logic
    print('Join savings group: $groupId');
  }

  void navigateToCreateGroup() {
    createGroupSave();
  }

  void navigateToGroupDetail(Map<String, dynamic> group) {
//    _navigationService.navigateToGroupSaveDetailView(group: group);
  }
}
