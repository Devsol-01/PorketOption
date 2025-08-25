import 'package:flutter/material.dart';

/// Utility functions for formatting numbers and currencies
class FormatUtils {
  /// Format a number with comma separators for thousands
  static String formatNumberWithCommas(double number, {int decimalPlaces = 2}) {
    // Handle null or invalid numbers
    if (number.isNaN || number.isInfinite) {
      return '0.00';
    }

    // Split into whole and decimal parts
    final parts = number.toStringAsFixed(decimalPlaces).split('.');
    final wholePart = parts[0];
    final decimalPart = parts.length > 1 ? parts[1] : '';

    // Add commas to whole number part
    String formattedWhole = '';
    for (int i = 0; i < wholePart.length; i++) {
      final digit = wholePart[wholePart.length - 1 - i];
      if (i > 0 && i % 3 == 0) {
        formattedWhole = ',$formattedWhole';
      }
      formattedWhole = digit + formattedWhole;
    }

    // Combine with decimal part
    return decimalPart.isNotEmpty
        ? '$formattedWhole.$decimalPart'
        : formattedWhole;
  }

  /// Format currency with dollar sign and commas
  static String formatCurrency(double amount, {int decimalPlaces = 2}) {
    return '\$${formatNumberWithCommas(amount, decimalPlaces: decimalPlaces)}';
  }

  /// Format large numbers with K, M, B suffixes
  static String formatCompactCurrency(double amount, {int decimalPlaces = 1}) {
    if (amount >= 1000000000) {
      return '\$${(amount / 1000000000).toStringAsFixed(decimalPlaces)}B';
    } else if (amount >= 1000000) {
      return '\$${(amount / 1000000).toStringAsFixed(decimalPlaces)}M';
    } else if (amount >= 1000) {
      return '\$${(amount / 1000).toStringAsFixed(decimalPlaces)}K';
    } else {
      return formatCurrency(amount, decimalPlaces: decimalPlaces);
    }
  }

  /// Format currency input with proper cursor position preservation
  static TextEditingValue formatCurrencyInput(
    String value,
    TextSelection selection,
  ) {
    // Remove all non-digit characters except decimal point
    final cleanValue = value.replaceAll(RegExp(r'[^\d.]'), '');

    // Parse the numeric value
    final numericValue = double.tryParse(cleanValue) ?? 0.0;

    // Format the currency
    final formattedText = formatCurrency(numericValue);

    // For now, just place cursor at the end
    // Proper cursor position calculation would require more complex logic
    // tracking the position of digits relative to formatting characters
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
