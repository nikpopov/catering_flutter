/// Extension methods on DateTime for common operations
extension DateTimeExtensions on DateTime {
  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Check if date is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  /// Check if date is in the past
  bool get isPast => isBefore(DateTime.now());

  /// Check if date is in the future
  bool get isFuture => isAfter(DateTime.now());

  /// Check if date is this week
  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    return isAfter(startOfWeek.startOfDay) && isBefore(endOfWeek.endOfDay);
  }

  /// Check if date is this month
  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }

  /// Check if date is this year
  bool get isThisYear {
    return year == DateTime.now().year;
  }

  /// Get start of day (00:00:00)
  DateTime get startOfDay {
    return DateTime(year, month, day);
  }

  /// Get end of day (23:59:59)
  DateTime get endOfDay {
    return DateTime(year, month, day, 23, 59, 59, 999);
  }

  /// Get start of week (Monday)
  DateTime get startOfWeek {
    return subtract(Duration(days: weekday - 1)).startOfDay;
  }

  /// Get end of week (Sunday)
  DateTime get endOfWeek {
    return startOfWeek.add(const Duration(days: 6)).endOfDay;
  }

  /// Get start of month
  DateTime get startOfMonth {
    return DateTime(year, month, 1);
  }

  /// Get end of month
  DateTime get endOfMonth {
    return DateTime(year, month + 1, 0, 23, 59, 59, 999);
  }

  /// Get start of year
  DateTime get startOfYear {
    return DateTime(year, 1, 1);
  }

  /// Get end of year
  DateTime get endOfYear {
    return DateTime(year, 12, 31, 23, 59, 59, 999);
  }

  /// Get number of days in month
  int get daysInMonth {
    return DateTime(year, month + 1, 0).day;
  }

  /// Check if year is leap year
  bool get isLeapYear {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }

  /// Get day of year (1-366)
  int get dayOfYear {
    final firstDay = DateTime(year, 1, 1);
    return difference(firstDay).inDays + 1;
  }

  /// Get week of year
  int get weekOfYear {
    final firstDayOfYear = DateTime(year, 1, 1);
    final daysOffset = firstDayOfYear.weekday - 1;
    final firstMonday = firstDayOfYear.subtract(Duration(days: daysOffset));
    final weekNumber = ((difference(firstMonday).inDays) / 7).ceil();
    return weekNumber;
  }

  /// Get age from date of birth
  int get age {
    final now = DateTime.now();
    int age = now.year - year;
    if (now.month < month || (now.month == month && now.day < day)) {
      age--;
    }
    return age;
  }

  /// Add business days (skips weekends)
  DateTime addBusinessDays(int days) {
    DateTime result = this;
    int addedDays = 0;

    while (addedDays < days) {
      result = result.add(const Duration(days: 1));
      if (result.weekday != DateTime.saturday &&
          result.weekday != DateTime.sunday) {
        addedDays++;
      }
    }

    return result;
  }

  /// Check if date is weekend
  bool get isWeekend {
    return weekday == DateTime.saturday || weekday == DateTime.sunday;
  }

  /// Check if date is weekday
  bool get isWeekday => !isWeekend;

  /// Get next occurrence of a weekday
  DateTime nextWeekday(int weekday) {
    assert(weekday >= 1 && weekday <= 7);
    int daysToAdd = (weekday - this.weekday) % 7;
    if (daysToAdd == 0) daysToAdd = 7;
    return add(Duration(days: daysToAdd));
  }

  /// Get previous occurrence of a weekday
  DateTime previousWeekday(int weekday) {
    assert(weekday >= 1 && weekday <= 7);
    int daysToSubtract = (this.weekday - weekday) % 7;
    if (daysToSubtract == 0) daysToSubtract = 7;
    return subtract(Duration(days: daysToSubtract));
  }

  /// Format as relative time (e.g., "2 hours ago", "in 3 days")
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'just now';
    }
  }

  /// Format as time from now (for future dates)
  String get timeFromNow {
    final now = DateTime.now();
    final difference = this.difference(now);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return 'in $years ${years == 1 ? 'year' : 'years'}';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return 'in $months ${months == 1 ? 'month' : 'months'}';
    } else if (difference.inDays > 0) {
      return 'in ${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'}';
    } else if (difference.inHours > 0) {
      return 'in ${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'}';
    } else if (difference.inMinutes > 0) {
      return 'in ${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'}';
    } else {
      return 'in a moment';
    }
  }

  /// Get friendly date string
  String get friendlyDate {
    if (isToday) return 'Today';
    if (isYesterday) return 'Yesterday';
    if (isTomorrow) return 'Tomorrow';
    if (isThisWeek) return weekdayName;
    return '$day $monthName $year';
  }

  /// Get month name
  String get monthName {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }

  /// Get short month name
  String get shortMonthName {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  /// Get weekday name
  String get weekdayName {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return weekdays[weekday - 1];
  }

  /// Get short weekday name
  String get shortWeekdayName {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[weekday - 1];
  }

  /// Copy with specific values
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }

  /// Check if same date (ignoring time)
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  /// Format as ISO 8601 string
  String get toIso8601 => toIso8601String();

  /// Format time only (HH:mm)
  String get timeOnly {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  /// Format time with seconds (HH:mm:ss)
  String get timeWithSeconds {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    final s = second.toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  /// Format date only (dd/MM/yyyy)
  String get dateOnly {
    final d = day.toString().padLeft(2, '0');
    final m = month.toString().padLeft(2, '0');
    return '$d/$m/$year';
  }

  /// Format as US date (MM/dd/yyyy)
  String get usDate {
    final d = day.toString().padLeft(2, '0');
    final m = month.toString().padLeft(2, '0');
    return '$m/$d/$year';
  }
}
