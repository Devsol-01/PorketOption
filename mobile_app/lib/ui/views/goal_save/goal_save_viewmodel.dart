import 'package:mobile_app/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:mobile_app/app/app.locator.dart';

class GoalSaveViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();

  // State properties
  bool _isOngoingSelected = true;
  bool _isBalanceVisible = true;
  List<Map<String, dynamic>> _liveGoals = [];
  List<Map<String, dynamic>> _completedGoals = [];

  // Getters
  bool get isOngoingSelected => _isOngoingSelected;
  bool get isBalanceVisible => _isBalanceVisible;
  List<Map<String, dynamic>> get liveGoals => _liveGoals;
  List<Map<String, dynamic>> get completedGoals => _completedGoals;
  List<Map<String, dynamic>> get currentGoals =>
      _isOngoingSelected ? _liveGoals : _completedGoals;

  double get totalGoalBalance {
    return _liveGoals.fold(
        0.0, (sum, goal) => sum + (goal['currentAmount'] as double));
  }

  GoalSaveViewModel() {
    _initializeSampleData();
  }

  void _initializeSampleData() {
    // Sample live goals
    _liveGoals = [
      {
        'id': '1',
        'purpose': 'Dream Vacation to Bali',
        'category': 'Vacation',
        'targetAmount': 5000.0,
        'currentAmount': 1250.0,
        'contributionAmount': 200.0,
        'frequency': 'Monthly',
        'fundSource': 'Porket Wallet',
        'startDate': DateTime.now().subtract(const Duration(days: 90)),
        'endDate': DateTime.now().add(const Duration(days: 180)),
        'isCompleted': false,
        'progress': 0.25,
      },
      {
        'id': '2',
        'purpose': 'Emergency Fund',
        'category': 'Emergency',
        'targetAmount': 10000.0,
        'currentAmount': 3500.0,
        'contributionAmount': 500.0,
        'frequency': 'Monthly',
        'fundSource': 'Porket Wallet',
        'startDate': DateTime.now().subtract(const Duration(days: 120)),
        'endDate': DateTime.now().add(const Duration(days: 300)),
        'isCompleted': false,
        'progress': 0.35,
      },
    ];

    // Sample completed goals
    _completedGoals = [
      {
        'id': '3',
        'purpose': 'New Laptop',
        'category': 'Gadgets',
        'targetAmount': 2000.0,
        'currentAmount': 2000.0,
        'contributionAmount': 300.0,
        'frequency': 'Monthly',
        'fundSource': 'Porket Wallet',
        'startDate': DateTime.now().subtract(const Duration(days: 200)),
        'endDate': DateTime.now().subtract(const Duration(days: 30)),
        'isCompleted': true,
        'progress': 1.0,
        'completedAt': DateTime.now().subtract(const Duration(days: 30)),
      },
    ];
  }

  void setOngoingSelected(bool value) {
    _isOngoingSelected = value;
    notifyListeners();
  }

  void toggleBalanceVisibility() {
    _isBalanceVisible = !_isBalanceVisible;
    notifyListeners();
  }

  void navigateToCreateGoal() {
    _navigationService..navigateToCreateGoalView();
  }

  void navigateToGoalDetail(Map<String, dynamic> goal) {
    _navigationService.navigateToGoalSaveDetailView(goal: goal);
  }

  void navigateBack() {
    _navigationService.back();
  }

  void addContribution(String goalId, double amount) {
    final goalIndex = _liveGoals.indexWhere((goal) => goal['id'] == goalId);
    if (goalIndex != -1) {
      final goal = _liveGoals[goalIndex];
      final newAmount = (goal['currentAmount'] as double) + amount;
      final targetAmount = goal['targetAmount'] as double;

      _liveGoals[goalIndex] = {
        ...goal,
        'currentAmount': newAmount,
        'progress': newAmount / targetAmount,
      };

      // Check if goal is completed
      if (newAmount >= targetAmount) {
        _liveGoals[goalIndex]['isCompleted'] = true;
        _liveGoals[goalIndex]['completedAt'] = DateTime.now();

        // Move to completed goals
        final completedGoal = _liveGoals.removeAt(goalIndex);
        _completedGoals.insert(0, completedGoal);
      }

      notifyListeners();
    }
  }

  void withdrawFromGoal(String goalId, double amount) {
    final goalIndex = _liveGoals.indexWhere((goal) => goal['id'] == goalId);
    if (goalIndex != -1) {
      final goal = _liveGoals[goalIndex];
      final currentAmount = goal['currentAmount'] as double;
      final newAmount = (currentAmount - amount).clamp(0.0, currentAmount);
      final targetAmount = goal['targetAmount'] as double;

      _liveGoals[goalIndex] = {
        ...goal,
        'currentAmount': newAmount,
        'progress': newAmount / targetAmount,
      };

      notifyListeners();
    }
  }

  // Quick Links navigation methods
  void navigateToLock() {
    // Navigate to Lock Save page
    _navigationService.navigateToLockSaveView();
  }

  void navigateToSettings() {
    // Navigate to Goal Save settings
    print('Navigate to Goal Save Settings');
  }

  void navigateToUpdatePayment() {
    // Navigate to payment update page
    print('Navigate to Update Payment');
  }

  void navigateToBreak() {
    // Navigate to break/pause goal functionality
    print('Navigate to Break Goal');
  }
}
