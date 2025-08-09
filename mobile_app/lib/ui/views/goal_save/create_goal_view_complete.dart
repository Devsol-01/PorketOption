import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/extensions/theme_context_extension.dart';
import 'package:mobile_app/ui/common/app_colors.dart';
import 'package:stacked/stacked.dart';

import 'create_goal_viewmodel.dart';

class CreateGoalView extends StackedView<CreateGoalViewModel> {
  const CreateGoalView({super.key});

  @override
  Widget builder(
    BuildContext context,
    CreateGoalViewModel viewModel,
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
          onPressed: () => viewModel.navigateBack(),
        ),
        title: Text(
          'Create Goal',
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
              // Goal Purpose
              Text(
                'Goal Purpose',
                style: GoogleFonts.inter(
                  color: context.primaryTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: viewModel.purposeController,
                style: GoogleFonts.inter(color: context.primaryTextColor),
                decoration: InputDecoration(
                  hintText: 'e.g., Dream Vacation to Bali',
                  hintStyle:
                      GoogleFonts.inter(color: context.secondaryTextColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: context.cardBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: primary),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Category Selection
              Text(
                'Category',
                style: GoogleFonts.inter(
                  color: context.primaryTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  'Vacation',
                  'Emergency',
                  'Car',
                  'Rent',
                  'Education',
                  'Business',
                  'Events',
                  'Gadgets',
                  'Other'
                ]
                    .map((category) => GestureDetector(
                          onTap: () => viewModel.selectCategory(category),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: viewModel.selectedCategory == category
                                  ? primary
                                  : context.cardColor,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: viewModel.selectedCategory == category
                                    ? primary
                                    : context.cardBorder,
                              ),
                            ),
                            child: Text(
                              category,
                              style: GoogleFonts.inter(
                                color: viewModel.selectedCategory == category
                                    ? Colors.white
                                    : context.primaryTextColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),

              const SizedBox(height: 24),

              // Target Amount
              Text(
                'Target Amount',
                style: GoogleFonts.inter(
                  color: context.primaryTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: viewModel.targetAmountController,
                keyboardType: TextInputType.number,
                style: GoogleFonts.inter(color: context.primaryTextColor),
                decoration: InputDecoration(
                  prefixText: '\$',
                  prefixStyle:
                      GoogleFonts.inter(color: context.primaryTextColor),
                  hintText: 'Enter target amount',
                  hintStyle:
                      GoogleFonts.inter(color: context.secondaryTextColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: context.cardBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: primary),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Contribution Amount
              Text(
                'Contribution Amount',
                style: GoogleFonts.inter(
                  color: context.primaryTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: viewModel.contributionController,
                keyboardType: TextInputType.number,
                style: GoogleFonts.inter(color: context.primaryTextColor),
                decoration: InputDecoration(
                  prefixText: '\$',
                  prefixStyle:
                      GoogleFonts.inter(color: context.primaryTextColor),
                  hintText: 'Amount per contribution',
                  hintStyle:
                      GoogleFonts.inter(color: context.secondaryTextColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: context.cardBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: primary),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Frequency Selection
              Text(
                'Frequency',
                style: GoogleFonts.inter(
                  color: context.primaryTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: ['Daily', 'Weekly', 'Monthly', 'Manual']
                    .map((frequency) => Expanded(
                          child: GestureDetector(
                            onTap: () => viewModel.selectFrequency(frequency),
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: viewModel.selectedFrequency == frequency
                                    ? primary
                                    : context.cardColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color:
                                      viewModel.selectedFrequency == frequency
                                          ? primary
                                          : context.cardBorder,
                                ),
                              ),
                              child: Text(
                                frequency,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  color:
                                      viewModel.selectedFrequency == frequency
                                          ? Colors.white
                                          : context.primaryTextColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),

              const SizedBox(height: 24),

              // Fund Source
              Text(
                'Fund Source',
                style: GoogleFonts.inter(
                  color: context.primaryTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Column(
                children: ['Porket Wallet', 'External Wallet', 'Add Card']
                    .map((source) => GestureDetector(
                          onTap: () => viewModel.selectFundSource(source),
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: context.cardColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: viewModel.selectedFundSource == source
                                    ? primary
                                    : context.cardBorder,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  viewModel.selectedFundSource == source
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_unchecked,
                                  color: viewModel.selectedFundSource == source
                                      ? primary
                                      : context.secondaryTextColor,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  source,
                                  style: GoogleFonts.inter(
                                    color: context.primaryTextColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              ),

              const SizedBox(height: 24),

              // Date Selection
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Start Date',
                          style: GoogleFonts.inter(
                            color: context.primaryTextColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => viewModel.selectStartDate(context),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: context.cardColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: context.cardBorder),
                            ),
                            child: Text(
                              viewModel.startDate != null
                                  ? '${viewModel.startDate!.day}/${viewModel.startDate!.month}/${viewModel.startDate!.year}'
                                  : 'Select date',
                              style: GoogleFonts.inter(
                                color: viewModel.startDate != null
                                    ? context.primaryTextColor
                                    : context.secondaryTextColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'End Date',
                          style: GoogleFonts.inter(
                            color: context.primaryTextColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => viewModel.selectEndDate(context),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: context.cardColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: context.cardBorder),
                            ),
                            child: Text(
                              viewModel.endDate != null
                                  ? '${viewModel.endDate!.day}/${viewModel.endDate!.month}/${viewModel.endDate!.year}'
                                  : 'Select date',
                              style: GoogleFonts.inter(
                                color: viewModel.endDate != null
                                    ? context.primaryTextColor
                                    : context.secondaryTextColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Terms and Conditions
              Row(
                children: [
                  Checkbox(
                    value: viewModel.isTermsAccepted,
                    onChanged: (value) => viewModel.toggleTermsAcceptance(),
                    activeColor: primary,
                  ),
                  Expanded(
                    child: Text(
                      'I agree to the terms and conditions',
                      style: GoogleFonts.inter(
                        color: context.primaryTextColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Create Goal Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed:
                      viewModel.canCreateGoal ? viewModel.createGoal : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    disabledBackgroundColor: primary.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Create Goal',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  @override
  CreateGoalViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      CreateGoalViewModel();
}
