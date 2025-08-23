import 'package:flutter/services.dart';

class NumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove all non-digit characters except decimal point
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d.]'), '');
    
    // Handle decimal point
    List<String> parts = digitsOnly.split('.');
    if (parts.length > 2) {
      // More than one decimal point, keep only the first one
      digitsOnly = '${parts[0]}.${parts.sublist(1).join('')}';
      parts = digitsOnly.split('.');
    }
    
    // Format the integer part with commas
    String integerPart = parts[0];
    if (integerPart.isNotEmpty) {
      integerPart = _addCommas(integerPart);
    }
    
    // Reconstruct the number
    String formatted = integerPart;
    if (parts.length > 1) {
      String decimalPart = parts[1];
      // Limit decimal places to 2
      if (decimalPart.length > 2) {
        decimalPart = decimalPart.substring(0, 2);
      }
      formatted += '.$decimalPart';
    }
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
  
  String _addCommas(String number) {
    return number.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}

class CurrencyFormatter {
  static String formatWithCommas(double number) {
    return number.toStringAsFixed(2).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
  
  static double parseFromFormatted(String formatted) {
    // Remove commas and parse
    String cleaned = formatted.replaceAll(',', '');
    return double.tryParse(cleaned) ?? 0.0;
  }
}
