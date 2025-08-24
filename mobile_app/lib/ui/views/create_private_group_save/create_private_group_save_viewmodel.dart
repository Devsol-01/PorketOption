import 'package:flutter/material.dart';
import 'package:mobile_app/app/app.locator.dart';
import 'package:mobile_app/app/app.router.dart';
import 'package:mobile_app/extensions/num_extensions.dart';
import 'package:mobile_app/services/contract_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CreatePrivateGroupSaveViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final ContractService _contractService = locator<ContractService>();

  // Controllers
  final TextEditingController purposeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController targetAmountController = TextEditingController();
  final TextEditingController contributionController = TextEditingController();

  final TextEditingController _textController = TextEditingController();
  TextEditingController get textController => _textController;

  bool _isDropdownOpen = false;
  bool get isDropdownOpen => _isDropdownOpen;

  String? _selectedValue;
  String? get selectedValue => _selectedValue;

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

      // Generate a random group code for private groups
      final groupCode = _generateGroupCode();

      final groupId = await _contractService.createGroupSave(
        title: purposeController.text,
        description: descriptionController.text,
        category: _selectedCategory,
        targetAmount: targetAmount,
        contributionType: _selectedFrequency,
        contributionAmount: contributionAmount,
        isPublic: false,
        endTime: _endDate!,
      );

      print(
          '🔒 Private group created successfully with ID: $groupId and code: $groupCode');
      _navigationService.back();
    } catch (e) {
      print('❌ Error creating private group: $e');
    } finally {
      setBusy(false);
    }
  }

  String _generateGroupCode() {
    // Generate a 6-character alphanumeric code
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    String code = '';
    for (int i = 0; i < 6; i++) {
      code += chars[(random + i) % chars.length];
    }
    return code;
  }


  // Sample options - replace with your data
  final List<String> _allOptions = [
    'Anyone can Invite',
    'Only Admin can Invite',
  ];

  List<String> _filteredOptions = [];
  List<String> get filteredOptions => _filteredOptions;

  DropdownTextFieldViewModel() {
    _filteredOptions = List.from(_allOptions);
  }

  void toggleDropdown() {
    _isDropdownOpen = !_isDropdownOpen;
    if (_isDropdownOpen) {
      // Always show all options when opening dropdown
      _filteredOptions = List.from(_allOptions);
    }
    notifyListeners();
  }

  void closeDropdown() {
    _isDropdownOpen = false;
    notifyListeners();
  }

  void selectOption(String option) {
    _selectedValue = option;
    _textController.text = option;
    closeDropdown();
    notifyListeners();
  }

  void onTextChanged(String value) {
    if (_isDropdownOpen) {
      _filterOptions(value);
    }
    notifyListeners();
  }

  void _filterOptions(String query) {
    if (query.isEmpty) {
      _filteredOptions = List.from(_allOptions);
    } else {
      _filteredOptions = _allOptions
          .where((option) => option.toLowerCase().contains(query.toLowerCase()))
          .toList();
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
