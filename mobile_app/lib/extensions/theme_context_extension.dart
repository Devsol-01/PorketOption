import 'package:flutter/material.dart';
import 'package:mobile_app/ui/common/app_colors.dart';

// ============================================================================
// THEME EXTENSION CLASS
// ============================================================================
extension ThemeContextExtension on BuildContext {
  // Check if dark mode is active
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  // Background color for scaffold or full pages
  Color get backgroundColor =>
      isDarkMode ? darkBackground : lightBackground;

  // Card color
  Color get cardColor => isDarkMode ? darkCard : lightCard;

  // Primary text (e.g., headings)
  Color get primaryTextColor =>
      isDarkMode ? darkTextPrimary : lightTextPrimary;

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
  Color get depositButtonBg => isDarkMode ? darkDepositButtonBg : lightDepositButtonBg;
  Color get saveButtonBg => isDarkMode ? darkSaveButtonBg : lightSaveButtonBg;
  Color get withdrawButtonBg => isDarkMode ? darkWithdrawButtonBg : lightWithdrawButtonBg;

  // Action button icons
  Color get depositIconColor => isDarkMode ? darkDepositIcon : lightDepositIcon;
  Color get saveIconColor => isDarkMode ? darkSaveIcon : lightSaveIcon;
  Color get withdrawIconColor => isDarkMode ? darkWithdrawIcon : lightWithdrawIcon;

  // General action button background
  Color get actionButtonBackground => isDarkMode
      ? darkButtonBackground
      : lightButtonBackground;

  // Card shadows and borders
  Color get cardShadow => isDarkMode ? transparent : lightCardShadow;
  Color get cardBorder => isDarkMode ? darkCardBorder : transparent;

  // Dividers
  Color get dividerColor => isDarkMode ? dividerDark : dividerLight;

  // Chart background
  Color get chartBackground => isDarkMode ? chartBackgroundDark : chartBackgroundLight;

  // Progress bar
  Color get progressBarInactiveColor => isDarkMode ? progressBarInactive : progressBarInactiveLight;

  // Navigation colors
  Color get navBarSelected => isDarkMode ? navBarSelectedDark : navBarSelectedLight;
  Color get navBarUnselected => isDarkMode ? navBarUnselectedDark : navBarUnselectedLight;

  // Green success color
  Color get successColor => green;

  // Milestone gold
  Color get goldColor => gold;

  // Wallet subtitle text
  Color get walletTextColor => lilac;

  // Transparent
  Color get transparent => transparent;

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