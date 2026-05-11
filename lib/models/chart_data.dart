import 'package:espresso_partes_cafe/data/months_of_year.dart';

class ChartData {
  DateTime date;
  double total;

  ChartData({
    required this.date,
    required this.total,
  });

  String get toDateString {
    return "${monthsOfYear[date.month - 1]} ${date.year}";
  }

  String get month {
    return monthsOfYear[date.month - 1].substring(0, 3);
  }
}
