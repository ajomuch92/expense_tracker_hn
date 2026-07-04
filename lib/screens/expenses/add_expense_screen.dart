import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../db/db_helper.dart';
import '../../l10n/app_localizations.dart';
import '../../models/expense.dart';
import '../../providers/expense_provider.dart';
import '../../providers/settings_provider.dart';
import '../../utils/formatters.dart';

class AddExpenseScreen extends StatefulWidget {
  final Expense? existing;
  final String? initialCategoryId;
  const AddExpenseScreen({super.key, this.existing, this.initialCategoryId});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _amountCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  String? _categoryId;
  DateTime _date = DateTime.now();
  String? _amountError;
  String? _categoryError;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    if (e != null) {
      _amountCtrl.text = e.amount.toStringAsFixed(2);
      _notesCtrl.text = e.notes ?? '';
      _categoryId = e.categoryId;
      _date = e.date;
    } else {
      _categoryId = widget.initialCategoryId;
    }
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2015),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    final amount = double.tryParse(_amountCtrl.text.replaceAll(',', '.'));
    setState(() {
      _amountError = (amount == null || amount <= 0)
          ? context.trRead('enterAmount')
          : null;
      _categoryError = _categoryId == null ? context.trRead('pickCategory') : null;
    });
    if (_amountError != null || _categoryError != null) return;

    final provider = context.read<ExpenseProvider>();
    if (_isEditing) {
      await provider.updateExpense(
        widget.existing!.copyWith(
          amount: amount,
          categoryId: _categoryId,
          date: _date,
          notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
        ),
      );
    } else {
      await provider.addExpense(
        Expense(
          id: DbHelper.newId(),
          categoryId: _categoryId!,
          amount: amount!,
          date: _date,
          notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
          createdAt: DateTime.now(),
        ),
      );
    }

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.tr('expenseSaved'))));
    Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(context.tr('confirmDeleteExpense')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.tr('cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.tr('delete')),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await context.read<ExpenseProvider>().deleteExpense(widget.existing!.id);
      if (!mounted) return;
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final expenseProvider = context.watch<ExpenseProvider>();
    final settings = context.watch<SettingsProvider>();
    final categories = expenseProvider.categories;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          _isEditing ? context.tr('editExpense') : context.tr('newExpense'),
        ),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded),
              onPressed: _delete,
            ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    context.tr('amount'),
                    style: TextStyle(
                      fontSize: 12,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _amountCtrl,
                    autofocus: !_isEditing,
                    textAlign: TextAlign.center,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      prefixText: '${settings.currency.symbol} ',
                      prefixStyle: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                      border: InputBorder.none,
                      filled: false,
                      hintText: '0.00',
                    ),
                  ),
                  if (_amountError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        _amountError!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            _Label(context.tr('category')),
            const SizedBox(height: 6),
            InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => _openCategoryPicker(context, categories),
              child: InputDecorator(
                decoration: InputDecoration(errorText: _categoryError),
                child: Row(
                  children: [
                    if (_categoryId != null) ...[
                      Icon(
                        expenseProvider.categoryById(_categoryId!)?.iconData ??
                            Icons.category_rounded,
                        size: 18,
                        color: expenseProvider
                            .categoryById(_categoryId!)
                            ?.color,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      child: Text(
                        _categoryId != null
                            ? (expenseProvider
                                      .categoryById(_categoryId!)
                                      ?.name ??
                                  '')
                            : context.tr('selectCategory'),
                        style: TextStyle(
                          color: _categoryId != null
                              ? null
                              : Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.4),
                        ),
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down_rounded),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _Label(context.tr('date')),
            const SizedBox(height: 6),
            InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: _pickDate,
              child: InputDecorator(
                decoration: const InputDecoration(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Formatters.shortDate(
                        _date,
                        languageCode: settings.languageCode,
                      ),
                    ),
                    const Icon(Icons.calendar_today_rounded, size: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _Label(context.tr('notes')),
            const SizedBox(height: 6),
            TextField(
              controller: _notesCtrl,
              maxLines: 3,
              decoration: InputDecoration(hintText: context.tr('notesHint')),
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: _save,
              child: Text(context.tr('saveExpense')),
            ),
          ],
        ),
      ),
    );
  }

  void _openCategoryPicker(BuildContext context, List categories) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            for (final c in categories)
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: c.color.withValues(alpha: 0.15),
                  child: Icon(c.iconData, color: c.color, size: 18),
                ),
                title: Text(c.name),
                onTap: () {
                  setState(() {
                    _categoryId = c.id;
                    _categoryError = null;
                  });
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        letterSpacing: 1.1,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
      ),
    );
  }
}
