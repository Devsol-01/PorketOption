import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class OnboardingViewModel extends BaseViewModel {
  final PageController _pageController = PageController();
  PageController get pageController => _pageController;

  int _currentPageIndex = 0;
  int get currentPageIndex => _currentPageIndex;

  bool get isLastPage => _currentPageIndex == onboardingData.length - 1;

  // Onboarding data based on your design
  final List<Map<String, String>> onboardingData = [
    {
      'image': 'lib/assets/onboard2.png', // Your wallet with coins icon
      'title': 'Smart',
      'subtitle': 'Savings\nPlan',
      'description':
          'Choose from Flexible, Goal-based, Locked or\nGroup saving Plan with high AYP rate tailored\nto to your Goals',
      'backgroundImage': 'lib/assets/line1.png', // Curvy background
    },
    {
      'image': 'lib/assets/onboard2.png', // Your padlock with shield icon
      'title': 'Secure &',
      'subtitle': 'Transparent',
      'description':
          'Enjoy complete control of your asset\ncontrols by blockchain technology and full-\non-chain transparency',
      'backgroundImage': 'lib/assets/line2.png', // Curvy background
    },
    {
      'image': 'lib/assets/onboard3.png', // Your growth chart icon
      'title': 'Web3',
      'subtitle': 'Investment',
      'description':
          'Enjoy complete control of your asset\ncontrols by blockchain technology and full-\non-chain transparency',
      'backgroundImage': 'assets/images/line3.png', // Curvy background
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onPageChanged(int index) {
    _currentPageIndex = index;
    rebuildUi();
  }

  void onNextPressed() {
    if (isLastPage) {
      // Navigate to main app or login screen
      _completeOnboarding();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void onSkipPressed() {
    _completeOnboarding();
  }

  void _completeOnboarding() {
    // Implement navigation to your main app
    // Example:
    // navigationService.clearStackAndShow(Routes.homeView);
    // or
    // navigationService.clearStackAndShow(Routes.loginView);

    // For now, just print
    print('Onboarding completed');

    // You can also save onboarding completion status
    // await sharedPreferences.setBool('onboarding_completed', true);
  }

  void goToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
