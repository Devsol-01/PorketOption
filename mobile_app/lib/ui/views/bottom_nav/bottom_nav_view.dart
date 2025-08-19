import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/extensions/theme_context_extension.dart';
import 'package:mobile_app/ui/views/dashboard/dashboard_view.dart';
import 'package:mobile_app/ui/views/investment/investment_view.dart';
import 'package:mobile_app/ui/views/profile/profile_view.dart';
import 'package:mobile_app/ui/views/saving/saving_view.dart';
import 'package:stacked/stacked.dart';

import 'bottom_nav_viewmodel.dart';

class BottomNavView extends StackedView<BottomNavViewModel> {
  const BottomNavView({super.key});

  @override
  Widget builder(
    BuildContext context,
    BottomNavViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: AnimatedSwitcher(
          switchInCurve: Curves.easeInOutQuad,
          duration: const Duration(milliseconds: 300),
          child: _getViewForIndex(viewModel.currentIndex)),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            // border: Border(
            //   top: BorderSide(
            //     color: context.dividerColor,
            //     width: 1,
            //   ),
            // ),
            ),
        child: BottomNavigationBar(
          currentIndex: viewModel.currentIndex,
          type: BottomNavigationBarType.fixed,
          onTap: viewModel.setIndex,
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFF004CE8),
          unselectedItemColor: Color(0xFF484C52),
          unselectedLabelStyle: GoogleFonts.inter(
            color: Colors.red,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.savings_outlined),
              label: 'Savings',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.trending_up), label: 'Invest'),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _getViewForIndex(int index) {
    switch (index) {
      case 0:
        return const DashboardView();
      case 1:
        return const SavingView();
      case 2:
        return const InvestmentView();
      default:
        return const ProfileView();
    }
  }

  @override
  BottomNavViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      BottomNavViewModel();
}
