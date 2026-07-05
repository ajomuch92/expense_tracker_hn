import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:flutter/material.dart';

enum AppToastType { success, error, warning }

/// Single place the app shows feedback from — success confirmations,
/// unexpected errors, and warnings — all through the same toast style
/// instead of mixing SnackBars, dialogs, etc.
class AppToast {
  AppToast._();

  static void success(BuildContext context, String message) => _show(context, message, AppToastType.success);
  static void error(BuildContext context, String message) => _show(context, message, AppToastType.error);
  static void warning(BuildContext context, String message) => _show(context, message, AppToastType.warning);

  static void _show(BuildContext context, String message, AppToastType type) {
    final IconData icon;
    final Color color;
    switch (type) {
      case AppToastType.success:
        icon = Icons.check_circle_rounded;
        color = const Color(0xFF34D399);
      case AppToastType.error:
        icon = Icons.error_rounded;
        color = const Color(0xFFF87171);
      case AppToastType.warning:
        icon = Icons.warning_rounded;
        color = const Color(0xFFFBBF24);
    }

    DelightToastBar(
      autoDismiss: true,
      snackbarDuration: const Duration(seconds: 3),
      builder: (_) => ToastCard(
        leading: Icon(icon, color: color),
        title: Text(message, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      ),
    ).show(context);
  }
}
