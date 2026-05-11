import 'package:intl/intl.dart';

class FormaterUtil {
  static double toDouble(String currencyString) {
    String cleanString = currencyString
        .replaceAll('R\$', '')
        .replaceAll(RegExp(r'[a-zA-Z]'), '')
        .replaceAll(".", "")
        .replaceAll(',', '.')
        .trim();
    return double.parse(cleanString);
  }

  static String toReal(double currencyString, [bool moneySimble = true]) {
    final formatter = NumberFormat.simpleCurrency(locale: "pt_Br");
    if (!moneySimble) {
      return formatter.format(currencyString)..replaceAll('R\$', '').trim();
    }
    return formatter.format(currencyString);
  }

  static DateTime subtractMonthsFromDate(DateTime date, int months) {
    return date.subtract(
        Duration(days: months * 30)); // Aproximadamente 30 dias em um mês
  }

  static DateTime addMonthsFromDate(DateTime date, int months) {
    return date
        .add(Duration(days: months * 30)); // Aproximadamente 30 dias em um mês
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
}
