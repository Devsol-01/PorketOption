import 'package:flutter/material.dart';
import 'package:mobile_app/ui/common/app_colors.dart';

// ============================================================================
// THEME EXTENSION CLASS
// ============================================================================
extension ThemeContextExtension on BuildContext {
  // Check if dark mode is active
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  // Background color for scaffold or full pages
  Color get backgroundColor => isDarkMode ? darkBackground : lightBackground;

  // Card color
  Color get cardColor => isDarkMode ? darkCard : lightCard;

  // Primary text (e.g., headings)
  Color get primaryTextColor => isDarkMode ? darkTextPrimary : lightTextPrimary;

  // Secondary text (e.g., smaller labels)
  Color get secondaryTextColor =>
      isDarkMode ? darkTextSecondary : lightTextSecondary;

  // Tab background (the container for Milestones/Transactions toggle)
  Color get tabBackground =>
      isDarkMode ? darkTabBackground : lightTabBackground;

  // Tab unselected icon/text
  Color get tabUnselectedColor => tabUnselected;

  // Tab selected icon/text
  Color get tabSelectedColor => tabSelected;

  // Action buttons backgrounds
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

  // General action button background
  Color get actionButtonBackground =>
      isDarkMode ? darkButtonBackground : lightButtonBackground;

  // Card shadows and borders
  Color get cardShadow => isDarkMode ? transparent : lightCardShadow;
  Color get cardBorder => isDarkMode ? darkCardBorder : transparent;

  // Dividers
  Color get dividerColor => isDarkMode ? dividerDark : dividerLight;

  // Chart background
  Color get chartBackground =>
      isDarkMode ? chartBackgroundDark : chartBackgroundLight;

  // Progress bar
  Color get progressBarInactiveColor =>
      isDarkMode ? progressBarInactive : progressBarInactiveLight;

  //USDT Address contsiner
  Color get usdtSectionBg =>
      isDarkMode ? usdtSectionBgDark : usdtSectionBgLight;

  //USDT warning text
  Color get warningText => isDarkMode ? warningTextDark : warningTextLight;

  //USDT warning bg border
  Color get warningBorder =>
      isDarkMode ? warningBorderDark : warningBorderLight;

  //USDT warning bg
  Color get warningBackground =>
      isDarkMode ? warningBackgroundDark : warningBackgroundLight;

  // Navigation colors
  Color get navBarSelected =>
      isDarkMode ? navBarSelectedDark : navBarSelectedLight;
  Color get navBarUnselected =>
      isDarkMode ? navBarUnselectedDark : navBarUnselectedLight;

  // Protocol card colors
  Color get protocolCardBackground => isDarkMode ? darkCard : lightCard;
  Color get protocolCardBorder =>
      isDarkMode ? darkCardBorder : Colors.grey.shade200;
  Color get protocolIconBackground =>
      isDarkMode ? darkButtonBackground : lightButtonBackground;
  Color get protocolRiskHighBackground =>
      isDarkMode ? Colors.red.shade900.withOpacity(0.3) : Colors.red.shade50;
  Color get protocolRiskMediumBackground => isDarkMode
      ? Colors.orange.shade900.withOpacity(0.3)
      : Colors.orange.shade50;
  Color get protocolRiskLowBackground => isDarkMode
      ? Colors.green.shade900.withOpacity(0.3)
      : Colors.green.shade50;
  Color get protocolRiskHighText =>
      isDarkMode ? Colors.red.shade300 : Colors.red.shade700;
  Color get protocolRiskMediumText =>
      isDarkMode ? Colors.orange.shade300 : Colors.orange.shade700;
  Color get protocolRiskLowText =>
      isDarkMode ? Colors.green.shade300 : Colors.green.shade700;
  Color get protocolApyColor =>
      isDarkMode ? Colors.green.shade400 : Colors.green.shade600;
  Color get protocolTvlColor =>
      isDarkMode ? darkTextSecondary : lightTextSecondary;
  Color get protocolExternalLinkColor =>
      isDarkMode ? Colors.grey.shade500 : Colors.grey.shade400;

  // Green success color
  Color get successColor => green;

  // Milestone gold
  Color get goldColor => gold;

  // Wallet subtitle text
  Color get walletTextColor => lilac;

  // Transparent
  Color get transparent => Colors.transparent;

  // Balance card gradient
  LinearGradient get balanceCardGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [balanceGradientStart, balanceGradientEnd],
      );

  // Chart bar gradient
  LinearGradient get chartBarGradient => LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [
          chartBarColor.withOpacity(0.6),
          chartBarColor,
        ],
      );
}
