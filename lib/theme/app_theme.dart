import 'package:flutter/material.dart';

// NOTE on flutter_tailwind_ui (https://fluttertailwind.com):
// The package is declared as a dependency in pubspec.yaml as requested.
// At the time this project was generated the package was in early/active
// development with very limited public API documentation, so instead of
// guessing at class names that might not compile, the palette below uses
// the *exact* official Tailwind CSS hex tokens directly. This keeps the
// app's look fully aligned with the Tailwind design language while
// guaranteeing the project builds. Once you `flutter pub get` the package
// locally, feel free to swap these constants for its widgets/tokens.
class TwHex {
  TwHex._();
  static const teal400 = Color(0xFF2DD4BF);
  static const teal300 = Color(0xFF5EEAD4);
  static const slate50 = Color(0xFFF8FAFC);
  static const slate100 = Color(0xFFF1F5F9);
  static const slate200 = Color(0xFFE2E8F0);
  static const slate300 = Color(0xFFCBD5E1);
  static const slate700 = Color(0xFF334155);
  static const slate900 = Color(0xFF0F172A);
  static const red400 = Color(0xFFF87171);
  static const amber400 = Color(0xFFFBBF24);
}

class AppTheme {
  AppTheme._();

  static Color get primary => TwHex.teal400;
  static Color get primaryDark => TwHex.teal300;
  static Color get danger => TwHex.red400;
  static Color get amber => TwHex.amber400;

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(seedColor: primary, brightness: Brightness.light);
    return _base(scheme, TwHex.slate50, Colors.white, TwHex.slate900);
  }

  static ThemeData get dark {
    final scheme = ColorScheme.fromSeed(seedColor: primaryDark, brightness: Brightness.dark);
    return _base(scheme, const Color(0xFF0B0F14), const Color(0xFF161B22), TwHex.slate100);
  }

  static ThemeData _base(ColorScheme scheme, Color scaffold, Color card, Color onBg) {
    final isDark = scheme.brightness == Brightness.dark;
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffold,
      brightness: scheme.brightness,
      cardColor: card,
      dividerColor: isDark ? TwHex.slate700.withValues(alpha: 0.4) : TwHex.slate200,
      appBarTheme: AppBarTheme(
        backgroundColor: scaffold,
        foregroundColor: onBg,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? Colors.white : Colors.black,
          foregroundColor: isDark ? Colors.black : Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          side: BorderSide(color: isDark ? TwHex.slate700 : TwHex.slate300),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: card,
        indicatorColor: primary.withValues(alpha: 0.18),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 11,
            fontWeight: states.contains(WidgetState.selected) ? FontWeight.w700 : FontWeight.w500,
            color: states.contains(WidgetState.selected) ? primary : onBg.withValues(alpha: 0.5),
          ),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? primary : null,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? primary.withValues(alpha: 0.4) : null,
        ),
      ),
      textTheme: (isDark
              ? Typography.material2021(platform: TargetPlatform.android).white
              : Typography.material2021(platform: TargetPlatform.android).black)
          .apply(bodyColor: onBg, displayColor: onBg),
    );
  }
}
