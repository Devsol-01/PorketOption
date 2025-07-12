import 'package:carousel_slider/carousel_slider.dart';
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
                        const SizedBox(height: 24),
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
                            const Row(
                              children: [
                                Text(
                                  'Find More',
                                  style: TextStyle(
                                    color: Color(0xFF8B7CF6),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Icon(
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

                        CarouselSlider(
                          options: CarouselOptions(
                              height: 250, // Keep original height
                              enlargeCenterPage: false,
                              enableInfiniteScroll: false,
                              viewportFraction: 0.65,
                              padEnds: false,
                              scrollPhysics: RangeMaintainingScrollPhysics()),
                          items: [
                            _buildProtocolCard(
                              context,
                              title: 'Solend',
                              subtitle: 'Decentralized\nlending protocol',
                              apy: '8.5%',
                              tvl: '\$120M',
                              riskLevel: 'Medium',
                              iconColor: const Color(0xFF6366F1), // Blue
                              iconData: Icons.shield_outlined,
                            ),
                            _buildProtocolCard(
                              context,
                              title: 'Mango Markets',
                              subtitle: 'Perpetual trading\nplatform',
                              apy: '12.3%',
                              tvl: '\$85M',
                              riskLevel: 'High',
                              iconColor: const Color(0xFFEF4444), // Red/Orange
                              iconData: Icons.trending_up,
                            ),
                            _buildProtocolCard(
                              context,
                              title: 'Jupitar',
                              subtitle: 'Perpetual trading\nplatform',
                              apy: '12.3%',
                              tvl: '\$85M',
                              riskLevel: 'Low',
                              iconColor: Colors.purple, // Red/Orange
                              iconData: Icons.trending_up,
                            )
                          ],
                        ),

                        SizedBox(height: 32),

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
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Up to 35% returns',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.2,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Total Investment',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.1,
            ),
          ),
          SizedBox(height: 4),
          Text(
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
            child: const Center(
              child: Icon(
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

  Widget _buildProtocolCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String apy,
    required String tvl,
    required String riskLevel,
    required Color iconColor,
    required IconData iconData,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Container(
        height: 240, 
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.protocolCardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: context.protocolCardBorder,
            width: 1,
          ),
          boxShadow: context.isDarkMode
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon 
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                iconData,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(height: 12), 
      
            // Title 
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: context.primaryTextColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6), // Reduced from 8
      
            // Subtitle
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: context.secondaryTextColor,
                height: 1.3, // Reduced line height
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12), // Reduced from 16
      
            // APY and Risk Level (keeping original design)
            Row(
              children: [
                Text(
                  'APY: ',
                  style: TextStyle(
                    fontSize: 14,
                    color: context.secondaryTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  apy,
                  style: TextStyle(
                    fontSize: 14,
                    color: context.protocolApyColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 25),
                _buildRiskBadge(context, riskLevel),
              ],
            ),
            const SizedBox(height: 10), // Reduced from 12
      
            // TVL and External Link (keeping original design)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'TVL: $tvl',
                  style: TextStyle(
                    fontSize: 14,
                    color: context.protocolTvlColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(
                  Icons.launch,
                  size: 16,
                  color: context.protocolExternalLinkColor,
                ),
              ],
            ),
      
            // Add spacer to fill remaining space and prevent overflow
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskBadge(BuildContext context, String riskLevel) {
    Color backgroundColor;
    Color textColor;

    switch (riskLevel.toLowerCase()) {
      case 'high':
        backgroundColor = context.protocolRiskHighBackground;
        textColor = context.protocolRiskHighText;
        break;
      case 'medium':
        backgroundColor = context.protocolRiskMediumBackground;
        textColor = context.protocolRiskMediumText;
        break;
      case 'low':
        backgroundColor = context.protocolRiskLowBackground;
        textColor = context.protocolRiskLowText;
        break;
      default:
        backgroundColor = context.protocolRiskMediumBackground;
        textColor = context.protocolRiskMediumText;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        riskLevel,
        style: TextStyle(
          fontSize: 12,
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }


  @override
  InvestmentViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      InvestmentViewModel();
}
