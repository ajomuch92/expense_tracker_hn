import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/expense_provider.dart';
import '../../providers/settings_provider.dart';
import '../../utils/date_filter.dart';
import '../../widgets/donut_chart.dart';
import '../../widgets/period_tabs.dart';
import '../../widgets/transaction_tile.dart';
import 'add_expense_screen.dart';
import 'all_expenses_screen.dart';

class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({super.key});

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

    if (expenseProvider.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final filtered = expenseProvider.filteredExpenses;
    final totalsByCategory = expenseProvider.filteredTotalsByCategory;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
              child: Icon(Icons.person_rounded, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(width: 10),
            Text(context.tr('myExpenses'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'expensesFab',
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
        ),
        child: const Icon(Icons.add_rounded),
      ),
      body: RefreshIndicator(
        onRefresh: expenseProvider.load,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
          children: [
            PeriodTabs(
              selected: expenseProvider.preset,
              onSelect: expenseProvider.setPreset,
              onCustomTap: () => _pickCustomRange(context),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: ExpenseDonutChart(
                  totalsByCategory: totalsByCategory,
                  categories: expenseProvider.categories,
                  total: expenseProvider.filteredTotal,
                  currency: settings.currency,
                  languageCode: settings.languageCode,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(context.tr('recentTransactions'),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AllExpensesScreen()),
                  ),
                  child: Text(
                    context.tr('seeAll'),
                    style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (filtered.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Text(
                    context.tr('noTransactions'),
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)),
                  ),
                ),
              )
            else
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Column(
                    children: [
                      for (final e in filtered)
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
      ),
    );
  }
}
