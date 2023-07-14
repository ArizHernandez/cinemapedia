import 'package:intl/intl.dart';

class HumanFormats {
  static String numberCompact(double number) {
    return NumberFormat.compact(locale: "en").format(number);
  }

  static String dateToString({required DateTime date, String? dateFormat}) {
    final format = DateFormat(dateFormat ?? "d/MMMM/yyyy");

    return format.format(date);
  }
}
