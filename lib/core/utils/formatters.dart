import 'package:intl/intl.dart';

class Formatters {
  static NumberFormat getCurrencyFormatter(String currencyCode) {
    if (currencyCode.toLowerCase() == 'idr') {
      return NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp ',
        decimalDigits: 0,
      );
    }
    return NumberFormat.currency(
      symbol: getCurrencySymbol(currencyCode),
      decimalDigits: 2,
    );
  }
  
  static String getCurrencySymbol(String currencyCode) {
    switch (currencyCode.toLowerCase()) {
      case 'idr':
        return 'Rp';
      case 'usd':
        return '\$';
      case 'eur':
        return '€';
      case 'gbp':
        return '£';
      case 'jpy':
        return '¥';
      case 'inr':
        return '₹';
      case 'cad':
        return 'C\$';
      case 'aud':
        return 'A\$';
      default:
        return currencyCode.toUpperCase();
    }
  }
  
  static String formatCurrency(double amount, [String? currencyCode]) {
    final code = currencyCode ?? 'IDR';
    final formatter = getCurrencyFormatter(code);
    return formatter.format(amount);
  }
  
  static String formatDate(DateTime date) {
    return DateFormat('MMM d, y', 'id_ID').format(date);
  }
  
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM d, y H:mm', 'id_ID').format(dateTime);
  }
  
  static String formatTime(DateTime time) {
    return DateFormat('H:mm', 'id_ID').format(time);
  }
  
  static String formatMonthYear(DateTime date) {
    return DateFormat('MMMM y', 'id_ID').format(date);
  }
  
  static String formatShortMonthYear(DateTime date) {
    return DateFormat('MMM y', 'id_ID').format(date);
  }
  
  static String formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) {
      return 'Hari ini';
    } else if (difference == 1) {
      return 'Kemarin';
    } else if (difference < 7) {
      return '${difference} hari yang lalu';
    } else {
      return formatDate(date);
    }
  }
  
  static String formatPercentage(double value) {
    return '${(value * 100).toStringAsFixed(1)}%';
  }
  
  static String formatCompactCurrency(double amount, String currencyCode) {
    final symbol = getCurrencySymbol(currencyCode);
    
    if (amount.abs() >= 1000000) {
      return '$symbol${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount.abs() >= 1000) {
      return '$symbol${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return formatCurrency(amount, currencyCode);
    }
  }
  
  // IDR format
  static String formatIDR(double amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(amount);
  }
  
  static String formatIDRWithDecimals(double amount) {
    return NumberFormat.currency(
      locale: 'id_ID', 
      symbol: 'Rp ',
      decimalDigits: 2,
    ).format(amount);
  }
}

class DateUtils {
  static DateTime getStartOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }
  
  static DateTime getEndOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0, 23, 59, 59);
  }
  
  static DateTime getStartOfWeek(DateTime date, int firstDayOfWeek) {
    final daysSinceMonday = (date.weekday - firstDayOfWeek) % 7;
    return date.subtract(Duration(days: daysSinceMonday));
  }
  
  static DateTime getEndOfWeek(DateTime date, int firstDayOfWeek) {
    final startOfWeek = getStartOfWeek(date, firstDayOfWeek);
    return startOfWeek.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
  }
  
  static List<DateTime> getDatesInRange(DateTime start, DateTime end) {
    final dates = <DateTime>[];
    DateTime current = start;
    
    while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
      dates.add(current);
      current = current.add(const Duration(days: 1));
    }
    
    return dates;
  }
  
  static int getDaysInMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0).day;
  }
  
  static bool isSameMonth(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month;
  }
  
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
