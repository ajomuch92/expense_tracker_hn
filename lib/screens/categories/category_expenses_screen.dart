import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/category.dart';
import '../../providers/expense_provider.dart';
import '../../providers/settings_provider.dart';
import '../../utils/date_filter.dart';
import '../../utils/formatters.dart';
import '../../widgets/transaction_tile.dart';
import '../expenses/add_expense_screen.dart';
import 'category_form_screen.dart';

class CategoryExpensesScreen extends StatelessWidget {
  final Category category;
  const CategoryExpensesScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final settings = context.watch<SettingsProvider>();
    final current = provider.categoryById(category.id) ?? category;
    // Full history, shown in the list below.
    final items = provider.expensesForCategory(category.id);
    // The summary card matches the "this month" scope used everywhere else
    // budgets are tracked (e.g. the Categories list), so the number here
    // agrees with what the user just saw before tapping into the category.
    final thisMonth = DateRange.forPreset(PeriodPreset.thisMonth);
    final monthlyItems = items.where((e) => thisMonth.contains(e.date)).toList();
    final total = monthlyItems.fold<double>(0, (s, e) => s + e.amount);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(current.iconData, color: current.color, size: 20),
            const SizedBox(width: 8),
            Text(current.name),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => CategoryFormScreen(existing: current)),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'categoryExpensesFab',
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
        ),
        child: const Icon(Icons.add_rounded),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${monthlyItems.length} ${monthlyItems.length == 1 ? 'gasto' : 'gastos'} · ${context.tr('thisMonth')}'),
                  Text(
                    Formatters.money(total, settings.currency),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 60),
              child: Center(child: Text(context.tr('noTransactions'))),
            )
          else
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Column(
                  children: [
                    for (final e in items)
                      TransactionTile(
                        expense: e,
                        category: current,
                        currency: settings.currency,
                        languageCode: settings.languageCode,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => AddExpenseScreen(existing: e)),
                        ),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
