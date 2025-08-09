import 'package:intl/intl.dart';

extension NumFormatting on num {
  String toCurrency({String symbol = ' 24'}) {
    final formatter = NumberFormat.currency(symbol: symbol, decimalDigits: 2);
    return formatter.format(this);
  }
}
