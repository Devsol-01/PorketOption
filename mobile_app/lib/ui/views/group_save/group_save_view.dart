import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/extensions/theme_context_extension.dart';
import 'package:mobile_app/ui/common/app_colors.dart';
import 'package:stacked/stacked.dart';

import 'group_save_viewmodel.dart';

class GroupSaveView extends StackedView<GroupSaveViewModel> {
  const GroupSaveView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    GroupSaveViewModel viewModel,
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
          'Group Save',
          style: GoogleFonts.inter(
            color: context.primaryTextColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Balance Card
            _buildBalanceCard(context),
            const SizedBox(height: 20),

            // Create Group Save Button
            _buildCreateGroupSaveButton(context, viewModel),
            const SizedBox(height: 30),

            // Promoted Savings Groups Section
            _buildPromotedSavingsSection(context, viewModel),
            const SizedBox(height: 30),

            // Live/Complete Toggle
            _buildLiveCompleteToggle(context, viewModel),
            const SizedBox(height: 30),

            // Empty State
            _buildEmptyState(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: context.balanceCardGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '5.8% per annum',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
               Text(
                'Group Save Balance',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.visibility,
                color: Colors.white.withOpacity(0.8),
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '\$0',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateGroupSaveButton(
      BuildContext context, GroupSaveViewModel viewModel) {
    return Container(
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
            'Create a Group Save',
            style: GoogleFonts.inter(
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
    );
  }

  Widget _buildPromotedSavingsSection(
      BuildContext context, GroupSaveViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Promoted Savings Groups',
              style: GoogleFonts.inter(
                color: context.primaryTextColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            GestureDetector(
              onTap: () => viewModel.findMoreGroups(),
              child: Row(
                children: [
                  Text(
                    'Find More',
                    style: GoogleFonts.inter(
                      color: context.isDarkMode
                          ? Colors.blue.shade300
                          : Colors.blue.shade600,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward,
                    color: context.isDarkMode
                        ? Colors.blue.shade300
                        : Colors.blue.shade600,
                    size: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 240,
          child: Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                GestureDetector(
                  onTap: () => viewModel.joinSavingsGroup('1'),
                  child: _buildSavingsGroupCard(
                    context,
                    title: 'Back to School',
                    amount: '\$250K each',
                    members: '2,940 members',
                    icon: '🎒',
                    iconBackground: Colors.red.shade400,
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () => viewModel.joinSavingsGroup('2'),
                  child: _buildSavingsGroupCard(
                    context,
                    title: 'Travel \'25',
                    amount: '\$4M each',
                    members: '398 members',
                    icon: '✈️',
                    iconBackground: Colors.blue.shade400,
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () => viewModel.joinSavingsGroup('3'),
                  child: _buildSavingsGroupCard(
                    context,
                    title: 'Dream Car Fund',
                    amount: '\$1.2M each',
                    members: '1,567 members',
                    icon: '🚗',
                    iconBackground: Colors.purple.shade400,
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () => viewModel.joinSavingsGroup('4'),
                  child: _buildSavingsGroupCard(
                    context,
                    title: 'Home Savings',
                    amount: '\$5M each',
                    members: '892 members',
                    icon: '🏠',
                    iconBackground: Colors.orange.shade400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSavingsGroupCard(
    BuildContext context, {
    required String title,
    required String amount,
    required String members,
    required String icon,
    required Color iconBackground,
  }) {
    return Container(
      width: 180,
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.cardBorder,
          width: context.isDarkMode ? 1 : 0,
        ),
        boxShadow: context.isDarkMode
            ? null
            : [
                BoxShadow(
                  color: context.cardShadow,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon container
          Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Center(
              child: Text(
                icon,
                style: GoogleFonts.inter(fontSize: 40),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Amount badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade400,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    amount,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Title
                Text(
                  title,
                  style: GoogleFonts.inter(
                    color: context.primaryTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                // Members
                Text(
                  members,
                  style: GoogleFonts.inter(
                    color: context.secondaryTextColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveCompleteToggle(
      BuildContext context, GroupSaveViewModel viewModel) {
    return // Tab Section
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
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: context.isDarkMode
                  ? Colors.grey.shade800
                  : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(
              Icons.group,
              size: 40,
              color: context.isDarkMode
                  ? Colors.grey.shade600
                  : Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No ongoing group save',
            style: GoogleFonts.inter(
              color: context.primaryTextColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first group save to get started',
            style: GoogleFonts.inter(
              color: context.secondaryTextColor,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  GroupSaveViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      GroupSaveViewModel();
}
