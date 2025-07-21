// import 'package:flutter/material.dart';
// import 'package:mobile_app/extensions/theme_context_extension.dart';
// import 'package:mobile_app/ui/common/app_colors.dart';
// import 'package:mobile_app/ui/common/ui_helpers.dart';
// import 'package:stacked/stacked.dart';
// import 'package:stacked_services/stacked_services.dart';
// import 'package:qr_flutter/qr_flutter.dart';

// import 'crypto_deposit_sheet_sheet_model.dart';

// class CryptoDepositSheetSheet
//     extends StackedView<CryptoDepositSheetSheetModel> {
//   final Function(SheetResponse response)? completer;
//   final SheetRequest request;
//   const CryptoDepositSheetSheet({
//     Key? key,
//     required this.completer,
//     required this.request,
//   }) : super(key: key);

//   @override
//   Widget builder(
//     BuildContext context,
//     CryptoDepositSheetSheetModel viewModel,
//     Widget? child,
//   ) {
//     return Container(
//       decoration: BoxDecoration(
//         color: context.cardColor,
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(24),
//           topRight: Radius.circular(24),
//         ),
//         // border: context.isDarkMode
//         //     ? Border.all(color: context.cardBorder, width: 1)
//         //     : null,
//         boxShadow: context.isDarkMode
//             ? null
//             : [
//                 BoxShadow(
//                   color: context.cardShadow,
//                   blurRadius: 20,
//                   offset: const Offset(0, -4),
//                 ),
//               ],
//       ),
//       child: Column(
//         children: [
//           // Custom App Bar
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const SizedBox(width: 40), // Spacer for center alignment
//                 Text(
//                   'Crypto Deposit',
//                   style: GoogleFonts.inter(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w600,
//                     color: context.primaryTextColor,
//                   ),
//                 ),
//                 GestureDetector(
//                   // onTap: viewModel.goBack,
//                   child: Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: context.actionButtonBackground,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Icon(
//                       Icons.close,
//                       size: 24,
//                       color: context.secondaryTextColor,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Content
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
//               child: Column(
//                mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const SizedBox(height: 32),

//                   // QR Code Container
//                   Center(
//                     child: QrImageView(
//                       data: '0x742d35Cc6639C0532fEb52F64e8a1e8e5e1D2B7B',
//                       version: QrVersions.auto,
//                       size: 200.0,
//                       backgroundColor: Colors.transparent,
//                       foregroundColor: context.isDarkMode
//                           ? qrCodeForegroundDark
//                           : qrCodeForegroundLight,
//                     ),
//                   ),

//                   const SizedBox(height: 32),

//                   // Wallet Address Section
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'USDT Address',
//                         style: GoogleFonts.inter(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                           color: context.secondaryTextColor,
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Container(
//                               padding: const EdgeInsets.all(16),
//                               decoration: BoxDecoration(
//                                 color: context.isDarkMode
//                                     ? addressFieldBackgroundDark
//                                     : addressFieldBackgroundLight,
//                                 borderRadius: BorderRadius.circular(12),
//                                 border: context.isDarkMode
//                                     ? Border.all(
//                                         color: context.cardBorder, width: 1)
//                                     : null,
//                               ),
//                               child: Text(
//                                 '0x742d35Cc6639C0532fEb52F64e8a1e8e5e1D2B7B',
//                                 style: GoogleFonts.inter(
//                                   fontSize: 14,
//                                   fontFamily: 'monospace',
//                                   color: context.primaryTextColor,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           GestureDetector(
//                             //onTap: viewModel.copyAddress,
//                             child: Container(
//                               padding: const EdgeInsets.all(12),
//                               decoration: BoxDecoration(
//                                 color: copyButtonColor,
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: Icon(
//                                 Icons.copy,
//                                 // viewModel.isCopied ? Icons.check : Icons.copy,
//                                 size: 20,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 24),

//                   // Warning Message
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: context.isDarkMode
//                           ? warningBackgroundDark
//                           : warningBackgroundLight,
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(
//                         color: context.isDarkMode
//                             ? warningBorderDark
//                             : warningBorderLight,
//                         width: 1,
//                       ),
//                     ),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Icon(
//                           Icons.warning_amber_rounded,
//                           size: 20,
//                           color: warningIconColor,
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: Text(
//                             'Only send USDT to this address. Sending other cryptocurrencies may result in permanent loss.',
//                             style: GoogleFonts.inter(
//                               fontSize: 14,
//                               color: context.isDarkMode
//                                   ? warningTextDark
//                                   : warningTextLight,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   const Spacer(),

//                   // Back Button
//                   // Container(
//                   //   width: double.infinity,
//                   //   padding: const EdgeInsets.symmetric(vertical: 24),
//                   //   child: TextButton(
//                   //     onPressed: viewModel.goBack,
//                   //     style: TextButton.styleFrom(
//                   //       padding: const EdgeInsets.symmetric(vertical: 16),
//                   //     ),
//                   //     child: Text(
//                   //       'Back',
//                   //       style: GoogleFonts.inter(
//                   //         fontSize: 16,
//                   //         fontWeight: FontWeight.w500,
//                   //         color: context.secondaryTextColor,
//                   //       ),
//                   //     ),
//                   //   ),
//                   // ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   CryptoDepositSheetSheetModel viewModelBuilder(BuildContext context) =>
//       CryptoDepositSheetSheetModel();
// }

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
                  child: QrImageView(
                    data: '0x742d35Cc6639C0532fEb52F64e8a1e8e5e1D2B7B',
                    version: QrVersions.auto,
                    size: 230.0,
                    backgroundColor: Colors.transparent,
                    foregroundColor: context.isDarkMode
                        ? qrCodeForegroundDark
                        : qrCodeForegroundLight,
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
                          'USDC Address',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: context.secondaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: context.isDarkMode
                                ? addressFieldBackgroundDark
                                : addressFieldBackgroundLight,
                            borderRadius: BorderRadius.circular(14),
                            border: context.isDarkMode
                                ? Border.all(
                                    color: context.cardBorder, width: 1)
                                : null,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '0x742d35Cc6639C0532fEb52F64e8a1e8e5e1D2B7B',
                                  style: GoogleFonts.jetBrainsMono(
                                      fontSize: 14,
                                      color: context.primaryTextColor,
                                      height: 1.4),
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Copy icon button
                              GestureDetector(
                                onTap: () {
                                  // Clipboard.setData(const ClipboardData(
                                  //   text:
                                  //       '0x742d35Cc6639C0532fEb52F64e8a1e8e5e1D2B7B',
                                  // ));
                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //   const SnackBar(content: Text('Address copied')),
                                  // );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: copyButtonColor, // Purple circle
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.copy,
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
                    onPressed: () =>
                        completer?.call(SheetResponse(confirmed: false)),
                    child: Text(
                      'Back',
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
