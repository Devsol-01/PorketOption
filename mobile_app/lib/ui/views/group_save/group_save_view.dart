import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

import 'group_save_viewmodel.dart';

class GroupSaveView extends StackedView<GroupSaveViewModel> {
  const GroupSaveView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    GroupSaveViewModel viewModel,
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
          'Group Savings',
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
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF4A90E2),
                    Color(0xFF357ABD),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
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

            _buildPromotedSavingsSection(context, viewModel),

            const SizedBox(height: 24),

            //Toggle buttons
            _buildToggleuttons(context),

            const SizedBox(height: 40),

            // Group Savings Section
            Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Color(0xFFEAFDEA),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.group,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'No ongoing Group savings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Create your first Goal savings to get started',
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => viewModel.createGroupSave(),
        backgroundColor: const Color(0xFF4A90E2),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildPromotedSavingsSection(
      BuildContext context, GroupSaveViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Promoted Savings Groups',
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
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Image.asset(
                'lib/assets/lock.png',
                width: 139,
                height: 172,
              ),
              const SizedBox(width: 16),
              Image.asset(
                'lib/assets/lock.png',
                width: 139,
                height: 172,
              ),
              const SizedBox(width: 16),
              Image.asset(
                'lib/assets/group.png',
                width: 139,
                height: 172,
              ),
              const SizedBox(width: 16),
              Image.asset(
                'lib/assets/group.png',
                width: 139,
                height: 172,
              ),
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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white, // #FFFFFF
              borderRadius: BorderRadius.circular(46),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(13, 213, 13, 0.1),
                  offset: Offset(-4, 4),
                  blurRadius: 20,
                  inset: true, // requires flutter_inset_shadow
                ),
                BoxShadow(
                  color: Color.fromRGBO(13, 213, 13, 0.1),
                  offset: Offset(4, 4),
                  blurRadius: 6,
                  inset: true,
                ),
              ],
            ),
            child: Center(
              child: Text(
                'Ongoing',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color:
                    Colors.transparent, // Secondary buttons usually transparent
                borderRadius: BorderRadius.circular(46),
                border: Border.all(
                  color: const Color(0xFFA9F9A9),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  'Paid back',
                  style: TextStyle(
                    color: Color(0xFF509350),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
            )),
      ],
    );
  }

  @override
  GroupSaveViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      GroupSaveViewModel();
}
