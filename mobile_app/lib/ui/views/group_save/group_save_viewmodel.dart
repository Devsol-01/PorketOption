import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:mobile_app/app/app.bottomsheets.dart';
import 'package:mobile_app/app/app.locator.dart';
import 'package:mobile_app/app/app.router.dart';
import 'package:mobile_app/services/contract_service.dart';
import 'package:mobile_app/ui/views/group_save_details/group_save_details_view.dart';

class GroupSaveViewModel extends BaseViewModel {
  // Services
  final ContractService _contractService = locator<ContractService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final _bottomSheetService = locator<BottomSheetService>();

  // State properties
  bool _isOngoingSelected = true;
  bool _isBalanceVisible = true;
  double _groupSaveBalance = 0.0;
  List<Map<String, dynamic>> _liveGroups = [];
  List<Map<String, dynamic>> _completedGroups = [];
  List<Map<String, dynamic>> _publicGroups = [];
  List<Map<String, dynamic>> _legacyLiveGroups = [];
  List<Map<String, dynamic>> _legacyCompletedGroups = [];

  // Getters for state properties
  bool get isOngoingSelected => _isOngoingSelected;
  bool get isBalanceVisible => _isBalanceVisible;
  double get groupSaveBalance => _groupSaveBalance;
  List<Map<String, dynamic>> get liveGroups => _liveGroups;
  List<Map<String, dynamic>> get completedGroups => _completedGroups;
  List<Map<String, dynamic>> get publicGroups => _publicGroups;

  // Legacy getters for UI compatibility
  List<Map<String, dynamic>> get legacyLiveGroups => _legacyLiveGroups;
  List<Map<String, dynamic>> get legacyCompletedGroups =>
      _legacyCompletedGroups;

  List<dynamic> get currentGroups =>
      _isOngoingSelected ? _liveGroups : _completedGroups;

  GroupSaveViewModel() {
    initialize();
  }

  Future<void> initialize() async {
    await loadGroupSaveBalance();
    await loadUserGroups();
    await loadPublicGroups();
    // Keep sample data for UI testing
    _initializeSampleData();
  }

  void toggleBalanceVisibility() {
    _isBalanceVisible = !_isBalanceVisible;
    notifyListeners();
  }

  // Load group save balance from contract
  Future<void> loadGroupSaveBalance() async {
    try {
      // For now, use a mock balance - in real implementation this would come from contract
      _groupSaveBalance = 120.50; // Mock balance for UI testing
      notifyListeners();
    } catch (e) {
      print('Error loading group save balance: $e');
      _groupSaveBalance = 0.0;
    }
  }

  // Load user groups from contract
  Future<void> loadUserGroups() async {
    try {
      final groups = await _contractService.getUserGroups();
      _liveGroups =
          groups.where((group) => group['isCompleted'] != true).toList();
      _completedGroups =
          groups.where((group) => group['isCompleted'] == true).toList();
      notifyListeners();
    } catch (e) {
      print('Error loading user groups: $e');
      _liveGroups = [];
      _completedGroups = [];
    }
  }

  // Load public groups from contract
  Future<void> loadPublicGroups() async {
    try {
      final groups = await _contractService.getPublicGroups();
      _publicGroups = groups;
      notifyListeners();
    } catch (e) {
      print('Error loading public groups: $e');
      _publicGroups = [];
    }
  }

  void _initializeSampleData() {
    // All sample data removed - using real contract data only
    // Data loaded from contract in respective load functions
    _legacyLiveGroups = [];
    _legacyCompletedGroups = [];
  }

  void setOngoingSelected(bool value) {
    _isOngoingSelected = value;
    notifyListeners(); // Notify UI to rebuild
  }

  void setLiveSelected(bool value) {
    _isOngoingSelected = value;
    notifyListeners();
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
          await _navigationService.navigateToCreatePublicGroupSaveView();
          // Refresh groups when returning from create group page
          await initialize();
        } else if (data == 'private') {
          print('Navigating to private group save form...');
          await _navigationService.navigateToCreatePrivateGroupSaveView();
          // Refresh groups when returning from create group page
          await initialize();
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

  // Join a group using contract service
  Future<void> joinSavingsGroup(String groupId, {String? groupCode}) async {
    setBusy(true);
    try {
      final txHash = await _contractService.joinGroupSave(
        groupId: groupId,
      );

      print('Successfully joined group: $txHash');
      // Refresh data
      await loadGroupSaveBalance();
      await loadUserGroups();
    } catch (e) {
      print('Error joining group: $e');
    } finally {
      setBusy(false);
    }
  }

  // Create a new group using contract service
  Future<void> createGroup({
    required String name,
    required String description,
    required String category,
    required double targetAmount,
    required String frequency,
    required double contributionAmount,
    required DateTime startDate,
    required DateTime endDate,
    required bool isPublic,
    String? groupCode,
  }) async {
    setBusy(true);
    try {
      final groupId = await _contractService.createGroupSave(
        title: name,
        description: description,
        category: category,
        targetAmount: targetAmount,
        contributionType: frequency,
        contributionAmount: contributionAmount,
        isPublic: isPublic,
        endTime: endDate,
      );

      print('Group created successfully with ID: $groupId');
      // Refresh data
      await loadGroupSaveBalance();
      await loadUserGroups();
      if (isPublic) {
        await loadPublicGroups();
      }
    } catch (e) {
      print('Error creating group: $e');
    } finally {
      setBusy(false);
    }
  }

  // Contribute to a group
  Future<void> contributeToGroup(String groupId, double amount) async {
    setBusy(true);
    try {
      final txHash = await _contractService.contributeGroupSave(
        groupId: groupId,
        amount: amount,
      );

      print('Contribution successful: $txHash');
      // Refresh data
      await loadGroupSaveBalance();
      await loadUserGroups();
    } catch (e) {
      print('Error contributing to group: $e');
    } finally {
      setBusy(false);
    }
  }

  // Leave a group
  // Future<void> leaveGroup(String groupId) async {
  //   setBusy(true);
  //   try {
  //     final txHash = await _contractService.leaveGroupSave(groupId: groupId);

  //     print('Successfully left group: $txHash');
  //     // Refresh data
  //     await loadGroupSaveBalance();
  //     await loadUserGroups();
  //   } catch (e) {
  //     print('Error leaving group: $e');
  //   } finally {
  //     setBusy(false);
  //   }
  // }

  void navigateToCreateGroup() async {
    await createGroupSave();
    // Refresh groups when returning from create group page
    await initialize();
  }

  void navigateToGroupDetail(Map<String, dynamic> group) {
    _navigationService.navigateToView(
      GroupSaveDetailsView(group: group),
    );
  }
}
