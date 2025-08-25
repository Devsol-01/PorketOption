import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'fiat_method_selection_sheet_model.dart';

class FiatMethodSelectionSheet
    extends StackedView<FiatMethodSelectionSheetModel> {
  final Function(SheetResponse response)? completer;
  final SheetRequest request;

  const FiatMethodSelectionSheet({
    Key? key,
    required this.completer,
    required this.request,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    FiatMethodSelectionSheetModel viewModel,
    Widget? child,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title + subtitle
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fiat Deposit',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Select a deposit method',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),

                // Close button
                GestureDetector(
                  onTap: () => completer!(SheetResponse(confirmed: false)),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Options
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
            child: Column(
              children: [
                _buildMethodOption(
                  context: context,
                  icon: Icons.credit_card,
                  iconBg: const Color(0xFFEAF3FF),
                  iconColor: const Color(0xFF4A90E2),
                  title: 'Debit Card',
                  subtitle: 'Pay with your debit card',
                  onTap: () => viewModel.onCardTap(completer!),
                ),
                const SizedBox(height: 14),
                _buildMethodOption(
                  context: context,
                  icon: Icons.account_balance,
                  iconBg: const Color(0xFFE9FAF1),
                  iconColor: const Color(0xFF34C759),
                  title: 'Bank Transfer',
                  subtitle: 'Transfer from your bank account',
                  onTap: () => viewModel.onBankTransferTap(completer!),
                ),
                const SizedBox(height: 14),
                _buildMethodOption(
                  context: context,
                  icon: Icons.account_balance_wallet,
                  iconBg: const Color(0xFFF7E9FB),
                  iconColor: const Color(0xFF9C27B0),
                  title: 'Virtual Account',
                  subtitle: 'Create a virtual bank account',
                  onTap: () => viewModel.onVirtualAccountTap(completer!),
                ),
              ],
            ),
          ),

          // Bottom safe padding
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildMethodOption({
    required BuildContext context,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 24,
                color: iconColor,
              ),
            ),

            const SizedBox(width: 16),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Arrow
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  @override
  FiatMethodSelectionSheetModel viewModelBuilder(BuildContext context) =>
      FiatMethodSelectionSheetModel();
}
