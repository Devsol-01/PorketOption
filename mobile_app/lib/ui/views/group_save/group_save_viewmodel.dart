import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:mobile_app/app/app.bottomsheets.dart';
import 'package:mobile_app/app/app.locator.dart';
import 'package:mobile_app/app/app.router.dart';
import 'package:mobile_app/services/contract_service.dart';
import 'package:mobile_app/services/wallet_service.dart';

class GroupSaveViewModel extends BaseViewModel {
  // Services
  final ContractService _contractService = locator<ContractService>();
  final WalletService _walletService = locator<WalletService>();
  final NavigationService _navigationService = NavigationService();
  final _bottomSheetService = locator<BottomSheetService>();

  // State properties
  bool _isOngoingSelected = true;
  bool _isBalanceVisible = true;
  double _groupSaveBalance = 0.0;
  List<GroupSaveData> _liveGroups = [];
  List<GroupSaveData> _completedGroups = [];
  List<GroupSaveData> _publicGroups = [];
  List<Map<String, dynamic>> _legacyLiveGroups = [];
  List<Map<String, dynamic>> _legacyCompletedGroups = [];

  // Getters for state properties
  bool get isOngoingSelected => _isOngoingSelected;
  bool get isBalanceVisible => _isBalanceVisible;
  double get groupSaveBalance => _groupSaveBalance;
  List<GroupSaveData> get liveGroups => _liveGroups;
  List<GroupSaveData> get completedGroups => _completedGroups;
  List<GroupSaveData> get publicGroups => _publicGroups;
  
  // Legacy getters for UI compatibility
  List<Map<String, dynamic>> get legacyLiveGroups => _legacyLiveGroups;
  List<Map<String, dynamic>> get legacyCompletedGroups => _legacyCompletedGroups;
  
  List<dynamic> get currentGroups => _isOngoingSelected ? _liveGroups : _completedGroups;

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
      final totalBalance = await _contractService.getUserTotalBalance();
      // For now, assume group save is part of total balance
      _groupSaveBalance = totalBalance * 0.2; // Placeholder calculation
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
      _liveGroups = groups.where((group) => !group.isCompleted).toList();
      _completedGroups = groups.where((group) => group.isCompleted).toList();
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
      _publicGroups = await _contractService.getPublicGroups(limit: 20);
      notifyListeners();
    } catch (e) {
      print('Error loading public groups: $e');
      _publicGroups = [];
    }
  }
  
  void _initializeSampleData() {
    if (_groupSaveBalance == 0.0) {
      _groupSaveBalance = 1500.0;
    }
    
    // Sample live groups
    _legacyLiveGroups = [
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
    _legacyCompletedGroups = [
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

  // Join a group using contract service
  Future<void> joinSavingsGroup(String groupId, {String? groupCode}) async {
    setBusy(true);
    try {
      final txHash = await _contractService.joinGroupSave(
        groupId: groupId,
        groupCode: groupCode,
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
        name: name,
        description: description,
        category: category,
        targetAmount: targetAmount,
        frequency: frequency,
        contributionAmount: contributionAmount,
        startDate: startDate,
        endDate: endDate,
        isPublic: isPublic,
        groupCode: groupCode,
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
  Future<void> leaveGroup(String groupId) async {
    setBusy(true);
    try {
      final txHash = await _contractService.leaveGroupSave(groupId: groupId);
      
      print('Successfully left group: $txHash');
      // Refresh data
      await loadGroupSaveBalance();
      await loadUserGroups();
    } catch (e) {
      print('Error leaving group: $e');
    } finally {
      setBusy(false);
    }
  }

  void navigateToCreateGroup() {
    createGroupSave();
  }

  void navigateToGroupDetail(Map<String, dynamic> group) {
//    _navigationService.navigateToGroupSaveDetailView(group: group);
  }
}
