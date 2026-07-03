enum PeriodPreset { lastWeek, lastMonth, thisMonth, custom }

class DateRange {
  final DateTime start;
  final DateTime end; // inclusive, end-of-day

  const DateRange(this.start, this.end);

  bool contains(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    final s = DateTime(start.year, start.month, start.day);
    final e = DateTime(end.year, end.month, end.day);
    return !d.isBefore(s) && !d.isAfter(e);
  }

  static DateRange forPreset(PeriodPreset preset, {DateRange? custom}) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    switch (preset) {
      case PeriodPreset.lastWeek:
        return DateRange(today.subtract(const Duration(days: 6)), today);
      case PeriodPreset.lastMonth:
        final prevMonth = DateTime(now.year, now.month - 1, 1);
        final lastDay = DateTime(now.year, now.month, 0);
        return DateRange(prevMonth, lastDay);
      case PeriodPreset.thisMonth:
        final first = DateTime(now.year, now.month, 1);
        return DateRange(first, today);
      case PeriodPreset.custom:
        return custom ?? DateRange(today.subtract(const Duration(days: 6)), today);
    }
  }
}
