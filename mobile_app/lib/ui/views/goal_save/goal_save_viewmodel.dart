import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:mobile_app/services/contract_service.dart';
import 'package:mobile_app/services/wallet_service.dart';
import 'package:mobile_app/app/app.locator.dart';
import 'package:mobile_app/app/app.router.dart';

class GoalSaveViewModel extends BaseViewModel {
  // Services
  final ContractService _contractService = locator<ContractService>();
  final WalletService _walletService = locator<WalletService>();
  final NavigationService _navigationService = locator<NavigationService>();

  // State properties
  bool _isBalanceVisible = true;
  double _goalSaveBalance = 0.0;
  List<Map<String, dynamic>> _liveGoals = [];
  List<Map<String, dynamic>> _completedGoals = [];
  bool _isLiveSelected = true;

  // Getters
  bool get isBalanceVisible => _isBalanceVisible;
  double get goalSaveBalance => _goalSaveBalance;
  List<Map<String, dynamic>> get liveGoals => _liveGoals;
  List<Map<String, dynamic>> get completedGoals => _completedGoals;
  bool get isLiveSelected => _isLiveSelected;

  List<Map<String, dynamic>> get currentGoals =>
      _isLiveSelected ? _liveGoals : _completedGoals;

  GoalSaveViewModel();

  // Navigate to Create Goal page
  void navigateToCreateGoal() async {
    await _navigationService.navigateToCreateGoalView();
    // Refresh goals when returning from create goal page
    await initialize();
  }

  @override
  void dispose() {
    // Dispose any controllers or listeners here if any
    super.dispose();
  }

  // Navigate to Goal Detail page
  void navigateToGoalDetail(Map<String, dynamic> goal) {
    _navigationService.navigateToGoalSaveDetailsView(goal: goal);
  }

  Future<void> initialize() async {
    await loadGoalSaveBalance();
    //await loadUserGoals();
  }

  void toggleBalanceVisibility() {
    _isBalanceVisible = !_isBalanceVisible;
    notifyListeners();
  }

  void setLiveSelected(bool value) {
    _isLiveSelected = value;
    notifyListeners();
  }

  // Load goal save balance from contract
  Future<void> loadGoalSaveBalance() async {
    try {
      final goals = await _contractService.getUserGoalSaves();
      _goalSaveBalance = goals.fold(0.0, (sum, goal) {
        final currentAmount = goal['current_amount'] as BigInt?;
        if (currentAmount != null) {
          return sum +
              (currentAmount.toDouble() / 1000000.0); // Convert from USDC units
        }
        return sum;
      });
      notifyListeners();
    } catch (e) {
      print('Error loading goal save balance: $e');
      _goalSaveBalance = 0.0;
    }
  }

  // Load user goals from contract
  // Future<void> loadUserGoals() async {
  //   try {
  //     final goals = await _contractService.getUserGoalSaves();

  //     // Convert contract data to UI format
  //     final formattedGoals = goals.map((goal) {
  //       final targetAmount =
  //           (goal['target_amount'] as BigInt).toDouble() / 1000000.0;
  //       final currentAmount =
  //           (goal['current_amount'] as BigInt).toDouble() / 1000000.0;
  //       final contributionAmount =
  //           (goal['contribution_amount'] as BigInt).toDouble() / 1000000.0;
  //       final startTime = DateTime.fromMillisecondsSinceEpoch(
  //           (goal['start_time'] as int) * 1000);
  //       final endTime = DateTime.fromMillisecondsSinceEpoch(
  //           (goal['end_time'] as int) * 1000);
  //       final isCompleted = goal['is_completed'] as bool;

