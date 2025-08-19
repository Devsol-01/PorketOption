import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

import 'porket_save_viewmodel.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';

class PorketSaveView extends StackedView<PorketSaveViewModel> {
  const PorketSaveView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    PorketSaveViewModel viewModel,
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
          'Porket Savings',
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
                    'Pocket saving Balance',
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
                        '\$${viewModel.balance}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: viewModel.toggleBalanceVisibility,
                        child: Icon(
                          viewModel.isBalanceVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
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

            // Action Buttons
            _buildAction(context),

            const SizedBox(height: 24),

            const SizedBox(height: 40),

            // Flexible Savings Section
            Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.account_balance_wallet_outlined,
                    color: Colors.grey[600],
                    size: 24,
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
      floatingActionButton: FloatingActionButton(
        onPressed: viewModel.onCreateGoalSavings,
        backgroundColor: const Color(0xFF4A90E2),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _AutoSaveCard(BuildContext context, PorketSaveViewModel viewModel) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'AutoSave is enable',
            style: TextStyle(
              color: Color(0xFF4A90E2),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Your next auto save is schedule to be on ${viewModel.nextAutoSaveDate}',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Auto Save amount :\$${viewModel.autoSaveAmount} daily',
                style: const TextStyle(
                  color: Color(0xFF4A90E2),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Switch(
                value: viewModel.isAutoSaveEnabled,
                onChanged: viewModel.toggleAutoSave,
                activeColor: const Color(0xFF4A90E2),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAction(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          icon: Icons.arrow_upward,
          label: 'Deposit',
          onTap: () {},
        ),
        _buildActionButton(
          icon: Icons.savings_outlined,
          label: 'Save',
          onTap: () {},
        ),
        _buildActionButton(
          icon: Icons.send_outlined,
          label: 'send',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
            onTap: onTap,
            child: Container(
              width: 80,
              height: 80,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(23.434),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(29, 132, 243, 0.1),
                    offset: Offset(-2.03774, 2.03774),
                    blurRadius: 10.1887,
                    inset: true,
                  ),
                  BoxShadow(
                    color: Color.fromRGBO(29, 132, 243, 0.1),
                    offset: Offset(2.03774, 2.03774),
                    blurRadius: 3.0566,
                    inset: true,
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: Colors.black,
                size: 24,
              ),
            )),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  @override
  PorketSaveViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      PorketSaveViewModel();
}
