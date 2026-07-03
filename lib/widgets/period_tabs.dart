import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../utils/date_filter.dart';

class PeriodTabs extends StatelessWidget {
  final PeriodPreset selected;
  final ValueChanged<PeriodPreset> onSelect;
  final VoidCallback onCustomTap;

  const PeriodTabs({
    super.key,
    required this.selected,
    required this.onSelect,
    required this.onCustomTap,
  });

  @override
  Widget build(BuildContext context) {
    final options = <(PeriodPreset, String)>[
      (PeriodPreset.lastWeek, context.tr('lastWeek')),
      (PeriodPreset.lastMonth, context.tr('lastMonth')),
      (PeriodPreset.thisMonth, context.tr('thisMonth')),
    ];

    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final trackColor = isDark ? Colors.white.withValues(alpha: 0.06) : scheme.surfaceContainerHighest;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: trackColor, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          ...options.map((opt) {
            final isSelected = selected == opt.$1;
            return Expanded(
              child: GestureDetector(
                onTap: () => onSelect(opt.$1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? (isDark ? Colors.white : Colors.black) : Colors.transparent,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    opt.$2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? (isDark ? Colors.black : Colors.white)
                          : scheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ),
            );
          }),
          IconButton(
            onPressed: onCustomTap,
            tooltip: context.tr('customRange'),
            icon: Icon(
              Icons.calendar_month_rounded,
              size: 18,
              color: selected == PeriodPreset.custom
                  ? Theme.of(context).colorScheme.primary
                  : scheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
