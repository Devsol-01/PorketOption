import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'package:mobile_app/utils/format_utils.dart';

import 'goal_save_details_viewmodel.dart';

class GoalSaveDetailsView extends StackedView<GoalSaveDetailsViewModel> {
  final Map<String, dynamic> goal;

  const GoalSaveDetailsView({Key? key, required this.goal}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    GoalSaveDetailsViewModel viewModel,
    Widget? child,
  ) {
    // Variables used in the main builder method are handled in _buildTargetHeader

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 24,
          ),
          onPressed: () => viewModel.navigateBack(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Target Header Card
            _buildTargetHeader(context, viewModel),

            const SizedBox(height: 20),

            // Action Buttons
            _buildActionButtons(context, viewModel),

            const SizedBox(height: 24),

            // Target Details
            _buildTargetDetails(context, viewModel),

            const SizedBox(height: 24),

            // Quick Links
            _buildQuickLinks(context, viewModel),

            const SizedBox(height: 24),

            // Latest Activities
            _buildLatestActivities(context, viewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildTargetHeader(
      BuildContext context, GoalSaveDetailsViewModel viewModel) {
    final currentAmount = (goal['currentAmount'] as double?) ?? 0.0;
    final targetAmount = (goal['targetAmount'] as double?) ?? 1.0;
    final category = (goal['category'] as String?) ?? 'General';
    final endDateString = goal['endDate'] as String?;
    final endDate =
        endDateString != null ? DateTime.tryParse(endDateString) : null;
    final daysLeft =
        endDate != null ? endDate.difference(DateTime.now()).inDays : 30;

    // Category icon + color
    IconData categoryIcon;
    Color cardColor;

    switch (category.toLowerCase()) {
      
      case 'education':
        categoryIcon = Icons.school;
        cardColor = const Color(0xFF00C851);
        break;
      case 'car':
        categoryIcon = Icons.directions_car;
        cardColor = const Color(0xFF00C851);
        break;
      case 'rent':
        categoryIcon = Icons.home;
        cardColor = const Color(0xFF8B4513);
        break;
      case 'business':
        categoryIcon = Icons.flash_on;
        cardColor = const Color(0xFF4A4A4A);
        break;
      case 'gadgets':
        categoryIcon = Icons.phone_android;
        cardColor = const Color(0xFF6C5CE7);
        break;
      case 'emergency':
        categoryIcon = Icons.medical_services;
        cardColor = const Color(0xFFFF6B6B);
        break;
      case 'events':
        categoryIcon = Icons.event;
        cardColor = const Color(0xFFB39DDB);
        break;
        case 'vacation':
        categoryIcon = Icons.flight;
        cardColor = const Color(0xFF4A90E2);
      default:
        categoryIcon = Icons.flag;
        cardColor = const Color(0xFF4A4A4A);
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon container
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              categoryIcon,
              color: Colors.purple,
              size: 26,
            ),
          ),
          const SizedBox(width: 16),

          // Goal details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  goal['title'] ?? goal['purpose'] ?? 'Goal Save',
                  style: GoogleFonts.inter(
                    color: Colors.black87,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Stats row (same as card style)
                Row(
                  children: [
                    _buildHeaderStat(
                      label: "Saved",
                      value: FormatUtils.formatCurrency(currentAmount),
                    ),
                    const SizedBox(width: 25),
                    _buildHeaderStat(
                      label: "Target",
                      value: FormatUtils.formatCurrency(targetAmount),
                    ),
                    const SizedBox(width: 25),
                    _buildHeaderStat(
                      label: "Days Left",
                      value: "$daysLeft",
                      alignRight: false,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStat({
    required String label,
    required String value,
    bool alignRight = false,
  }) {
    return Column(
      crossAxisAlignment:
          alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: Colors.grey.shade600,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.inter(
            color: Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(
      BuildContext context, GoalSaveDetailsViewModel viewModel) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => viewModel.showTopUpDialog(context, goal),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF8A38F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'Top Up ⚡️',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: () => viewModel.navigateToHistory(),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF8A38F5),
                  width: 1,
                ),
              ),
              child: Text(
                'History',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: Color(0xFF8A38F5),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTargetDetails(
      BuildContext context, GoalSaveDetailsViewModel viewModel) {
    final startDateString = goal['startDate'] as String?;
    final startDate =
        startDateString != null ? DateTime.tryParse(startDateString) : null;
    final endDateString = goal['endDate'] as String?;
    final endDate =
        endDateString != null ? DateTime.tryParse(endDateString) : null;
    final frequency = goal['frequency'] as String?;
    final contributionAmount = (goal['contributionAmount'] as double?) ?? 0.0;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildDetailCard(
                'Start Date',
                startDate != null
                    ? '${startDate.day}${_getOrdinalSuffix(startDate.day)} ${_getMonthName(startDate.month)} ${startDate.year}'
                    : '6th Aug 2025',
                Icons.calendar_today,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDetailCard(
                'Withdrawal Date',
                endDate != null
                    ? '${endDate.day}${_getOrdinalSuffix(endDate.day)} ${_getMonthName(endDate.month)} ${endDate.year}'
                    : '9th Sep 2025',
                Icons.calendar_month,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildDetailCard(
                'Frequency',
                '${FormatUtils.formatCurrency(contributionAmount)} ${frequency?.toLowerCase() ?? 'manually'}',
                Icons.repeat,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDetailCard(
                'Target Per Member',
                '\$${((goal['targetAmount'] as double?) ?? 0.0).toStringAsFixed(0)}',
                Icons.person,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildDetailCard(
                'Interest Per Annum',
                '${((goal['interestRate'] as double?) ?? 12.0).toStringAsFixed(1)}%',
                Icons.trending_up,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDetailCard(
                'Days Left',
                '${endDate != null ? endDate.difference(DateTime.now()).inDays : 33}',
                Icons.access_time,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: GoogleFonts.inter(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: GoogleFonts.inter(
              color: Colors.grey[600],
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickLinks(
      BuildContext context, GoalSaveDetailsViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Links',
          style: GoogleFonts.inter(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(
                width: 160,
                child: _buildQuickLinkCard(
                  'Lock',
                  Icons.lock,
                  const Color(0xFF8A38F5),
                  () => viewModel.navigateToLock(),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 140,
                child: _buildQuickLinkCard(
                  'Break',
                  Icons.pause_circle,
                  const Color(0xFF8A38F5),
                  () => viewModel.navigateToBreak(),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 140,
                child: _buildQuickLinkCard(
                  'Settings',
                  Icons.settings,
                  const Color(0xFF8A38F5),
                  () => viewModel.navigateToSettings(),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 140,
                child: _buildQuickLinkCard(
                  'Payment',
                  Icons.payment,
                  const Color(0xFF8A38F5),
                  () => viewModel.navigateToUpdatePayment(),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 140,
                child: _buildQuickLinkCard(
                  'Break',
                  Icons.pause_circle,
                  const Color(0xFF8A38F5),
                  () => viewModel.navigateToBreak(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickLinkCard(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 130,
        width: 220,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(1, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.inter(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLatestActivities(
      BuildContext context, GoalSaveDetailsViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Latest Activities',
          style: GoogleFonts.inter(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildActivityItem(
                'Joined target',
                '2 days ago',
                'JOINED',
                Icons.person_add,
                Color(0xFF8A38F5),
              ),
              const Divider(color: Color(0xFFEAEAEA), height: 1),
              _buildActivityItem(
                'Target created',
                '2 days ago',
                'STARTED',
                Icons.flag,
                Color(0xFF8A38F5),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(
      String title, String time, String status, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  time,
                  style: GoogleFonts.inter(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: GoogleFonts.inter(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getOrdinalSuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  String _getMonthName(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month];
  }

  @override
  GoalSaveDetailsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      GoalSaveDetailsViewModel();
}
