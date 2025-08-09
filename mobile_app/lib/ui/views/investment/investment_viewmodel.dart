import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:mobile_app/app/app.locator.dart';

class InvestmentViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  // Investment state
  bool _isBalanceVisible = true;
  bool get isBalanceVisible => _isBalanceVisible;

  String _selectedTab = 'Active';
  String get selectedTab => _selectedTab;

  double _totalInvestmentBalance = 0.0;
  double get totalInvestmentBalance => _totalInvestmentBalance;

  double _totalReturns = 0.0;
  double get totalReturns => _totalReturns;

  double _growthPercentage = 0.0;
  double get growthPercentage => _growthPercentage;

  List<Map<String, dynamic>> _activeInvestments = [];
  List<Map<String, dynamic>> get activeInvestments => _activeInvestments;

  List<Map<String, dynamic>> _maturedInvestments = [];
  List<Map<String, dynamic>> get maturedInvestments => _maturedInvestments;

  bool get hasActiveInvestments => _activeInvestments.isNotEmpty;
  bool get hasMaturedInvestments => _maturedInvestments.isNotEmpty;

  // DeFi Protocols data
  List<Map<String, dynamic>> get availableProtocols => [
    {
      'id': 'solend',
      'title': 'Solend',
      'subtitle': 'Decentralized\nlending protocol',
      'apy': '8.5%',
      'tvl': '\$120M',
      'riskLevel': 'Medium',
      'iconColor': 0xFF6366F1,
      'description': 'Earn yield by lending your crypto assets on Solana\'s leading lending protocol.',
      'minInvestment': 10.0,
      'category': 'Lending',
    },
    {
      'id': 'marinade',
      'title': 'Marinade',
      'subtitle': 'Liquid staking\nprotocol',
      'apy': '6.8%',
      'tvl': '\$180M',
      'riskLevel': 'Low',
      'iconColor': 0xFF10B981,
      'description': 'Stake your SOL and receive mSOL while earning staking rewards.',
      'minInvestment': 1.0,
      'category': 'Staking',
    },
    {
      'id': 'jupiter',
      'title': 'Jupiter',
      'subtitle': 'DEX aggregator\nfor best prices',
      'apy': '12.3%',
      'tvl': '\$95M',
      'riskLevel': 'High',
      'iconColor': 0xFFF59E0B,
      'description': 'Provide liquidity and earn fees from the best DEX aggregator on Solana.',
      'minInvestment': 25.0,
      'category': 'Liquidity',
    },
    {
      'id': 'raydium',
      'title': 'Raydium',
      'subtitle': 'Automated market\nmaker (AMM)',
      'apy': '15.7%',
      'tvl': '\$75M',
      'riskLevel': 'High',
      'iconColor': 0xFFEF4444,
      'description': 'Earn trading fees by providing liquidity to Raydium\'s AMM pools.',
      'minInvestment': 50.0,
      'category': 'AMM',
    },
  ];

  void initialize() {
    _loadInvestmentData();
  }

  void _loadInvestmentData() {
    // Simulate loading user's investment data
    // In a real app, this would fetch from an API or local storage
    
    // Mock data for demonstration
    _totalInvestmentBalance = 2450.75;
    _totalReturns = 145.30;
    _growthPercentage = 6.3;
    
    _activeInvestments = [
      {
        'id': '1',
        'protocol': 'Solend',
        'amount': 1000.0,
        'currentValue': 1085.0,
        'apy': '8.5%',
        'returns': 85.0,
        'startDate': DateTime.now().subtract(const Duration(days: 45)),
      },
      {
        'id': '2',
        'protocol': 'Marinade',
        'amount': 1500.0,
        'currentValue': 1560.30,
        'apy': '6.8%',
        'returns': 60.30,
        'startDate': DateTime.now().subtract(const Duration(days: 30)),
      },
    ];

    _maturedInvestments = [
      {
        'id': '3',
        'protocol': 'Jupiter',
        'amount': 500.0,
        'finalValue': 575.0,
        'apy': '15.0%',
        'returns': 75.0,
        'startDate': DateTime.now().subtract(const Duration(days: 90)),
        'endDate': DateTime.now().subtract(const Duration(days: 15)),
      },
    ];

    notifyListeners();
  }

  void toggleBalanceVisibility() {
    _isBalanceVisible = !_isBalanceVisible;
    notifyListeners();
  }

  void switchTab(String tab) {
    _selectedTab = tab;
    notifyListeners();
  }

  void navigateToProtocolDetail(String protocolId) {
    final protocol = availableProtocols.firstWhere(
      (p) => p['id'] == protocolId,
      orElse: () => {},
    );
    
    if (protocol.isNotEmpty) {
      // Navigate to protocol detail view
      // _navigationService.navigateTo('/protocol-detail', arguments: protocol);
      
      // For now, show a dialog with protocol info
      showProtocolDialog(protocol);
    }
  }

  void showProtocolDialog(Map<String, dynamic> protocol) {
    // This would typically show a bottom sheet or navigate to a detail page
    // For now, we'll implement it as a method that can be called from the view
  }

  void investInProtocol(String protocolId, double amount) {
    setBusy(true);
    
    // Simulate investment process
    Future.delayed(const Duration(seconds: 2), () {
      final protocol = availableProtocols.firstWhere(
        (p) => p['id'] == protocolId,
        orElse: () => {},
      );
      
      if (protocol.isNotEmpty && amount >= protocol['minInvestment']) {
        // Add to active investments
        _activeInvestments.add({
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'protocol': protocol['title'],
          'amount': amount,
          'currentValue': amount,
          'apy': protocol['apy'],
          'returns': 0.0,
          'startDate': DateTime.now(),
        });
        
        // Update totals
        _totalInvestmentBalance += amount;
        _recalculateReturns();
        
        setBusy(false);
        notifyListeners();
      } else {
        setBusy(false);
        // Show error - insufficient amount or invalid protocol
      }
    });
  }

  void withdrawInvestment(String investmentId) {
    setBusy(true);
    
    Future.delayed(const Duration(seconds: 2), () {
      final investmentIndex = _activeInvestments.indexWhere(
        (inv) => inv['id'] == investmentId,
      );
      
      if (investmentIndex != -1) {
        final investment = _activeInvestments[investmentIndex];
        
        // Move to matured investments
        _maturedInvestments.add({
          ...investment,
          'finalValue': investment['currentValue'],
          'endDate': DateTime.now(),
        });
        
        // Remove from active investments
        _activeInvestments.removeAt(investmentIndex);
        
        // Update totals
        _totalInvestmentBalance -= investment['currentValue'];
        _recalculateReturns();
        
        setBusy(false);
        notifyListeners();
      } else {
        setBusy(false);
      }
    });
  }

  void _recalculateReturns() {
    double totalReturns = 0.0;
    double totalInvested = 0.0;
    
    for (var investment in _activeInvestments) {
      totalReturns += investment['returns'] ?? 0.0;
      totalInvested += investment['amount'] ?? 0.0;
    }
    
    for (var investment in _maturedInvestments) {
      totalReturns += investment['returns'] ?? 0.0;
      totalInvested += investment['amount'] ?? 0.0;
    }
    
    _totalReturns = totalReturns;
    _growthPercentage = totalInvested > 0 ? (totalReturns / totalInvested) * 100 : 0.0;
  }

  void refreshInvestments() {
    setBusy(true);
    
    Future.delayed(const Duration(seconds: 1), () {
      _loadInvestmentData();
      setBusy(false);
    });
  }

  void navigateToFindMore() {
    // Navigate to a page with more investment opportunities
    // _navigationService.navigateTo('/investment-opportunities');
  }

  void showInvestmentInfo() {
    // Show information dialog about investments
  }
}
