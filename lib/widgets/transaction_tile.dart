import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/expense.dart';
import '../providers/settings_provider.dart';
import '../utils/formatters.dart';

class TransactionTile extends StatelessWidget {
  final Expense expense;
  final Category? category;
  final CurrencyOption currency;
  final String languageCode;
  final VoidCallback? onTap;

  const TransactionTile({
    super.key,
    required this.expense,
    required this.category,
    required this.currency,
    required this.languageCode,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = category?.color ?? Colors.grey;
    final title = expense.notes?.trim().isNotEmpty == true
        ? expense.notes!.trim()
        : (category?.name ?? '—');

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(category?.iconData ?? Icons.receipt_long_rounded, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(
                    '${Formatters.relativeDay(expense.date, languageCode: languageCode)}, '
                    '${Formatters.time(expense.date)} · ${category?.name ?? ''}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '-${Formatters.money(expense.amount, currency)}',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
