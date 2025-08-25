import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'package:mobile_app/utils/format_utils.dart';

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
                  color: Color.fromRGBO(13, 213, 13, 0.1),
                  offset: Offset(5, 5),
                  blurRadius: 4,
                ),
                BoxShadow(
                  color: Color.fromRGBO(13, 213, 13, 0.1),
                  offset: Offset(-1, -1),
                  blurRadius: 2,
                  inset: true, // keeps inset effect
                ),
              ],
            ),
            child: Center(
                child: Icon(
              Icons.add,
              color: Colors.green,
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
    final currentAmount = (group['currentAmount'] as double? ?? 0.0);
    final targetAmount = (group['targetAmount'] as double? ?? 0.0);
    final daysLeft = _calculateDaysLeft(group['endDate'] as String?);

    return GestureDetector(
      onTap: () => viewModel.navigateToGroupDetail(group),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              spreadRadius: 1,
              offset: const Offset(0, 6),
            )
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
                color: _getCategoryColor(group['category'] as String?)
                    .withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Icon(
                  _getCategoryIcon(group['category'] as String?),
                  color: _getCategoryColor(group['category'] as String?),
                  size: 26,
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Goal details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Goal title
                  Text(
                    group['title'] as String? ?? 'Untitled Goal',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 8),

                  // Stats row (clean text only)
                  Row(
                    children: [
                      _buildPlainStat(
                        label: "Members",
                        //value: FormatUtils.formatCurrency(currentAmount),
                        value: "${group['memberCount'] ?? 0}",
                      ),
                      const SizedBox(width: 30),
                      _buildPlainStat(
                        label: "Target",
                        value: FormatUtils.formatCurrency(targetAmount),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      _buildPlainStat(
                        label: "Days Left",
                        value: "$daysLeft",
                        alignRight: false,
                        highlight: false,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlainStat({
    required String label,
    required String value,
    bool alignRight = false,
    bool highlight = false,
  }) {
    return Column(
      crossAxisAlignment:
          alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
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
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: highlight ? Colors.blue.shade600 : Colors.black87,
          ),
        ),
      ],
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
