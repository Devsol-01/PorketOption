import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

import 'investment_viewmodel.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';

class InvestmentView extends StackedView<InvestmentViewModel> {
  const InvestmentView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    InvestmentViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        title: const Text(
          'Investments',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Main Balance Card
            _buildBalanceCard(context),

            const SizedBox(height: 24),

            _buildPromotedSavingsSection(context, viewModel),

            const SizedBox(height: 24),

            //Toggle buttons
            _buildToggleuttons(context),

            const SizedBox(height: 40),

            // Flexible Savings Section
            Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F8FE), // background
                    borderRadius: BorderRadius.circular(23.434),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.trending_up_outlined,
                      size: 24,
                      color:
                          const Color(0xFF004CE8), // you can adjust icon color
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'No active Investment',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500, // 500 = medium
                    fontSize: 14,
                    height: 17 / 14, // line-height ÷ font-size = ~1.21
                    color: Color(0xFF0D0D0D),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF4A90E2),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF004CE8).withOpacity(0.7),
            Color(0xFF1D84F3).withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: (20)),
            child: Row(
              children: [
                Text(
                  'Total Investments',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Icon(
                    Icons.trending_up,
                    color: Colors.white.withOpacity(0.8),
                    size: 25,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                Text(
                  '\$2,567.87',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 12),
                Icon(
                  Icons.visibility_outlined,
                  color: Colors.white.withOpacity(0.8),
                  size: 24,
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              'Up to 35% returns',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromotedSavingsSection(
      BuildContext context, InvestmentViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Vetted Opportunities',
              style: GoogleFonts.inter(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Row(
                children: [
                  Text(
                    'Find More',
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.black,
                    size: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 240,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Image.asset('lib/assets/Invest1.png'),
              const SizedBox(width: 16),
              Image.asset('lib/assets/Invest2.png'),
              const SizedBox(width: 16),
              Image.asset('lib/assets/Invest1.png'),
              const SizedBox(width: 16),
              Image.asset('lib/assets/Invest2.png'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToggleuttons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            width: 171,
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(46),
              // don't make this list `const` if you use Color.fromRGBO, etc.
              boxShadow: [
                BoxShadow(
                  offset: const Offset(-4, 4),
                  blurRadius: 20,
                  color: const Color.fromRGBO(29, 132, 243, 0.10),
                  inset: true,
                ),
                BoxShadow(
                  offset: const Offset(4, 4),
                  blurRadius: 6,
                  color: const Color.fromRGBO(29, 132, 243, 0.10),
                  inset: true,
                ),
              ],
            ),
            child: Center(
              child: Text(
                'Active', // replace with your label or pass via constructor
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF004CE8),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 3,
          child: Container(
            width: 171,
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white, // no fill in Figma, keep white/transparent
              borderRadius: BorderRadius.circular(46),
              border: Border.all(
                color: const Color(0xFF004CE8), // border blue
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                'Matured',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF0E4AC7),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  InvestmentViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      InvestmentViewModel();
}
