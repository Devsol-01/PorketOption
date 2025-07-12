import 'package:flutter/material.dart';
import 'package:mobile_app/extensions/theme_context_extension.dart';
import 'package:mobile_app/ui/common/app_colors.dart';
import 'package:stacked/stacked.dart';

import 'flexi_save_viewmodel.dart';

class FlexiSaveView extends StackedView<FlexiSaveViewModel> {
  const FlexiSaveView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    FlexiSaveViewModel viewModel,
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
          onPressed: () => viewModel.navigateBack()
        ),
        title: Text(
          'Flexible Savings',
          style: TextStyle(
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
                    const Text(
                      '4.5% per annum',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text(
                          'Flexible Savings Balance',
                          style: TextStyle(
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
                    const Text(
                      '\$0',
                      style: TextStyle(
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
                    Row(
                      children: [
                        Text(
                          'AutoSave is enabled',
                          style: TextStyle(
                            color: context.primaryTextColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '⚡',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Your next AutoSave deposit is scheduled to be on Thursday 3rd of July 2025, by 8:00:00 AM',
                      style: TextStyle(
                        color: context.secondaryTextColor,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'AutoSave Amount: \$1,000 daily',
                          style: TextStyle(
                            color: context.primaryTextColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Switch(
                          splashRadius: 30.0,
                          value: viewModel.isAutoSaveEnabled,
                          onChanged: viewModel.toggleAutoSave,
                          activeColor: primary,
                          activeTrackColor: primary.withOpacity(0.3),
                          inactiveThumbColor: context.secondaryTextColor,
                          inactiveTrackColor:
                              context.secondaryTextColor.withOpacity(0.3),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      context,
                      icon: Icons.add,
                      label: 'Quick Save',
                      backgroundColor: context.actionButtonBackground,
                      iconColor: primary,
                      textColor: context.primaryTextColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionButton(
                      context,
                      icon: Icons.attach_money,
                      label: 'Withdraw',
                      backgroundColor: primary,
                      iconColor: Colors.white,
                      textColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionButton(
                      context,
                      icon: Icons.settings,
                      label: 'Settings',
                      backgroundColor: context.actionButtonBackground,
                      iconColor: context.secondaryTextColor,
                      textColor: context.primaryTextColor,
                    ),
                  ),
                ],
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
                    const Text(
                      'Create a Flexible Savings',
                      style: TextStyle(
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
                            'Ongoing',
                            textAlign: TextAlign.center,
                            style: TextStyle(
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
                            'Paid Back',
                            textAlign: TextAlign.center,
                            style: TextStyle(
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
                      'No ongoing flexible savings',
                      style: TextStyle(
                        color: context.primaryTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Create your first flexible savings to get started',
                      style: TextStyle(
                        color: context.secondaryTextColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color backgroundColor,
    required Color iconColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: context.cardBorder,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  FlexiSaveViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      FlexiSaveViewModel();
}
