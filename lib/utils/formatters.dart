import 'package:intl/intl.dart';

import '../providers/settings_provider.dart';

class Formatters {
  static String money(double value, CurrencyOption currency, {String locale = 'en_US'}) {
    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: currency.symbol,
      decimalDigits: 2,
    );
    return formatter.format(value);
  }

  static String shortDate(DateTime date, {String languageCode = 'es'}) {
    final locale = languageCode == 'es' ? 'es' : 'en';
    return DateFormat('dd/MM/yyyy', locale).format(date);
  }

  static String relativeDay(DateTime date, {String languageCode = 'es'}) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = today.difference(target).inDays;
    final locale = languageCode == 'es' ? 'es' : 'en';
    if (diff == 0) return languageCode == 'es' ? 'Hoy' : 'Today';
    if (diff == 1) return languageCode == 'es' ? 'Ayer' : 'Yesterday';
    return DateFormat('dd MMM', locale).format(date);
  }

  static String time(DateTime date) => DateFormat('HH:mm').format(date);
}
