import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/expense.dart';
import '../../providers/expense_provider.dart';
import '../../providers/settings_provider.dart';
import '../../utils/date_filter.dart';
import '../../utils/formatters.dart';
import '../../widgets/donut_chart.dart';
import '../../widgets/period_tabs.dart';
import '../../widgets/transaction_tile.dart';
import 'add_expense_screen.dart';
import 'all_expenses_screen.dart';
import 'search_screen.dart';

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

  List<Widget> _buildGroupedSections(
    BuildContext context,
    List<Expense> filtered,
    ExpenseProvider provider,
    SettingsProvider settings,
  ) {
    final byCategory = <String, List<Expense>>{};
    for (final e in filtered) {
      byCategory.putIfAbsent(e.categoryId, () => []).add(e);
    }
    // Highest-spending category group first.
    final entries = byCategory.entries.toList()
      ..sort((a, b) => b.value
          .fold<double>(0, (s, e) => s + e.amount)
          .compareTo(a.value.fold<double>(0, (s, e) => s + e.amount)));

    return [
      for (final entry in entries)
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Builder(builder: (context) {
                final category = provider.categoryById(entry.key);
                final subtotal = entry.value.fold<double>(0, (s, e) => s + e.amount);
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: (category?.color ?? Colors.grey).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              category?.iconData ?? Icons.category_rounded,
                              color: category?.color,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              category?.name ?? context.tr('other'),
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Text(
                            Formatters.money(subtotal, settings.currency),
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    for (final e in entry.value)
                      TransactionTile(
                        expense: e,
                        category: category,
                        currency: settings.currency,
                        languageCode: settings.languageCode,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => AddExpenseScreen(existing: e)),
                        ),
                      ),
                  ],
                );
              }),
            ),
          ),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final expenseProvider = context.watch<ExpenseProvider>();
    final settings = context.watch<SettingsProvider>();

    // Only take over the whole screen on the very first load (no data yet).
    // Pull-to-refresh and post-mutation reloads also flip `loading`, but the
    // list and chart should stay put; RefreshIndicator shows its own spinner.
    if (expenseProvider.loading && expenseProvider.categories.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final filtered = expenseProvider.filteredExpenses;
    final totalsByCategory = expenseProvider.filteredTotalsByCategory;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr('myExpenses'),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            tooltip: context.tr('search'),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SearchScreen()),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'expensesFab',
        tooltip: context.tr('newExpense'),
        onPressed: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const AddExpenseScreen())),
        child: const Icon(Icons.add_rounded),
      ),
      body: RefreshIndicator(
        onRefresh: expenseProvider.load,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          children: [
            PeriodTabs(
              selected: expenseProvider.preset,
              onSelect: expenseProvider.setPreset,
              onCustomTap: () => _pickCustomRange(context),
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: Text(
                    context.tr('recentTransactions'),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _ViewToggleButton(
                  icon: Icons.view_list_rounded,
                  tooltip: context.tr('viewAsList'),
                  selected: !settings.groupExpensesByCategory,
                  onTap: () => context.read<SettingsProvider>().setGroupExpensesByCategory(false),
                ),
                const SizedBox(width: 4),
                _ViewToggleButton(
                  icon: Icons.category_rounded,
                  tooltip: context.tr('groupByCategory'),
                  selected: settings.groupExpensesByCategory,
                  onTap: () => context.read<SettingsProvider>().setGroupExpensesByCategory(true),
                ),
                const SizedBox(width: 4),
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AllExpensesScreen(),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 14,
                    ),
                    child: Text(
                      context.tr('seeAll'),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (filtered.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.receipt_long_rounded,
                        size: 40,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.25),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        context.tr('noTransactions'),
                        textAlign: TextAlign.center,
                        // 0.6 clears WCAG AA (~4.5:1) on the surface; 0.5 did not.
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (settings.groupExpensesByCategory)
              ..._buildGroupedSections(context, filtered, expenseProvider, settings)
            else
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: Column(
                    children: [
                      for (var i = 0; i < filtered.length; i++) ...[
                        if (i > 0) const Divider(height: 1),
                        TransactionTile(
                          expense: filtered[i],
                          category: expenseProvider.categoryById(
                            filtered[i].categoryId,
                          ),
                          currency: settings.currency,
                          languageCode: settings.languageCode,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  AddExpenseScreen(existing: filtered[i]),
                            ),
                          ),
                        ),
                      ],
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

class _ViewToggleButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final bool selected;
  final VoidCallback onTap;

  const _ViewToggleButton({
    required this.icon,
    required this.tooltip,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Tooltip(
      message: tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        // 48x48 hit area (Material min touch target) around a 32px visual pill.
        child: SizedBox(
          width: 48,
          height: 48,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                // Inverted-Action selection, matching PeriodTabs so both
                // selection controls speak one language and Fresh Mint stays
                // the single voice in this row (the "See all" link).
                color: selected
                    ? (isDark ? Colors.white : Colors.black)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 18,
                color: selected
                    ? (isDark ? Colors.black : Colors.white)
                    : scheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
