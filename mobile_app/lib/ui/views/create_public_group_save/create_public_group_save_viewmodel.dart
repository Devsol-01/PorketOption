import 'package:flutter/material.dart';
import 'package:mobile_app/app/app.locator.dart';
import 'package:mobile_app/app/app.router.dart';
import 'package:mobile_app/extensions/num_extensions.dart';
import 'package:mobile_app/services/contract_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CreatePublicGroupSaveViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final ContractService _contractService = locator<ContractService>();

  // Controllers
  final TextEditingController purposeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController targetAmountController = TextEditingController();
  final TextEditingController contributionController = TextEditingController();

  // State variables
  String _selectedCategory = '';
  String _selectedFrequency = 'Monthly';
  String _selectedFundSource = 'Porket Wallet';
  DateTime? _startDate;
  DateTime? _endDate;

  // Frequency-specific options
  TimeOfDay? _preferredTime;
  String _selectedDayOfWeek = 'Monday';
  int _selectedDayOfMonth = 1;

  // Terms acceptance
  bool _isTermsAccepted = false;

  // Calculated contribution amount
  double _calculatedContributionAmount = 0.0;

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
  double get calculatedContributionAmount => _calculatedContributionAmount;

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

  void updateCalculatedContribution() {
    if (_selectedFrequency.isEmpty || _startDate == null || _endDate == null) {
      _calculatedContributionAmount = 0.0;
      notifyListeners();
      return;
    }

    final targetAmount = double.tryParse(targetAmountController.text) ?? 0.0;
    if (targetAmount <= 0) {
      _calculatedContributionAmount = 0.0;
      notifyListeners();
      return;
    }

    final daysDifference = _endDate!.difference(_startDate!).inDays;
    if (daysDifference <= 0) {
      _calculatedContributionAmount = 0.0;
      notifyListeners();
      return;
    }

    double totalContributions = 0;
    switch (_selectedFrequency.toLowerCase()) {
      case 'daily':
        totalContributions = daysDifference.toDouble();
        break;
      case 'weekly':
        totalContributions = (daysDifference / 7).ceil().toDouble();
        break;
      case 'monthly':
        totalContributions = (daysDifference / 30).ceil().toDouble();
        break;
      default:
        totalContributions = 1; // Manual
    }

    _calculatedContributionAmount =
        totalContributions > 0 ? targetAmount / totalContributions : 0.0;
    notifyListeners();
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

  void navigateBack() {
    // Navigate specifically to GroupSaveView instead of just going back
    _navigationService.clearStackAndShow(Routes.groupSaveView);
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

    setBusy(true);
    try {
      final targetAmount = double.tryParse(targetAmountController.text) ?? 0.0;
      final contributionAmount = calculatedContributionAmount;

      final groupId = await _contractService.createGroupSave(
        title: purposeController.text,
        description: descriptionController.text,
        category: _selectedCategory,
        targetAmount: targetAmount,
        contributionType: _selectedFrequency,
        contributionAmount: contributionAmount,
        isPublic: true,
        endTime: _endDate!,
      );

      print('👥 Public group created successfully with ID: $groupId');
      _navigationService.back();
    } catch (e) {
      print('❌ Error creating public group: $e');
    } finally {
      setBusy(false);
    }
  }

  @override
  void dispose() {
    purposeController.dispose();
    descriptionController.dispose();
    targetAmountController.dispose();
    contributionController.dispose();
    super.dispose();
  }


  // Initialize listeners when the view is ready
  void initializeListeners() {
    targetAmountController.addListener(_updateContributionAmount);
  }
}
