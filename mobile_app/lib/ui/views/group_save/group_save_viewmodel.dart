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

  // Getters for state properties
  bool get isOngoingSelected => _isOngoingSelected;
  bool get isBalanceVisible => _isBalanceVisible;
  double get groupSaveBalance => _groupSaveBalance;
  List<Map<String, dynamic>> get liveGroups => _liveGroups;
  List<Map<String, dynamic>> get completedGroups => _completedGroups;
  List<Map<String, dynamic>> get publicGroups => _publicGroups;

  // Real data getters - no legacy mock data

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
      // Get the group save rate (in percentage)
      final rate = await _contractService.getGroupSaveRate();
      // For now, we'll use the rate as a placeholder for balance
      // In a real implementation, you'd calculate based on user's group contributions
      _groupSaveBalance = rate; // This is just a placeholder
      notifyListeners();
    } catch (e) {
      print('Error loading group save balance: $e');
      _groupSaveBalance = 0.0;
    }
  }

  // Load user groups from contract
  Future<void> loadUserGroups() async {
    try {
      // TODO: Implement contract integration
      // final groups = await _contractService.getUserGroups();
      // _liveGroups = groups.where((group) => group['isCompleted'] != true).toList();
      // _completedGroups = groups.where((group) => group['isCompleted'] == true).toList();
      _liveGroups = []; // Mock data
      _completedGroups = []; // Mock data
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
      // TODO: Implement contract integration
      // final groups = await _contractService.getPublicGroups();
      _publicGroups = []; // Mock data
      notifyListeners();
    } catch (e) {
      print('Error loading public groups: $e');
      _publicGroups = [];
    }
  }

  void _initializeSampleData() {
    // All sample data removed - using real contract data only
    // Data loaded from contract in respective load functions
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
      // Convert string groupId to BigInt
      final groupIdBigInt = BigInt.parse(groupId);
      final txHash =
          await _contractService.joinGroupSave(groupId: groupIdBigInt);

      print('Successfully joined group: $txHash');
      // Refresh data
      await loadGroupSaveBalance();
      await loadUserGroups();
    } catch (e) {
      print('Error joining group: $e');
      rethrow; // Re-throw to let UI handle the error
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
      // TODO: Implement contract integration
      // final groupId = await _contractService.createGroupSave(
      //   title: name,
      //   description: description,
      //   category: category,
      //   targetAmount: targetAmount,
      //   frequency: frequency,
      //   contributionAmount: contributionAmount,
      //   isPublic: isPublic,
      // );
      final groupId = 'mock_group_${DateTime.now().millisecondsSinceEpoch}';

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
      // Convert string groupId to BigInt
      final groupIdBigInt = BigInt.parse(groupId);
      final txHash = await _contractService.contributeToGroupSave(
        groupId: groupIdBigInt,
        amount: amount,
      );

      print('Contribution successful: $txHash');
      // Refresh data
      await loadGroupSaveBalance();
      await loadUserGroups();
    } catch (e) {
      print('Error contributing to group: $e');
      rethrow; // Re-throw to let UI handle the error
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

  // Get group save details
  Future<Map<String, dynamic>> getGroupSaveDetails(String groupId) async {
    try {
      final groupIdBigInt = BigInt.parse(groupId);
      final groupDetails =
          await _contractService.getGroupSave(groupId: groupIdBigInt);
      return groupDetails;
    } catch (e) {
      print('Error getting group save details: $e');
      rethrow;
    }
  }

  void navigateToGroupDetail(Map<String, dynamic> group) {
    _navigationService.navigateToGroupSaveDetailsView(group: group);
  }

  @override
  void dispose() {
    // Dispose any controllers or listeners here if any
    super.dispose();
  }
}
