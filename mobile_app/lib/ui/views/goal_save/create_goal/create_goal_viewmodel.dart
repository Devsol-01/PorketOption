import 'package:flutter/material.dart';
import 'package:mobile_app/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:mobile_app/app/app.locator.dart';
import 'package:mobile_app/extensions/num_extensions.dart';
import 'package:mobile_app/services/contract_service.dart';
import 'package:mobile_app/ui/views/dashboard/dashboard_viewmodel.dart';

class CreateGoalViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final ContractService _contractService = locator<ContractService>();
  final SnackbarService _snackbarService = locator<SnackbarService>();

  DashboardViewModel? _dashboardViewModel;

  // Controllers
  final TextEditingController purposeController = TextEditingController();
  final TextEditingController targetAmountController = TextEditingController();
  final TextEditingController contributionController = TextEditingController();

  // State variables
  String _selectedCategory = '';
  String _selectedFrequency = 'Daily';
  String _selectedFundSource = 'Porket Wallet';
  DateTime? _startDate;
  DateTime? _endDate;

  // Frequency-specific options
  TimeOfDay? _preferredTime;
  String _selectedDayOfWeek = 'Monday';
  int _selectedDayOfMonth = 1;

  // Terms acceptance
  bool _isTermsAccepted = false;

  // Getters
  String get selectedCategory => _selectedCategory;
  String get selectedFrequency => _selectedFrequency;
  String get selectedFundSource => _selectedFundSource;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  TimeOfDay? get preferredTime => _preferredTime;
  String get selectedDayOfWeek => _selectedDayOfWeek;
  int get selectedDayOfMonth => _selectedDayOfMonth;
  bool get isTermsAccepted => _isTermsAccepted;

  bool get canCreateGoal {
    bool hasBasicInfo = purposeController.text.isNotEmpty &&
        _selectedCategory.isNotEmpty &&
        targetAmountController.text.isNotEmpty &&
        _startDate != null &&
        _endDate != null &&
        _isTermsAccepted;

    // Check frequency-specific requirements
    bool hasFrequencyRequirements = true;
    if (_selectedFrequency == 'Daily' ||
        _selectedFrequency == 'Weekly' ||
        _selectedFrequency == 'Monthly' ||
        _selectedFrequency == 'Manual') {
      hasFrequencyRequirements = _preferredTime != null;
    }

    return hasBasicInfo && hasFrequencyRequirements;
  }

  // Calculate the required contribution amount based on target and duration
  double get calculatedContributionAmount {
    final targetAmount = double.tryParse(targetAmountController.text) ?? 0.0;
    if (targetAmount <= 0 || _startDate == null || _endDate == null) return 0.0;

    final duration = _endDate!.difference(_startDate!).inDays;
    if (duration <= 0) return 0.0;

    switch (_selectedFrequency) {
      case 'Daily':
        return targetAmount / duration;
      case 'Weekly':
        final weeks = (duration / 7).ceil();
        return targetAmount / weeks;
      case 'Monthly':
        final months = (duration / 30).ceil();
        return targetAmount / months;
      case 'Manual':
        // For manual, we'll use the total duration as the number of contributions
        return targetAmount / duration;
      default:
        return 0.0;
    }
  }

  // Get the contribution frequency text for display
  String get contributionFrequencyText {
    switch (_selectedFrequency) {
      case 'Daily':
        return 'daily';
      case 'Weekly':
        return 'weekly';
      case 'Monthly':
        return 'monthly';
      case 'Manual':
        return 'per contribution';
      default:
        return '';
    }
  }

  void setDashboardViewModel(DashboardViewModel dashboardViewModel) {
    _dashboardViewModel = dashboardViewModel;
  }

  void navigateBack() {
    _navigationService.back();
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void selectFrequency(String frequency) {
    _selectedFrequency = frequency;
    // Reset frequency-specific options when changing frequency
    _preferredTime = null;
    _selectedDayOfWeek = 'Monday';
    _selectedDayOfMonth = 1;
    _updateContributionAmount();
    notifyListeners();
  }

  void selectFundSource(String source) {
    _selectedFundSource = source;
    notifyListeners();
  }

  void _updateContributionAmount() {
    final calculatedAmount = calculatedContributionAmount;
    if (calculatedAmount > 0) {
      contributionController.text = calculatedAmount.toCurrency(symbol: ' 24');
    } else {
      contributionController.text = '';
    }
  }

  Future<void> selectPreferredTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _preferredTime ?? const TimeOfDay(hour: 9, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: const Color(0xFF6C5CE7),
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      _preferredTime = picked;
      notifyListeners();
    }
  }

  void selectDayOfWeek(String day) {
    _selectedDayOfWeek = day;
    notifyListeners();
  }

  void selectDayOfMonth(int day) {
    _selectedDayOfMonth = day;
    notifyListeners();
  }

  void toggleTermsAcceptance() {
    _isTermsAccepted = !_isTermsAccepted;
    notifyListeners();
  }

  Future<void> selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: const Color(0xFF6C5CE7),
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      _startDate = picked;
      // If end date is before start date, clear it
      if (_endDate != null && _endDate!.isBefore(picked)) {
        _endDate = null;
      }
      _updateContributionAmount();
      notifyListeners();
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ??
          (_startDate?.add(const Duration(days: 30)) ??
              DateTime.now().add(const Duration(days: 30))),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: const Color(0xFF6C5CE7),
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      _endDate = picked;
      _updateContributionAmount();
      notifyListeners();
    }
  }

  Future<void> createGoal() async {
    if (!canCreateGoal) return;

    final targetAmount = double.tryParse(targetAmountController.text) ?? 0.0;
    final contributionAmount = calculatedContributionAmount;

    if (targetAmount <= 0) {
      _showErrorSnackbar('Please enter a valid target amount');
      return;
    }

    // Check if dashboard has sufficient balance for initial contribution
    if (_dashboardViewModel != null) {
      if (_dashboardViewModel!.dashboardBalance < contributionAmount) {
        _showErrorSnackbar(
            'Insufficient balance in dashboard for initial contribution');
        return;
      }
    }

    setBusy(true);
    try {
      print('🎯 Creating goal with contract...');

      // Transfer initial contribution from dashboard to goal save
      bool transferSuccess = false;
      if (_dashboardViewModel != null) {
        transferSuccess =
            _dashboardViewModel!.transferToGoalSave(contributionAmount);
      }

      if (transferSuccess) {
        // Simulate contract interaction delay
        await Future.delayed(Duration(milliseconds: 1500));

        // Create goal on contract
        final goalId = await _contractService.createGoalSave(
          title: purposeController.text,
          category: _selectedCategory,
          targetAmount: targetAmount,
          contributionType: _selectedFrequency,
          contributionAmount: contributionAmount,
          endTime: _endDate!,
        );

        if (goalId.isNotEmpty) {
          print('✅ Goal created successfully! ID: $goalId');
          _showSuccessSnackbar(
              '🎯 Goal Save created successfully! \$${contributionAmount.toStringAsFixed(2)} transferred as initial contribution');

          // Navigate back to Goal Save page
          _navigationService.navigateToGoalSaveView();
        } else {
          _showErrorSnackbar('Failed to create goal save');
          // Rollback the transfer on error
          if (_dashboardViewModel != null) {
            _dashboardViewModel!.transferFromGoalSave(contributionAmount);
          }
        }
      } else {
        _showErrorSnackbar('Transfer failed. Please try again.');
      }
    } catch (e) {
      print('❌ Error creating goal: $e');
      _showErrorSnackbar('Error creating goal: $e');

      // Rollback the transfer on error
      if (_dashboardViewModel != null) {
        _dashboardViewModel!.transferFromGoalSave(contributionAmount);
      }
    } finally {
      setBusy(false);
    }
  }

  void _showSuccessSnackbar(String message) {
    _snackbarService.showSnackbar(
      message: message,
      duration: Duration(seconds: 3),
    );
  }

  void _showErrorSnackbar(String message) {
    _snackbarService.showSnackbar(
      message: message,
      duration: Duration(seconds: 4),
    );
  }

  @override
  void dispose() {
    purposeController.dispose();
    targetAmountController.dispose();
    contributionController.dispose();
    super.dispose();
  }

  // Initialize listeners when the view is ready
  void initializeListeners() {
    targetAmountController.addListener(_updateContributionAmount);
  }
}
