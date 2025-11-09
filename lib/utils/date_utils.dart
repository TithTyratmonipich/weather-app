import 'package:intl/intl.dart';

extension UnixTimestamp on int {
  // -------------------------------------------------
  // 1. Hourly – only hour + am/pm (same day)
  // -------------------------------------------------
  String toHourAmPm([String pattern = 'hh:mm a']) {
    final DateTime utc = DateTime.fromMillisecondsSinceEpoch(
      this * 1000,
      isUtc: true,
    );
    final DateTime utc7 = utc.add(const Duration(hours: 7));
    return DateFormat(pattern).format(utc7);
  }

  // -------------------------------------------------
  // 2. Daily – day/month (e.g. 24 May)
  // -------------------------------------------------
  String toDayMonth([String pattern = 'd MMM']) {
    final DateTime utc = DateTime.fromMillisecondsSinceEpoch(
      this * 1000,
      isUtc: true,
    );
    final DateTime utc7 = utc.add(const Duration(hours: 7));
    return DateFormat(pattern).format(utc7);
  }

  // Optional: Daily with time (if you ever need it)
  String toDayMonthWithTime([String pattern = 'd MMM, h a']) {
    final DateTime utc = DateTime.fromMillisecondsSinceEpoch(
      this * 1000,
      isUtc: true,
    );
    final DateTime utc7 = utc.add(const Duration(hours: 7));
    return DateFormat(pattern).format(utc7);
  }

  // -------------------------------------------------
  // Returns Full UTC+7 version
  // -------------------------------------------------
  String toUtcPlus7String([String pattern = "yyyy-MM-dd HH:mm:ss '(UTC+7)'"]) {
    // Start from UTC, then add 7 hours
    final DateTime utc = DateTime.fromMillisecondsSinceEpoch(
      this * 1000,
      isUtc: true,
    );
    final DateTime utc7 = utc.add(const Duration(hours: 7));
    return DateFormat(pattern).format(utc7);
  }
}
