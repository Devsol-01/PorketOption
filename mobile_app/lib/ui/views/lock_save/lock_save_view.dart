import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/extensions/theme_context_extension.dart';
import 'package:mobile_app/ui/common/app_colors.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/services.dart';

import 'create_lock_view.dart';
import 'lock_save_viewmodel.dart';

class LockSaveView extends StackedView<LockSaveViewModel> {
  const LockSaveView({super.key});

  @override
  Widget builder(
    BuildContext context,
    LockSaveViewModel viewModel,
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
            onPressed: () => viewModel.navigateBack()),
        title: Text(
          'Lock Save',
          style: GoogleFonts.inter(
            color: context.primaryTextColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showPeriodSelectionBottomSheet(context, viewModel),
        backgroundColor: primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.lock),
        label: const Text('Create Lock'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Balance Card
              Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20.0),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFFF6B6B),
                        Color(0xFFFF5252),
                        Color(0xFFE53935),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Interest rate badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 6.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: const Text(
                          'Up to 18.5% per annum',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Title row with eye icon
                      Row(
                        children: [
                          const Text(
                            'Lock Save Balance',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
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

                      // Balance amount
                      Text(
                        viewModel.isBalanceVisible
                            ? '₦${viewModel.lockSaveBalance.toStringAsFixed(2)}'
                            : '₦••••••',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          height: 1.0,
                        ),
                      ),
                    ],
                  )),

              const SizedBox(height: 24),

