import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app/utils/format_utils.dart';

void main() {
  group('FormatUtils Input Tests', () {
    test('formatCurrencyInput formats numbers correctly', () {
      final result1 = FormatUtils.formatCurrencyInput(
          '123', const TextSelection.collapsed(offset: 3));
      expect(result1.text, '\$123.00');
      expect(result1.selection.baseOffset, 7); // Cursor at end of "\$123.00"

      final result2 = FormatUtils.formatCurrencyInput(
          '1234', const TextSelection.collapsed(offset: 4));
      expect(result2.text, '\$1,234.00');
      expect(result2.selection.baseOffset, 9); // Cursor at end of "\$1,234.00"

      final result3 = FormatUtils.formatCurrencyInput(
          '123.45', const TextSelection.collapsed(offset: 6));
      expect(result3.text, '\$123.45');
      expect(result3.selection.baseOffset, 7); // Cursor at end of "\$123.45"
    });

    test('formatCurrencyInput handles empty input', () {
      final result = FormatUtils.formatCurrencyInput(
          '', const TextSelection.collapsed(offset: 0));
      expect(result.text, '\$0.00');
      expect(result.selection.baseOffset, 5); // Cursor at end of "\$0.00"
    });

    test('formatCurrencyInput handles invalid input gracefully', () {
      final result = FormatUtils.formatCurrencyInput(
          'abc', const TextSelection.collapsed(offset: 3));
      expect(result.text, '\$0.00');
      expect(result.selection.baseOffset, 5); // Cursor at end of "\$0.00"
    });

    test('formatCurrencyInput handles partial decimal input', () {
      final result = FormatUtils.formatCurrencyInput(
          '123.', const TextSelection.collapsed(offset: 4));
      expect(result.text, '\$123.00');
      expect(result.selection.baseOffset, 7); // Cursor at end of "\$123.00"
    });
  });
}
