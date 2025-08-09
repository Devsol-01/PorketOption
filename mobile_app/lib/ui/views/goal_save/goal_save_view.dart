import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mobile_app/ui/common/app_colors.dart';
import 'package:stacked/stacked.dart';
import 'package:mobile_app/extensions/num_extensions.dart';

import 'goal_save_viewmodel.dart';

class GoalSaveView extends StackedView<GoalSaveViewModel> {
  const GoalSaveView({super.key});

  @override
  Widget builder(
    BuildContext context,
    GoalSaveViewModel viewModel,
    Widget? child,
  ) {
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
        title: Text(
          'Goal Save',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.info_outline,
              color: Colors.white,
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
              _buildBalanceCard(context, viewModel),
              const SizedBox(height: 20),

              // Create Goal Save Button
              _buildCreateGoalSaveButton(context, viewModel),
              const SizedBox(height: 24),

              // Quick Links
              _buildQuickLinks(context, viewModel),
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

  Widget _buildToggleTabs(BuildContext context, GoalSaveViewModel viewModel) {
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

  Widget _buildLiveTargets(BuildContext context, GoalSaveViewModel viewModel) {
    print('DEBUG: Live goals count: ${viewModel.liveGoals.length}');
    print('DEBUG: Live goals data: ${viewModel.liveGoals}');
    
    if (viewModel.liveGoals.isEmpty) {
      return _buildEmptyState('No live targets yet', 'Create your first goal save to get started');
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: viewModel.liveGoals.length,
      itemBuilder: (context, index) {
        final goal = viewModel.liveGoals[index];
        return _buildGoalCard(context, goal, viewModel);
      },
    );
  }

  Widget _buildCompletedTargets(BuildContext context, GoalSaveViewModel viewModel) {
    if (viewModel.completedGoals.isEmpty) {
      return _buildEmptyState('No completed targets yet', 'Complete some goals to see them here');
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: viewModel.completedGoals.length,
      itemBuilder: (context, index) {
        final goal = viewModel.completedGoals[index];
        return _buildGoalCard(context, goal, viewModel);
      },
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
              Icons.flag_outlined,
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

  Widget _buildGoalCard(BuildContext context, Map<String, dynamic> goal,
      GoalSaveViewModel viewModel) {
    print('DEBUG: Building card for goal: ${goal['purpose']}');
    print('DEBUG: Goal data: $goal');
    
    final currentAmount = (goal['currentAmount'] as double?) ?? 0.0;
    final targetAmount = (goal['targetAmount'] as double?) ?? 1.0;
    final progress = currentAmount / targetAmount;
    final category = (goal['category'] as String?) ?? 'General';
    final endDate = goal['endDate'] as DateTime?;
    final daysLeft = endDate != null 
        ? endDate.difference(DateTime.now()).inDays
        : 30;
    
    // Get category icon and color based on your screenshot
    IconData categoryIcon;
    Color cardColor;
    
    switch (category.toLowerCase()) {
      case 'vacation':
      case 'education':
        categoryIcon = Icons.school;
        cardColor = const Color(0xFF00C851); // Green like "Back to School 2025"
        break;
      case 'car':
        categoryIcon = Icons.directions_car;
        cardColor = const Color(0xFF00C851); // Green
        break;
      case 'rent':
        categoryIcon = Icons.home;
        cardColor = const Color(0xFF8B4513); // Brown like "my house rent"
        break;
      case 'business':
        categoryIcon = Icons.flash_on;
        cardColor = const Color(0xFF4A4A4A); // Dark like "heeje"
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
        cardColor = const Color(0xFF6C5CE7);
    }
    
    return GestureDetector(
      onTap: () => viewModel.navigateToGoalDetail(goal),
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
                        goal['purpose'] ?? 'Goal Save',
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
                            'N${(goal['currentAmount'] as double).toStringAsFixed(0)}',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'N${(goal['targetAmount'] as double).toStringAsFixed(0)}',
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
                          Text(
                            'Saved',
                            style: GoogleFonts.inter(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Total Target',
                            style: GoogleFonts.inter(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                            ),
                          ),
                          const Spacer(),
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

  void _showAddMoneyDialog(BuildContext context, Map<String, dynamic> goal,
      GoalSaveViewModel viewModel) {
    final TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Add Money to Goal',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'How much would you like to add to "${goal['purpose']}"?',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixText: '\$',
                hintText: 'Enter amount',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(amountController.text) ?? 0.0;
              if (amount > 0) {
                viewModel.addContribution(goal['id'], amount);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
            ),
            child: Text('Add Money'),
          ),
        ],
      ),
    );
  }

  void _showWithdrawDialog(BuildContext context, Map<String, dynamic> goal,
      GoalSaveViewModel viewModel) {
    final TextEditingController amountController = TextEditingController();
    final maxAmount = goal['currentAmount'] as double;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Withdraw from Goal',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'How much would you like to withdraw from "${goal['purpose']}"?',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Available: \$${maxAmount.toCurrency(symbol: ' 24')}',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixText: '\$',
                hintText: 'Enter amount',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(amountController.text) ?? 0.0;
              if (amount > 0 && amount <= maxAmount) {
                viewModel.withdrawFromGoal(goal['id'], amount);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            child: Text('Withdraw'),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context, GoalSaveViewModel viewModel) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6C5CE7),
            Color(0xFF5A4FCF),
          ],
        ),
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
              '12% per annum',
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
                'Goal Save Balance',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => viewModel.toggleBalanceVisibility(),
                child: Icon(
                  viewModel.isBalanceVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white.withOpacity(0.8),
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            viewModel.isBalanceVisible ? '\$2,750' : '****',
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

  Widget _buildCreateGoalSaveButton(BuildContext context, GoalSaveViewModel viewModel) {
    return GestureDetector(
      onTap: () => viewModel.navigateToCreateGoal(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF2A2A3E),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF00C851).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.add,
                color: Color(0xFF00C851),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create Goal Save',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Set a savings goal and start building your future',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF8E8E93),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF8E8E93),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickLinks(BuildContext context, GoalSaveViewModel viewModel) {
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
                  'Update Payment',
                  Icons.payment,
                  const Color(0xFF00C851),
                  () => viewModel.navigateToUpdatePayment(),
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

  @override
  GoalSaveViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      GoalSaveViewModel();
}
