import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(context.tr('configuration'))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          _SectionLabel(context.tr('theme')),
          Card(
            child: Column(
              children: [
                _ThemeOption(
                  icon: Icons.light_mode_rounded,
                  label: context.tr('light'),
                  selected: settings.themeMode == ThemeMode.light,
                  onTap: () => settings.setThemeMode(ThemeMode.light),
                ),
                const Divider(height: 1),
                _ThemeOption(
                  icon: Icons.dark_mode_rounded,
                  label: context.tr('dark'),
                  selected: settings.themeMode == ThemeMode.dark,
                  onTap: () => settings.setThemeMode(ThemeMode.dark),
                ),
                const Divider(height: 1),
                _ThemeOption(
                  icon: Icons.settings_suggest_rounded,
                  label: context.tr('system'),
                  selected: settings.themeMode == ThemeMode.system,
                  onTap: () => settings.setThemeMode(ThemeMode.system),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _SectionLabel(context.tr('currency')),
          Card(
            child: Column(
              children: [
                for (var i = 0; i < kCurrencies.length; i++) ...[
                  _CurrencyOptionTile(
                    option: kCurrencies[i],
                    selected: settings.currencyCode == kCurrencies[i].code,
                    onTap: () => settings.setCurrency(kCurrencies[i].code),
                  ),
                  if (i != kCurrencies.length - 1) const Divider(height: 1),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          _SectionLabel(context.tr('language')),
          Card(
            child: Column(
              children: [
                _LanguageOptionTile(
                  flag: '🇪🇸',
                  label: context.tr('spanish'),
                  selected: settings.languageCode == 'es',
                  onTap: () => settings.setLanguage('es'),
                ),
                const Divider(height: 1),
                _LanguageOptionTile(
                  flag: '🇺🇸',
                  label: context.tr('english'),
                  selected: settings.languageCode == 'en',
                  onTap: () => settings.setLanguage('en'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 4),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          letterSpacing: 1.1,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _ThemeOption({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: selected
          ? Icon(
              Icons.check_circle_rounded,
              color: Theme.of(context).colorScheme.primary,
            )
          : const Icon(
              Icons.radio_button_unchecked_rounded,
              color: Colors.grey,
            ),
      onTap: onTap,
    );
  }
}

class _CurrencyOptionTile extends StatelessWidget {
  final CurrencyOption option;
  final bool selected;
  final VoidCallback onTap;
  const _CurrencyOptionTile({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(
          context,
        ).colorScheme.primary.withValues(alpha: 0.12),
        child: Text(
          option.symbol,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(option.labelKey),
      subtitle: Text(option.code),
      trailing: selected
          ? Icon(
              Icons.check_circle_rounded,
              color: Theme.of(context).colorScheme.primary,
            )
          : const Icon(
              Icons.radio_button_unchecked_rounded,
              color: Colors.grey,
            ),
      onTap: onTap,
    );
  }
}

class _LanguageOptionTile extends StatelessWidget {
  final String flag;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _LanguageOptionTile({
    required this.flag,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(flag, style: const TextStyle(fontSize: 22)),
      title: Text(label),
      trailing: selected
          ? Icon(
              Icons.check_circle_rounded,
              color: Theme.of(context).colorScheme.primary,
            )
          : const Icon(
              Icons.radio_button_unchecked_rounded,
              color: Colors.grey,
            ),
      onTap: onTap,
    );
  }
}
