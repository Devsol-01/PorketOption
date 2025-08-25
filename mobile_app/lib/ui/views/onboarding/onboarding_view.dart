import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'onboarding_viewmodel.dart';

class OnboardingView extends StackedView<OnboardingViewModel> {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    OnboardingViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top padding
            const SizedBox(height: 40),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: viewModel.pageController,
                onPageChanged: viewModel.onPageChanged,
                itemCount: viewModel.onboardingData.length,
                itemBuilder: (context, index) {
                  final data = viewModel.onboardingData[index];
                  return _buildOnboardingPage(
                    context,
                    data['image']!,
                    data['title']!,
                    data['subtitle']!,
                    data['description']!,
                    data['backgroundImage']!,
                  );
                },
              ),
            ),

            // Bottom section with indicators and button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Page indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      viewModel.onboardingData.length,
                      (index) => _buildPageIndicator(
                        index,
                        viewModel.currentPageIndex,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Action button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: viewModel.onNextPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2B5CE6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        viewModel.isLastPage ? 'Get Started' : 'Next',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Skip button (only show if not last page)
                  if (!viewModel.isLastPage)
                    TextButton(
                      onPressed: viewModel.onSkipPressed,
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          color: Color(0xFF8B8B8B),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(
    BuildContext context,
    String imagePath,
    String title,
    String subtitle,
    String description,
    String backgroundImagePath,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          // Main illustration with positioned curvy lines
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                // Positioned curvy lines based on screen
                _buildPositionedCurvyLines(backgroundImagePath),

                // Main icon centered
                Center(
                  child: Image.asset(
                    imagePath,
                    height: 200,
                    width: 200,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Text content
          Expanded(
            flex: 2,
            child: Column(
              children: [
                // Title with blue accent
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      height: 1.2,
                    ),
                    children: [
                      TextSpan(
                        text: '$title ',
                        style: const TextStyle(
                          color: Color(0xFF2B5CE6),
                        ),
                      ),
                      TextSpan(text: subtitle),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Description
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF666666),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(int index, int currentIndex) {
    final isActive = index == currentIndex;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF2B5CE6) : const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildPositionedCurvyLines(String backgroundImagePath) {
    // Position curvy lines differently for each screen
    if (backgroundImagePath.contains('savings')) {
      // First screen - bottom left
      return Positioned(
        bottom: 20,
        left: -30,
        child: Image.asset(
          'lib/assets/line3.png',
          width: 150,
          height: 100,
          fit: BoxFit.contain,
        ),
      );
    } else if (backgroundImagePath.contains('secure')) {
      // Second screen - bottom center
      return Positioned(
        bottom: 40,
        left: 50,
        child: Image.asset(
          'lib/assets/line2.png',
          width: 200,
          height: 120,
          fit: BoxFit.contain,
        ),
      );
    } else {
      // Third screen - bottom right
      return Positioned(
        bottom: 30,
        right: -20,
        child: Image.asset(
          'lib/assets/line3.png',
          width: 160,
          height: 110,
          fit: BoxFit.contain,
        ),
      );
    }
  }

  @override
  OnboardingViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      OnboardingViewModel();
}
