import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

import 'group_save_details_viewmodel.dart';

class GroupSaveDetailsView extends StackedView<GroupSaveDetailsViewModel> {
  final Map<String, dynamic> group;
  const GroupSaveDetailsView({Key? key, required this.group}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    GroupSaveDetailsViewModel viewModel,
    Widget? child,
  ) {
    // Variables used in the main builder method are handled in _buildGroupHeader

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
            // Group Header Card
            _buildGroupHeader(context, viewModel),
            
            const SizedBox(height: 20),
            
            // Leaderboard and Members
            _buildLeaderboardAndMembers(context, viewModel),
            
            const SizedBox(height: 20),
            
            // Action Buttons
            _buildActionButtons(context, viewModel),
            
            const SizedBox(height: 24),
            
            // Group Details
            _buildGroupDetails(context, viewModel),
            
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

  Widget _buildGroupHeader(BuildContext context, GroupSaveDetailsViewModel viewModel) {
    final memberCount = (group['memberCount'] as int?) ?? 6515;
    final totalSaved = (group['totalSaved'] as double?) ?? 229200.0;
    final endDateString = group['endDate'] as String?;
    final endDate = endDateString != null ? DateTime.tryParse(endDateString) : null;
    final daysLeft = endDate != null 
        ? endDate.difference(DateTime.now()).inDays
        : 31;
    final progress = (group['progress'] as double?) ?? 0.14;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF00C851),
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
                child: const Icon(
                  Icons.school,
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
                      group['name'] ?? 'Back to School 2025',
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
                              '${memberCount.toString()}',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Members',
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
                              'N${(totalSaved / 1000).toStringAsFixed(0)}K',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Total Saved',
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

  Widget _buildLeaderboardAndMembers(BuildContext context, GroupSaveDetailsViewModel viewModel) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => viewModel.navigateToLeaderboard(),
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
              child: Row(
                children: [
                  Text(
                    'Leaderboard',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '🔥',
                    style: TextStyle(fontSize: 16),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFF8E8E93),
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: () => viewModel.navigateToMembers(),
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
              child: Row(
                children: [
                  Text(
                    'Members',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFF8E8E93),
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, GroupSaveDetailsViewModel viewModel) {
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

    Widget _buildGroupDetails(BuildContext context, GroupSaveDetailsViewModel viewModel) {
    final startDateString = group['startDate'] as String?;
    final startDate = startDateString != null ? DateTime.tryParse(startDateString) : null;
    final endDateString = group['endDate'] as String?;
    final endDate = endDateString != null ? DateTime.tryParse(endDateString) : null;
    final frequency = group['frequency'] as String?;
    final contributionAmount = (group['contributionAmount'] as double?) ?? 2976.0;
    final targetPerMember = (group['targetPerMember'] as double?) ?? 250000.0;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildDetailCard(
                'Start Date',
                startDate != null 
                    ? '${startDate.day}${_getOrdinalSuffix(startDate.day)} ${_getMonthName(startDate.month)} ${startDate.year}'
                    : '15th Jun 2025',
                Icons.calendar_today,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDetailCard(
                'Withdrawal Date',
                endDate != null 
                    ? '${endDate.day}${_getOrdinalSuffix(endDate.day)} ${_getMonthName(endDate.month)} ${endDate.year}'
                    : '7th Sep 2025',
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
                'N${contributionAmount.toStringAsFixed(0)} ${frequency?.toLowerCase() ?? 'daily'}',
                Icons.repeat,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDetailCard(
                'Target Per Member',
                'N${(targetPerMember / 1000).toStringAsFixed(0)}K',
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
                '${endDate != null ? endDate.difference(DateTime.now()).inDays : 31}',
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

  Widget _buildQuickLinks(BuildContext context, GroupSaveDetailsViewModel viewModel) {
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
                  'Invite Users',
                  Icons.person_add,
                  const Color(0xFF00C851),
                  () => viewModel.navigateToInvite(),
                ),
              ),
              const SizedBox(width: 16),
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

  Widget _buildLatestActivities(BuildContext context, GroupSaveDetailsViewModel viewModel) {
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
                'Target funded',
                '4 minutes ago',
                'N20,000',
                Icons.account_balance_wallet,
                const Color(0xFF00C851),
                showAmount: true,
              ),
              const Divider(color: Color(0xFF2A2A3E), height: 1),
              _buildActivityItem(
                'Target funded',
                '7 minutes ago',
                'N5,000',
                Icons.account_balance_wallet,
                const Color(0xFF00C851),
                showAmount: true,
                showAvatar: true,
              ),
              const Divider(color: Color(0xFF2A2A3E), height: 1),
              _buildActivityItem(
                'Target funded',
                '7 minutes ago',
                'N70,000',
                Icons.account_balance_wallet,
                const Color(0xFF00C851),
                showAmount: true,
              ),
              const Divider(color: Color(0xFF2A2A3E), height: 1),
              _buildActivityItem(
                'Target funded',
                '12 minutes ago',
                'N100,000',
                Icons.account_balance_wallet,
                const Color(0xFF00C851),
                showAmount: true,
              ),
              const Divider(color: Color(0xFF2A2A3E), height: 1),
              _buildActivityItem(
                'Joined target',
                '14 minutes ago',
                'JOINED',
                Icons.person_add,
                const Color(0xFF6C5CE7),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(
    String title, 
    String time, 
    String status, 
    IconData icon, 
    Color color, {
    bool showAmount = false,
    bool showAvatar = false,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (showAvatar)
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: AssetImage('assets/images/avatar.png'),
                  fit: BoxFit.cover,
                ),
              ),
            )
          else
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
          if (showAmount)
            Text(
              status,
              style: GoogleFonts.inter(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            )
          else
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
  GroupSaveDetailsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      GroupSaveDetailsViewModel();
}
