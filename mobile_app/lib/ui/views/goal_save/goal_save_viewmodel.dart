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

  // Navigate to Goal Detail page
  void navigateToGoalDetail(Map<String, dynamic> goal) {
    _navigationService.navigateToGoalSaveDetailsView(goal: goal);
  }

  Future<void> initialize() async {
    await loadGoalSaveBalance();
    await loadUserGoals();
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
      // TODO: Implement contract integration
      // final goals = await _contractService.getUserGoals();
      // _goalSaveBalance = goals.fold(0.0, (sum, goal) => sum + (goal['currentAmount'] ?? 0.0));
      _goalSaveBalance = 0.0; // Mock data
      notifyListeners();
    } catch (e) {
      print('Error loading goal save balance: $e');
      _goalSaveBalance = 0.0;
    }
  }

  // Load user goals from contract
  Future<void> loadUserGoals() async {
    try {
      // TODO: Implement contract integration
      // final goals = await _contractService.getUserGoals();
      // _liveGoals = goals.where((goal) => goal['status'] == 'active').toList();
      // _completedGoals = goals.where((goal) => goal['status'] == 'completed').toList();
      _liveGoals = []; // Mock data
      _completedGoals = []; // Mock data
      notifyListeners();
    } catch (e) {
      print('Error loading user goals: $e');
      _liveGoals = [];
      _completedGoals = [];
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
      // TODO: Implement contract integration
      // final goalId = await _contractService.createGoalSave(
      //   title: purpose,
      //   category: category,
      //   targetAmount: targetAmount,
      //   contributionAmount: contributionAmount,
      //   frequency: frequency,
      //   endTime: endDate,
      // );
      final goalId = 'mock_goal_${DateTime.now().millisecondsSinceEpoch}';

      print('Goal created successfully with ID: $goalId');
      // Refresh data
      await loadGoalSaveBalance();
      await loadUserGoals();
    } catch (e) {
      print('Error creating goal: $e');
    } finally {
      setBusy(false);
    }
  }

  // Add contribution to goal
  Future<void> addContribution(String goalId, double amount) async {
    setBusy(true);
    try {
      // TODO: Implement contract integration
      // final txHash = await _contractService.contributeGoalSave(
      //   goalId: goalId,
      //   amount: amount,
      // );
      final txHash = 'mock_tx_${DateTime.now().millisecondsSinceEpoch}';

      print('Contribution successful: $txHash');
      // Refresh data
      await loadGoalSaveBalance();
      await loadUserGoals();
    } catch (e) {
      print('Error adding contribution: $e');
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
      await loadUserGoals();
    } catch (e) {
      print('Error claiming goal: $e');
    } finally {
      setBusy(false);
    }
  }
}
