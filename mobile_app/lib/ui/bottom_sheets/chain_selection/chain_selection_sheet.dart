import 'package:cryptofont/cryptofont.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'chain_selection_sheet_model.dart';

class ChainSelectionSheet extends StackedView<ChainSelectionSheetModel> {
  final Function(SheetResponse response)? completer;
  final SheetRequest request;

  const ChainSelectionSheet({
    Key? key,
    required this.completer,
    required this.request,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ChainSelectionSheetModel viewModel,
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
                // Title
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Chain',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Choose which blockchain to deposit from',
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

          // Chain list
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
              child: Column(
                children: [
                  _buildChainOption(
                    chainName: 'Ethereum',
                    symbol: 'ETH',
                    icon: CryptoFontIcons.eth,
                    iconColor: const Color(0xFF627EEA),
                    onTap: () =>
                        viewModel.onChainSelected('ethereum', completer!),
                  ),
                  const SizedBox(height: 14),
                  _buildChainOption(
                    chainName: 'Bitcoin',
                    symbol: 'BTC',
                    icon: CryptoFontIcons.btc,
                    iconColor: const Color(0xFFF7931A),
                    onTap: () => viewModel.onChainSelected('bitcoin', completer!),
                  ),
                  const SizedBox(height: 14),
                  _buildChainOption(
                    chainName: 'Polygon',
                    symbol: 'MATIC',
                    icon: CryptoFontIcons.matic,
                    iconColor: const Color(0xFF8247E5),
                    onTap: () =>
                        viewModel.onChainSelected('polygon', completer!),
                  ),
                  const SizedBox(height: 14),
                  _buildChainOption(
                    chainName: 'Binance Smart Chain',
                    symbol: 'BNB',
                    icon: CryptoFontIcons.bnb,
                    iconColor: const Color(0xFFF3BA2F),
                    onTap: () => viewModel.onChainSelected('bsc', completer!),
                  ),
                  const SizedBox(height: 14),
                  _buildChainOption(
                    chainName: 'Solana',
                    symbol: 'SOL',
                    icon: CryptoFontIcons.sol,
                    iconColor: const Color(0xFF9945FF),
                    onTap: () =>
                        viewModel.onChainSelected('solana', completer!),
                  ),
                  const SizedBox(height: 14),
                  _buildChainOption(
                    chainName: 'Optimism',
                    symbol: 'OP',
                    icon: CryptoFontIcons.opt,
                    iconColor: const Color(0xFFFF0420),
                    onTap: () =>
                        viewModel.onChainSelected('optimism', completer!),
                  ),
                  const SizedBox(height: 14),
                  _buildChainOption(
                    chainName: 'Avalanche',
                    symbol: 'AVAX',
                    icon: CryptoFontIcons.avax,
                    iconColor: const Color(0xFFE84142),
                    onTap: () =>
                        viewModel.onChainSelected('avalanche', completer!),
                  ),
                ],
              ),
            ),
          ),

          // Bottom safe padding
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildChainOption({
    required String chainName,
    required String symbol,
    required IconData icon,
    required Color iconColor,
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
            // Chain icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 22,
                  color: iconColor,
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Chain info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chainName,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    symbol,
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
  ChainSelectionSheetModel viewModelBuilder(BuildContext context) =>
      ChainSelectionSheetModel();
}
