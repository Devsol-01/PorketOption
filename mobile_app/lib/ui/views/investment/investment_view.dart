import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/extensions/theme_context_extension.dart';

import 'package:stacked/stacked.dart';

import 'investment_viewmodel.dart';

class InvestmentView extends StackedView<InvestmentViewModel> {
  const InvestmentView({super.key});

  @override
  Widget builder(
    BuildContext context,
    InvestmentViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        backgroundColor: context.backgroundColor,
        elevation: 0,
        title: Text(
          'My Investments',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: context.primaryTextColor,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: context.primaryTextColor,
            ),
            onPressed: () => viewModel.refreshInvestments(),
          ),
          IconButton(
            icon: Icon(
              Icons.info_outline,
              color: context.primaryTextColor,
            ),
            onPressed: () => viewModel.showInvestmentInfo(),
          ),
        ],
      ),
      body: SafeArea(
        child: viewModel.isBusy
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () async => viewModel.refreshInvestments(),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Investment Summary Card
                      _buildInvestmentSummaryCard(context, viewModel),

                      const SizedBox(height: 32),

                      // Vetted Opportunities Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Vetted Opportunities',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: context.primaryTextColor,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => viewModel.navigateToFindMore(),
                            child: Row(
                              children: [
                                Text(
                                  'Find More',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF8B7CF6),
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
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Investment Opportunities Carousel
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 250,
                          enlargeCenterPage: false,
                          enableInfiniteScroll: false,
                          viewportFraction: 0.65,
                          padEnds: false,
                          scrollPhysics: const RangeMaintainingScrollPhysics(),
                        ),
                        items: viewModel.availableProtocols.map((protocol) {
                          return _buildProtocolCard(
                            context,
                            protocol: protocol,
                            onTap: () => viewModel.navigateToProtocolDetail(protocol['id']),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 32),

                      // Active/Matured Toggle
                      _buildToggleSection(context, viewModel),
                      const SizedBox(height: 24),

                      // Investments Section
                      _buildInvestmentsSection(context, viewModel),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildInvestmentSummaryCard(BuildContext context, InvestmentViewModel viewModel) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF8B5CF6),
            Color(0xFF7C3AED),
            Color(0xFF6D28D9),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Total Portfolio Value',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => viewModel.toggleBalanceVisibility(),
                child: Icon(
                  viewModel.isBalanceVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            viewModel.isBalanceVisible
                ? '\$${viewModel.totalInvestmentBalance.toStringAsFixed(2)}'
                : '****',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w700,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Returns',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      viewModel.isBalanceVisible
                          ? '\$${viewModel.totalReturns.toStringAsFixed(2)}'
                          : '****',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  viewModel.isBalanceVisible
                      ? '+${viewModel.growthPercentage.toStringAsFixed(1)}%'
                      : '****',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToggleSection(BuildContext context, InvestmentViewModel viewModel) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: context.tabBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Active Tab
          Expanded(
            child: GestureDetector(
              onTap: () => viewModel.switchTab('Active'),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Container(
                  height: 47,
                  decoration: BoxDecoration(
                    color: viewModel.selectedTab == 'Active'
                        ? const Color(0xFF8B5CF6)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 8),
                      Text(
                        'Active',
                        style: GoogleFonts.inter(
                          color: viewModel.selectedTab == 'Active'
                              ? Colors.white
                              : context.tabUnselectedColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Matured Tab
          Expanded(
            child: GestureDetector(
              onTap: () => viewModel.switchTab('Matured'),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Container(
                  height: 47,
                  decoration: BoxDecoration(
                    color: viewModel.selectedTab == 'Matured'
                        ? const Color(0xFF8B5CF6)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 8),
                      Text(
                        'Matured',
                        style: GoogleFonts.inter(
                          color: viewModel.selectedTab == 'Matured'
                              ? Colors.white
                              : context.tabUnselectedColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
          Text(
            'No active investments yet',
            style: GoogleFonts.inter(
              color: const Color(0xFF8B8B8B),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start investing to see your portfolio here',
            style: GoogleFonts.inter(
              color: const Color(0xFF5A5A5A),
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
    required Map<String, dynamic> protocol,
    required VoidCallback onTap,
  }) {
    final iconColor = Color(protocol['iconColor']);
    final iconData = _getProtocolIcon(protocol['category']);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Container(
          height: 240,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: context.primaryTextColor.withOpacity(0.1),
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
                protocol['title'],
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: context.primaryTextColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),

              // Subtitle
              Text(
                protocol['subtitle'],
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: context.secondaryTextColor,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // APY and Risk Level
              Row(
                children: [
                  Text(
                    'APY: ',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: context.secondaryTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    protocol['apy'],
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 25),
                  _buildRiskBadge(context, protocol['riskLevel']),
                ],
              ),
              const SizedBox(height: 10),

              // TVL and External Link
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'TVL: ${protocol['tvl']}',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: context.secondaryTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(
                    Icons.launch,
                    size: 16,
                    color: context.secondaryTextColor,
                  ),
                ],
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getProtocolIcon(String category) {
    switch (category.toLowerCase()) {
      case 'lending':
        return Icons.account_balance;
      case 'staking':
        return Icons.waves;
      case 'liquidity':
        return Icons.swap_horiz;
      case 'amm':
        return Icons.trending_up;
      default:
        return Icons.account_balance;
    }
  }

  Widget _buildInvestmentsSection(BuildContext context, InvestmentViewModel viewModel) {
    final investments = viewModel.selectedTab == 'Active'
        ? viewModel.activeInvestments
        : viewModel.maturedInvestments;

    if (investments.isEmpty) {
      return _buildEmptyInvestmentsState(context, viewModel.selectedTab);
    }

    return Column(
      children: investments.map((investment) {
        return _buildInvestmentCard(context, investment, viewModel);
      }).toList(),
    );
  }

  Widget _buildEmptyInvestmentsState(BuildContext context, String tab) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: context.cardColor,
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
          Text(
            tab == 'Active' ? 'No active investments yet' : 'No matured investments yet',
            style: GoogleFonts.inter(
              color: const Color(0xFF8B8B8B),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            tab == 'Active'
                ? 'Start investing to see your portfolio here'
                : 'Your completed investments will appear here',
            style: GoogleFonts.inter(
              color: const Color(0xFF5A5A5A),
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvestmentCard(BuildContext context, Map<String, dynamic> investment, InvestmentViewModel viewModel) {
    final isActive = viewModel.selectedTab == 'Active';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.primaryTextColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                investment['protocol'],
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: context.primaryTextColor,
                ),
              ),
              Text(
                investment['apy'],
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Amount Invested',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: context.secondaryTextColor,
                    ),
                  ),
                  Text(
                    '\$${investment['amount'].toStringAsFixed(2)}',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: context.primaryTextColor,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    isActive ? 'Current Value' : 'Final Value',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: context.secondaryTextColor,
                    ),
                  ),
                  Text(
                    '\$${(isActive ? investment['currentValue'] : investment['finalValue']).toStringAsFixed(2)}',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: context.primaryTextColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (isActive) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => viewModel.withdrawInvestment(investment['id']),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B5CF6),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Withdraw'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRiskBadge(BuildContext context, String riskLevel) {
    Color backgroundColor;
    Color textColor;

    switch (riskLevel.toLowerCase()) {
      case 'high':
        backgroundColor = Colors.red.withOpacity(0.1);
        textColor = Colors.red;
        break;
      case 'medium':
        backgroundColor = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange;
        break;
      case 'low':
        backgroundColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green;
        break;
      default:
        backgroundColor = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        riskLevel,
        style: GoogleFonts.inter(
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
