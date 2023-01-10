import 'package:intl/intl.dart';

String getWeekdayString(DateTime dateTime) {
  var formatter = DateFormat(
      "EEE"); // EEE format returns the abbreviated weekday name (e.g. "Tue")
  return formatter.format(dateTime);
}
