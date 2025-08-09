import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/extensions/theme_context_extension.dart';
import 'package:mobile_app/ui/common/app_colors.dart';
import 'package:stacked/stacked.dart';

import 'group_save_viewmodel.dart';

class GroupSaveView extends StackedView<GroupSaveViewModel> {
  const GroupSaveView({super.key});

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
            size: 24,
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
        actions: [
          IconButton(
            icon: Icon(
              Icons.info_outline,
              color: context.primaryTextColor,
              size: 24,
            ),
            onPressed: () => print('Info tapped'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Balance Card
              _buildBalanceCard(context),
              const SizedBox(height: 20),

              // Create Group Save Button
              _buildCreateGroupSaveButton(context, viewModel),
              const SizedBox(height: 24),

              // Promoted Savings Section
              _buildPromotedSavingsSection(context, viewModel),
              const SizedBox(height: 24),

              // Live/Completed Toggle
              _buildToggleTabs(context, viewModel),
              const SizedBox(height: 16),

              // Target List
              SizedBox(
                height: 400, // Fixed height for the list
                child: viewModel.isOngoingSelected
                    ? _buildLiveTargets(context, viewModel)
                    : _buildCompletedTargets(context, viewModel),
              ),
            ],
          ),
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
    return GestureDetector(
      onTap: viewModel.createGroupSave,
      child: Container(
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
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward,
              color: primary,
              size: 16,
            ),
          ],
        ),
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

  Widget _buildToggleTabs(BuildContext context, GroupSaveViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => viewModel.setOngoingSelected(true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: viewModel.isOngoingSelected
                      ? const Color(0xFF6C5CE7)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Live',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: viewModel.isOngoingSelected
                        ? Colors.white
                        : const Color(0xFF8E8E93),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => viewModel.setOngoingSelected(false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !viewModel.isOngoingSelected
                      ? const Color(0xFF6C5CE7)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Completed',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: !viewModel.isOngoingSelected
                        ? Colors.white
                        : const Color(0xFF8E8E93),
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

  Widget _buildLiveTargets(BuildContext context, GroupSaveViewModel viewModel) {
    if (viewModel.liveGroups.isEmpty) {
      return _buildEmptyState('No live targets yet', 'Create your first group save to get started');
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: viewModel.liveGroups.length,
      itemBuilder: (context, index) {
        final group = viewModel.liveGroups[index];
        return _buildGroupCard(context, group, viewModel);
      },
    );
  }

  Widget _buildCompletedTargets(BuildContext context, GroupSaveViewModel viewModel) {
    if (viewModel.completedGroups.isEmpty) {
      return _buildEmptyState('No completed targets yet', 'Complete some groups to see them here');
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: viewModel.completedGroups.length,
      itemBuilder: (context, index) {
        final group = viewModel.completedGroups[index];
        return _buildGroupCard(context, group, viewModel);
      },
    );
  }

  Widget _buildGroupCard(BuildContext context, Map<String, dynamic> group, GroupSaveViewModel viewModel) {
    final currentAmount = (group['currentAmount'] as double?) ?? 0.0;
    final targetAmount = (group['targetAmount'] as double?) ?? 1.0;
    final progress = currentAmount / targetAmount;
    final category = (group['category'] as String?) ?? 'General';
    final endDate = group['endDate'] as DateTime?;
    final daysLeft = endDate != null 
        ? endDate.difference(DateTime.now()).inDays
        : 30;
    
    // Get category icon and color based on group type
    IconData categoryIcon;
    Color cardColor;
    
    switch (category.toLowerCase()) {
      case 'education':
        categoryIcon = Icons.school;
        cardColor = const Color(0xFF00C851); // Green like "Back to School 2025"
        break;
      case 'vacation':
        categoryIcon = Icons.flight;
        cardColor = const Color(0xFF6C5CE7); // Purple
        break;
      case 'business':
        categoryIcon = Icons.business;
        cardColor = const Color(0xFF4A4A4A); // Dark
        break;
      case 'emergency':
        categoryIcon = Icons.medical_services;
        cardColor = const Color(0xFFFF6B6B); // Red
        break;
      default:
        categoryIcon = Icons.group;
        cardColor = const Color(0xFF00C851); // Default green
    }
    
    return GestureDetector(
      onTap: () => viewModel.navigateToGroupDetail(group),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    categoryIcon,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group['name'] ?? 'Group Save',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'N${(currentAmount / 1000).toStringAsFixed(0)}K',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'N${(targetAmount / 1000).toStringAsFixed(0)}K',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '$daysLeft',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Total Saved',
                              style: GoogleFonts.inter(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Target Amount',
                              style: GoogleFonts.inter(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Days Left',
                              textAlign: TextAlign.end,
                              style: GoogleFonts.inter(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Progress bar
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress > 1.0 ? 1.0 : progress,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2E),
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(
              Icons.group,
              size: 40,
              color: Color(0xFF8E8E93),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              color: const Color(0xFF8E8E93),
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
