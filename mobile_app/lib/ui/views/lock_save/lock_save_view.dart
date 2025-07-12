import 'package:flutter/material.dart';
import 'package:mobile_app/extensions/theme_context_extension.dart';
import 'package:mobile_app/ui/common/app_colors.dart';
import 'package:stacked/stacked.dart';

import 'lock_save_viewmodel.dart';

class LockSaveView extends StackedView<LockSaveViewModel> {
  const LockSaveView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    LockSaveViewModel viewModel,
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
          'Lock Save',
          style: TextStyle(
            color: context.primaryTextColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
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
                    '8.7% per annum',
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
                        'Lock Save Balance',
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

            // Create Lock Save Button
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
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Create a Lock Save',
                    style: TextStyle(
                      color: primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward,
                    color: primary,
                    size: 16,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Recommendations Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recommendations',
                  style: TextStyle(
                    color: context.primaryTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    const Text(
                      'More options',
                      style: TextStyle(
                        color: primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward,
                      color: primary,
                      size: 14,
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Recommendation Cards
            SizedBox(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildRecommendationCard(
                    earnings: '\$2,325',
                    lockAmount: '\$15,000',
                    duration: '365 days',
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF5C79FF), Color(0xFF4A6CFF)],
                    ),
                  ),
                  const SizedBox(width: 16),
                  _buildRecommendationCard(
                    earnings: '\$2,383',
                    lockAmount: '\$50,000',
                    duration: '120 days',
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFA45EFF), Color(0xFF7B46F5)],
                    ),
                  ),
                  const SizedBox(width: 16),
                  _buildRecommendationCard(
                    earnings: '\$1,200',
                    lockAmount: '\$25,000',
                    duration: '180 days',
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF4CAF50), Color(0xFF388E3C)],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

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
                      Icons.lock_outline,
                      size: 24,
                      color: context.secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No ongoing lock save',
                    style: TextStyle(
                      color: context.primaryTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create your first lock save to get started',
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
    );
  }

  Widget _buildRecommendationCard({
    required String earnings,
    required String lockAmount,
    required String duration,
    required LinearGradient gradient,
  }) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Text(
              'Earn $earnings',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Lock $lockAmount',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'For $duration',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  @override
  LockSaveViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      LockSaveViewModel();
}
