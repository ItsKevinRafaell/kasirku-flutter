import 'package:intl/intl.dart';

class DateTimeHelper {
  static String formatDateTime(
      {required DateTime dateTime, String format = 'd MMM yyyy'}) {
    return DateFormat(format, 'id').format(dateTime);
  }

  static String formatDateTimeFromString(
      {required String dateTimeString, String format = 'd MMM yyyy'}) {
    if (dateTimeString.isEmpty) {
      return '';
    }
    DateTime dateTime = DateTime.parse(dateTimeString);
    return DateFormat(format, 'id').format(dateTime);
  }
}
