import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/extensions/theme_context_extension.dart';
import 'package:mobile_app/ui/common/app_colors.dart';
import 'package:stacked/stacked.dart';

import 'lock_preview_viewmodel.dart';

class LockPreviewView extends StackedView<LockPreviewViewModel> {
  final Map<String, dynamic> lockData;

  const LockPreviewView({
    super.key,
    required this.lockData,
  });

  @override
  Widget builder(
    BuildContext context,
    LockPreviewViewModel viewModel,
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
        actions: [
          IconButton(
            icon: Icon(
              Icons.info_outline,
              color: context.primaryTextColor,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header with lock icon and title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: context.cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.lock,
                      color: primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Safelock Preview For',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: context.secondaryTextColor,
                          ),
                        ),
                        Text(
                          lockData['title'],
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: context.primaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: context.tabBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => viewModel.setInterestUpfront(true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: viewModel.isInterestUpfront
                                ? Colors.transparent
                                : primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Interest Upfront',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: viewModel.isInterestUpfront
                                  ? context.secondaryTextColor
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => viewModel.setInterestUpfront(false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !viewModel.isInterestUpfront
                                ? Colors.transparent
                                : primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Interest @ Maturity',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: !viewModel.isInterestUpfront
                                  ? context.secondaryTextColor
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Preview Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Amount and Interest Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildDetailCard(
                            context,
                            'Amount To Lock',
                            '₦${lockData['amount'].toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildDetailCard(
                            context,
                            'Interest',
                            '${lockData['selectedOption']['interestRate'].toStringAsFixed(3)}%',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Interest Amount and Maturity Date Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildDetailCard(
                            context,
                            viewModel.isInterestUpfront
                                ? 'Interest (paid upfront)'
                                : 'Interest (@ maturity)',
                            '₦${lockData['selectedOption']['interestAmount'].toStringAsFixed(2)}',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildDetailCard(
                            context,
                            'Maturity/Payback Date',
                            lockData['selectedOption']['date'],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Lock Duration and Destination Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildDetailCard(
                            context,
                            'Lock Duration',
                            '${lockData['days']} days',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildDetailCard(
                            context,
                            'Matures Into Your',
                            'PiggyFlex',
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Terms and Conditions
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: context.cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: context.cardBorder,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: viewModel.agreedToTerms1,
                                onChanged: (value) =>
                                    viewModel.setAgreedToTerms1(value ?? false),
                                activeColor: primary,
                              ),
                              Expanded(
                                child: Text(
                                  'I authorize Piggyvest to SafeLock ₦${lockData['amount'].toStringAsFixed(0)} immediately and return it in full on ${lockData['selectedOption']['date']} by 10:40 PM to my PiggyFlex. I confirm and approve this transaction.',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: context.primaryTextColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Checkbox(
                                value: viewModel.agreedToTerms2,
                                onChanged: (value) =>
                                    viewModel.setAgreedToTerms2(value ?? false),
                                activeColor: primary,
                              ),
                              Expanded(
                                child: Text(
                                  viewModel.isInterestUpfront
                                      ? 'Because interest will be paid to me UPFRONT, I hereby acknowledge that this SafeLock CANNOT be broken once it has been created until the end of the maturity period I have set.'
                                      : 'I acknowledge that my CAPITAL and INTEREST from this Safelock will be paid ONLY at MATURITY. I understand that this Safelock CANNOT be BROKEN for at least 33 DAYS after it is created.',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: context.primaryTextColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Create SafeLock Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: viewModel.canCreateLock
                            ? () => viewModel.createSafeLock(lockData)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Create Safelock',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(BuildContext context, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.cardBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: context.secondaryTextColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: context.primaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  LockPreviewViewModel viewModelBuilder(BuildContext context) =>
      LockPreviewViewModel();
}
