import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'fiat_send_selection_sheet_model.dart';

class FiatSendSelectionSheet extends StackedView<FiatSendSelectionSheetModel> {
  final Function(SheetResponse response)? completer;
  final SheetRequest request;

  const FiatSendSelectionSheet({
    Key? key,
    required this.completer,
    required this.request,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    FiatSendSelectionSheetModel viewModel,
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
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Send',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                GestureDetector(
                  onTap: () => completer?.call(SheetResponse(confirmed: false)),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Options
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
            child: Column(
              children: [
                _buildFiatOption(
                  context: context,
                  icon: Icons.flag,
                  iconColor: const Color(0xFF34C759),
                  title: 'Fiat (NGN)',
                  subtitle: 'Send Naira via bank transfer',
                  onTap: () => viewModel.onNGNTap(completer!),
                  isEnabled: true,
                ),
                const SizedBox(height: 12),
                _buildFiatOption(
                  context: context,
                  icon: Icons.account_balance,
                  iconColor: Colors.grey[400]!,
                  title: 'Fiat (USD)',
                  subtitle: 'Send USD via bank transfer • Coming Soon',
                  onTap: () => viewModel.showComingSoon('USD'),
                  isEnabled: false,
                ),
                const SizedBox(height: 12),
                _buildFiatOption(
                  context: context,
                  icon: Icons.account_balance,
                  iconColor: Colors.grey[400]!,
                  title: 'Fiat (EUR)',
                  subtitle: 'Send EUR via bank transfer • Coming Soon',
                  onTap: () => viewModel.showComingSoon('EUR'),
                  isEnabled: false,
                ),
              ],
            ),
          ),

          // Safe area padding
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildFiatOption({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    bool isEnabled = true,
  }) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isEnabled ? Colors.grey[50] : Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 24, color: Colors.white),
            ),
            const SizedBox(width: 16),

            // Texts
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isEnabled ? Colors.black : Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: isEnabled ? Colors.grey[600] : Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),

            // Arrow
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: isEnabled ? Colors.grey[400] : Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }

  @override
  FiatSendSelectionSheetModel viewModelBuilder(BuildContext context) =>
      FiatSendSelectionSheetModel();
}
