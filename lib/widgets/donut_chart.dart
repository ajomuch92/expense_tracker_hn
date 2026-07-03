import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/category.dart';
import '../providers/settings_provider.dart';
import '../utils/formatters.dart';

/// Renders the ring/donut chart used at the top of "Mis Gastos", showing
/// the proportional spend per category for the active date range.
class ExpenseDonutChart extends StatelessWidget {
  final Map<String, double> totalsByCategory;
  final List<Category> categories;
  final double total;
  final CurrencyOption currency;
  final String languageCode;

  const ExpenseDonutChart({
    super.key,
    required this.totalsByCategory,
    required this.categories,
    required this.total,
    required this.currency,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    final entries = totalsByCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final segments = <_Segment>[];
    for (final e in entries) {
      final cat = categories.where((c) => c.id == e.key).cast<Category?>().firstOrNull;
      segments.add(_Segment(
        color: cat?.color ?? Colors.grey,
        value: e.value,
      ));
    }

    return Column(
      children: [
        SizedBox(
          width: 190,
          height: 190,
          child: CustomPaint(
            painter: _DonutPainter(segments: segments, total: total, trackColor: Theme.of(context).dividerColor),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.tr('total'),
                    style: TextStyle(
                      fontSize: 12,
                      letterSpacing: 1.2,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Formatters.money(total, currency),
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 18,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: entries.take(4).map((e) {
            final cat = categories.where((c) => c.id == e.key).cast<Category?>().firstOrNull;
            final pct = total == 0 ? 0 : (e.value / total * 100);
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(color: cat?.color ?? Colors.grey, shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
                Text(
                  '${cat?.name ?? context.tr('other')} ${pct.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

class _Segment {
  final Color color;
  final double value;
  const _Segment({required this.color, required this.value});
}

class _DonutPainter extends CustomPainter {
  final List<_Segment> segments;
  final double total;
  final Color trackColor;

  _DonutPainter({required this.segments, required this.total, required this.trackColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 18.0;
    final rect = Rect.fromCircle(center: center, radius: radius - strokeWidth / 2);

    final track = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawArc(rect, 0, 6.2832, false, track);

    if (total <= 0 || segments.isEmpty) return;

    double startAngle = -1.5708; // -90deg, start at top
    for (final seg in segments) {
      final sweep = (seg.value / total) * 6.28319;
      final paint = Paint()
        ..color = seg.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(rect, startAngle, sweep, false, paint);
      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) =>
      oldDelegate.segments != segments || oldDelegate.total != total;
}
