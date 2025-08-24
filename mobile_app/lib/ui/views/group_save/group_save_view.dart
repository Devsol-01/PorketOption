import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:google_fonts/google_fonts.dart';
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
                            ? '\$${viewModel.groupSaveBalance.toStringAsFixed(0)}'
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

            //Toggle buttons
            _buildToggleButtons(context, viewModel),

            const SizedBox(height: 40),

            // Group Savings Section
            viewModel.currentGroups.isEmpty
                ? _buildEmptyState()
                : _buildGroupsList(viewModel),

            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () => viewModel.createGroupSave(),
          child: Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color: Color(0xFFFFFFFF), // can change to 0xFFFFF2E0 for more pop
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Color(0x33FFA82F), // subtle outer shadow
                  offset: Offset(2, 2),
                  blurRadius: 4,
                ),
                BoxShadow(
                  color: Color(0x22FFA82F),
                  offset: Offset(-1, -1),
                  blurRadius: 2,
                  inset: true, // keeps inset effect
                ),
              ],
            ),
            child: Center(
                child: Icon(
              Icons.add,
              color: Color(0xFFFFA82F),
            )),
          ),
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

  Widget _buildToggleButtons(
      BuildContext context, GroupSaveViewModel viewModel) {
    return Row(
      children: [
        Expanded(
          flex: 3,
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
                        color: Colors.green,
                        width: 1,
                      ),
                boxShadow: viewModel.isOngoingSelected
                    ? const [
                        BoxShadow(
                          color: Color.fromRGBO(13, 213, 13, 0.1),
                          offset: Offset(-4, 4),
                          blurRadius: 20,
                          inset: true,
                        ),
                        BoxShadow(
                          color: Color.fromRGBO(13, 213, 13, 0.1),
                          offset: Offset(4, 4),
                          blurRadius: 6,
                          inset: true,
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: Text(
                  'Ongoing',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: () => viewModel.setOngoingSelected(false),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: !viewModel.isOngoingSelected
                      ? Colors.white
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(46),
                  border: !viewModel.isOngoingSelected
                      ? null
                      : Border.all(
                          color: Colors.green,
                          width: 1,
                        ),
                  boxShadow: !viewModel.isOngoingSelected
                      ? const [
                          BoxShadow(
                            color: Color.fromRGBO(13, 213, 13, 0.1),
                            offset: Offset(-4, 4),
                            blurRadius: 20,
                            inset: true,
                          ),
                          BoxShadow(
                            color: Color.fromRGBO(13, 213, 13, 0.1),
                            offset: Offset(4, 4),
                            blurRadius: 6,
                            inset: true,
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    'Paid back',
                    style: TextStyle(
                      color: Color(0xFF509350),
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Color(0xFFEAFDEA),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            Icons.group,
            color: Colors.black,
            size: 24,
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
          'Create your first Group savings to get started',
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
    final progress = (group['progress'] as double? ?? 0.0);
    final currentAmount = (group['currentAmount'] as double? ?? 0.0);
    final memberCount = (group['memberCount'] as int? ?? 0);
    final daysLeft = _calculateDaysLeft(group['endDate'] as String?);

    return GestureDetector(
      onTap: () => viewModel.navigateToGroupDetail(group),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: _getCategoryColor(group['category'] as String?),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getCategoryIcon(group['category'] as String?),
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            // Group details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group['title'] as String? ?? 'Untitled Group',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '$memberCount',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                      const Text(
                        ' Members',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '$daysLeft Days Left',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '\$${currentAmount.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        ' Total Saved',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '$daysLeft Days Left',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Progress bar
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.green,
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

  Color _getCategoryColor(String? category) {
    switch (category?.toLowerCase()) {
      case 'business':
        return Colors.green;
      case 'education':
        return Colors.blue;
      case 'rent':
      case 'house':
        return Colors.pink;
      case 'vacation':
        return Colors.orange;
      case 'car':
        return Colors.purple;
      default:
        return Colors.green;
    }
  }

  IconData _getCategoryIcon(String? category) {
    switch (category?.toLowerCase()) {
      case 'business':
        return Icons.business;
      case 'education':
        return Icons.school;
      case 'rent':
      case 'house':
        return Icons.home;
      case 'vacation':
        return Icons.flight;
      case 'car':
        return Icons.directions_car;
      default:
        return Icons.group;
    }
  }

  int _calculateDaysLeft(String? endDateStr) {
    if (endDateStr == null) return 0;
    try {
      final endDate = DateTime.parse(endDateStr);
      final now = DateTime.now();
      final difference = endDate.difference(now).inDays;
      return difference > 0 ? difference : 0;
    } catch (e) {
      return 0;
    }
  }

  @override
  GroupSaveViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      GroupSaveViewModel();
}
