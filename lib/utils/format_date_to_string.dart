import 'package:intl/intl.dart';

String formatDateToString(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);
}
