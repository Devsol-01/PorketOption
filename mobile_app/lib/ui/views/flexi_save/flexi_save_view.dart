import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/extensions/theme_context_extension.dart';
import 'package:mobile_app/ui/common/app_colors.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/services.dart';

import 'flexi_save_viewmodel.dart';

class FlexiSaveView extends StackedView<FlexiSaveViewModel> {
  const FlexiSaveView({super.key});

  @override
  Widget builder(
    BuildContext context,
    FlexiSaveViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        backgroundColor: context.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: context.primaryTextColor,
          ),
          onPressed: () => viewModel.navigateBack(),
        ),
        title: Text(
          'PiggyBank',
          style: GoogleFonts.inter(
            color: context.primaryTextColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.info_outline,
              color: context.primaryTextColor,
            ),
            onPressed: () => viewModel.showInfo(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showQuickSaveDialog(context, viewModel),
        backgroundColor: const Color(0xFF4B7EF7),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PiggyBank Balance Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF4B7EF7),
                      Color(0xFF5B8EFF),
                      Color(0xFF7BA7FF),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Interest rate badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 6.0),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: const Text(
                        '18% per annum',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Title row with eye icon
                    Row(
                      children: [
                        const Text(
                          'PiggyBank Balance',
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
                            color: Colors.white.withOpacity(0.8),
                            size: 18,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Balance amount
                    Text(
                      viewModel.isBalanceVisible
                          ? '₦${viewModel.flexiSaveBalance.toStringAsFixed(0)}'
                          : '****',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        height: 1.0,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Interest and AutoSave info row
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Interest in 1 days',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const Text(
                                '₦0 at (18% p.a)',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'AutoSave',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const Text(
                              '₦1,000 daily',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // AutoSave Toggle Section
              _buildAutoSaveToggleSection(context, viewModel),

              const SizedBox(height: 24),

              // Action Buttons Row
              _buildActionButtonsRow(context, viewModel),

              const SizedBox(height: 32),

              // Recent Transactions
              if (viewModel.transactions.isNotEmpty)
                ..._buildTransactionsSection(context, viewModel),

              const SizedBox(
                  height: 80), // Extra space for floating action button
            ],
          ),
        ),
      ),
    );
  }

  // Show save options bottom sheet
  void _showSaveOptionsBottomSheet(
      BuildContext context, FlexiSaveViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildSaveOptionsBottomSheet(context, viewModel),
    );
  }

  Widget _buildSaveOptionsBottomSheet(
      BuildContext context, FlexiSaveViewModel viewModel) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: context.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: context.secondaryTextColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Save Money',
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: context.primaryTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose how you want to save',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: context.secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 32),
                _buildSaveOption(
                  context,
                  icon: Icons.flash_on,
                  title: 'Quick Save',
                  subtitle: 'Save any amount instantly',
                  onTap: () {
                    Navigator.pop(context);
                    _showQuickSaveDialog(context, viewModel);
                  },
                ),
                const SizedBox(height: 16),
                _buildSaveOption(
                  context,
                  icon: Icons.schedule,
                  title: 'Setup AutoSave',
                  subtitle: 'Automatically save on schedule',
                  onTap: () {
                    Navigator.pop(context);
                    _showAutoSaveSetupDialog(context, viewModel);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.cardBorder),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: primary, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: context.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: context.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: context.secondaryTextColor,
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickSaveDialog(
      BuildContext context, FlexiSaveViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildQuickSaveBottomSheet(context, viewModel),
    );
  }

  Widget _buildQuickSaveBottomSheet(BuildContext context, FlexiSaveViewModel viewModel) {
    final TextEditingController amountController = TextEditingController(text: '5,000');
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: context.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: context.secondaryTextColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Text(
                  'Quick save to Piggybank',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.flash_on,
                  color: Color(0xFFFFD700),
                  size: 20,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Amount Input Section
                  Text(
                    'Enter an Amount',
                    style: TextStyle(
                      color: context.secondaryTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Amount Input Field
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    decoration: BoxDecoration(
                      color: context.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: context.cardBorder),
                    ),
                    child: Row(
                      children: [
                        Text(
                          '₦',
                          style: TextStyle(
                            color: context.secondaryTextColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              color: context.primaryTextColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: '0',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Quick Save Button
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 32),
                    child: ElevatedButton(
                      onPressed: () {
                        final amountText = amountController.text.replaceAll(',', '');
                        final amount = double.tryParse(amountText);
                        if (amount != null && amount > 0) {
                          viewModel.quickSave(amount, 'Porket Wallet');
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Successfully saved ₦${amount.toStringAsFixed(0)}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              backgroundColor: const Color(0xFF4B7EF7),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4B7EF7),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Quick Save',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAutoSaveSetupDialog(
      BuildContext context, FlexiSaveViewModel viewModel) {
    // This would open a comprehensive auto-save setup flow
    // For now, showing a simple dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Setup AutoSave',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        content: const Text(
            'AutoSave setup flow will be implemented here with frequency, amount, and timing options.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAutoSaveSection(
      BuildContext context, FlexiSaveViewModel viewModel) {
    return [
      Text(
        'AutoSave Settings',
        style: GoogleFonts.inter(
          color: context.primaryTextColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 16),
      ...viewModel.autoSaveSettings
          .map((autoSave) => _buildAutoSaveCard(context, viewModel, autoSave)),
    ];
  }

  Widget _buildAutoSaveCard(BuildContext context, FlexiSaveViewModel viewModel,
      Map<String, dynamic> autoSave) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${autoSave['amount']} ${autoSave['frequency']}',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: context.primaryTextColor,
                ),
              ),
              Switch(
                value: autoSave['isActive'],
                onChanged: (value) =>
                    viewModel.toggleAutoSaveStatus(autoSave['id']),
                activeColor: primary,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Source: ${autoSave['fundSource']} • Time: ${autoSave['time']}',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: context.secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyAutoSaveCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.cardBorder),
      ),
      child: Column(
        children: [
          Icon(
            Icons.schedule,
            size: 48,
            color: context.secondaryTextColor.withOpacity(0.5),
          ),
          const SizedBox(height: 12),
          Text(
            'No AutoSave Setup',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: context.primaryTextColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Set up automatic savings to reach your goals faster',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: context.secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTransactionsSection(
      BuildContext context, FlexiSaveViewModel viewModel) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Recent Transactions',
            style: GoogleFonts.inter(
              color: context.primaryTextColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextButton(
            onPressed: () => viewModel.showTransactionHistory(),
            child: Text(
              'View All',
              style: GoogleFonts.inter(
                color: primary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      ...viewModel.transactions
          .take(3)
          .map((transaction) => _buildTransactionItem(context, transaction)),
    ];
  }

  Widget _buildTransactionItem(
      BuildContext context, Map<String, dynamic> transaction) {
    final isPositive = transaction['amount'] > 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (isPositive ? Colors.green : Colors.red).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isPositive ? Icons.add : Icons.remove,
              color: isPositive ? Colors.green : Colors.red,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction['type'],
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: context.primaryTextColor,
                  ),
                ),
                Text(
                  transaction['fundSource'],
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: context.secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${isPositive ? '+' : ''}\$${transaction['amount'].abs().toStringAsFixed(2)}',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isPositive ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }



  // AutoSave Toggle Section
  Widget _buildAutoSaveToggleSection(BuildContext context, FlexiSaveViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.flash_on,
                color: Color(0xFFFFD700),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'AutoSave is enabled',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Switch(
                value: viewModel.isAutoSaveEnabled,
                onChanged: (value) => viewModel.toggleAutoSave(),
                activeColor: const Color(0xFF4B7EF7),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Your next AutoSave deposit is scheduled to be on Thursday 3rd of July 2025, by 8:00:00 AM',
            style: TextStyle(
              color: context.secondaryTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  // Action Buttons Row
  Widget _buildActionButtonsRow(BuildContext context, FlexiSaveViewModel viewModel) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            context,
            icon: Icons.add,
            label: 'Quick Save',
            backgroundColor: const Color(0xFFE8F4FD),
            iconColor: const Color(0xFF4B7EF7),
            textColor: const Color(0xFF4B7EF7),
            onTap: () => _showQuickSaveDialog(context, viewModel),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildActionButton(
            context,
            icon: Icons.account_balance,
            label: 'Withdraw',
            backgroundColor: const Color(0xFFE8F4FD),
            iconColor: const Color(0xFF4B7EF7),
            textColor: const Color(0xFF4B7EF7),
            onTap: () => _showWithdrawDialog(context, viewModel),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildActionButton(
            context,
            icon: Icons.settings,
            label: 'Settings',
            backgroundColor: const Color(0xFFE8F4FD),
            iconColor: const Color(0xFF4B7EF7),
            textColor: const Color(0xFF4B7EF7),
            onTap: () => _showSettingsDialog(context, viewModel),
          ),
        ),
      ],
    );
  }

  // Updated Action Button
  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color backgroundColor,
    required Color iconColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: GoogleFonts.inter(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Withdraw Dialog
  void _showWithdrawDialog(BuildContext context, FlexiSaveViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildBreakDialog(context, viewModel),
    );
  }

  // Settings Dialog
  void _showSettingsDialog(BuildContext context, FlexiSaveViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildSettingsBottomSheet(context, viewModel),
    );
  }

  // Break Dialog (like the PiggyBank break feature)
  Widget _buildBreakDialog(BuildContext context, FlexiSaveViewModel viewModel) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: context.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: context.secondaryTextColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F4FD),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.account_balance,
                        color: Color(0xFF4B7EF7),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Break Your PiggyBank 😔',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.account_balance_wallet,
                                color: Color(0xFF4B7EF7),
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '₦0',
                                style: TextStyle(
                                  color: context.primaryTextColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Current Balance',
                            style: TextStyle(
                              color: context.secondaryTextColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                color: Color(0xFF4B7EF7),
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '30th of Sep, ...',
                                style: TextStyle(
                                  color: context.primaryTextColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Next Withdrawal Day',
                            style: TextStyle(
                              color: context.secondaryTextColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Settings Bottom Sheet
  Widget _buildSettingsBottomSheet(BuildContext context, FlexiSaveViewModel viewModel) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: context.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: context.secondaryTextColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F4FD),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.shield,
                        color: Color(0xFF4B7EF7),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'PiggyBank Settings',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                _buildSettingsOption(
                  context,
                  icon: Icons.settings,
                  title: 'AutoSave Settings',
                  subtitle: 'Change your AutoSave settings here.',
                  onTap: () => viewModel.navigateToAutoSaveSettings(),
                ),
                const SizedBox(height: 16),
                _buildSettingsOption(
                  context,
                  icon: Icons.calendar_today,
                  title: 'Set Withdrawal Date',
                  subtitle: 'Change your withdrawal date here.',
                  onTap: () => viewModel.navigateToWithdrawalSettings(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.cardBorder),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF4B7EF7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: context.primaryTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: context.secondaryTextColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: context.secondaryTextColor,
            ),
          ],
        ),
      ),
    );
  }

  @override
  FlexiSaveViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      FlexiSaveViewModel();
}