  //       return {
  //         'id': goal['id'].toString(),
  //         'title': goal['title'] as String,
  //         'category': goal['category'] as String,
  //         'targetAmount': targetAmount,
  //         'currentAmount': currentAmount,
  //         'contributionAmount': contributionAmount,
  //         'contributionType':
  //             _getContributionTypeString(goal['contribution_type'] as int),
  //         'startDate': startTime,
  //         'endDate': endTime,
  //         'progress':
  //             targetAmount > 0 ? (currentAmount / targetAmount) * 100 : 0.0,
  //         'isCompleted': isCompleted,
  //         'status': isCompleted ? 'completed' : 'active',
  //       };
  //     }).toList();

  //     _liveGoals =
  //         formattedGoals.where((goal) => goal['status'] == 'active').toList();
  //     _completedGoals = formattedGoals
  //         .where((goal) => goal['status'] == 'completed')
  //         .toList();
  //     notifyListeners();
  //   } catch (e) {
  //     print('Error loading user goals: $e');
  //     _liveGoals = [];
  //     _completedGoals = [];
  //   }
  // }

  // Helper method to convert contribution type to string
  String _getContributionTypeString(int type) {
    switch (type) {
      case 1:
        return 'Daily';
      case 2:
        return 'Weekly';
      case 3:
        return 'Monthly';
      case 4:
        return 'Manual';
      default:
        return 'Manual';
    }
  }

  // Create a new goal using contract service
  Future<void> createGoal({
    required String purpose,
    required String category,
    required double targetAmount,
    required String frequency,
    required double contributionAmount,
    required DateTime startDate,
    required DateTime endDate,
    required String fundSource,
  }) async {
    setBusy(true);
    try {
      final contributionTypeMap = {
        'Daily': 1,
        'Weekly': 2,
        'Monthly': 3,
        'Manual': 4,
      };

      final contributionType = contributionTypeMap[frequency] ?? 4;

      final txHash = await _contractService.createGoalSave(
        title: purpose,
        category: category,
        targetAmount: targetAmount,
        contributionType: contributionType,
        contributionAmount: contributionAmount,
        endDate: endDate,
      );

      print('Goal created successfully with TX: $txHash');
      // Refresh data
      await loadGoalSaveBalance();
     // await loadUserGoals();
    } catch (e) {
      print('Error creating goal: $e');
      throw e; // Re-throw to let caller handle
    } finally {
      setBusy(false);
    }
  }

  // Add contribution to goal
  Future<void> addContribution(String goalId, double amount) async {
    setBusy(true);
    try {
      final goalIdBigInt = BigInt.parse(goalId);
      final txHash = await _contractService.contributeGoalSave(
        goalId: goalIdBigInt,
        amount: amount,
      );

      print('Contribution successful: $txHash');
      // Refresh data
      await loadGoalSaveBalance();
      //await loadUserGoals();
    } catch (e) {
      print('Error adding contribution: $e');
      throw e; // Re-throw to let caller handle
    } finally {
      setBusy(false);
    }
  }

  // Withdraw from goal
  // Future<void> withdrawFromGoal(String goalId, double amount) async {
  //   setBusy(true);
  //   try {
  //     final txHash = await _contractService.withdrawGoalSave(
  //       goalId: goalId,
  //       amount: amount,
  //     );

  //     print('Withdrawal successful: $txHash');
  //     // Refresh data
  //     await loadGoalSaveBalance();
  //     await loadUserGoals();
  //   } catch (e) {
  //     print('Error withdrawing from goal: $e');
  //   } finally {
  //     setBusy(false);
  //   }
  // }

  // Claim completed goal
  Future<void> claimCompletedGoal(String goalId) async {
    setBusy(true);
    try {
      // TODO: Implement contract integration
      // await _contractService.contributeGoalSave(goalId: goalId, amount: 0.0);
      await Future.delayed(Duration(milliseconds: 500)); // Mock delay
      print('Goal claimed successfully: $goalId');
      // Refresh data
      await loadGoalSaveBalance();
      //await loadUserGoals();
    } catch (e) {
      print('Error claiming goal: $e');
    } finally {
      setBusy(false);
    }
  }
}
