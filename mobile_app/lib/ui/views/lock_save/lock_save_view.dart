import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/ui/views/lock_save/create_lock/create_lock_view.dart';
import 'package:mobile_app/ui/views/lock_save/lock_save_viewmodel.dart';
import 'package:mobile_app/ui/views/dashboard/dashboard_viewmodel.dart';
import 'package:mobile_app/app/app.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:mobile_app/utils/format_utils.dart';

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
      body: RefreshIndicator(
        onRefresh: viewModel.refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Main Balance Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color(0xFFFFC36F),
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
                      "Lock Savings Balance",
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
                          viewModel.isBalanceVisible
                              ? FormatUtils.formatCurrency(viewModel.rawBalance)
                              : '****',
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

              const SizedBox(height: 24),

              _buildRecommendations(context, viewModel),

              const SizedBox(height: 24),

              //Toggle buttons
              _buildToggleButtons(context, viewModel),

              const SizedBox(height: 16),

              // Show error if any
              if (viewModel.lastError != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red[600], size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          viewModel.lastError!,
                          style: TextStyle(color: Colors.red[700], fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),

              // Lock Savings Section
              viewModel.isLoading
                  ? _buildLoadingState()
                  : viewModel.currentLocks.isEmpty
                      ? _buildEmptyState(viewModel.isOngoingSelected)
                      : _buildLocksList(context, viewModel),

              const SizedBox(height: 100), // Space for FAB
            ],
          ),
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

  Widget _buildToggleButtons(
      BuildContext context, LockSaveViewModel viewModel) {
    return Row(
      children: [
        Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: () => viewModel.setOngoingSelected(true),
              child: Container(
                width: 171,
                height: 39,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: viewModel.isOngoingSelected
                      ? Colors.white
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(46),
                  border: viewModel.isOngoingSelected
                      ? null
                      : Border.all(
                          color: const Color(0xFFFFA82F),
                          width: 1,
                        ),
                  boxShadow: viewModel.isOngoingSelected
                      ? [
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
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    'Ongoing (${viewModel.ongoingLocks.length})',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      height: 19 / 16,
                      color: Color(0xFFFFA82F),
                    ),
                  ),
                ),
              ),
            )),
        const SizedBox(width: 16),
        Expanded(
          flex: 3,
          child: GestureDetector(
            onTap: () => viewModel.setOngoingSelected(false),
            child: Container(
              width: 171,
              height: 39,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: !viewModel.isOngoingSelected
                    ? Colors.white
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(46),
                border: !viewModel.isOngoingSelected
                    ? null
                    : Border.all(
                        color: const Color(0xFFFFA82F),
                        width: 1,
                      ),
                boxShadow: !viewModel.isOngoingSelected
                    ? [
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
                      ]
                    : null,
              ),
              child: Center(
                child: Text(
                  'Completed (${viewModel.completedLocks.length})',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    height: 19 / 16,
                    color: Color(0xFFFFA82F),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocksList(BuildContext context, LockSaveViewModel viewModel) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: viewModel.currentLocks.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final lock = viewModel.currentLocks[index];
        return _buildLockCard(context, lock, viewModel);
      },
    );
  }

  Widget _buildLockCard(BuildContext context, Map<String, dynamic> lock, LockSaveViewModel viewModel) {
    final title = lock['title'] ?? 'Untitled';
    final amount = (lock['amount'] ?? 0.0) as double;
    final status = lock['status'] ?? 'unknown';
    final isMatured = lock['isMatured'] ?? false;
    final timeRemaining = lock['timeRemaining'] ?? 0;
    final maturityDate = lock['maturityDate'];

    // Calculate days left
    String daysLeftText = '';
    if (status == 'ongoing' && timeRemaining > 0) {
      final days = (timeRemaining / 86400).ceil(); // Convert seconds to days
      daysLeftText = days == 1 ? '1 day left' : '$days days left';
    } else if (status == 'ready_to_withdraw' || isMatured) {
      daysLeftText = 'Ready to withdraw';
    } else if (status == 'completed') {
      daysLeftText = 'Completed';
    }

    // Status color
    Color statusColor;
    switch (status) {
      case 'ongoing':
        statusColor = Colors.blue;
        break;
      case 'ready_to_withdraw':
        statusColor = Colors.green;
        break;
      case 'completed':
        statusColor = Colors.grey;
        break;
      default:
        statusColor = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with title and status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      FormatUtils.formatCurrency(amount),
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFFFA82F),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  daysLeftText,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Details row
          Row(
            children: [
              if (maturityDate != null) ...[
                Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  'Maturity: $maturityDate',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ],
          ),
          
          // Action buttons for matured/ready locks
          if (status == 'ready_to_withdraw' || isMatured) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => viewModel.withdrawLock(lock['id'].toString()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFA82F),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Withdraw',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showBreakLockDialog(context, lock, viewModel),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Break Early',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ] else if (status == 'ongoing') ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => _showBreakLockDialog(context, lock, viewModel),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Break Lock (Penalty applies)',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showBreakLockDialog(BuildContext context, Map<String, dynamic> lock, LockSaveViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Break Lock Early?',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Breaking this lock early will result in a penalty. Are you sure you want to continue?',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(color: Colors.grey[600]),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              viewModel.breakLock(lock['id'].toString());
            },
            child: Text(
              'Break Lock',
              style: GoogleFonts.inter(color: Colors.red, fontWeight: FontWeight.w600),
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
                          onTap: () async {
                            Navigator.pop(context);
                            // Navigate to CreateLockView with selected period
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateLockView(
                                  selectedPeriod: period,
                                ),
                              ),
                            );
                            // Force refresh locks when returning from create lock page
                            print('🔄 Refreshing locks after creation...');
                            await viewModel.loadUserLocks();
                            print(
                                '🔄 Locks refreshed: ${viewModel.currentLocks.length} locks');
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

  Widget _buildEmptyState(bool isOngoing) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Color(0xFFFFDBA8),
            borderRadius: BorderRadius.circular(23.434),
          ),
          child: Center(
            child: Icon(
              Icons.lock_outline,
              size: 24,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          isOngoing ? 'No ongoing Lock savings' : 'No completed Lock savings',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          isOngoing 
              ? 'Create your first lock savings to get started'
              : 'Your completed lock savings will appear here',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Color(0xFFFFDBA8),
            borderRadius: BorderRadius.circular(23.434),
          ),
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFA82F)),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Loading your lock savings...',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  @override
  LockSaveViewModel viewModelBuilder(
    BuildContext context,
  ) {
    final dashboardViewModel = locator<DashboardViewModel>();
    final viewModel = LockSaveViewModel();
    viewModel.setDashboardViewModel(dashboardViewModel);
    viewModel.initialize(dashboardViewModel);
    return viewModel;
  }
}