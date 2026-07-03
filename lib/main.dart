import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'l10n/app_localizations.dart';
import 'providers/expense_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/root_shell.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize date formatting symbols for both supported locales (es, en)
  // so DateFormat(..., 'es') doesn't throw at runtime.
  await initializeDateFormatting('es');
  await initializeDateFormatting('en');
  runApp(const AppRoot());
}

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  late final SettingsProvider _settings;
  late final ExpenseProvider _expenses;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _settings = SettingsProvider();
    _expenses = ExpenseProvider();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await _settings.load();
    await _expenses.load();
    if (mounted) setState(() => _ready = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _settings),
        ChangeNotifierProvider.value(value: _expenses),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            onGenerateTitle: (ctx) => ctx.tr('appTitle'),
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: settings.themeMode,
            home: const RootShell(),
          );
        },
      ),
    );
  }
}