              // Lock Periods Section
              Text(
                'Lock Periods & Interest Rates',
                style: GoogleFonts.inter(
                  color: context.primaryTextColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: viewModel.lockPeriods.length,
                  itemBuilder: (context, index) {
                    final period = viewModel.lockPeriods[index];
                    return Padding(
                      padding: EdgeInsets.only(
                          right: index < viewModel.lockPeriods.length - 1
                              ? 12
                              : 0),
                      child: GestureDetector(
                        onTap: () =>
                            viewModel.navigateToCreateLockWithPeriod(period),
                        child: _buildLockPeriodCard(context, period),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Tab Section
              Container(
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: context.tabBackground,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => viewModel.setOngoingSelected(true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          decoration: BoxDecoration(
                            color: viewModel.isOngoingSelected
                                ? primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            'Ongoing',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: viewModel.isOngoingSelected
                                  ? Colors.white
                                  : context.secondaryTextColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => viewModel.setOngoingSelected(false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          decoration: BoxDecoration(
                            color: !viewModel.isOngoingSelected
                                ? primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            'Paid Back',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: !viewModel.isOngoingSelected
                                  ? Colors.white
                                  : context.secondaryTextColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Locks List
              if (viewModel.currentLocks.isNotEmpty)
                ...viewModel.currentLocks
                    .map((lock) => Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: _buildLockCard(context, viewModel, lock),
                        ))
                    .toList()
              else
                _buildEmptyState(context),
            ],
          ),
        ),
      ),
    );
  }

  void _showCreateLockBottomSheet(
      BuildContext context, LockSaveViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildCreateLockBottomSheet(context, viewModel),
    );
  }

  Widget _buildCreateLockBottomSheet(
      BuildContext context, LockSaveViewModel viewModel) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: context.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: context.secondaryTextColor.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Text(
                  'Create Lock Save',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: context.primaryTextColor,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color: context.secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choose Lock Period',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: context.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Lock period options
                  ...viewModel.lockPeriods
                      .map((period) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildLockPeriodOption(
                                context, viewModel, period),
                          ))
                      .toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLockPeriodOption(BuildContext context,
      LockSaveViewModel viewModel, Map<String, dynamic> period) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        _showLockDetailsDialog(context, viewModel, period);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: context.secondaryTextColor.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Color(period['color']),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    period['label'],
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: context.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${period['interestRate']}% per annum',
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

  void _showLockDetailsDialog(BuildContext context, LockSaveViewModel viewModel,
      Map<String, dynamic> period) {
    final TextEditingController amountController = TextEditingController();
    final TextEditingController titleController = TextEditingController();
    String selectedFundSource = 'Porket Wallet';
    int selectedDays = period['minDays'];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: context.backgroundColor,
          title: Text(
            'Lock Details',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: context.primaryTextColor,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Amount input
                Text(
                  'Amount to Lock',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: context.primaryTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter amount',
                    prefixText: '₦ ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Title input
                Text(
                  'Lock Title',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: context.primaryTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: 'e.g., Emergency Fund',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Days selector
                Text(
                  'Lock Duration (${period['minDays']}-${period['maxDays']} days)',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: context.primaryTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                Slider(
                  value: selectedDays.toDouble(),
                  min: period['minDays'].toDouble(),
                  max: period['maxDays'].toDouble(),
                  divisions: period['maxDays'] - period['minDays'],
                  label: '$selectedDays days',
                  onChanged: (value) {
                    setState(() {
                      selectedDays = value.round();
                    });
                  },
                ),

                const SizedBox(height: 16),

                // Fund source
                Text(
                  'Fund Source',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: context.primaryTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedFundSource,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: ['Porket Wallet', 'External Wallet', 'Add Card']
                      .map((source) => DropdownMenuItem(
                            value: source,
                            child: Text(source),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedFundSource = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(
                  color: context.secondaryTextColor,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (amountController.text.isNotEmpty &&
                    titleController.text.isNotEmpty) {
                  final lockData = {
                    'amount': double.parse(amountController.text),
                    'title': titleController.text,
                    'days': selectedDays,
                    'fundSource': selectedFundSource,
                    'period': period,
                  };
                  Navigator.pop(context);
                  _showLockPreview(context, viewModel, lockData);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Preview'),
            ),
          ],
        ),
      ),
    );
  }

  void _showLockPreview(BuildContext context, LockSaveViewModel viewModel,
      Map<String, dynamic> lockData) {
    final preview = viewModel.calculateLockPreview(
      lockData['amount'],
      lockData['days'],
      lockData['period']['interestRate'],
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.backgroundColor,
        title: Text(
          'Lock Preview',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: context.primaryTextColor,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPreviewRow('Title', lockData['title']),
            _buildPreviewRow(
                'Amount', '₦${lockData['amount'].toStringAsFixed(2)}'),
            _buildPreviewRow(
                'Interest Rate', '${lockData['period']['interestRate']}%'),
            _buildPreviewRow('Duration', '${lockData['days']} days'),
            _buildPreviewRow('Interest to Earn',
                '₦${preview['interest'].toStringAsFixed(2)}'),
            _buildPreviewRow('Maturity Date', preview['maturityDate']),
            _buildPreviewRow('Total Payout',
                '₦${preview['totalPayout'].toStringAsFixed(2)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                color: context.secondaryTextColor,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              viewModel.createSafelock(
                lockData['amount'],
                lockData['title'],
                lockData['days'],
                lockData['fundSource'],
                lockData['period'],
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Create Lock'),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildLockPeriodCard(
      BuildContext context, Map<String, dynamic> period) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(period['color']).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color(period['color']).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            period['label'],
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: context.primaryTextColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${period['interestRate']}%',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(period['color']),
            ),
          ),
          Text(
            'per annum',
            style: GoogleFonts.inter(
              fontSize: 10,
              color: context.secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLockCard(BuildContext context, LockSaveViewModel viewModel,
      Map<String, dynamic> lock) {
    final bool isMatured = lock['status'] == 'matured';
    final bool isOngoing = lock['status'] == 'ongoing';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.cardBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lock['title'],
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: context.primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₦${lock['amount'].toStringAsFixed(2)}',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: primary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isMatured
                      ? Colors.green.withValues(alpha: 0.1)
                      : isOngoing
                          ? Colors.orange.withValues(alpha: 0.1)
                          : Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  lock['status'].toString().toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isMatured
                        ? Colors.green
                        : isOngoing
                            ? Colors.orange
                            : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Interest Rate',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: context.secondaryTextColor,
                      ),
                    ),
                    Text(
                      '${lock['interestRate']}%',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: context.primaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Maturity Date',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: context.secondaryTextColor,
                      ),
                    ),
                    Text(
                      lock['maturityDate'],
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: context.primaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (isMatured) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => viewModel.withdrawLock(lock['id']),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Withdraw ₦${lock['totalPayout'].toStringAsFixed(2)}',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ] else if (isOngoing) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        _showBreakLockDialog(context, viewModel, lock),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Break Lock',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _showBreakLockDialog(BuildContext context, LockSaveViewModel viewModel,
      Map<String, dynamic> lock) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.backgroundColor,
        title: Text(
          'Break Lock',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: context.primaryTextColor,
          ),
        ),
        content: Text(
          'Are you sure you want to break this lock? You will lose all accrued interest and pay a penalty fee.',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: context.secondaryTextColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                color: context.secondaryTextColor,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              viewModel.breakLock(lock['id']);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Break Lock'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: context.actionButtonBackground,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Icon(
              Icons.lock_outline,
              size: 24,
              color: context.secondaryTextColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No locks found',
            style: GoogleFonts.inter(
              color: context.primaryTextColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first lock to get started',
            style: GoogleFonts.inter(
              color: context.secondaryTextColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
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
          color: context.backgroundColor,
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
                color: context.secondaryTextColor.withOpacity(0.3),
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
                  color: context.primaryTextColor,
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
                              color: context.primaryTextColor,
                            ),
                          ),
                          subtitle: Text(
                            '${period['interestRate']}% per annum',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: context.secondaryTextColor,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: context.secondaryTextColor,
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

  void _showSimpleCreateLockDialog(BuildContext context,
      LockSaveViewModel viewModel, Map<String, dynamic> period) {
    final TextEditingController amountController = TextEditingController();
    final TextEditingController titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.backgroundColor,
        title: Text(
          'Create ${period['label']} Lock',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: context.primaryTextColor,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount to Lock',
                prefixText: '₦ ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Lock Title',
                hintText: 'e.g., Emergency Fund',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                color: context.secondaryTextColor,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (amountController.text.isNotEmpty &&
                  titleController.text.isNotEmpty) {
                final amount = double.tryParse(amountController.text) ?? 0;
                if (amount > 0) {
                  viewModel.createSafelock(
                    amount,
                    titleController.text,
                    period['minDays'] +
                        ((period['maxDays'] - period['minDays']) ~/
                            2), // Use middle duration
                    'Porket Wallet',
                    period,
                  );
                  Navigator.pop(context);

                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('SafeLock created successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Create Lock'),
          ),
        ],
      ),
    );
  }

  @override
  LockSaveViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      LockSaveViewModel();
}
