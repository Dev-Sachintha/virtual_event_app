import 'package:intl/intl.dart';

class DateFormatter {
  static String formatEventDate(DateTime dateTime) {
    return DateFormat('EEE, MMM d, yyyy')
        .format(dateTime); // e.g., "Wed, Sep 27, 2023"
  }

  static String formatEventTime(DateTime dateTime) {
    return DateFormat('h:mm a').format(dateTime); // e.g., "2:30 PM"
  }
}
