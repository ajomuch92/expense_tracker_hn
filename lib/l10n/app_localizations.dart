import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';

/// Lightweight, dependency-free localization for the app.
///
/// We keep this hand-rolled (instead of the flutter_localizations /
/// gen-l10n toolchain) so the strings can be edited directly without
/// running codegen. Supported locales: Spanish (es, default) and
/// English (en).
class AppStrings {
  AppStrings._();

  static const Map<String, Map<String, String>> _values = {
    'appTitle': {'es': 'Mis Finanzas', 'en': 'My Finances'},
    'home': {'es': 'Home', 'en': 'Home'},
    'categories': {'es': 'Categorías', 'en': 'Categories'},
    'settings': {'es': 'Settings', 'en': 'Settings'},
    'myExpenses': {'es': 'Mis Gastos', 'en': 'My Expenses'},
    'lastWeek': {'es': 'Última semana', 'en': 'Last week'},
    'lastMonth': {'es': 'Último mes', 'en': 'Last month'},
    'thisMonth': {'es': 'Este mes', 'en': 'This month'},
    'custom': {'es': 'Personalizado', 'en': 'Custom'},
    'total': {'es': 'TOTAL', 'en': 'TOTAL'},
    'recentTransactions': {'es': 'Transacciones Recientes', 'en': 'Recent Transactions'},
    'viewAsList': {'es': 'Ver como lista', 'en': 'View as list'},
    'groupByCategory': {'es': 'Agrupar por categoría', 'en': 'Group by category'},
    'seeAll': {'es': 'Ver todo', 'en': 'See all'},
    'allTransactions': {'es': 'Todas las Transacciones', 'en': 'All Transactions'},
    'transactions': {'es': 'transacciones', 'en': 'transactions'},
    'noTransactions': {'es': 'No hay transacciones en este período', 'en': 'No transactions in this period'},
    'newExpense': {'es': 'Nuevo Gasto', 'en': 'New Expense'},
    'editExpense': {'es': 'Editar Gasto', 'en': 'Edit Expense'},
    'amount': {'es': 'IMPORTE', 'en': 'AMOUNT'},
    'category': {'es': 'CATEGORÍA', 'en': 'CATEGORY'},
    'selectCategory': {'es': 'Seleccionar categoría', 'en': 'Select category'},
    'date': {'es': 'FECHA', 'en': 'DATE'},
    'notes': {'es': 'OBSERVACIONES', 'en': 'NOTES'},
    'notesHint': {'es': '¿En qué gastaste este dinero?', 'en': 'What did you spend this money on?'},
    'ticket': {'es': 'Ticket', 'en': 'Receipt'},
    'location': {'es': 'Ubicación', 'en': 'Location'},
    'saveExpense': {'es': 'Guardar Gasto', 'en': 'Save Expense'},
    'newCategory': {'es': 'Nueva Categoría', 'en': 'New Category'},
    'editCategory': {'es': 'Editar Categoría', 'en': 'Edit Category'},
    'categoryName': {'es': 'Nombre de la Categoría', 'en': 'Category Name'},
    'categoryNameHint': {'es': 'Ej. Restaurantes, Gimnasio...', 'en': 'E.g. Restaurants, Gym...'},
    'description': {'es': 'DESCRIPCIÓN (OPCIONAL)', 'en': 'DESCRIPTION (OPTIONAL)'},
    'descriptionHint': {'es': 'Agrega una nota sobre esta categoría...', 'en': 'Add a note about this category...'},
    'selectIcon': {'es': 'Seleccionar Icono', 'en': 'Select Icon'},
    'chooseIcon': {'es': 'Elegir ícono', 'en': 'Choose icon'},
    'searchIconHint': {'es': 'Buscar ícono...', 'en': 'Search icon...'},
    'noResultsFor': {'es': 'Sin resultados para "%s"', 'en': 'No results for "%s"'},
    'autoColor': {'es': 'Automático (según nombre)', 'en': 'Automatic (from name)'},
    'customColor': {'es': 'Personalizado', 'en': 'Custom'},
    'pickColor': {'es': 'Elegir color', 'en': 'Pick a color'},
    'visualIdentity': {'es': 'Identidad Visual', 'en': 'Visual Identity'},
    'monthlyBudget': {'es': 'Presupuesto Mensual', 'en': 'Monthly Budget'},
    'setSpendingLimit': {'es': 'Establecer un límite de gasto', 'en': 'Set a spending limit'},
    'saveCategory': {'es': 'Guardar Categoría', 'en': 'Save Category'},
    'preview': {'es': 'VISTA PREVIA', 'en': 'PREVIEW'},
    'needMoreCategories': {'es': '¿Necesitas separar más tus gastos?', 'en': 'Need to split your expenses further?'},
    'createCustomCategory': {'es': 'Crea una categoría personalizada.', 'en': 'Create a custom category.'},
    'configuration': {'es': 'Configuración', 'en': 'Settings'},
    'theme': {'es': 'TEMA', 'en': 'THEME'},
    'light': {'es': 'Claro', 'en': 'Light'},
    'dark': {'es': 'Oscuro', 'en': 'Dark'},
    'system': {'es': 'Sistema', 'en': 'System'},
    'currency': {'es': 'MONEDA', 'en': 'CURRENCY'},
    'language': {'es': 'IDIOMA', 'en': 'LANGUAGE'},
    'spanish': {'es': 'Español', 'en': 'Spanish'},
    'english': {'es': 'Inglés', 'en': 'English'},
    'preferences': {'es': 'PREFERENCIAS', 'en': 'PREFERENCES'},
    'dailyNotifications': {'es': 'Notificaciones Diarias', 'en': 'Daily Notifications'},
    'biometricLock': {'es': 'Bloqueo Biométrico', 'en': 'Biometric Lock'},
    'upgradePremium': {'es': 'Mejora a Premium', 'en': 'Upgrade to Premium'},
    'premiumDesc': {
      'es': 'Exportaciones ilimitadas, sincronización en la nube y categorías personalizadas.',
      'en': 'Unlimited exports, cloud sync and custom categories.'
    },
    'getPro': {'es': 'Obtener Pro', 'en': 'Get Pro'},
    'totalBudget': {'es': 'PRESUPUESTO TOTAL', 'en': 'TOTAL BUDGET'},
    'spentPercent': {
      'es': 'Has gastado el %s% de tu presupuesto total este mes.',
      'en': "You've spent %s% of your total budget this month."
    },
    'noLimit': {'es': 'Sin límite', 'en': 'No limit'},
    'confirmDelete': {'es': '¿Eliminar esta categoría?', 'en': 'Delete this category?'},
    'confirmDeleteExpense': {'es': '¿Eliminar este gasto?', 'en': 'Delete this expense?'},
    'confirmDeleteBody': {
      'es': 'Esta acción no se puede deshacer. Los gastos asociados no se eliminarán.',
      'en': 'This action cannot be undone. Associated expenses will not be deleted.'
    },
    'cancel': {'es': 'Cancelar', 'en': 'Cancel'},
    'delete': {'es': 'Eliminar', 'en': 'Delete'},
    'save': {'es': 'Guardar', 'en': 'Save'},
    'expenseSaved': {'es': 'Gasto guardado', 'en': 'Expense saved'},
    'categorySaved': {'es': 'Categoría guardada', 'en': 'Category saved'},
    'expenseDeleted': {'es': 'Gasto eliminado', 'en': 'Expense deleted'},
    'categoryDeleted': {'es': 'Categoría eliminada', 'en': 'Category deleted'},
    'unexpectedError': {'es': 'Ocurrió un error inesperado. Intenta de nuevo.', 'en': 'Something went wrong. Please try again.'},
    'comingSoon': {'es': 'Próximamente', 'en': 'Coming soon'},
    'enterAmount': {'es': 'Ingresa un importe válido', 'en': 'Enter a valid amount'},
    'pickCategory': {'es': 'Selecciona una categoría', 'en': 'Pick a category'},
    'enterName': {'es': 'Ingresa un nombre', 'en': 'Enter a name'},
    'from': {'es': 'Desde', 'en': 'From'},
    'to': {'es': 'Hasta', 'en': 'To'},
    'apply': {'es': 'Aplicar', 'en': 'Apply'},
    'customRange': {'es': 'Rango personalizado', 'en': 'Custom range'},
    'noCategories': {'es': 'Aún no tienes categorías', 'en': "You don't have categories yet"},
    'addCategory': {'es': 'Agregar categoría', 'en': 'Add category'},
    'spent': {'es': 'gastado', 'en': 'spent'},
    'today': {'es': 'Hoy', 'en': 'Today'},
    'yesterday': {'es': 'Ayer', 'en': 'Yesterday'},
    'other': {'es': 'Otros', 'en': 'Other'},
  };

  static String of(BuildContext context, String key, [List<String>? args]) =>
      _resolve(context.watch<SettingsProvider>().languageCode, key, args);

  /// Same as [of], but reads the language without subscribing to changes.
  /// Use this outside of `build()` (e.g. inside `onPressed`/`onTap`
  /// callbacks or when eagerly building widgets before a dialog opens),
  /// where `context.watch` throws because there is no widget tree building.
  static String ofRead(BuildContext context, String key, [List<String>? args]) =>
      _resolve(context.read<SettingsProvider>().languageCode, key, args);

  static String _resolve(String lang, String key, List<String>? args) {
    var text = _values[key]?[lang] ?? _values[key]?['es'] ?? key;
    if (args != null) {
      for (final a in args) {
        text = text.replaceFirst('%s', a);
      }
    }
    return text;
  }
}

extension AppStringsX on BuildContext {
  String tr(String key, [List<String>? args]) => AppStrings.of(this, key, args);

  /// Same as [tr], but safe to call outside of `build()`.
  String trRead(String key, [List<String>? args]) => AppStrings.ofRead(this, key, args);
}
