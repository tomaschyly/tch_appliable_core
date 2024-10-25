import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

extension DateTimeExtension on DateTime {
  /// Convert DateTime to Jiffy
  Jiffy get jiffy => Jiffy.parseFromDateTime(this);

  /// Convert DateTime to Jiffy
  Jiffy toJiffy() {
    return Jiffy.parseFromDateTime(this);
  }

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

extension JiffyExtension on Jiffy {
  /// Copy Jiffy with new dayOfWeek
  Jiffy setDayOfWeek(int dayOfWeek) {
    return Jiffy.parseFromDateTime(dateTime.setDayOfWeek(dayOfWeek));
  }
}

final DateFormat kDayOfWeekFormatter = DateFormat('E');

/// Generate list of days in a month
/// If full weeks, it will add prev/next month days
List<Jiffy> getDaysInMonth(
  Jiffy date,
  int weekDayStart, {
  bool fullWeeks = true,
}) {
  final theDate = date.dateTime.copyWith(
    hour: 0,
    minute: 0,
    second: 0,
    millisecond: 0,
  );
  final List<Jiffy> days = [];
  final int daysInMonth = DateUtils.getDaysInMonth(theDate.year, theDate.month);
  final DateTime firstDayOfMonth = DateTime(theDate.year, theDate.month, 1);

  if (fullWeeks) {
    late int daysBefore;
    if (weekDayStart == DateTime.sunday) {
      daysBefore = firstDayOfMonth.weekday - DateTime.monday + 1;
    } else {
      daysBefore = firstDayOfMonth.weekday - DateTime.monday;
    }

    final DateTime prevMonth = firstDayOfMonth.subtract(Duration(days: daysBefore));
    for (int i = 0; i < daysBefore; i++) {
      days.add(Jiffy.parseFromDateTime(prevMonth.add(Duration(days: i))));
    }
  }

  for (int i = 0; i < daysInMonth; i++) {
    final DateTime day = firstDayOfMonth.copyWith(
      day: i + 1,
    );
    days.add(Jiffy.parseFromDateTime(day));
  }

  if (fullWeeks) {
    final DateTime lastDayOfMonth = DateTime(theDate.year, theDate.month, daysInMonth);

    late int daysAfter;
    if (weekDayStart == DateTime.sunday) {
      daysAfter = DateTime.saturday - lastDayOfMonth.weekday;
    } else {
      daysAfter = DateTime.sunday - lastDayOfMonth.weekday;
    }

    final DateTime nextMonth = lastDayOfMonth.add(const Duration(days: 1));
    for (int i = 0; i < daysAfter; i++) {
      days.add(Jiffy.parseFromDateTime(nextMonth.add(Duration(days: i))));
    }
  }

  return days;
}

/// Get list of Weekdays by Locale
List<String> getWeekdaysShort(int weekDayStart) {
  final List<String> weekdaysShort = [];

  if (weekDayStart == DateTime.sunday) {
    for (int i = 5; i <= 11; i++) {
      final DateTime dateTime = DateTime(2023, 2, i);
      final String weekdayShort = kDayOfWeekFormatter.format(dateTime);
      weekdaysShort.add(weekdayShort);
    }
  } else {
    for (int i = 6; i <= 12; i++) {
      final DateTime dateTime = DateTime(2023, 2, i);
      final String weekdayShort = kDayOfWeekFormatter.format(dateTime);
      weekdaysShort.add(weekdayShort);
    }
  }

  return weekdaysShort;
}

/// Convert the index back to weekday
/// Respect setting for start is monday or sunday
int indexToWeekday(int index, int weekDayStart) {
  if (weekDayStart == DateTime.sunday) {
    if (index == 1) {
      return DateTime.sunday;
    } else {
      return index - 1;
    }
  } else {
    return index;
  }
}
