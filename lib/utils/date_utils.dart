
import 'package:intl/intl.dart';

extension DayBefore on DateTime {
  bool isDayBeforeNow() {
    var now = DateTime.now();

    return (!(this.year == now.year &&
        this.month == now.month &&
        this.day == now.day) &&
        this.isBefore(now));
  }
}

extension DayFormatting on DateTime {
  String formatToYYYYMMdd() {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  String formatToYYYYMMddWithTime() {
    return DateFormat('yyyy-MM-ddTHH:mm:ss').format(this) + 'Z';
  }
}
