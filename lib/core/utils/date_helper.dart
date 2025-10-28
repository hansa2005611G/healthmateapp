import 'package:intl/intl.dart';

/// Date utility class for formatting and manipulating dates
/// Provides consistent date handling throughout the app
class DateHelper {
  // Private constructor to prevent instantiation
  DateHelper._();

  // ==================== DATE FORMATS ====================
  
  /// Format: 2025-10-28 (ISO 8601 - for database storage)
  static final DateFormat _isoFormat = DateFormat('yyyy-MM-dd');
  
  /// Format: October 28, 2025 (full date display)
  static final DateFormat _fullDateFormat = DateFormat('MMMM dd, yyyy');
  
  /// Format: Oct 28, 2025 (short date display)
  static final DateFormat _shortDateFormat = DateFormat('MMM dd, yyyy');
  
  /// Format: Oct 28 (very short display)
  static final DateFormat _veryShortFormat = DateFormat('MMM dd');
  
  /// Format: 28/10/2025 (numeric display)
  static final DateFormat _numericFormat = DateFormat('dd/MM/yyyy');
  
  /// Format: Tuesday, October 28 (day and date)
  static final DateFormat _dayDateFormat = DateFormat('EEEE, MMMM dd');
  
  /// Format: 2:30 PM (time display)
  static final DateFormat _timeFormat = DateFormat('h:mm a');
  
  /// Format: Oct 28, 2025 2:30 PM (date and time)
  static final DateFormat _dateTimeFormat = DateFormat('MMM dd, yyyy h:mm a');

  // ==================== FORMATTING METHODS ====================
  
  /// Convert DateTime to ISO 8601 string for database storage
  /// Example: 2025-10-28
  static String toIsoString(DateTime date) {
    return _isoFormat.format(date);
  }
  
  /// Parse ISO 8601 string from database to DateTime
  /// Example: "2025-10-28" -> DateTime
  static DateTime fromIsoString(String dateString) {
    try {
      return _isoFormat.parse(dateString);
    } catch (e) {
      // If parsing fails, return current date
      return DateTime.now();
    }
  }
  
  /// Format DateTime to full date string
  /// Example: October 28, 2025
  static String toFullDateString(DateTime date) {
    return _fullDateFormat.format(date);
  }
  
  /// Format DateTime to short date string
  /// Example: Oct 28, 2025
  static String toShortDateString(DateTime date) {
    return _shortDateFormat.format(date);
  }
  
  /// Format DateTime to very short date string
  /// Example: Oct 28
  static String toVeryShortString(DateTime date) {
    return _veryShortFormat.format(date);
  }
  
  /// Format DateTime to numeric date string
  /// Example: 28/10/2025
  static String toNumericString(DateTime date) {
    return _numericFormat.format(date);
  }
  
  /// Format DateTime to day and date string
  /// Example: Tuesday, October 28
  static String toDayDateString(DateTime date) {
    return _dayDateFormat.format(date);
  }
  
  /// Format DateTime to time string
  /// Example: 2:30 PM
  static String toTimeString(DateTime date) {
    return _timeFormat.format(date);
  }
  
  /// Format DateTime to date and time string
  /// Example: Oct 28, 2025 2:30 PM
  static String toDateTimeString(DateTime date) {
    return _dateTimeFormat.format(date);
  }

  // ==================== DATE COMPARISON ====================
  
  /// Check if a date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
  
  /// Check if a date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }
  
  /// Check if a date is tomorrow
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }
  
  /// Check if two dates are the same day
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
  
  /// Check if a date is in the past (before today)
  static bool isPast(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final checkDate = DateTime(date.year, date.month, date.day);
    return checkDate.isBefore(today);
  }
  
  /// Check if a date is in the future (after today)
  static bool isFuture(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final checkDate = DateTime(date.year, date.month, date.day);
    return checkDate.isAfter(today);
  }

  // ==================== DATE MANIPULATION ====================
  
  /// Get current date with time set to midnight
  static DateTime getToday() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }
  
  /// Get yesterday's date
  static DateTime getYesterday() {
    return getToday().subtract(const Duration(days: 1));
  }
  
  /// Get tomorrow's date
  static DateTime getTomorrow() {
    return getToday().add(const Duration(days: 1));
  }
  
  /// Strip time from DateTime (set to midnight)
  static DateTime stripTime(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
  
  /// Get the first day of the current month
  static DateTime getFirstDayOfMonth() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, 1);
  }
  
  /// Get the last day of the current month
  static DateTime getLastDayOfMonth() {
    final now = DateTime.now();
    return DateTime(now.year, now.month + 1, 0);
  }
  
  /// Get days between two dates
  static int getDaysBetween(DateTime start, DateTime end) {
    final startDate = stripTime(start);
    final endDate = stripTime(end);
    return endDate.difference(startDate).inDays;
  }

  // ==================== DISPLAY HELPERS ====================
  
  /// Get relative date string (Today, Yesterday, or formatted date)
  static String getRelativeDateString(DateTime date) {
    if (isToday(date)) {
      return 'Today';
    } else if (isYesterday(date)) {
      return 'Yesterday';
    } else if (isTomorrow(date)) {
      return 'Tomorrow';
    } else {
      return toShortDateString(date);
    }
  }
  
  /// Get display string with relative date when applicable
  /// Example: "Today" or "Oct 28, 2025"
  static String getDisplayString(DateTime date, {bool showYear = true}) {
    if (isToday(date)) {
      return 'Today';
    } else if (isYesterday(date)) {
      return 'Yesterday';
    } else {
      return showYear ? toShortDateString(date) : toVeryShortString(date);
    }
  }

  // ==================== VALIDATION ====================
  
  /// Check if a date string is valid ISO format
  static bool isValidIsoDate(String dateString) {
    try {
      _isoFormat.parse(dateString);
      return true;
    } catch (e) {
      return false;
    }
  }
  
  /// Check if a date is within a reasonable range for health tracking
  /// (not too far in past or future)
  static bool isReasonableHealthDate(DateTime date) {
    final now = DateTime.now();
    final oneYearAgo = now.subtract(const Duration(days: 365));
    final tomorrow = now.add(const Duration(days: 1));
    
    return date.isAfter(oneYearAgo) && date.isBefore(tomorrow);
  }
}