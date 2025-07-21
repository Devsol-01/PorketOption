import 'package:flutter/material.dart';
import 'package:mobile_app/ui/common/app_colors.dart';

// ============================================================================
// THEME EXTENSION CLASS
// ============================================================================
extension ThemeContextExtension on BuildContext {
  // ============================================================================
  // THEME DETECTION
  // ============================================================================
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  // ============================================================================
  // BACKGROUND COLORS
  // ============================================================================
  Color get backgroundColor => isDarkMode ? darkBackground : lightBackground;
  Color get cardColor => isDarkMode ? darkCard : lightCard;
  Color get usdtSectionBg =>
      isDarkMode ? usdtSectionBgDark : usdtSectionBgLight;

  // ============================================================================
  // TEXT COLORS
  // ============================================================================
  Color get primaryTextColor => isDarkMode ? darkTextPrimary : lightTextPrimary;
  Color get secondaryTextColor =>
      isDarkMode ? darkTextSecondary : lightTextSecondary;

  // ============================================================================
  // TAB COLORS
  // ============================================================================
  Color get tabBackground => isDarkMode ? darkCard : lightTabBackground;
  Color get tabUnselectedColor => tabUnselected;
  Color get tabSelectedColor => tabSelected;

  // ============================================================================
  // BUTTON COLORS
  // ============================================================================
  Color get actionButtonBackground =>
      isDarkMode ? darkButtonBackground : lightButtonBackground;

  // Action button backgrounds
  Color get depositButtonBg =>
      isDarkMode ? darkDepositButtonBg : lightDepositButtonBg;
  Color get saveButtonBg => isDarkMode ? darkSaveButtonBg : lightSaveButtonBg;
  Color get withdrawButtonBg =>
      isDarkMode ? darkWithdrawButtonBg : lightWithdrawButtonBg;

  // Action button icons
  Color get depositIconColor => isDarkMode ? darkDepositIcon : lightDepositIcon;
  Color get saveIconColor => isDarkMode ? darkSaveIcon : lightSaveIcon;
  Color get withdrawIconColor =>
      isDarkMode ? darkWithdrawIcon : lightWithdrawIcon;

  // ============================================================================
  // CARD & BORDER COLORS
  // ============================================================================
  Color get cardShadow => isDarkMode ? transparent : lightCardShadow;
  Color get cardBorder => isDarkMode ? darkCardBorder : transparent;
  Color get dividerColor => isDarkMode ? dividerDark : dividerLight;

  // ============================================================================
  // NAVIGATION COLORS
  // ============================================================================
  Color get navBarSelected =>
      isDarkMode ? navBarSelectedDark : navBarSelectedLight;
  Color get navBarUnselected =>
      isDarkMode ? navBarUnselectedDark : navBarUnselectedLight;

  // ============================================================================
  // CHART & PROGRESS COLORS
  // ============================================================================
  Color get chartBackground =>
      isDarkMode ? chartBackgroundDark : chartBackgroundLight;
  Color get progressBarInactiveColor =>
      isDarkMode ? progressBarInactive : progressBarInactiveLight;

  // ============================================================================
  // WARNING COLORS
  // ============================================================================
  Color get warningText => isDarkMode ? warningTextDark : warningTextLight;
  Color get warningBorder =>
      isDarkMode ? warningBorderDark : warningBorderLight;
  Color get warningBackground =>
      isDarkMode ? warningBackgroundDark : warningBackgroundLight;

  // ============================================================================
  // PROTOCOL CARD COLORS
  // ============================================================================
  Color get protocolCardBackground => isDarkMode ? darkCard : lightCard;
  Color get protocolCardBorder =>
      isDarkMode ? darkCardBorder : Colors.grey.shade200;
  Color get protocolIconBackground =>
      isDarkMode ? darkButtonBackground : lightButtonBackground;

  // Protocol risk backgrounds
  Color get protocolRiskHighBackground =>
      isDarkMode ? Colors.red.shade900.withOpacity(0.3) : Colors.red.shade50;
  Color get protocolRiskMediumBackground => isDarkMode
      ? Colors.orange.shade900.withOpacity(0.3)
      : Colors.orange.shade50;
  Color get protocolRiskLowBackground => isDarkMode
      ? Colors.green.shade900.withOpacity(0.3)
      : Colors.green.shade50;

  // Protocol risk text colors
  Color get protocolRiskHighText =>
      isDarkMode ? Colors.red.shade300 : Colors.red.shade700;
  Color get protocolRiskMediumText =>
      isDarkMode ? Colors.orange.shade300 : Colors.orange.shade700;
  Color get protocolRiskLowText =>
      isDarkMode ? Colors.green.shade300 : Colors.green.shade700;

  // Protocol other colors
  Color get protocolApyColor =>
      isDarkMode ? Colors.green.shade400 : Colors.green.shade600;
  Color get protocolTvlColor =>
      isDarkMode ? darkTextSecondary : lightTextSecondary;
  Color get protocolExternalLinkColor =>
      isDarkMode ? Colors.grey.shade500 : Colors.grey.shade400;

  // ============================================================================
  // STATUS & ACCENT COLORS
  // ============================================================================
  Color get successColor => green;
  Color get goldColor => gold;
  Color get walletTextColor => lilac;

  // ============================================================================
  // GRADIENTS
  // ============================================================================
  LinearGradient get balanceCardGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF7B6FFF), // Slightly different purple (same as chart bars)
          Color(0xFF6B5FEF), // Slightly darker purple for the end
        ],
      );

  LinearGradient get chartBarGradient => LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [
          const Color(0xFF7B6FFF)
              .withOpacity(0.6), // Slightly different purple bottom
          const Color(0xFF7B6FFF), // Solid top
        ],
      );
}
