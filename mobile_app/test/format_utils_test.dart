import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/utils/format_utils.dart';

void main() {
  group('FormatUtils Tests', () {
    test('formatCurrency formats numbers correctly', () {
      expect(FormatUtils.formatCurrency(0), equals('\$0.00'));
      expect(FormatUtils.formatCurrency(1), equals('\$1.00'));
      expect(FormatUtils.formatCurrency(10), equals('\$10.00'));
      expect(FormatUtils.formatCurrency(100), equals('\$100.00'));
      expect(FormatUtils.formatCurrency(1000), equals('\$1,000.00'));
      expect(FormatUtils.formatCurrency(10000), equals('\$10,000.00'));
      expect(FormatUtils.formatCurrency(100000), equals('\$100,000.00'));
      expect(FormatUtils.formatCurrency(1000000), equals('\$1,000,000.00'));
      expect(FormatUtils.formatCurrency(1234.56), equals('\$1,234.56'));
      expect(FormatUtils.formatCurrency(1234567.89), equals('\$1,234,567.89'));
    });

    test('formatCurrency handles decimal numbers correctly', () {
      expect(FormatUtils.formatCurrency(0.5), equals('\$0.50'));
      expect(FormatUtils.formatCurrency(0.99), equals('\$0.99'));
      expect(
          FormatUtils.formatCurrency(123.456), equals('\$123.46')); // rounds up
      expect(FormatUtils.formatCurrency(123.454),
          equals('\$123.45')); // rounds down
    });

    test('formatCurrency handles negative numbers', () {
      expect(FormatUtils.formatCurrency(-1), equals('\$-1.00'));
      expect(FormatUtils.formatCurrency(-1000), equals('\$-1,000.00'));
      expect(FormatUtils.formatCurrency(-1234.56), equals('\$-1,234.56'));
    });
  });
}
