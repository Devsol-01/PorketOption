import 'package:stacked/stacked.dart';
import 'package:mobile_app/services/contract_service.dart';
import 'package:mobile_app/services/wallet_service.dart';
import 'package:mobile_app/app/app.locator.dart';

class GoalSaveViewModel extends BaseViewModel {
  // Services
  final ContractService _contractService = locator<ContractService>();
  final WalletService _walletService = locator<WalletService>();
  
  // State properties
  bool _isBalanceVisible = true;
  double _goalSaveBalance = 0.0;
  List<GoalSaveData> _liveGoals = [];
  List<GoalSaveData> _completedGoals = [];
  bool _isLiveSelected = true;
  
  // Getters
  bool get isBalanceVisible => _isBalanceVisible;
  double get goalSaveBalance => _goalSaveBalance;
  List<GoalSaveData> get liveGoals => _liveGoals;
  List<GoalSaveData> get completedGoals => _completedGoals;
  bool get isLiveSelected => _isLiveSelected;
  
  List<GoalSaveData> get currentGoals => _isLiveSelected ? _liveGoals : _completedGoals;
  
  GoalSaveViewModel() {
    initialize();
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
      final totalBalance = await _contractService.getUserTotalBalance();
      // For now, assume goal save is part of total balance
      _goalSaveBalance = totalBalance * 0.25; // Placeholder calculation
      notifyListeners();
    } catch (e) {
      print('Error loading goal save balance: $e');
      _goalSaveBalance = 0.0;
    }
  }
  
  // Load user goals from contract
  Future<void> loadUserGoals() async {
    try {
      final goals = await _contractService.getUserGoals();
      _liveGoals = goals.where((goal) => !goal.isCompleted).toList();
      _completedGoals = goals.where((goal) => goal.isCompleted).toList();
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
      final goalId = await _contractService.createGoalSave(
        purpose: purpose,
        category: category,
        targetAmount: targetAmount,
        frequency: frequency,
        contributionAmount: contributionAmount,
        startDate: startDate,
        endDate: endDate,
        fundSource: fundSource,
      );
      
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
      final txHash = await _contractService.contributeGoalSave(
        goalId: goalId,
        amount: amount,
      );
      
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
  Future<void> withdrawFromGoal(String goalId, double amount) async {
    setBusy(true);
    try {
      final txHash = await _contractService.withdrawGoalSave(
        goalId: goalId,
        amount: amount,
      );
      
      print('Withdrawal successful: $txHash');
      // Refresh data
      await loadGoalSaveBalance();
      await loadUserGoals();
    } catch (e) {
      print('Error withdrawing from goal: $e');
    } finally {
      setBusy(false);
    }
  }
  
  // Claim completed goal
  Future<void> claimCompletedGoal(String goalId) async {
    setBusy(true);
    try {
      final txHash = await _contractService.claimCompletedGoal(goalId: goalId);
      
      print('Goal claimed successfully: $txHash');
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
