import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

import 'goal_save_detail_viewmodel.dart';

class GoalSaveDetailView extends StackedView<GoalSaveDetailViewModel> {
  final Map<String, dynamic> goal;
  
  const GoalSaveDetailView({super.key, required this.goal});

  @override
  Widget builder(
    BuildContext context,
    GoalSaveDetailViewModel viewModel,
    Widget? child,
  ) {
    final currentAmount = (goal['currentAmount'] as double?) ?? 0.0;
    final targetAmount = (goal['targetAmount'] as double?) ?? 1.0;
    final progress = currentAmount / targetAmount;
    final category = (goal['category'] as String?) ?? 'General';
    final endDate = goal['endDate'] as DateTime?;
    final daysLeft = endDate != null 
        ? endDate.difference(DateTime.now()).inDays
        : 30;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F1F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
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

  Widget _buildTargetHeader(BuildContext context, GoalSaveDetailViewModel viewModel) {
    final currentAmount = (goal['currentAmount'] as double?) ?? 0.0;
    final targetAmount = (goal['targetAmount'] as double?) ?? 1.0;
    final progress = currentAmount / targetAmount;
    final category = (goal['category'] as String?) ?? 'General';
    final endDate = goal['endDate'] as DateTime?;
    final daysLeft = endDate != null 
        ? endDate.difference(DateTime.now()).inDays
        : 30;

    // Get category icon and color
    IconData categoryIcon;
    Color cardColor;
    
    switch (category.toLowerCase()) {
      case 'vacation':
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
      default:
        categoryIcon = Icons.flag;
        cardColor = const Color(0xFF4A4A4A);
    }

    return Container(
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
                      goal['purpose'] ?? 'Goal Save',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'N${currentAmount.toStringAsFixed(0)}',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Saved',
                              style: GoogleFonts.inter(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 24),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'N${targetAmount.toStringAsFixed(0)}',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Total Target',
                              style: GoogleFonts.inter(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '$daysLeft',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Days Left',
                              style: GoogleFonts.inter(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 12,
                              ),
                            ),
                          ],
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
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, GoalSaveDetailViewModel viewModel) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => viewModel.showTopUpDialog(),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF00C851),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.flash_on,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Top Up',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
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
                color: const Color(0xFF1A1A2E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF2A2A3E),
                  width: 1,
                ),
              ),
              child: Text(
                'History',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: Colors.white,
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

  Widget _buildTargetDetails(BuildContext context, GoalSaveDetailViewModel viewModel) {
    final startDate = goal['startDate'] as DateTime?;
    final endDate = goal['endDate'] as DateTime?;
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
                'N${contributionAmount.toStringAsFixed(0)} ${frequency?.toLowerCase() ?? 'manually'}',
                Icons.repeat,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDetailCard(
                'Target Per Member',
                'N${((goal['targetAmount'] as double?) ?? 0.0).toStringAsFixed(0)}',
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
                '12%',
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
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF2A2A3E),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              color: const Color(0xFF8E8E93),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickLinks(BuildContext context, GoalSaveDetailViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Links',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(
                width: 140,
                child: _buildQuickLinkCard(
                  'Lock',
                  Icons.lock,
                  const Color(0xFF00C851),
                  () => viewModel.navigateToLock(),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 140,
                child: _buildQuickLinkCard(
                  'Settings',
                  Icons.settings,
                  const Color(0xFF00C851),
                  () => viewModel.navigateToSettings(),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 140,
                child: _buildQuickLinkCard(
                  'Payment',
                  Icons.payment,
                  const Color(0xFF00C851),
                  () => viewModel.navigateToPayment(),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 140,
                child: _buildQuickLinkCard(
                  'Break',
                  Icons.pause_circle,
                  const Color(0xFF00C851),
                  () => viewModel.navigateToBreak(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickLinkCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF2A2A3E),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLatestActivities(BuildContext context, GoalSaveDetailViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Latest Activities',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF2A2A3E),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              _buildActivityItem(
                'Joined target',
                '2 days ago',
                'JOINED',
                Icons.person_add,
                const Color(0xFF00C851),
              ),
              const Divider(color: Color(0xFF2A2A3E), height: 1),
              _buildActivityItem(
                'Target created',
                '2 days ago',
                'STARTED',
                Icons.flag,
                const Color(0xFF6C5CE7),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(String title, String time, String status, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
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
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  time,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF8E8E93),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
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
      case 1: return 'st';
      case 2: return 'nd';
      case 3: return 'rd';
      default: return 'th';
    }
  }

  String _getMonthName(int month) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month];
  }

  @override
  GoalSaveDetailViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      GoalSaveDetailViewModel();
}
