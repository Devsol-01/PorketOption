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
            // Top section with page indicators and skip button
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 50), // Spacer

                  // Page indicators
                  Row(
                    children: List.generate(
                      viewModel.onboardingItems.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: viewModel.currentIndex == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: viewModel.currentIndex == index
                              ? const Color(0xFF2563EB)
                              : const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),

                  // Skip button
                  TextButton(
                    onPressed: viewModel.onGetStarted,
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Main content area with PageView
            Expanded(
              child: PageView.builder(
                controller: viewModel.pageController,
                itemCount: viewModel.onboardingItems.length,
                onPageChanged: viewModel.updateIndex,
                itemBuilder: (context, index) {
                  final item = viewModel.onboardingItems[index];
                  return _buildOnboardingCard(item);
                },
              ),
            ),

            // Bottom navigation section
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Previous button (only show if not on first page)
                  if (viewModel.currentIndex > 0)
                    TextButton(
                      onPressed: viewModel.previousPage,
                      child: const Text(
                        'Previous',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 80),

                  // Next/Get Started button
                  ElevatedButton(
                    onPressed: viewModel.currentIndex ==
                            viewModel.onboardingItems.length - 1
                        ? viewModel.onGetStarted
                        : viewModel.nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      viewModel.currentIndex ==
                              viewModel.onboardingItems.length - 1
                          ? 'Get Started'
                          : 'Next',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
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

  Widget _buildOnboardingCard(OnboardingItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFF),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background decorative lines
          Positioned(
            right: -20,
            bottom: -20,
            child: CustomPaint(
              size: const Size(120, 80),
              painter: _DecorativeLinesPainter(),
            ),
          ),

          // Main content
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                const SizedBox(height: 40),

                // Icon section
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2563EB).withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: _buildIcon(item),
                  ),
                ),

                const SizedBox(height: 48),

                // Title section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Blue title part
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2563EB),
                          height: 1.1,
                        ),
                      ),
                    ),

                    // Black subtitle part
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        item.subtitle,
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                          height: 1.1,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Description
                Text(
                  item.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF64748B),
                    height: 1.6,
                  ),
                ),

                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(OnboardingItem item) {
    // Use your actual images - replace with Image.asset when ready
    if (item.title.contains('Smart')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          item.iconPath,
          width: 60,
          height: 60,
          fit: BoxFit.contain,
          // Fallback icon if image doesn't load
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.account_balance_wallet_outlined,
                size: 32,
                color: Color(0xFF2563EB),
              ),
            );
          },
        ),
      );
    } else if (item.title.contains('Secure')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          item.iconPath,
          width: 60,
          height: 60,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.shield_outlined,
                size: 32,
                color: Color(0xFF2563EB),
              ),
            );
          },
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          item.iconPath,
          width: 60,
          height: 60,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.trending_up_outlined,
                size: 32,
                color: Color(0xFF2563EB),
              ),
            );
          },
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

// Custom painter for decorative lines (add this at the bottom of your file)
class _DecorativeLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path();

    // Create flowing curved lines similar to your design
    for (int i = 0; i < 3; i++) {
      path.moveTo(0, size.height * (0.2 + i * 0.3));
      path.quadraticBezierTo(
        size.width * 0.3,
        size.height * (0.1 + i * 0.3),
        size.width * 0.6,
        size.height * (0.3 + i * 0.3),
      );
      path.quadraticBezierTo(
        size.width * 0.8,
        size.height * (0.4 + i * 0.3),
        size.width,
        size.height * (0.2 + i * 0.3),
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
