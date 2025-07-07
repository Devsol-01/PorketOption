import 'package:flutter/material.dart';
import 'package:mobile_app/extensions/theme_context_extension.dart';
import 'package:stacked/stacked.dart';

import 'profile_viewmodel.dart';

class ProfileView extends StackedView<ProfileViewModel> {
  const ProfileView({Key? key}) : super(key: key);

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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Header
                    _buildProfileHeader(),
                    const SizedBox(height: 32),
                    
                    // Statistics Section
                    _buildStatisticsSection(),
                    const SizedBox(height: 32),
                    
                    // Achievements Section
                    _buildAchievementsSection(),
                    const SizedBox(height: 32),
                    
                    // Wallet Address Section
                    _buildWalletAddressSection(),
                    const SizedBox(height: 24),
                    
                    // Privacy Section
                    _buildPrivacySection(),
                    const SizedBox(height: 16),
                    
                    // Log Out Section
                    _buildLogOutSection(),
                  ],
                )
              ),
            ),
          ],
        ),
      )
    );
  }


    Widget _buildProfileHeader() {
    return Row(
      children: [
        // Profile Avatar
        Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF9F7AEA),
                Color(0xFF667EEA),
              ],
            ),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Text(
              'US',
              style: TextStyle(
                color: Colors.white,
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
              const Text(
                'Uchechukwu Solomon',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.3,
                ),
              ),
              const Text(
                'solomonu928@gmail.com',
                style: TextStyle(
                  color: Color(0xFF8B8B8B),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Text(
                'FlowCoin Member',
                style: TextStyle(
                  color: Color(0xFF667EEA),
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

  Widget _buildStatisticsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Statistics',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
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
                icon: Icons.local_fire_department_outlined,
                iconColor: const Color(0xFFFF8A65),
                value: '47',
                label: 'Day Streak',
                backgroundColor: const Color(0xFF1F1F1F),
              ),
            ),
            const SizedBox(width: 16),
            
            // FlowCoins Card
            Expanded(
              child: _buildStatCard(
                icon: Icons.monetization_on_outlined,
                iconColor: const Color(0xFF9F7AEA),
                value: '2,847',
                label: 'FlowCoins',
                backgroundColor: const Color(0xFF1F1F1F),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Total Returns Card
        _buildStatCard(
          icon: Icons.trending_up_rounded,
          iconColor: const Color(0xFF10B981),
          value: '\$1,247.83',
          label: 'Total Returns This Year',
          backgroundColor: const Color(0xFF1F1F1F),
          isWide: true,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
    required Color backgroundColor,
    bool isWide = false,
  }) {
    return Container(
      width: isWide ? double.infinity : null,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 28, 28, 28),
        borderRadius: BorderRadius.circular(12),
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF8B8B8B),
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

  Widget _buildAchievementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Achievements',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
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
                icon: Icons.savings_outlined,
                iconColor: const Color(0xFFFFB74D),
                title: 'First Save',
                backgroundColor: const Color(0xFF2D2416),
              ),
            ),
            const SizedBox(width: 12),
            
            // Goal Master Achievement
            Expanded(
              child: _buildAchievementCard(
                icon: Icons.trending_up_rounded,
                iconColor: const Color(0xFF10B981),
                title: 'Goal Master',
                backgroundColor: const Color(0xFF0F2419),
              ),
            ),
            const SizedBox(width: 12),
            
            // Investor Achievement
            Expanded(
              child: _buildAchievementCard(
                icon: Icons.show_chart_rounded,
                iconColor: const Color(0xFF9F7AEA),
                title: 'Investor',
                backgroundColor: const Color(0xFF251B2E),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAchievementCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 9, bottom: 9),
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
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
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

  Widget _buildWalletAddressSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 28, 28, 28),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Wallet Address',
                  style: TextStyle(
                    color: Color(0xFF8B8B8B),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '0xCEER...h47B',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.copy_outlined,
              color: Color(0xFF667EEA),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacySection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 28, 28, 28),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.security_outlined,
            color: Color(0xFF8B8B8B),
            size: 24,
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              'Privacy',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Color(0xFF8B8B8B),
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildLogOutSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 28, 28, 28),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.logout_outlined,
            color: Color(0xFFFF6B6B),
            size: 24,
          ),
          SizedBox(width: 16),
          Text(
            'Log Out',
            style: TextStyle(
              color: Color(0xFFFF6B6B),
              fontSize: 16,
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

