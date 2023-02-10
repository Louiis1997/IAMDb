
import 'package:intl/intl.dart';

class DateHelpers {
  static String formatEventDates({
    required DateTime? startDate,
    required DateTime? endDate,
  }) {
    var formattedStartDate = startDate != null
        ? DateFormat.yMMMEd().format(startDate)
        : Null;
    var formattedEndDate = endDate != null
        ? DateFormat.yMMMEd().format(endDate)
        : Null;

    if (formattedStartDate != Null && formattedEndDate != Null) {
      return 'From $formattedStartDate - To $formattedEndDate';
    } else if (formattedStartDate != Null && formattedEndDate == Null) {
      return 'On $formattedStartDate';
    } else {
      throw Exception('Invalid event dates : $startDate - $endDate');
    }
  }
}
