import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyOption {
  final String code;
  final String symbol;
  final String labelKey;
  const CurrencyOption(this.code, this.symbol, this.labelKey);
}

const List<CurrencyOption> kCurrencies = [
  CurrencyOption('USD', '\$', 'Dólar Estadounidense'),
  CurrencyOption('EUR', '€', 'Euro'),
  CurrencyOption('MXN', '\$', 'Peso Mexicano'),
  CurrencyOption('HNL', 'L', 'Lempira Hondureño'),
];

/// Holds all user preferences. Persisted locally with SharedPreferences
/// (device-local key/value storage — no network calls involved).
class SettingsProvider extends ChangeNotifier {
  static const _kThemeMode = 'theme_mode';
  static const _kCurrency = 'currency_code';
  static const _kLanguage = 'language_code';
  static const _kNotifications = 'daily_notifications';
  static const _kBiometric = 'biometric_lock';
  static const _kGroupExpensesByCategory = 'group_expenses_by_category';

  ThemeMode _themeMode = ThemeMode.dark;
  String _currencyCode = 'USD';
  String _languageCode = 'es';
  bool _dailyNotifications = true;
  bool _biometricLock = false;
  bool _groupExpensesByCategory = false;

  ThemeMode get themeMode => _themeMode;
  String get currencyCode => _currencyCode;
  String get languageCode => _languageCode;
  bool get dailyNotifications => _dailyNotifications;
  bool get biometricLock => _biometricLock;
  bool get groupExpensesByCategory => _groupExpensesByCategory;

  CurrencyOption get currency =>
      kCurrencies.firstWhere((c) => c.code == _currencyCode, orElse: () => kCurrencies.first);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final themeStr = prefs.getString(_kThemeMode);
    _themeMode = switch (themeStr) {
      'light' => ThemeMode.light,
      'system' => ThemeMode.system,
      _ => ThemeMode.dark,
    };
    _currencyCode = prefs.getString(_kCurrency) ?? 'USD';
    _languageCode = prefs.getString(_kLanguage) ?? 'es';
    _dailyNotifications = prefs.getBool(_kNotifications) ?? true;
    _biometricLock = prefs.getBool(_kBiometric) ?? false;
    _groupExpensesByCategory = prefs.getBool(_kGroupExpensesByCategory) ?? false;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kThemeMode, mode.name);
  }

  Future<void> setCurrency(String code) async {
    _currencyCode = code;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kCurrency, code);
  }

  Future<void> setLanguage(String code) async {
    _languageCode = code;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLanguage, code);
  }

  Future<void> setDailyNotifications(bool value) async {
    _dailyNotifications = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kNotifications, value);
  }

  Future<void> setBiometricLock(bool value) async {
    _biometricLock = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kBiometric, value);
  }

  Future<void> setGroupExpensesByCategory(bool value) async {
    _groupExpensesByCategory = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kGroupExpensesByCategory, value);
  }
}
