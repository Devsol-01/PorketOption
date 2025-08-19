import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';

class OnboardingItem {
  final String title;
  final String subtitle;
  final String description;
  final String iconPath;

  OnboardingItem({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.iconPath,
  });
}

class OnboardingViewModel extends BaseViewModel {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  PageController get pageController => _pageController;
  int get currentIndex => _currentIndex;

  List<OnboardingItem> get onboardingItems => [
        OnboardingItem(
          title: 'Smart',
          subtitle: 'Savings\nPlan',
          description:
              'Choose from Flexible, Goal-based, Locked or Group saving Plan with high AYP rate tailored to your Goals',
          iconPath:
              'lib/assets/smart.png', // Replace with your actual icon path
        ),
        OnboardingItem(
          title: 'Secure &',
          subtitle: 'Transparent',
          description:
              'Enjoy complete control of your asset controls by blockchain technology and full-on-chain transparency',
          iconPath:
              'lib/assets/smart.png', // Replace with your actual icon path
        ),
        OnboardingItem(
          title: 'Web3',
          subtitle: 'Investment',
          description:
              'Enjoy complete control of your asset controls by blockchain technology and full-on-chain transparency',
          iconPath:
              'lib/assets/smart.png', // Replace with your actual icon path
        ),
      ];

  void updateIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void nextPage() {
    if (_currentIndex < onboardingItems.length - 1) {
      _currentIndex++;
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      notifyListeners();
    }
  }

  void previousPage() {
    if (_currentIndex > 0) {
      _currentIndex--;
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      notifyListeners();
    }
  }

  void onGetStarted() {
    // Handle get started action
    // Navigate to main app or login screen
    print('Get Started clicked');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
