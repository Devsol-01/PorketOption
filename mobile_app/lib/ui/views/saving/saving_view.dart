import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/extensions/theme_context_extension.dart';
import 'package:stacked/stacked.dart';

import 'saving_viewmodel.dart';

class SavingView extends StackedView<SavingViewModel> {
  const SavingView({Key? key}) : super(key: key);

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
                SizedBox(height: 30),
                _buildBalanceCard(context),
                SizedBox(height: 32),
                Text('Choose a Savings Plan', style: TextStyle(fontSize: 16)),
                SizedBox(height: 20),

                // Savings Plans Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1,
                  children: [
                    _buildSavingsPlan(
                      context: context,
                      icon: Icons.savings,
                      color: Colors.blue,
                      title: 'Flexi Save',
                      description: 'Save with complete flexibility',
                      apy: '4.5%',
                    ),
                    _buildSavingsPlan(
                      context: context,
                      icon: Icons.gps_fixed,
                      color: Colors.green,
                      title: 'Goal Save',
                      description: 'Save towards specific goals',
                      apy: '6.2%',
                    ),
                    _buildSavingsPlan(
                      context: context,
                      icon: Icons.lock,
                      color: Colors.purple,
                      title: 'Lock Save',
                      description: 'Lock funds to avoid temptation',
                      apy: '8.7%',
                    ),
                    _buildSavingsPlan(
                      context: context,
                      icon: Icons.group,
                      color: Colors.orange,
                      title: 'Group Save',
                      description: 'Save together with friends',
                      apy: '5.8%',
                    ),
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
        gradient: LinearGradient(
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
                'Total Savings',
                style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: context.walletTextColor),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Center(
                  child: Icon(
                    Icons.savings_outlined,
                    color: context.primaryTextColor,
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

  Widget _buildSavingsPlan({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required String title,
    required String description,
    required String apy,
  }) {
    return Container(
      padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    apy,
                    style: GoogleFonts.inter(
                      color: Colors.green[400],
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'APY',
                    style: GoogleFonts.inter(
                      color: context.primaryTextColor.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.inter(
              color: context.primaryTextColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: GoogleFonts.inter(
              color: context.primaryTextColor.withOpacity(0.6),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  @override
  SavingViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      SavingViewModel();
}
