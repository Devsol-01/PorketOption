import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/extensions/theme_context_extension.dart';
import 'package:mobile_app/ui/common/app_colors.dart';
import 'package:stacked/stacked.dart';

import 'goal_save_viewmodel.dart';

class GoalSaveView extends StackedView<GoalSaveViewModel> {
  const GoalSaveView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    GoalSaveViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        backgroundColor: context.backgroundColor,
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: context.primaryTextColor,
            ),
            onPressed: () => viewModel.navigateBack()),
        title: Text(
          'Goal Savings',
          style: GoogleFonts.inter(
            color: context.primaryTextColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Balance Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  gradient: context.balanceCardGradient,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '4.5% per annum',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          'Goal Savings Balance',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.visibility,
                          color: Colors.white.withOpacity(0.8),
                          size: 16,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$0',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // AutoSave Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: context.backgroundColor,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color: const Color.fromARGB(255, 210, 210, 210),
                    width: 0.5,
                  ),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: context.cardShadow,
                  //     blurRadius: 8,
                  //     offset: const Offset(0, 2),
                  //   ),
                  // ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'What is Goal Savings?',
                      style: GoogleFonts.inter(
                        color: context.primaryTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Target Savings is a great way to save towards a specific goal or target.\n \nYou can set up automatic savings to help you reach your goal faster.',
                      style: GoogleFonts.inter(
                        color: context.secondaryTextColor,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Create Flexible Savings Button
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color: context.cardBorder,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: context.cardShadow,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Create a Goal Save',
                      style: GoogleFonts.inter(
                        color: primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward,
                      color: primary,
                      size: 16,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Tab Section
              Container(
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: context.tabBackground,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          viewModel.setOngoingSelected(true);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          decoration: BoxDecoration(
                            color: viewModel.isOngoingSelected
                                ? primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            'Live',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: viewModel.isOngoingSelected
                                  ? Colors.white
                                  : context.secondaryTextColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          viewModel.setOngoingSelected(false);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          decoration: BoxDecoration(
                            color: !viewModel.isOngoingSelected
                                ? primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            'Completed',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: !viewModel.isOngoingSelected
                                  ? Colors.white
                                  : context.secondaryTextColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Empty State
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: context.actionButtonBackground,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Icon(
                        Icons.savings_outlined,
                        size: 24,
                        color: context.secondaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No ongoing goal savings',
                      style: GoogleFonts.inter(
                        color: context.primaryTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
            onPressed: () {}, child: const Icon(Icons.add)),
      ),
    );
  }

  @override
  GoalSaveViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      GoalSaveViewModel();
}
