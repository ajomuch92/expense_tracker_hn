import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/expense_provider.dart';
import '../../providers/settings_provider.dart';
import '../../utils/date_filter.dart';
import '../../utils/formatters.dart';
import '../../widgets/period_tabs.dart';
import '../../widgets/transaction_tile.dart';
import 'add_expense_screen.dart';

class AllExpensesScreen extends StatelessWidget {
  const AllExpensesScreen({super.key});

  Future<void> _pickCustomRange(BuildContext context) async {
    final provider = context.read<ExpenseProvider>();
    final now = DateTime.now();
    final result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 3),
      lastDate: now,
      initialDateRange: DateTimeRange(
        start: provider.activeRange.start,
        end: provider.activeRange.end,
      ),
    );
    if (result != null) {
      provider.setCustomRange(DateRange(result.start, result.end));
    }
  }

  @override
  Widget build(BuildContext context) {
    final expenseProvider = context.watch<ExpenseProvider>();
    final settings = context.watch<SettingsProvider>();
    final items = expenseProvider.filteredExpenses;
    final total = expenseProvider.filteredTotal;

    return Scaffold(
      appBar: AppBar(title: Text(context.tr('allTransactions'))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          PeriodTabs(
            selected: expenseProvider.preset,
            onSelect: expenseProvider.setPreset,
            onCustomTap: () => _pickCustomRange(context),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${items.length} ${context.tr('transactions')}'),
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
                        category: expenseProvider.categoryById(e.categoryId),
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
