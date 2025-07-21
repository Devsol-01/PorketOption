import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/extensions/theme_context_extension.dart';
import 'package:mobile_app/ui/common/app_colors.dart' as AppColors;
import 'package:stacked/stacked.dart';

import 'saving_viewmodel.dart';

class SavingView extends StackedView<SavingViewModel> {
  const SavingView({super.key});

  @override
  Widget builder(
    BuildContext context,
    SavingViewModel viewModel,
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
                Text(
                  'Savings',
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: context.primaryTextColor,
                  ),
                ),
                const SizedBox(height: 30),
                _buildBalanceCard(context),
                const SizedBox(height: 32),
                Text('Choose a Savings Plan',
                    style: GoogleFonts.inter(
                        fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 20),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 25,
                  childAspectRatio: 0.95,
                  children: [
                    _buildSavingsCard(
                        context: context,
                        title: 'Flexi Save',
                        subtitle: 'Save with complete flexibility',
                        apy: '3.50% APY',
                        icon: Icons.flash_on,
                        primaryColor: const Color(0xFF007AFF),
                        secondaryColor: const Color(0xFF4A90E2),
                        textColor: Colors.blue,
                        onTap: viewModel.navigateToFlexiSave),
                    _buildSavingsCard(
                        context: context,
                        title: 'Goal Save',
                        subtitle: 'Save towards specific goals',
                        apy: '4.20% APY',
                        icon: Icons.center_focus_strong,
                        primaryColor: const Color(0xFF34C759),
                        secondaryColor: const Color(0xFF52D76A),
                        textColor: Colors.green,
                        onTap: viewModel.navigateToGoalSave),
                    _buildSavingsCard(
                        context: context,
                        title: 'Lock Save',
                        subtitle: 'Lock funds to avoid temptation',
                        apy: '6.80% APY',
                        icon: Icons.lock,
                        primaryColor: const Color(0xFF8E44AD),
                        secondaryColor: const Color(0x00ab56c4),
                        textColor: Colors.purple,
                        onTap: viewModel.navigateToLockSave),
                    _buildSavingsCard(
                        context: context,
                        title: 'Group Save',
                        subtitle: 'Save together with friends',
                        apy: '5.10% APY',
                        icon: Icons.group,
                        primaryColor: const Color(0xFFFF6B35),
                        secondaryColor: const Color(0xFFFF8F65),
                        textColor: const Color.fromARGB(255, 249, 150, 1),
                        onTap: viewModel.navigateToGroupSave),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF8A4FFF),
            Color(0xFF4F8AFF),
          ],
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
                'Total Savings',
                style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: context.walletTextColor),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.walletAddressBg,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Center(
                  child: Icon(
                    Icons.savings_outlined,
                    color: Colors.white,
                    size: 20,
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
          Text(
            '+12.5% this month',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavingsCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String apy,
    required IconData icon,
    required Color primaryColor,
    required Color secondaryColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: context.isDarkMode
                ? [
                    primaryColor.withOpacity(0.3),
                    primaryColor.withOpacity(0.1),
                  ]
                : [
                    primaryColor.withOpacity(0.1),
                    primaryColor.withOpacity(0.05),
                  ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: context.isDarkMode
                ? primaryColor.withOpacity(0.2)
                : primaryColor.withOpacity(0.1),
            width: 2.5,
          ),
          boxShadow: [
            BoxShadow(
              color: context.cardShadow,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background decorative circles
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              bottom: -30,
              left: -30,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: secondaryColor.withOpacity(0.08),
                ),
              ),
            ),
            // Main content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor.withOpacity(0.2),
                    ),
                    child: Icon(
                      icon,
                      color: primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Title
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Subtitle
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        color: context.secondaryTextColor,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 16),
                  // APY
                  // Container(
                  //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  //   decoration: BoxDecoration(
                  //     color: primaryColor.withOpacity(0.15),
                  //     borderRadius: BorderRadius.circular(12),
                  //   ),
                  //   child: Text(
                  //     apy,
                  //     style: GoogleFonts.inter(
                  //       fontSize: 14,
                  //       fontWeight: FontWeight.w600,
                  //       color: primaryColor,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  SavingViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      SavingViewModel();
}
