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
                    "Goal Savings Balance",
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
                            ? FormatUtils.formatCurrency(
                                viewModel.lockSaveBalance)
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

            const SizedBox(height: 40),

            // Lock Savings Section
            Builder(
              builder: (context) {
                print(
                    '🔍 UI Debug: currentLocks.length = ${viewModel.currentLocks.length}');
                print(
                    '🔍 UI Debug: isOngoingSelected = ${viewModel.isOngoingSelected}');
                for (int i = 0; i < viewModel.currentLocks.length; i++) {
                  final lock = viewModel.currentLocks[i];
                  print(
                      '🔍 UI Debug: Lock $i: ${lock['title']} - ${lock['amount']} - ${lock['status']}');
                }
                return viewModel.currentLocks.isEmpty
                    ? _buildEmptyState()
                    : _buildLocksList(viewModel);
              },
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
                    'Ongoing',
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
                  'Paid Back',
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

  Widget _buildEmptyState() {
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
        const Text(
          'No ongoing Lock savings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Create your first lock savings to get started',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLocksList(LockSaveViewModel viewModel) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: viewModel.currentLocks.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final lock = viewModel.currentLocks[index];
        return _buildLockCard(lock, viewModel);
      },
    );
  }

  Widget _buildLockCard(
      Map<String, dynamic> lock, LockSaveViewModel viewModel) {
    final amount = (lock['amount'] as double? ?? 0.0);
    final title = lock['title'] as String? ?? 'Untitled Lock';
    final maturityDateStr = lock['maturityDate'] as String?;
    final daysLeft = _calculateDaysLeft(maturityDateStr);
    final isMatured = daysLeft <= 0;
    final status = lock['status'] as String? ?? 'active';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon container
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFFFA82F).withOpacity(0.9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.lock,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),

          // Lock details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),

                // Amount
                Text(
                  FormatUtils.formatCurrency(amount),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 6),

                // Progress + status
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          minHeight: 6,
                          value: isMatured ? 1.0 : 0.7,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isMatured ? Colors.green : const Color(0xFFFFA82F),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isMatured ? "Matured" : "$daysLeft d",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isMatured ? Colors.green[700] : Colors.grey[700],
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

  int _calculateDaysLeft(String? maturityDateStr) {
    if (maturityDateStr == null) return 0;
    try {
      // Parse ISO 8601 date format from mock data service
      final maturityDate = DateTime.parse(maturityDateStr);
      final now = DateTime.now();
      final difference = maturityDate.difference(now).inDays;
      return difference > 0 ? difference : 0;
    } catch (e) {
      // Fallback for old format 'dd/mm/yyyy'
      try {
        final parts = maturityDateStr.split('/');
        if (parts.length == 3) {
          final day = int.parse(parts[0]);
          final month = int.parse(parts[1]);
          final year = int.parse(parts[2]);
          final maturityDate = DateTime(year, month, day);
          final now = DateTime.now();
          final difference = maturityDate.difference(now).inDays;
          return difference > 0 ? difference : 0;
        }
        return 0;
      } catch (e2) {
        return 0;
      }
    }
  }

  @override
  LockSaveViewModel viewModelBuilder(
    BuildContext context,
  ) {
    final dashboardViewModel = locator<DashboardViewModel>();
    final viewModel = LockSaveViewModel();
    viewModel.setDashboardViewModel(dashboardViewModel);
    return viewModel;
  }
}
