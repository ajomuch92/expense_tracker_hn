import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/category.dart';
import '../../providers/expense_provider.dart';
import '../../providers/settings_provider.dart';
import '../../utils/date_filter.dart';
import '../../utils/formatters.dart';
import 'category_expenses_screen.dart';
import 'category_form_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final settings = context.watch<SettingsProvider>();
    final categories = provider.categories;
    final totalBudget = provider.totalMonthlyBudget;

    final thisMonth = DateRange.forPreset(PeriodPreset.thisMonth);
    // Only categories that actually have a budget count towards "% of total
    // budget spent" — otherwise spending from unbudgeted categories would
    // inflate the percentage past what the total budget can represent.
    final budgetedCategories = categories.where(
      (c) => (c.monthlyBudget ?? 0) > 0,
    );
    final spentOnBudgeted = budgetedCategories.fold<double>(
      0,
      (sum, c) => sum + provider.totalSpentForCategory(c.id, range: thisMonth),
    );
    final spentPct = totalBudget == 0
        ? 0.0
        : (spentOnBudgeted / totalBudget * 100).clamp(0, 999);

    // Highest spender (this month) first.
    final sortedCategories = [...categories]..sort((a, b) =>
        provider
            .totalSpentForCategory(b.id, range: thisMonth)
            .compareTo(provider.totalSpentForCategory(a.id, range: thisMonth)));

    return Scaffold(
      appBar: AppBar(title: Text(context.tr('categories'))),
      floatingActionButton: FloatingActionButton(
        heroTag: 'categoriesFab',
        onPressed: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const CategoryFormScreen())),
        child: const Icon(Icons.add_rounded),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.tr('totalBudget'),
                        style: TextStyle(
                          fontSize: 11,
                          letterSpacing: 1.1,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Formatters.money(totalBudget, settings.currency),
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: (spentPct / 100).clamp(0, 1).toDouble(),
                      minHeight: 8,
                      backgroundColor: Theme.of(context).dividerColor,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.tr('spentPercent', [spentPct.toStringAsFixed(0)]),
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (categories.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 60),
              child: Center(child: Text(context.tr('noCategories'))),
            )
          else
            ...sortedCategories.map(
              (c) => _CategoryTile(category: c, thisMonth: thisMonth),
            ),
          const SizedBox(height: 12),
          InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const CategoryFormScreen()),
            ),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.12),
                      child: Icon(
                        Icons.add_rounded,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      context.tr('needMoreCategories'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      context.tr('createCustomCategory'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final Category category;
  final DateRange thisMonth;
  const _CategoryTile({required this.category, required this.thisMonth});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final settings = context.watch<SettingsProvider>();
    final spent = provider.totalSpentForCategory(category.id, range: thisMonth);
    final budget = category.monthlyBudget;
    final progress = (budget != null && budget > 0)
        ? (spent / budget).clamp(0, 1).toDouble()
        : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => CategoryExpensesScreen(category: category),
          ),
        ),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: category.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    category.iconData,
                    color: category.color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            category.name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            budget != null
                                ? '${Formatters.money(spent, settings.currency)} / ${Formatters.money(budget, settings.currency)}'
                                : '${Formatters.money(spent, settings.currency)} / ${context.tr('noLimit')}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          // No budget means there's nothing to track progress
                          // against: use a flat, fully-filled bar in the same
                          // shade as the track (a plain line) instead of
                          // `value: null`, which renders as an animated
                          // indeterminate spinner and looks like it's loading.
                          value: progress ?? 1,
                          minHeight: 6,
                          backgroundColor: Theme.of(context).dividerColor,
                          color: progress == null
                              ? Theme.of(context).dividerColor
                              : (progress >= 1
                                    ? Theme.of(context).colorScheme.error
                                    : category.color),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
