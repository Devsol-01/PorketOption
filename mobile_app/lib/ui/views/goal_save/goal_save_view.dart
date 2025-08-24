import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'package:mobile_app/app/app.locator.dart';

import 'goal_save_viewmodel.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';

class GoalSaveView extends StackedView<GoalSaveViewModel> {
  const GoalSaveView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    GoalSaveViewModel viewModel,
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
          'Goal Savings',
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
                  borderRadius: BorderRadius.circular(30),
                  color: const Color.fromRGBO(138, 56, 245, 0.7)),
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
                    "Goal Savings Balance",
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
                            ? '\$${viewModel.goalSaveBalance.toStringAsFixed(0)}'
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

            const SizedBox(height: 20),

            // AutoSave Card
            _AutoSaveCard(context, viewModel),

            const SizedBox(height: 24),

            //Toggle buttons
            _buildToggleButtons(context, viewModel),

            const SizedBox(height: 20),

            // Goals List
            viewModel.currentGoals.isEmpty
                ? _buildEmptyState()
                : _buildGoalsList(viewModel),

            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () => viewModel.navigateToCreateGoal(),
          child: Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color: Color(0xFFFFFFFF), // can change to 0xFFFFF2E0 for more pop
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Color(0x338A38F5),
                  offset: Offset(2, 2),
                  blurRadius: 4,
                ),
                BoxShadow(
                  color: Color(0x338A38F5),
                  offset: Offset(-1, -1),
                  blurRadius: 2,
                  inset: true, // keeps inset effect
                ),
              ],
            ),
            child: Center(
                child: Icon(
              Icons.add,
              color: Color(0xFF8A38F5),
            )),
          ),
        ),
      ),
    );
  }

  Widget _AutoSaveCard(BuildContext context, GoalSaveViewModel viewModel) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color.fromRGBO(138, 56, 245, 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What is goal savings?',
            style: GoogleFonts.inter(
              color: const Color(0xFF8A38F5),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Goal savings is a great way to save towards towards a specific goal or target.',
            style: TextStyle(
                color: Color(0xFF8A38F5),
                fontSize: 13,
                height: 15 / 12,
                fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 12),
          Text(
            'You can set up automatic savings to help you reach your goal faster.',
            style: TextStyle(
                color: Color(0xFF8A38F5),
                height: 15 / 12,
                fontSize: 13,
                fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButtons(
      BuildContext context, GoalSaveViewModel viewModel) {
    return Row(
      children: [
        Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: () => viewModel.setLiveSelected(true),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: viewModel.isLiveSelected
                      ? Colors.white
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(46),
                  border: viewModel.isLiveSelected
                      ? null
                      : Border.all(
                          color: const Color(0xFF8A38F5),
                        ),
                  boxShadow: viewModel.isLiveSelected
                      ? [
                          BoxShadow(
                            color: const Color.fromRGBO(138, 56, 245, 0.1),
                            offset: const Offset(-4, 4),
                            blurRadius: 20,
                            inset: true,
                          ),
                          BoxShadow(
                            color: const Color.fromRGBO(138, 56, 245, 0.1),
                            offset: const Offset(4, 4),
                            blurRadius: 6,
                            inset: true,
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
            )),
        const SizedBox(width: 16),
        Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: () => viewModel.setLiveSelected(false),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: !viewModel.isLiveSelected
                      ? Colors.white
                      : Colors.transparent,
                  border: !viewModel.isLiveSelected
                      ? null
                      : Border.all(
                          color: const Color(0xFF8A38F5),
                          width: 1,
                        ),
                  borderRadius: BorderRadius.circular(46),
                  boxShadow: !viewModel.isLiveSelected
                      ? [
                          BoxShadow(
                            color: const Color.fromRGBO(138, 56, 245, 0.1),
                            offset: const Offset(-4, 4),
                            blurRadius: 20,
                            inset: true,
                          ),
                          BoxShadow(
                            color: const Color.fromRGBO(138, 56, 245, 0.1),
                            offset: const Offset(4, 4),
                            blurRadius: 6,
                            inset: true,
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
                      color: const Color(0xFF8A38F5),
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
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            color: Color(0xFFE8D7FF),
            borderRadius: BorderRadius.circular(23.434),
          ),
          child: Center(
            child: Icon(
              Icons.track_changes,
              size: 24,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'No ongoing Goal savings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Create your first goal savings to get started',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildGoalsList(GoalSaveViewModel viewModel) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: viewModel.currentGoals.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final goal = viewModel.currentGoals[index];
        return _buildGoalCard(goal, viewModel);
      },
    );
  }

  // Widget _buildGoalCard(
  //     Map<String, dynamic> goal, GoalSaveViewModel viewModel) {
  //   final progress = (goal['progress'] as double? ?? 0.0);
  //   final currentAmount = (goal['currentAmount'] as double? ?? 0.0);
  //   final targetAmount = (goal['targetAmount'] as double? ?? 0.0);
  //   final daysLeft = _calculateDaysLeft(goal['endDate'] as String?);

  //   return GestureDetector(
  //     onTap: () => viewModel.navigateToGoalDetail(goal),
  //     child: Container(
  //       padding: const EdgeInsets.all(16),
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(16),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.black.withOpacity(0.05),
  //             blurRadius: 10,
  //             offset: const Offset(0, 2),
  //           ),
  //         ],
  //       ),
  //       child: Row(
  //         children: [
  //           // Icon container
  //           Container(
  //             width: 60,
  //             height: 60,
  //             decoration: BoxDecoration(
  //               color: _getCategoryColor(goal['category'] as String?),
  //               borderRadius: BorderRadius.circular(12),
  //             ),
  //             child: Icon(
  //               _getCategoryIcon(goal['category'] as String?),
  //               color: Colors.white,
  //               size: 24,
  //             ),
  //           ),
  //           const SizedBox(width: 16),
  //           // Goal details
  //           Expanded(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   goal['title'] as String? ?? 'Untitled Goal',
  //                   style: const TextStyle(
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.w600,
  //                     color: Colors.black87,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 8),
  //                 Row(
  //                   children: [
  //                     Text(
  //                       '\$${currentAmount.toStringAsFixed(0)}',
  //                       style: const TextStyle(
  //                         fontSize: 14,
  //                         fontWeight: FontWeight.w500,
  //                         color: Colors.black54,
  //                       ),
  //                     ),
  //                     Text(
  //                       ' / \$${targetAmount.toStringAsFixed(0)}',
  //                       style: const TextStyle(
  //                         fontSize: 14,
  //                         color: Colors.black54,
  //                       ),
  //                     ),
  //                     const Spacer(),
  //                     Text(
  //                       '$daysLeft days left',
  //                       style: const TextStyle(
  //                         fontSize: 12,
  //                         color: Colors.black54,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 8),
  //                 // Progress bar
  //                 LinearProgressIndicator(
  //                   value: progress,
  //                   backgroundColor: Colors.grey[200],
  //                   valueColor: AlwaysStoppedAnimation<Color>(
  //                     Color(0xFF8A38F5),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildGoalCard(
      Map<String, dynamic> goal, GoalSaveViewModel viewModel) {
    final currentAmount = (goal['currentAmount'] as double? ?? 0.0);
    final targetAmount = (goal['targetAmount'] as double? ?? 0.0);
    final daysLeft = _calculateDaysLeft(goal['endDate'] as String?);

    return GestureDetector(
      onTap: () => viewModel.navigateToGoalDetail(goal),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
        padding: const EdgeInsets.all(20),
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
                color: _getCategoryColor(goal['category'] as String?)
                    .withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Icon(
                  _getCategoryIcon(goal['category'] as String?),
                  color: _getCategoryColor(goal['category'] as String?),
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
                    goal['title'] as String? ?? 'Untitled Goal',
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
                        label: "Saved",
                        value: "\$${currentAmount.toStringAsFixed(0)}",
                      ),
                      const SizedBox(width: 35),
                      _buildPlainStat(
                        label: "Target",
                        value: "\$${targetAmount.toStringAsFixed(0)}",
                      ),
                      const SizedBox(
                        width: 35,
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

  Color _getCategoryColor(String? category) {
    switch (category?.toLowerCase()) {
      case 'car':
        return Colors.green;
      case 'house':
      case 'rent':
        return Colors.pink;
      case 'vacation':
        return Colors.blue;
      case 'education':
        return Colors.orange;
      case 'business':
        return Colors.purple;
      case 'gadgets':
        return Colors.teal;
      default:
        return Color(0xFF8A38F5);
    }
  }

  IconData _getCategoryIcon(String? category) {
    switch (category?.toLowerCase()) {
      case 'car':
        return Icons.directions_car;
      case 'house':
      case 'rent':
        return Icons.home;
      case 'vacation':
        return Icons.flight;
      case 'education':
        return Icons.school;
      case 'business':
        return Icons.business;
      case 'gadgets':
        return Icons.phone_android;
      default:
        return Icons.savings;
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
  GoalSaveViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      locator<GoalSaveViewModel>();

  @override
  void onViewModelReady(GoalSaveViewModel viewModel) {
    viewModel.initialize();
  }
}
