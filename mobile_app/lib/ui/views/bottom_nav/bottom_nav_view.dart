import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

import 'bottom_nav_viewmodel.dart';

class BottomNavView extends StackedView<BottomNavViewModel> {
  const BottomNavView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    BottomNavViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(bottomNavigationBar: _buildBottomNavigationBar());
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        border: Border(
          top: BorderSide(
            color: Colors.grey[800]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            icon: Icons.home,
            label: 'Dashboard',
            isActive: true,
          ),
          _buildNavItem(
            icon: Icons.savings_outlined,
            label: 'Savings',
            isActive: false,
          ),
          _buildNavItem(
            icon: Icons.trending_up,
            label: 'Invest',
            isActive: false,
          ),
          _buildNavItem(
            icon: Icons.person_outline,
            label: 'Profile',
            isActive: false,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isActive ? const Color(0xFF8B5CF6) : Colors.grey[400],
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isActive ? const Color(0xFF8B5CF6) : Colors.grey[400],
          ),
        ),
      ],
    );
  }

  @override
  BottomNavViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      BottomNavViewModel();
}
