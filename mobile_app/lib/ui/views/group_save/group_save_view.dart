import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'group_save_viewmodel.dart';
import 'package:mobile_app/utils/format_utils.dart';

class GroupSaveView extends StackedView<GroupSaveViewModel> {
  const GroupSaveView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    GroupSaveViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Group Savings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Main Balance Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(9, 129, 9, 0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Interest Rate
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withOpacity(0.2), // subtle transparent white
                      borderRadius: BorderRadius.circular(20), // pill shape
                    ),
                    child: Text(
                      '4.5% per annum',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Balance Label
                  Text(
                    "Group Savings Balance",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      height: 17 / 14, // lineHeight / fontSize
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),

                  // Balance Amount
                  Row(
                    children: [
                      Text(
                        viewModel.isBalanceVisible
                            ? FormatUtils.formatCurrency(
                                viewModel.groupSaveBalance)
                            : '****',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: viewModel.toggleBalanceVisibility,
                        child: Icon(
                          viewModel.isBalanceVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _buildPromotedSavingsSection(context, viewModel),

            const SizedBox(height: 24),

            // Toggle buttons for Live and Completed
            _buildToggleButtons(context, viewModel),
            const SizedBox(height: 20),
            // Groups List
            viewModel.currentGroups.isEmpty
                ? _buildEmptyState()
                : _buildGroupsList(viewModel),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => viewModel.createGroupSave(),
        backgroundColor: const Color(0xFF8A38F5),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildToggleButtons(
      BuildContext context, GroupSaveViewModel viewModel) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => viewModel.setOngoingSelected(true),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: viewModel.isOngoingSelected
                    ? Colors.white
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(46),
                border: viewModel.isOngoingSelected
                    ? null
                    : Border.all(
                        color: const Color(0xFF8A38F5),
                      ),
                boxShadow: viewModel.isOngoingSelected
                    ? [
                        BoxShadow(
                          color: const Color.fromRGBO(138, 56, 245, 0.1),
                          offset: const Offset(-4, 4),
                          blurRadius: 20,
                        ),
                        BoxShadow(
                          color: const Color.fromRGBO(138, 56, 245, 0.1),
                          offset: const Offset(4, 4),
                          blurRadius: 6,
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: Text(
                  'Live',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF8A38F5),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: () => viewModel.setOngoingSelected(false),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: !viewModel.isOngoingSelected
                    ? Colors.white
                    : Colors.transparent,
                border: !viewModel.isOngoingSelected
                    ? null
                    : Border.all(
                        color: const Color(0xFF8A38F5),
                        width: 1,
                      ),
                borderRadius: BorderRadius.circular(46),
                boxShadow: !viewModel.isOngoingSelected
                    ? [
                        BoxShadow(
                          color: const Color.fromRGBO(138, 56, 245, 0.1),
                          offset: const Offset(-4, 4),
                          blurRadius: 20,
                        ),
                        BoxShadow(
                          color: const Color.fromRGBO(138, 56, 245, 0.1),
                          offset: const Offset(4, 4),
                          blurRadius: 6,
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: Text(
                  'Completed',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Color(0xFF8A38F5),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            color: Color(0xFFE8D7FF),
            borderRadius: BorderRadius.circular(23.434),
          ),
          child: Center(
            child: Icon(
              Icons.group,
              size: 40,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'No ongoing Group savings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Create your first group savings to get started',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildGroupsList(GroupSaveViewModel viewModel) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: viewModel.currentGroups.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final group = viewModel.currentGroups[index];
        return _buildGroupCard(group, viewModel);
      },
    );
  }

  Widget _buildGroupCard(
      Map<String, dynamic> group, GroupSaveViewModel viewModel) {
    // Safely convert BigInt amounts to double (USDC has 6 decimals)
    final currentAmount = group['current_amount'] is BigInt
        ? (group['current_amount'] as BigInt).toDouble() / 1000000.0
        : (group['current_amount'] is double ? group['current_amount'] : 0.0);
    final targetAmount = group['target_amount'] is BigInt
        ? (group['target_amount'] as BigInt).toDouble() / 1000000.0
        : (group['target_amount'] is double ? group['target_amount'] : 0.0);
    final daysLeft = _calculateDaysLeft(group['end_time'] as int?);

    final membersCount = group['member_count'] ?? 0;
    final progress =
        targetAmount > 0 ? (currentAmount / targetAmount).clamp(0.0, 1.0) : 0.0;
    final groupTitle = group['title'] as String? ?? 'Untitled Group';
    final category = group['category'] as String? ?? 'General';

    return GestureDetector(
      onTap: () => viewModel.navigateToGroupDetail(group),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: Colors.grey.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon and category
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade400, Colors.blue.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.group,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Group title
                      Text(
                        groupTitle,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Progress section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        progress >= 1.0
                            ? Colors.green.shade500
                            : Colors.blue.shade500,
                      ),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Progress text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${(progress * 100).toStringAsFixed(1)}% Complete',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: progress >= 1.0
                              ? Colors.green.shade700
                              : Colors.blue.shade700,
                        ),
                      ),
                      Text(
                        '${FormatUtils.formatCurrency(currentAmount)} / ${FormatUtils.formatCurrency(targetAmount)}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Stats row
            Row(
              children: [
                _buildEnhancedStat(
                  icon: Icons.people,
                  label: "Members",
                  value: membersCount.toString(),
                  color: Colors.purple,
                ),
                const SizedBox(width: 20),
                _buildEnhancedStat(
                  icon: Icons.schedule,
                  label: "Days Left",
                  value: daysLeft.toString(),
                  color: Colors.orange,
                ),
                const Spacer(),
                // Status indicator
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: progress >= 1.0
                        ? Colors.green.shade100
                        : Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    progress >= 1.0 ? 'Completed' : 'Active',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: progress >= 1.0
                          ? Colors.green.shade700
                          : Colors.blue.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlainStat({
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedStat({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Icon(
              icon,
              color: color,
              size: 16,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }

  int _calculateDaysLeft(int? endTime) {
    if (endTime == null) return 0;
    final endDate = DateTime.fromMillisecondsSinceEpoch(endTime * 1000);
    final now = DateTime.now();
    final difference = endDate.difference(now).inDays;
    return difference > 0 ? difference : 0;
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
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Row(
                children: [
                  Text(
                    'Find More',
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.black,
                    size: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Image.asset(
                'lib/assets/Group3.png',
                width: 139,
                height: 172,
              ),
              const SizedBox(width: 16),
              Image.asset(
                'lib/assets/Group2.png',
                width: 139,
                height: 172,
              ),
              const SizedBox(width: 16),
              Image.asset(
                'lib/assets/Group1.png',
                width: 139,
                height: 172,
              ),
              const SizedBox(width: 16),
              Image.asset(
                'lib/assets/Group4.png',
                width: 139,
                height: 172,
              ),
              const SizedBox(width: 16),
              Image.asset(
                'lib/assets/Group5.png',
                width: 139,
                height: 172,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  GroupSaveViewModel viewModelBuilder(BuildContext context) =>
      GroupSaveViewModel();

  @override
  void onViewModelReady(GroupSaveViewModel viewModel) {
    viewModel.initialize();
  }
}
