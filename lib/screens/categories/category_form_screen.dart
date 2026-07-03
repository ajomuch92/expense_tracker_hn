import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../db/db_helper.dart';
import '../../l10n/app_localizations.dart';
import '../../models/category.dart';
import '../../providers/expense_provider.dart';

class CategoryFormScreen extends StatefulWidget {
  final Category? existing;
  const CategoryFormScreen({super.key, this.existing});

  @override
  State<CategoryFormScreen> createState() => _CategoryFormScreenState();
}

class _CategoryFormScreenState extends State<CategoryFormScreen> {
  final _nameCtrl = TextEditingController();
  final _budgetCtrl = TextEditingController();
  String _icon = 'cart';
  String _colorHex = kCategoryColors.first;
  bool _hasBudget = false;
  String? _nameError;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final c = widget.existing;
    if (c != null) {
      _nameCtrl.text = c.name;
      _icon = c.icon;
      _colorHex = c.colorHex;
      _hasBudget = c.monthlyBudget != null;
      if (c.monthlyBudget != null) _budgetCtrl.text = c.monthlyBudget!.toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _budgetCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    setState(() => _nameError = name.isEmpty ? context.tr('enterName') : null);
    if (_nameError != null) return;

    final budget = _hasBudget ? double.tryParse(_budgetCtrl.text.replaceAll(',', '.')) : null;
    final provider = context.read<ExpenseProvider>();

    if (_isEditing) {
      await provider.updateCategory(widget.existing!.copyWith(
        name: name,
        icon: _icon,
        colorHex: _colorHex,
        monthlyBudget: budget,
        clearBudget: !_hasBudget,
      ));
    } else {
      await provider.addCategory(Category(
        id: DbHelper.newId(),
        name: name,
        icon: _icon,
        colorHex: _colorHex,
        monthlyBudget: budget,
        createdAt: DateTime.now(),
      ));
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.tr('categorySaved'))));
    Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(context.tr('confirmDelete')),
        content: Text(context.tr('confirmDeleteBody')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(context.tr('cancel'))),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text(context.tr('delete'))),
        ],
      ),
    );
    if (confirmed == true) {
      await context.read<ExpenseProvider>().deleteCategory(widget.existing!.id);
      if (!mounted) return;
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Color(int.parse(_colorHex.replaceFirst('#', '0xFF')));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(_isEditing ? context.tr('editCategory') : context.tr('newCategory')),
        actions: [
          if (_isEditing) IconButton(icon: const Icon(Icons.delete_outline_rounded), onPressed: _delete),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            Center(
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                    child: Icon(kCategoryIcons[_icon], color: Colors.white, size: 30),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.tr('preview'),
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 1.1,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            _Label(context.tr('categoryName')),
            const SizedBox(height: 6),
            TextField(
              controller: _nameCtrl,
              decoration: InputDecoration(hintText: context.tr('categoryNameHint'), errorText: _nameError),
              onChanged: (_) {
                if (_nameError != null) setState(() => _nameError = null);
              },
            ),
            const SizedBox(height: 22),
            _Label(context.tr('selectIcon')),
            const SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1,
              children: kCategoryIcons.entries.map((entry) {
                final isSelected = _icon == entry.key;
                return GestureDetector(
                  onTap: () => setState(() => _icon = entry.key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    decoration: BoxDecoration(
                      color: isSelected ? color.withValues(alpha: 0.15) : Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: isSelected ? color : Theme.of(context).dividerColor, width: isSelected ? 1.6 : 1),
                    ),
                    child: Icon(entry.value, color: isSelected ? color : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 22),
            _Label(context.tr('visualIdentity')),
            const SizedBox(height: 10),
            Wrap(
              spacing: 14,
              runSpacing: 14,
              children: kCategoryColors.map((hex) {
                final c = Color(int.parse(hex.replaceFirst('#', '0xFF')));
                final isSelected = _colorHex == hex;
                return GestureDetector(
                  onTap: () => setState(() => _colorHex = hex),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: c,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: Theme.of(context).colorScheme.onSurface, width: 2)
                          : null,
                    ),
                    child: isSelected ? const Icon(Icons.check_rounded, color: Colors.white, size: 18) : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 22),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(context.tr('monthlyBudget'), style: const TextStyle(fontWeight: FontWeight.w600)),
                              Text(
                                context.tr('setSpendingLimit'),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(value: _hasBudget, onChanged: (v) => setState(() => _hasBudget = v)),
                      ],
                    ),
                    if (_hasBudget) ...[
                      const SizedBox(height: 10),
                      TextField(
                        controller: _budgetCtrl,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(hintText: '0.00'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save_outlined, size: 18),
              label: Text(context.tr('saveCategory')),
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
