import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/extensions/theme_context_extension.dart';
import 'package:mobile_app/ui/common/app_colors.dart';
import 'package:stacked/stacked.dart';

import 'profile_viewmodel.dart';

class ProfileView extends StackedView<ProfileViewModel> {
  const ProfileView({super.key});

  @override
  Widget builder(
    BuildContext context,
    ProfileViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
        backgroundColor: context.backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              //Main Content
              Expanded(
                child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile Header
                        _buildProfileHeader(context),
                        const SizedBox(height: 32),

                        // Statistics Section
                        _buildStatisticsSection(context),
                        const SizedBox(height: 32),

                        // Achievements Section
                        _buildAchievementsSection(context),
                        const SizedBox(height: 32),

                        // Wallet Address Section
                        _buildWalletAddressSection(context),
                        const SizedBox(height: 24),

                        // Privacy Section
                        _buildPrivacySection(context),
                        const SizedBox(height: 16),

                        // Log Out Section
                        _buildLogOutSection(context),
                      ],
                    )),
              ),
            ],
          ),
        ));
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Row(
      children: [
        // Profile Avatar
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: context.balanceCardGradient,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              'US',
              style: GoogleFonts.inter(
                color: context.primaryTextColor,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),

        // Profile Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Uchechukwu Solomon',
                style: GoogleFonts.inter(
                  color: context.primaryTextColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.3,
                ),
              ),
              Text(
                'solomonu928@gmail.com',
                style: GoogleFonts.inter(
                  color: context.secondaryTextColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                'FlowCoin Member',
                style: GoogleFonts.inter(
                  color: context.tabSelectedColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Statistics',
          style: GoogleFonts.inter(
            color: context.primaryTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 16),

        // Statistics Cards
        Row(
          children: [
            // Day Streak Card
            Expanded(
              child: _buildStatCard(
                context,
                icon: Icons.local_fire_department_outlined,
                iconColor: const Color(0xFFFF8A65),
                value: '47',
                label: 'Day Streak',
              ),
            ),
            const SizedBox(width: 16),

            // FlowCoins Card
            Expanded(
              child: _buildStatCard(
                context,
                icon: Icons.monetization_on_outlined,
                iconColor: context.tabSelectedColor,
                value: '2,847',
                label: 'FlowCoins',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Total Returns Card
        _buildStatCard(
          context,
          icon: Icons.trending_up_rounded,
          iconColor: context.successColor,
          value: '\$1,247.83',
          label: 'Total Returns This Year',
          isWide: true,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
    bool isWide = false,
  }) {
    return Container(
      width: isWide ? double.infinity : null,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(12),
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
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: GoogleFonts.inter(
                    color: context.primaryTextColor,
                    fontSize: 21,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    color: context.secondaryTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Achievements',
          style: GoogleFonts.inter(
            color: context.primaryTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 16),

        // Achievement Cards
        Row(
          children: [
            // First Save Achievement
            Expanded(
              child: _buildAchievementCard(
                context,
                icon: Icons.savings_outlined,
                iconColor: context.goldColor,
                title: 'First Save',
                backgroundColor: context.isDarkMode
                    ? const Color(0xFF2D2416)
                    : const Color(0xFFFFF8E1),
              ),
            ),
            const SizedBox(width: 12),

            // Goal Master Achievement
            Expanded(
              child: _buildAchievementCard(
                context,
                icon: Icons.trending_up_rounded,
                iconColor: context.successColor,
                title: 'Goal Master',
                backgroundColor: context.isDarkMode
                    ? const Color(0xFF0F2419)
                    : const Color(0xFFE8F5E8),
              ),
            ),
            const SizedBox(width: 12),

            // Investor Achievement
            Expanded(
              child: _buildAchievementCard(
                context,
                icon: Icons.show_chart_rounded,
                iconColor: context.tabSelectedColor,
                title: 'Investor',
                backgroundColor: context.isDarkMode
                    ? const Color(0xFF251B2E)
                    : const Color(0xFFF3E5F5),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAchievementCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 12, bottom: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.inter(
              color: iconColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWalletAddressSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardColor,
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
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Wallet Address',
                  style: GoogleFonts.inter(
                    color: context.secondaryTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '0xCEER...h47B',
                  style: GoogleFonts.jetBrainsMono(
                    color: context.primaryTextColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: context.actionButtonBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.copy_outlined,
              color: context.primaryTextColor,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacySection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.cardColor,
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
      child: Row(
        children: [
          Icon(
            Icons.security_outlined,
            color: context.secondaryTextColor,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Privacy',
              style: GoogleFonts.inter(
                color: context.primaryTextColor,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: context.secondaryTextColor,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildLogOutSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.cardColor,
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
      child: Row(
        children: [
          const Icon(
            Icons.logout_outlined,
            color: notificationRed,
            size: 24,
          ),
          const SizedBox(width: 16),
          Text(
            'Log Out',
            style: GoogleFonts.inter(
              color: notificationRed,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  ProfileViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ProfileViewModel();
}
