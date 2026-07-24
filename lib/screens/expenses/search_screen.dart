import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/expense.dart';
import '../../providers/expense_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/transaction_tile.dart';
import 'add_expense_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  final _queryController = TextEditingController();
  final _focusNode = FocusNode();

  DateTime? _startDate;
  DateTime? _endDate;

  // Animation for the search bar entrance
  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, -0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    _animController.forward();
    _queryController.addListener(() => setState(() {}));

    // Auto-focus the search field after the animation settles
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) _focusNode.requestFocus();
      });
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _queryController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // ── Filtering ──────────────────────────────────────────────────────────────

  List<Expense> _filter(List<Expense> all) {
    final query = _queryController.text.trim().toLowerCase();
    final provider = context.read<ExpenseProvider>();

    return all.where((e) {
      // Text filter: match notes or category name
      if (query.isNotEmpty) {
        final notes = (e.notes ?? '').toLowerCase();
        final categoryName =
            (provider.categoryById(e.categoryId)?.name ?? '').toLowerCase();
        if (!notes.contains(query) && !categoryName.contains(query)) {
          return false;
        }
      }

      // Date range filter
      if (_startDate != null) {
        final d = DateTime(e.date.year, e.date.month, e.date.day);
        final s = DateTime(
          _startDate!.year,
          _startDate!.month,
          _startDate!.day,
        );
        if (d.isBefore(s)) return false;
      }
      if (_endDate != null) {
        final d = DateTime(e.date.year, e.date.month, e.date.day);
        final end =
            DateTime(_endDate!.year, _endDate!.month, _endDate!.day);
        if (d.isAfter(end)) return false;
      }

      return true;
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // ── Date pickers ───────────────────────────────────────────────────────────

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
      initialDateRange: (_startDate != null && _endDate != null)
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          datePickerTheme: DatePickerThemeData(
            headerBackgroundColor: Theme.of(context).colorScheme.primary,
            headerForegroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        child: child!,
      ),
    );
    if (result != null) {
      setState(() {
        _startDate = result.start;
        _endDate = result.end;
      });
    }
  }

  void _clearDateFilter() => setState(() {
        _startDate = null;
        _endDate = null;
      });

  // ── UI helpers ─────────────────────────────────────────────────────────────

  String _formatDate(DateTime d, String lang) {
    final locale = lang == 'es' ? 'es' : 'en';
    return DateFormat('dd MMM yyyy', locale).format(d);
  }

  @override
  Widget build(BuildContext context) {
    final expenseProvider = context.watch<ExpenseProvider>();
    final settings = context.watch<SettingsProvider>();
    final lang = settings.languageCode;

    final results = _filter(expenseProvider.expenses);
    final hasDateFilter = _startDate != null && _endDate != null;
    final hasQuery = _queryController.text.trim().isNotEmpty;
    final hasAnyFilter = hasQuery || hasDateFilter;

    return Scaffold(
      appBar: AppBar(
        title: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: _SearchField(
              controller: _queryController,
              focusNode: _focusNode,
              hintText: context.tr('searchHint'),
            ),
          ),
        ),
        titleSpacing: 0,
        // Remove back-button label spacing distortion
        leadingWidth: 48,
      ),
      body: Column(
        children: [
          // ── Date filter chip bar ──────────────────────────────────────────
          _DateFilterBar(
            startDate: _startDate,
            endDate: _endDate,
            lang: lang,
            formatDate: _formatDate,
            hasDateFilter: hasDateFilter,
            onPickRange: _pickDateRange,
            onClear: _clearDateFilter,
          ),

          // ── Results ───────────────────────────────────────────────────────
          Expanded(
            child: hasAnyFilter
                ? _ResultsList(
                    results: results,
                    expenseProvider: expenseProvider,
                    settings: settings,
                    query: _queryController.text.trim(),
                  )
                : _EmptyPrompt(icon: Icons.search_rounded, message: context.tr('searchPrompt')),
          ),
        ],
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;

  const _SearchField({
    required this.controller,
    required this.focusNode,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return TextField(
      controller: controller,
      focusNode: focusNode,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: colorScheme.onSurface.withValues(alpha: 0.45),
          fontSize: 16,
        ),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close_rounded, size: 20),
                onPressed: controller.clear,
                tooltip: 'Clear',
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
      ),
      style: const TextStyle(fontSize: 16),
    );
  }
}

class _DateFilterBar extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final String lang;
  final String Function(DateTime, String) formatDate;
  final bool hasDateFilter;
  final VoidCallback onPickRange;
  final VoidCallback onClear;

  const _DateFilterBar({
    required this.startDate,
    required this.endDate,
    required this.lang,
    required this.formatDate,
    required this.hasDateFilter,
    required this.onPickRange,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.15),
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today_rounded,
            size: 16,
            color: hasDateFilter
                ? colorScheme.primary
                : colorScheme.onSurface.withValues(alpha: 0.45),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: onPickRange,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: hasDateFilter
                      ? colorScheme.primary.withValues(alpha: isDark ? 0.25 : 0.1)
                      : colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(10),
                  border: hasDateFilter
                      ? Border.all(
                          color: colorScheme.primary.withValues(alpha: 0.4),
                          width: 1,
                        )
                      : null,
                ),
                child: Text(
                  hasDateFilter
                      ? '${formatDate(startDate!, lang)}  →  ${formatDate(endDate!, lang)}'
                      : context.tr('filterByDate'),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: hasDateFilter
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: hasDateFilter
                        ? colorScheme.primary
                        : colorScheme.onSurface.withValues(alpha: 0.55),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          if (hasDateFilter) ...[
            const SizedBox(width: 8),
            InkWell(
              onTap: onClear,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: colorScheme.onSurface.withValues(alpha: 0.55),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ResultsList extends StatelessWidget {
  final List<Expense> results;
  final ExpenseProvider expenseProvider;
  final SettingsProvider settings;
  final String query;

  const _ResultsList({
    required this.results,
    required this.expenseProvider,
    required this.settings,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return _EmptyPrompt(
        icon: Icons.search_off_rounded,
        message: context.tr('noSearchResults'),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      children: [
        // Results count chip
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${results.length} ${context.tr('results')}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        Card(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Column(
              children: [
                for (var i = 0; i < results.length; i++) ...[
                  if (i > 0) const Divider(height: 1),
                  TransactionTile(
                    expense: results[i],
                    category: expenseProvider.categoryById(
                      results[i].categoryId,
                    ),
                    currency: settings.currency,
                    languageCode: settings.languageCode,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            AddExpenseScreen(existing: results[i]),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyPrompt extends StatelessWidget {
  final IconData icon;
  final String message;

  const _EmptyPrompt({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 52,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.18),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
