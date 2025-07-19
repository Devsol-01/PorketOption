import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/extensions/theme_context_extension.dart';
import 'package:mobile_app/ui/common/app_colors.dart' as AppColors;
import 'package:stacked/stacked.dart';
import 'onboarding_viewmodel.dart';

class OnboardingView extends StackedView<OnboardingViewModel> {
  const OnboardingView({super.key});

  @override
  Widget builder(
    BuildContext context,
    OnboardingViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: viewModel.pageController,
                    itemCount: viewModel.pages.length,
                    onPageChanged: viewModel.onPageChanged,
                    itemBuilder: (context, index) {
                      final page = viewModel.pages[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 130,
                              width: 130,
                              decoration: BoxDecoration(
                                color: page['color'],
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                page['icon'],
                                size: 70,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 30),
                            Text(
                              page['title'],
                              style: GoogleFonts.dmSans(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: context.primaryTextColor),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              page['description'],
                              style:  GoogleFonts.dmSans(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    viewModel.pages.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: viewModel.currentIndex == index ? 10 : 6,
                      height: viewModel.currentIndex == index ? 10 : 6,
                      decoration: BoxDecoration(
                        color: viewModel.currentIndex == index
                            ? AppColors.primary
                            : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: GestureDetector(
                    onTap: () => viewModel.onNextPressed(),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                             decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xFF675DFF),
                                Color(0xFF4F46E5),
                              ],
                            ),
                          ),
                      child: Center(
                        child: Text(
                          viewModel.isLastPage ? 'Get Started' : 'Next',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: context.primaryTextColor),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),

            // Skip Button
            Positioned(
              top: 10,
              right: 20,
              child: GestureDetector(
                onTap: viewModel.onSkip,
                child: Text(
                  'Skip',
                  style: TextStyle(
                    color: context.primaryTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  OnboardingViewModel viewModelBuilder(BuildContext context) =>
      OnboardingViewModel();
}
