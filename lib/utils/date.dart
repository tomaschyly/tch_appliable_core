extension DateTimeExtension on DateTime {
  /// Convert DateTime UTC Offset to Timezone name, e.g. UTC+08:00
  String timezoneNameFromUtcOffset() {
    int utcOffset = timeZoneOffset.inSeconds;

    final String sign = utcOffset >= 0 ? '+' : '-';
    final int hours = utcOffset ~/ 3600;
    final int minutes = (utcOffset % 3600) ~/ 60;

    return 'UTC$sign${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  /// Copy DateTime with new dayOfWeek
  DateTime setDayOfWeek(int dayOfWeek) {
    final currentWeekDay = weekday;
    final dayOfWeekOffset = dayOfWeek - currentWeekDay;

    if (dayOfWeekOffset == 0) {
      return copyWith();
    } else if (dayOfWeekOffset > 0) {
      final adjustedDate = copyWith().add(Duration(days: dayOfWeekOffset));
      return adjustedDate;
    } else {
      final adjustedDate = copyWith().subtract(Duration(days: dayOfWeekOffset.abs()));
      return adjustedDate;
    }
  }
}
