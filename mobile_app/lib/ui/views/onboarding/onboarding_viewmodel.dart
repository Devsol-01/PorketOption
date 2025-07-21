import 'package:flutter/material.dart';
import 'package:mobile_app/app/app.locator.dart';
import 'package:mobile_app/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class OnboardingViewModel extends BaseViewModel {
  final PageController pageController = PageController();
  final _navigationService = locator<NavigationService>();

  int currentIndex = 0;

  final List<Map<String, dynamic>> pages = [
    {
      'icon': Icons.diamond,
      'title': 'Welcome to PorketOption',
      'description':
          'Discover the power of decentralized finance with savings, investments, and portfolio tools — all in one place.',
      'color': const Color(0xFF8B5CF6)
    },
    {
      'icon': Icons.savings,
      'title': 'Smart Savings Plans',
      'description':
          'Choose from Flexible, Goal-based, Locked, or Group savings plans with high APY rates tailored to your goals.',
      'color': const Color(0xFF3B82F6),
    },
    {
      'icon': Icons.trending_up,
      'title': 'Web3 Investments',
      'description':
          'Invest in trusted Solana projects like Solend, Marinade, and Raydium — with clear risk insights and full transparency.',
      'color': const Color(0xFF22C55E),
    },
    {
      'icon': Icons.shield,
      'title': 'Secure & Transparent',
      'description':
          'Enjoy complete control of your assets, secured by blockchain technology and full on-chain transparency.',
      'color': const Color(0xFFF97316),
    },
  ];

  void onPageChanged(int index) {
    currentIndex = index;
    notifyListeners();
  }

  bool get isLastPage => currentIndex == pages.length - 1;

  void onNextPressed() {
    if (isLastPage) {
      _navigationService
          .navigateToEmailView(); // Replace with your actual home route
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void onSkip() {
    _navigationService
        .navigateToEmailView(); // Replace with your actual home route
  }
}
