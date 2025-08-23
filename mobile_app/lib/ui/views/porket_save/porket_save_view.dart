import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/ui/views/porket_save/porket_save_viewmodel.dart';
import 'package:mobile_app/ui/views/dashboard/dashboard_viewmodel.dart';
import 'package:mobile_app/ui/widgets/deposit_sheet.dart';
import 'package:mobile_app/ui/widgets/withdraw_sheet.dart';
import 'package:stacked/stacked.dart';
import 'package:mobile_app/app/app.locator.dart';

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
        title: Text(
          'Porket Savings',
          style: GoogleFonts.inter(
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
                color: Color(0xFF0000A5).withOpacity(0.7),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Interest Rate
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withOpacity(0.2), // subtle transparent white
                      borderRadius: BorderRadius.circular(20), // pill shape
                    ),
                    child: Text(
                      '4.5% per annum',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Balance Label
                  Text(
                    "Porket Savings Balance",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      height: 17 / 14, // lineHeight / fontSize
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),

                  // Balance Amount
                  Row(
                    children: [
                      Text(
                        viewModel.isBalanceVisible ? viewModel.balance : '****',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
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
            _buildAction(context, viewModel),

            const SizedBox(height: 24),

            const SizedBox(height: 40),

            // Flexible Savings Section
            Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Color(0xFFCADAFC),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.savings_outlined,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'No ongoing Porket savings',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500, // 500 = medium
                    fontSize: 15,
                    height: 17 / 14, // line-height ÷ font-size
                    color: const Color(0xFF0D0D0D), // #0D0D0D
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Create your first Porket savings to get started',
                  style: TextStyle(
                    fontSize: 13,
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
    );
  }

  Widget _AutoSaveCard(BuildContext context, PorketSaveViewModel viewModel) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color(0xFF004CE8).withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'AutoSave is enable',
            style: TextStyle(
              color: Color(0xFF0000A5),
              height: 17 / 14,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Your next auto save is schedule to be on 3rd October 2025, by 8:00 am',
            style: TextStyle(
              color: Color(0xFF0000A5),
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
                  color: Color(0xFF0000A5),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Transform.scale(
                scale:
                    0.8, // Adjust the scale to reduce size (0.5 = half size, 1.0 = default)
                child: Switch(
                  value: viewModel.isAutoSaveEnabled,
                  onChanged: viewModel.toggleAutoSave,
                  activeColor:
                      const Color(0xFF0000A5), // thumb color when active
                  activeTrackColor: const Color(0xFF0000A5)
                      .withOpacity(0.5), // track color when active
                  //inactiveThumbColor: Colors.grey, // thumb color when inactive
                  //inactiveTrackColor: Colors.grey.shade400, // track color when inactive
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAction(BuildContext context, PorketSaveViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          icon: Icons.arrow_upward,
          label: 'Quick Save',
          onTap: () => _showDepositSheet(context, viewModel),
        ),
        _buildActionButton(
          icon: Icons.savings_outlined,
          label: 'Withdraw',
          onTap: () => _showWithdrawSheet(context, viewModel),
        ),
        _buildActionButton(
          icon: Icons.settings_outlined,
          label: 'Settings',
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
                color: Color(0xFF000000),
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

  void _showDepositSheet(BuildContext context, PorketSaveViewModel viewModel) {
    // Get dashboard viewmodel for balance checking
    final dashboardViewModel = locator<DashboardViewModel>();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DepositSheet(
        onDeposit: (amount, fundSource) => viewModel.quickSave(amount, fundSource),
        currentBalance: dashboardViewModel.dashboardBalance, // Use dashboard balance
        isLoading: viewModel.isBusy,
      ),
    );
  }

  void _showWithdrawSheet(BuildContext context, PorketSaveViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WithdrawSheet(
        onWithdraw: viewModel.withdraw,
        currentBalance: viewModel.rawBalance,
        isLoading: viewModel.isBusy,
      ),
    );
  }

  @override
  PorketSaveViewModel viewModelBuilder(
    BuildContext context,
  ) {
    final dashboardViewModel = locator<DashboardViewModel>();
    final viewModel = PorketSaveViewModel();
    viewModel.initialize(dashboardViewModel);
    return viewModel;
  }
}
