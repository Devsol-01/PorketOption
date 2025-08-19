import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

import 'goal_save_viewmodel.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';

class GoalSaveView extends StackedView<GoalSaveViewModel> {
  const GoalSaveView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    GoalSaveViewModel viewModel,
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
          'Goal Savings',
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
                gradient: LinearGradient(
                  begin: Alignment(-0.6, -1), // approx. 127.44deg
                  end: Alignment(0.6, 1),
                  colors: [
                    const Color.fromRGBO(
                        138, 56, 245, 0.7), // rgba(138, 56, 245, 0.7)
                    const Color.fromRGBO(
                        238, 226, 255, 0.7), // rgba(238, 226, 255, 0.7)
                  ],
                  stops: [0.2832, 0.8873], // 28.32% and 88.73%
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

            const SizedBox(height: 20),

            // AutoSave Card
            _AutoSaveCard(context, viewModel),

            const SizedBox(height: 24),

            //Toggle buttons
            _buildToggleuttons(context),

            const SizedBox(height: 40),

            Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    color: Color(0xFFE8D7FF),
                    borderRadius: BorderRadius.circular(
                        23.434), // match previous save button
                  ),
                  child: Center(
                    child: Icon(
                      Icons.track_changes, // or your piggy bank icon
                      size: 24,
                      color: Colors.black, // matches vector in your Figma
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'No ongoingGoal savings',
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
        child: Container(
          width: 65,
          height: 65,
          decoration: BoxDecoration(
            color: Color(0xFFFFFFFF), // can change to 0xFFFFF2E0 for more pop
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Color(0x338A38F5),
                offset: Offset(2, 2),
                blurRadius: 4,
              ),
              BoxShadow(
                color: Color(0x338A38F5),
                offset: Offset(-1, -1),
                blurRadius: 2,
                inset: true, // keeps inset effect
              ),
            ],
          ),
          child: Center(
              child: Icon(
            Icons.add,
            color: Color(0xFF8A38F5),
          )),
        ),
      ),
    );
  }

  Widget _AutoSaveCard(BuildContext context, GoalSaveViewModel viewModel) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              const Color.fromRGBO(138, 56, 245, 0.3), // rgba(138,56,245,0.3)
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What is goal savings?',
            style: GoogleFonts.inter(
              color: const Color(0xFF8A38F5),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Goal savings is a great way to save towards towards a specific goal or target.',
            style: TextStyle(
              color: Color(0xFF8A38F5),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'You can set up automatic savings to help you reach your goal faster.',
            style: TextStyle(
              color: Color(0xFF8A38F5),
              fontSize: 14,
            ),
          ),
        ],
      ),
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
                color: Colors.white, // matches background #FFFFFF
                borderRadius: BorderRadius.circular(46),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromRGBO(138, 56, 245, 0.1),
                    offset: const Offset(-4, 4),
                    blurRadius: 20,
                    inset:
                        true, // inset shadow requires flutter_inset_shadow package
                  ),
                  BoxShadow(
                    color: const Color.fromRGBO(138, 56, 245, 0.1),
                    offset: const Offset(4, 4),
                    blurRadius: 6,
                    inset: true,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'Live', // replace with your text
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF8A38F5), // optional text color
                  ),
                ),
              ),
            )),
        const SizedBox(width: 16),
        Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.transparent, // no fill, just border
                border: Border.all(
                  color: const Color(0xFF8A38F5), // matches #8A38F5
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(46), // rounded pill shape
              ),
              child: Center(
                child: Text(
                  'Completed', // replace with your text
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Color(0xFF8A38F5), // same as border
                  ),
                ),
              ),
            )),
      ],
    );
  }

  @override
  GoalSaveViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      GoalSaveViewModel();
}
