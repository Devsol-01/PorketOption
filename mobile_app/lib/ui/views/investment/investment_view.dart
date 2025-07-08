import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/extensions/theme_context_extension.dart';
import 'package:stacked/stacked.dart';

import 'investment_viewmodel.dart';

class InvestmentView extends StackedView<InvestmentViewModel> {
  const InvestmentView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    InvestmentViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
        backgroundColor: context.backgroundColor,
        body: SafeArea(
            child: Column(children: [
          // Main content
          Expanded(
              child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Text(
                          'My Investments',
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: context.primaryTextColor,
                          ),
                        ),
                        SizedBox(height: 24),
                        _buildInvestmentSummaryCard(),

                        const SizedBox(height: 32),

                        // Vetted Opportunities Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Vetted Opportunities',
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: context.primaryTextColor,
                              ),
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Find More',
                                  style: TextStyle(
                                    color: Color(0xFF8B7CF6),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Color(0xFF8B7CF6),
                                  size: 12,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Investment Opportunities
                        SizedBox(
                          height: 220,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              _buildOpportunityCard(
                                context,
                                returnPercentage: '19.5',
                                investorsCount: '1260',
                                title: 'Crypto Portfolio',
                                description: '19.5% • returns in 6\nmonths',
                              ),
                              _buildOpportunityCard(
                                context,
                                returnPercentage: '17.0',
                                investorsCount: '890',
                                title: 'DeFi Yield Farming',
                                description: '17.0% • returns in 3\nmonths',
                              ),
                              _buildOpportunityCard(
                                context,
                                returnPercentage: '21.0',
                                investorsCount: '750',
                                title: 'Staking',
                                description: '21.0% • returns in 12\nmonths',
                                isLast: true,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Active/Matured Toggle
                        _buildToggleSection(context),
                        const SizedBox(height: 55),

                        // Active Investments Section
                        _buildActiveInvestmentsSection(context),
                      ])))
        ])));
  }

  Widget _buildInvestmentSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF9F7AEA),
            Color(0xFF667EEA),
            Color(0xFF764BA2),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Up to 35% returns',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Total Investment',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.1,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '\$4,250.00',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.9,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOpportunityCard(
    BuildContext context, {
    required String returnPercentage,
    required String investorsCount,
    required String title,
    required String description,
    bool isLast = false,
  }) {
    return Container(
      width: 200,
      margin: EdgeInsets.only(right: isLast ? 0 : 18),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Invest Now Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'INVEST NOW',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Return Percentage Circle
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Color(0xFF2A2A2A),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$returnPercentage%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Investors Count
          Text(
            'INVESTORS: $investorsCount',
            style: const TextStyle(
              color: Color(0xFF8B8B8B),
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),

          // Title
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 4),

          // Description
          Flexible(
            child: Text(
              description,
              style: const TextStyle(
                color: Color(0xFF8B8B8B),
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 1.2,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleSection(BuildContext context) {
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
                    const SizedBox(width: 8),
                    Text(
                      'Active',
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
                const SizedBox(width: 8),
                Text(
                  'Matured',
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

  Widget _buildActiveInvestmentsSection(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: context.tabBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: const Icon(
                Icons.trending_up_rounded,
                color: Color(0xFF4A4A4A),
                size: 40,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No active investments yet',
            style: TextStyle(
              color: Color(0xFF8B8B8B),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Start investing to see your portfolio here',
            style: TextStyle(
              color: Color(0xFF5A5A5A),
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  @override
  InvestmentViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      InvestmentViewModel();
}
