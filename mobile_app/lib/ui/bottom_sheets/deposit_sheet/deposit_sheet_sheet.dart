import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/extensions/theme_context_extension.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'deposit_sheet_sheet_model.dart';

class DepositSheetSheet extends StackedView<DepositSheetSheetModel> {
  final Function(SheetResponse response)? completer;
  final SheetRequest request;
  const DepositSheetSheet({
    Key? key,
    required this.completer,
    required this.request,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    DepositSheetSheetModel viewModel,
    Widget? child,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        // border: context.isDarkMode
        //     ? Border.all(color: context.cardBorder, width: 1)
        //     : null,
        boxShadow: context.isDarkMode
            ? null
            : [
                BoxShadow(
                  color: context.cardShadow,
                  blurRadius: 20,
                  offset: const Offset(0, -4),
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
                  'Deposit Funds',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: context.primaryTextColor,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: context.actionButtonBackground,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.close,
                      size: 20,
                      color: context.secondaryTextColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
            child: Column(
              children: [
                // Crypto Deposit Option
                _buildDepositOption(
                  context: context,
                  icon: Icons.smartphone,
                  iconColor: const Color(0xFFFF8C42),
                  title: 'Crypto Deposit',
                  subtitle: 'Bitcoin, Ethereum, USDT',
                  onTap: () {
                    //Navigate to crypto deposit
                    viewModel.onCryptoTap(completer!);
                  },
                ),

                const SizedBox(height: 12),

                // Card Deposit Option
                _buildDepositOption(
                  context: context,
                  icon: Icons.credit_card,
                  iconColor: const Color(0xFF4A90E2),
                  title: 'Card Deposit',
                  subtitle: 'USD, EUR, GBP',
                  onTap: () {
                    //Navigate to fiat deposit
                  },
                ),
              ],
            ),
          ),

          // Bottom safe area
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildDepositOption({
    required BuildContext context,
    required IconData icon,
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
          color: context.actionButtonBackground,
          borderRadius: BorderRadius.circular(16),
          border: context.isDarkMode
              ? Border.all(color: context.cardBorder, width: 1)
              : null,
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 24,
                color: Colors.white,
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
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
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
          ],
        ),
      ),
    );
  }

  @override
  DepositSheetSheetModel viewModelBuilder(BuildContext context) =>
      DepositSheetSheetModel();
}
