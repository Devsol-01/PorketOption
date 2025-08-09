import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class FlexiSaveViewModel extends BaseViewModel {
  // State properties
  bool _isAutoSaveEnabled = true;
  bool _isOngoingSelected = true;
  bool _isBalanceVisible = true;
  double _flexiSaveBalance = 0.0;
  List<Map<String, dynamic>> _transactions = [];
  List<Map<String, dynamic>> _autoSaveSettings = [];

  final NavigationService _navigationService = NavigationService();

  FlexiSaveViewModel() {
    initializeSampleData();
  }

  // Getters for state properties
  bool get isAutoSaveEnabled => _isAutoSaveEnabled;
  bool get isOngoingSelected => _isOngoingSelected;
  bool get isBalanceVisible => _isBalanceVisible;
  double get flexiSaveBalance => _flexiSaveBalance;
  List<Map<String, dynamic>> get transactions => _transactions;
  List<Map<String, dynamic>> get autoSaveSettings => _autoSaveSettings;

  // Methods to update state
  void toggleAutoSave([bool? value]) {
    _isAutoSaveEnabled = value ?? !_isAutoSaveEnabled;
    notifyListeners();
  }

  void setOngoingSelected(bool value) {
    _isOngoingSelected = value;
    notifyListeners();
  }

  void toggleBalanceVisibility() {
    _isBalanceVisible = !_isBalanceVisible;
    notifyListeners();
  }

  void navigateBack() {
    _navigationService.back();
  }

  // Transaction History
  void showTransactionHistory() {
    // Navigate to transaction history page
    // _navigationService.navigateTo('/transaction-history');
  }

  void showInfo() {
    // Show info dialog or navigate to info page
    print('Show PiggyBank info');
  }

  void navigateToAutoSaveSettings() {
    // Navigate to AutoSave settings page
    print('Navigate to AutoSave settings');
  }

  void navigateToWithdrawalSettings() {
    // Navigate to withdrawal settings page
    print('Navigate to withdrawal settings');
  }

  // Quick Save Methods
  void quickSave(double amount, String fundSource) {
    _flexiSaveBalance += amount;
    _addTransaction('Quick Save', amount, fundSource);
    notifyListeners();
  }

  // Auto Save Methods
  void setupAutoSave({
    required String frequency, // daily, weekly, monthly
    required double amount,
    required String fundSource,
    required String time,
    String? dayOfWeek, // for weekly
    int? dayOfMonth, // for monthly
  }) {
    final autoSave = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'frequency': frequency,
      'amount': amount,
      'fundSource': fundSource,
      'time': time,
      'dayOfWeek': dayOfWeek,
      'dayOfMonth': dayOfMonth,
      'isActive': true,
      'createdAt': DateTime.now(),
    };

    _autoSaveSettings.add(autoSave);
    notifyListeners();
  }

  void toggleAutoSaveStatus(String autoSaveId) {
    final index =
        _autoSaveSettings.indexWhere((item) => item['id'] == autoSaveId);
    if (index != -1) {
      _autoSaveSettings[index]['isActive'] =
          !_autoSaveSettings[index]['isActive'];
      notifyListeners();
    }
  }

  void deleteAutoSave(String autoSaveId) {
    _autoSaveSettings.removeWhere((item) => item['id'] == autoSaveId);
    notifyListeners();
  }

  // Withdraw Methods
  void withdraw(double amount) {
    if (amount <= _flexiSaveBalance) {
      _flexiSaveBalance -= amount;
      _addTransaction('Withdrawal', -amount, 'Porket Wallet');
      notifyListeners();
    }
  }

  // Private helper methods
  void _addTransaction(String type, double amount, String fundSource) {
    _transactions.insert(0, {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'type': type,
      'amount': amount,
      'fundSource': fundSource,
      'date': DateTime.now(),
      'status': 'Completed',
    });
  }

  // Initialize with sample data
  void initializeSampleData() {
    _flexiSaveBalance = 1250.50;
    _transactions = [
      {
        'id': '1',
        'type': 'Quick Save',
        'amount': 100.0,
        'fundSource': 'Porket Wallet',
        'date': DateTime.now().subtract(const Duration(days: 1)),
        'status': 'Completed',
      },
      {
        'id': '2',
        'type': 'Auto Save',
        'amount': 50.0,
        'fundSource': 'External Wallet',
        'date': DateTime.now().subtract(const Duration(days: 3)),
        'status': 'Completed',
      },
      {
        'id': '3',
        'type': 'Withdrawal',
        'amount': -25.0,
        'fundSource': 'Porket Wallet',
        'date': DateTime.now().subtract(const Duration(days: 5)),
        'status': 'Completed',
      },
    ];

    _autoSaveSettings = [
      {
        'id': 'auto1',
        'frequency': 'daily',
        'amount': 10.0,
        'fundSource': 'Porket Wallet',
        'time': '4:00 PM',
        'isActive': true,
        'createdAt': DateTime.now().subtract(const Duration(days: 7)),
      },
      {
        'id': 'auto2',
        'frequency': 'weekly',
        'amount': 50.0,
        'fundSource': 'External Wallet',
        'time': '6:00 PM',
        'dayOfWeek': 'Friday',
        'isActive': false,
        'createdAt': DateTime.now().subtract(const Duration(days: 14)),
      },
    ];
    notifyListeners();
  }
}
