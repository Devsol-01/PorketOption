import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/extensions/theme_context_extension.dart';
import 'package:mobile_app/ui/common/app_colors.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'crypto_deposit_sheet_sheet_model.dart';

class CryptoDepositSheetSheet
    extends StackedView<CryptoDepositSheetSheetModel> {
  final Function(SheetResponse response)? completer;
  final SheetRequest request;
  const CryptoDepositSheetSheet({
    super.key,
    required this.completer,
    required this.request,
  });

  @override
  Widget builder(
    BuildContext context,
    CryptoDepositSheetSheetModel viewModel,
    Widget? child,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
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
      child: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: SingleChildScrollView(
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
                        'Crypto Deposit',
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

                // QR Code
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: viewModel.hasWalletAddress
                          ? QrImageView(
                              data: viewModel.walletAddress!,
                              version: QrVersions.auto,
                              size: 200.0,
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                            )
                          : Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Wallet Address Section with Container
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: context.usdtSectionBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: context.cardBorder,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'USDC Wallet Address',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: context.primaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: context.cardColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: context.cardBorder,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  viewModel.hasWalletAddress
                                      ? viewModel.walletAddress!
                                      : 'Loading wallet address...',
                                  style: GoogleFonts.jetBrainsMono(
                                      fontSize: 13,
                                      color: context.primaryTextColor,
                                      height: 1.4),
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Copy icon button
                              GestureDetector(
                                onTap: viewModel.hasWalletAddress
                                    ? () => viewModel.copyAddress()
                                    : null,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: viewModel.hasWalletAddress
                                        ? (viewModel.isCopied
                                            ? Colors.green
                                            : copyButtonColor)
                                        : Colors.grey,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    viewModel.isCopied
                                        ? Icons.check
                                        : Icons.copy,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Warning Message
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: context.warningBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: context.warningBorder,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          size: 20,
                          color: warningIconColor,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Only send USDC to this address. Sending other cryptocurrencies may result in permanent loss.',
                            style: GoogleFonts.inter(
                                fontSize: 14, color: context.warningText),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                TextButton(
                    onPressed: () {
                      viewModel.goBack();
                      completer?.call(SheetResponse(confirmed: false));
                    },
                    child: Text(
                      'Close',
                      style: GoogleFonts.inter(color: context.primaryTextColor),
                    )),

                // Bottom safe area padding
                SizedBox(height: MediaQuery.of(context).padding.bottom),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  CryptoDepositSheetSheetModel viewModelBuilder(BuildContext context) =>
      CryptoDepositSheetSheetModel();
}
