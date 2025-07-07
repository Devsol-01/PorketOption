import 'package:flutter/material.dart';

import '../ui/common/app_colors.dart' as AppColors;

extension ThemeContextExtension on BuildContext {
  // Check if dark mode is active
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  // Background color for scaffold or full pages
  Color get backgroundColor =>
      isDarkMode ? AppColors.darkBackground : AppColors.lightBackground;

  // Card color
  Color get cardColor => isDarkMode ? AppColors.darkCard : AppColors.lightCard;

  // Primary text (e.g., headings)
  Color get primaryTextColor =>
      isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

  // Secondary text (e.g., smaller labels)
  Color get secondaryTextColor =>
      isDarkMode ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

  // Tab background (the container for Milestones/Transactions toggle)
  Color get tabBackground =>
      isDarkMode ? AppColors.darkTabBackground : AppColors.lightTabBackground;

  // Tab unselected icon/text
  Color get tabUnselectedColor => AppColors.tabUnselected;

  // Tab selected icon/text
  Color get tabSelectedColor => AppColors.tabSelected;

  // Buttons like "Save", "Deposit"
  Color get actionButtonBackground => isDarkMode
      ? AppColors.darkButtonBackground
      : AppColors.lightButtonBackground;

  // Green success color
  Color get successColor => AppColors.green;

  // Milestone gold
  Color get goldColor => AppColors.gold;

  // Wallet subtitle text
  Color get walletTextColor => AppColors.lilac;

  // Transparent
  Color get transparent => AppColors.transparent;
}
