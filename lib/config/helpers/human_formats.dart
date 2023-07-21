import 'package:intl/intl.dart';

class HumanFormats {
  static String numberCompact(double number, [int? decimalDigits]) {
    return NumberFormat.compactCurrency(
      decimalDigits: decimalDigits,
      locale: "en",
      symbol: "",
    ).format(number);
  }

  static String dateToString({required DateTime date, String? dateFormat}) {
    final format = DateFormat(dateFormat ?? "d/MMMM/yyyy");

    return format.format(date);
  }
}
