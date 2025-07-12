import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/extensions/theme_context_extension.dart';
import 'package:stacked/stacked.dart';

import '../../common/app_colors.dart' as AppColors;
import 'dashboard_viewmodel.dart';

class DashboardView extends StackedView<DashboardViewModel> {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    DashboardViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
        backgroundColor: context.backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Header section
                  _buildHeader(context),
                  const SizedBox(height: 30),

                  //Balance card
                  _buildBalanceCard(context),
                  const SizedBox(height: 30),

                  //Action Buttons
                  _buildActionButtons(context, viewModel),
                  const SizedBox(height: 30),

                  //Interest Earnings chart
                  _buildInterestEarningsChart(context),
                  const SizedBox(height: 30),

                  //Navigation Buttons
                  _buildNavigationButtons(context),
                  const SizedBox(height: 30),

                  //Savings Goal
                  _buildSavingsGoal(context)
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: context.primaryTextColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Welcome back, Uchechukwu',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: context.secondaryTextColor,
              ),
            ),
          ],
        ),
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(30),
                border: context.isDarkMode
                    ? Border.all(color: context.cardBorder)
                    : null,
              ),
              child: Center(
                child: Icon(
                  Icons.notifications_none,
                  color: context.primaryTextColor,
                  size: 20,
                ),
              ),
            ),
            const Positioned(
              top: 8,
              right: 8,
              child: CircleAvatar(
                radius: 4,
                backgroundColor: AppColors.notificationRed,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBalanceCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFB16CEA), Color(0xFF8A4FFF)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Balance',
                style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: context.walletTextColor),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.walletAddressBg,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Center(
                  child: Icon(
                    Icons.account_balance_wallet_outlined,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ),
            ],
          ),
          Text(
            '\$24,567.89',
            style: GoogleFonts.poppins(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Row(
            children: [
              Text(
                'Wallet:',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: context.walletTextColor,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.walletAddressBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '0xCEER...h47B',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.copy,
                size: 14,
                color: Colors.white.withOpacity(0.7),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
      BuildContext context, DashboardViewModel viewModel) {
    return Row(
      children: [
        _buildActionButton(
          context: context,
          icon: Icons.arrow_downward,
          label: 'Deposit',
          backgroundColor: context.cardColor,
          iconColor: context.depositIconColor,
          onTap: () {
            viewModel.showDepositSheet();
          },
        ),
        const SizedBox(width: 16),
        _buildActionButton(
          context: context,
          icon: Icons.savings_outlined,
          label: 'Save',
          backgroundColor: context.cardColor,
          iconColor: context.saveIconColor,
          onTap: () {}
        ),
        const SizedBox(width: 16),
        _buildActionButton(
          context: context,
          icon: Icons.arrow_upward,
          label: 'Withdraw',
          backgroundColor: context.cardColor,
          iconColor: context.withdrawIconColor,
          // Add onTap if needed
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color backgroundColor,
    required Color iconColor,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: context.isDarkMode
                ? null
                : [
                    BoxShadow(
                      color: context.cardShadow,
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: context.primaryTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInterestEarningsChart(BuildContext context) {
    List<double> weeklyData = [0.7, 0.9, 0.6, 1.0, 0.8, 0.7, 0.9];
    List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: context.isDarkMode
            ? null
            : [
                BoxShadow(
                  color: context.cardShadow,
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Interest Earnings',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: context.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'This Week',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: context.secondaryTextColor,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '5.2%',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: context.successColor,
                    ),
                  ),
                  Text(
                    'APY',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: context.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),
          // Chart
          SizedBox(
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 20,
                      height: weeklyData[index] * 90,
                      decoration: BoxDecoration(
                        gradient: context.chartBarGradient,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      days[index],
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: context.secondaryTextColor,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
          const SizedBox(height: 20),
          Text.rich(
            TextSpan(
              text: 'Total Earned: ',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: context.secondaryTextColor,
              ),
              children: [
                TextSpan(
                  text: '\$99.00',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: context
                        .successColor, // Green or your custom success color
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: context.tabBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Milestones Tab (Active)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Container(
                height: 47,
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.emoji_events_outlined,
                      color: context.tabSelectedColor,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Milestones',
                      style: GoogleFonts.inter(
                        color: context.tabSelectedColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Transactions Tab (Inactive)
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.format_list_bulleted,
                  color: context.tabUnselectedColor,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  'Transactions',
                  style: GoogleFonts.inter(
                    color: context.tabUnselectedColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavingsGoal(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: context.isDarkMode
            ? null
            : [
                BoxShadow(
                  color: context.cardShadow,
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.goldColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.star_outline,
              color: context.goldColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Save \$10,000',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: context.primaryTextColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Progress: 85.0%',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: context.secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: 0.85,
                  backgroundColor: context.progressBarInactiveColor,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.progressBarActive,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  DashboardViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      DashboardViewModel();
}
