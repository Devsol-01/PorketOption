import 'package:flutter/material.dart';
import 'package:mobile_app/app/app.locator.dart';
import 'package:mobile_app/services/contract_service.dart';
import 'package:mobile_app/ui/views/dashboard/dashboard_viewmodel.dart';
import 'package:mobile_app/ui/views/goal_save/goal_save_viewmodel.dart';
import 'package:mobile_app/ui/widgets/deposit_sheet.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class GoalSaveDetailsViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final ContractService _contractService = locator<ContractService>();
  final SnackbarService _snackbarService = locator<SnackbarService>();

  void navigateBack() {
    _navigationService.back();
  }

  void showTopUpDialog(BuildContext context, Map<String, dynamic> goal) {
    final dashboardViewModel = locator<DashboardViewModel>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DepositSheet(
        onDeposit: (amount, fundSource) => topUpGoal(goal, amount, fundSource),
        currentBalance: dashboardViewModel.dashboardBalance,
        isLoading: isBusy,
      ),
    );
  }

  Future<void> topUpGoal(
      Map<String, dynamic> goal, double amount, String fundSource) async {
    if (amount <= 0) {
      _showErrorSnackbar('Please enter a valid amount');
      return;
    }

    final dashboardViewModel = locator<DashboardViewModel>();

    // Check if dashboard has sufficient balance
    if (dashboardViewModel.dashboardBalance < amount) {
      _showErrorSnackbar('Insufficient balance in dashboard');
      return;
    }

    setBusy(true);
    try {
      // Transfer from dashboard to goal save
      bool transferSuccess = dashboardViewModel.transferToGoalSave(amount);

      if (transferSuccess) {
        // Update goal with new contribution (mock implementation)
        await _contractService.contributeGoalSave(
          goalId: goal['id'].toString(),
          amount: amount,
        );

        // Update the goal data locally to reflect changes immediately
        goal['currentAmount'] = (goal['currentAmount'] as double) + amount;
        goal['progress'] = (goal['currentAmount'] as double) /
            (goal['targetAmount'] as double);

        _showSuccessSnackbar(
            'Goal topped up successfully! \$${amount.toStringAsFixed(2)} added');

        // Refresh all related ViewModels to update UI
        final goalSaveViewModel = locator<GoalSaveViewModel>();
        await goalSaveViewModel.initialize();

        // Refresh dashboard to update all balances
        await dashboardViewModel.loadSavingsBalance();
        await dashboardViewModel.refreshDashboard();

        // Refresh the goal data
        notifyListeners();
      } else {
        _showErrorSnackbar('Transfer failed. Please try again.');
      }
    } catch (e) {
      print('Error topping up goal: $e');
      _showErrorSnackbar('Failed to top up goal. Please try again.');
    } finally {
      setBusy(false);
    }
  }

  void _showSuccessSnackbar(String message) {
    _snackbarService.showSnackbar(
      message: message,
      duration: const Duration(seconds: 3),
    );
  }

  void _showErrorSnackbar(String message) {
    _snackbarService.showSnackbar(
      message: message,
      duration: const Duration(seconds: 3),
    );
  }

  void navigateToHistory() {
    // TODO: Navigate to history page
    print('Navigate to history');
  }

  void navigateToLock() {
    // TODO: Navigate to lock page
    print('Navigate to lock');
  }

  void navigateToSettings() {
    // TODO: Navigate to settings page
    print('Navigate to settings');
  }

  void navigateToPayment() {
    // TODO: Navigate to payment page
    print('Navigate to payment');
  }

  void navigateToBreak() {
    // TODO: Navigate to break page or show break dialog
    print('Navigate to break');
  }

  void navigateToUpdatePayment() {
    // TODO: Navigate to update payment page
    print('Navigate to update payment');
  }
}
