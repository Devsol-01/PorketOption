import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/ui/views/lock_save/create_lock/create_lock_view.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';

import 'lock_save_viewmodel.dart';

class LockSaveView extends StackedView<LockSaveViewModel> {
  const LockSaveView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    LockSaveViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Lock Savings',
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromRGBO(255, 195, 111, 0.7), // rgba(255,195,111,0.7)
                    Color.fromRGBO(255, 229, 193, 0.7), // rgba(255,229,193,0.7)
                  ],
                  stops: [0.3285, 1.2219], // stops match Figma percentages
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Interest Rate
                  const Text(
                    '4.5% per annum',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Balance Label
                  const Text(
                    'Goal saving Balance',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  // const SizedBox(height: 8),

                  // Balance Amount
                  Row(
                    children: [
                      Text(
                        '\$1000',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {},
                        child: Icon(
                          Icons.visibility,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _buildRecommendations(context, viewModel),

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
                    color: const Color(0xFFFFDBA8), // Figma background
                    borderRadius: BorderRadius.circular(23.434),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.lock_outline, // Placeholder for piggy bank
                      size: 24,
                      color: Colors.black, // matches your vector color
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'No ongoing flexible savings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Create your first flexible savings to get started',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () => _showPeriodSelectionBottomSheet(context, viewModel),
          child: Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color: Color(0xFFFFFFFF), // can change to 0xFFFFF2E0 for more pop
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Color(0x33FFA82F), // subtle outer shadow
                  offset: Offset(2, 2),
                  blurRadius: 4,
                ),
                BoxShadow(
                  color: Color(0x22FFA82F),
                  offset: Offset(-1, -1),
                  blurRadius: 2,
                  inset: true, // keeps inset effect
                ),
              ],
            ),
            child: Center(
                child: Icon(
              Icons.add,
              color: Color(0xFFFFA82F),
            )),
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendations(
      BuildContext context, LockSaveViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recommendations',
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
                    'View More',
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
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Image.asset(
                'lib/assets/365.png',
                height: 160,
                width: 139,
              ),
              const SizedBox(width: 16),
              Image.asset('lib/assets/120.png', height: 153, width: 139),
              const SizedBox(width: 16),
              Image.asset('lib/assets/365.png', height: 153, width: 139),
              const SizedBox(width: 16),
              Image.asset('lib/assets/120.png', height: 153, width: 139),
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
              height: 39,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(46),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(-4, 4),
                    blurRadius: 20,
                    color: const Color.fromRGBO(255, 168, 47, 0.1),
                    inset: true,
                  ),
                  BoxShadow(
                    offset: const Offset(4, 4),
                    blurRadius: 6,
                    color: const Color.fromRGBO(255, 168, 47, 0.1),
                    inset: true,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'Live',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    height: 19 / 16, // line-height ÷ font-size
                    color: Color(0xFFFFA82F), // Primary orange
                  ),
                ),
              ),
            )),
        const SizedBox(width: 16),
        Expanded(
          flex: 3,
          child: Container(
            width: 171,
            height: 39,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(46),
              border: Border.all(
                color: const Color(0xFFFFA82F), // orange border
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                'Paid Back',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  height: 19 / 16, // line-height ÷ font-size
                  color: Color(0xFFFFA82F), // orange text
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showPeriodSelectionBottomSheet(
      BuildContext context, LockSaveViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Select Lock Period',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),

            // Period options - wrapped in Flexible to prevent overflow
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: viewModel.lockPeriods
                    .map((period) => ListTile(
                          leading: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Color(period['color']),
                              shape: BoxShape.circle,
                            ),
                          ),
                          title: Text(
                            period['label'],
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            '${period['interestRate']}% per annum',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.black,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            // Navigate to CreateLockView with selected period
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateLockView(
                                  selectedPeriod: period,
                                ),
                              ),
                            );
                          },
                        ))
                    .toList(),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  LockSaveViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      LockSaveViewModel();
}
