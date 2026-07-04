import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart' hide colorToHex;
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:provider/provider.dart';

import '../../db/db_helper.dart';
import '../../l10n/app_localizations.dart';
import '../../models/category.dart';
import '../../providers/expense_provider.dart';
import '../../widgets/icon_picker_sheet.dart';

class CategoryFormScreen extends StatefulWidget {
  final Category? existing;
  const CategoryFormScreen({super.key, this.existing});

  @override
  State<CategoryFormScreen> createState() => _CategoryFormScreenState();
}

class _CategoryFormScreenState extends State<CategoryFormScreen> {
  final _nameCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _budgetCtrl = TextEditingController();
  IconPickerIcon _icon = kDefaultCategoryIcon;
  String _colorHex = kCategoryColors.first;
  bool _hasBudget = false;
  // Whether the color should keep following the name as the user types.
  // Turns off as soon as the user manually picks a swatch or a custom color.
  bool _colorFollowsName = true;
  String? _nameError;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final c = widget.existing;
    if (c != null) {
      _nameCtrl.text = c.name;
      _descriptionCtrl.text = c.description ?? '';
      _icon = c.iconPickerIcon;
      _colorHex = c.colorHex;
      _colorFollowsName = false;
      _hasBudget = c.monthlyBudget != null;
      if (c.monthlyBudget != null) _budgetCtrl.text = c.monthlyBudget!.toStringAsFixed(0);
    }
  }

  void _onNameChanged(String value) {
    setState(() {
      if (_nameError != null) _nameError = null;
      if (_colorFollowsName) _colorHex = colorToHex(colorForName(value));
    });
  }

  Future<void> _pickIcon() async {
    final icon = await showAppIconPicker(context, preSelected: _icon);
    if (icon != null) setState(() => _icon = icon);
  }

  Future<void> _pickCustomColor() async {
    var picked = Color(int.parse(_colorHex.replaceFirst('#', '0xFF')));
    final title = context.trRead('pickColor');
    final cancel = context.trRead('cancel');
    final apply = context.trRead('apply');
    final result = await showDialog<Color>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: picked,
            onColorChanged: (c) => picked = c,
            enableAlpha: false,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(cancel)),
          TextButton(onPressed: () => Navigator.pop(dialogContext, picked), child: Text(apply)),
        ],
      ),
    );
    if (result != null) {
      setState(() {
        _colorHex = colorToHex(result);
        _colorFollowsName = false;
      });
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descriptionCtrl.dispose();
    _budgetCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    setState(() => _nameError = name.isEmpty ? context.trRead('enterName') : null);
    if (_nameError != null) return;

    final budget = _hasBudget ? double.tryParse(_budgetCtrl.text.replaceAll(',', '.')) : null;
    final provider = context.read<ExpenseProvider>();

    final encodedIcon = Category.encodeIcon(_icon);
    final description = _descriptionCtrl.text.trim();
    if (_isEditing) {
      await provider.updateCategory(widget.existing!.copyWith(
        name: name,
        icon: encodedIcon,
        colorHex: _colorHex,
        monthlyBudget: budget,
        clearBudget: !_hasBudget,
        description: description,
        clearDescription: description.isEmpty,
      ));
    } else {
      await provider.addCategory(Category(
        id: DbHelper.newId(),
        name: name,
        icon: encodedIcon,
        colorHex: _colorHex,
        monthlyBudget: budget,
        description: description.isEmpty ? null : description,
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
      // A single pop would land back on CategoryExpensesScreen for the
      // category we just deleted. Go all the way back to the root instead.
      Navigator.of(context).popUntil((route) => route.isFirst);
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
                    child: Icon(_icon.data, color: Colors.white, size: 30),
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
              onChanged: _onNameChanged,
            ),
            const SizedBox(height: 22),
            _Label(context.tr('description')),
            const SizedBox(height: 6),
            TextField(
              controller: _descriptionCtrl,
              maxLines: 3,
              decoration: InputDecoration(hintText: context.tr('descriptionHint')),
            ),
            const SizedBox(height: 22),
            _Label(context.tr('selectIcon')),
            const SizedBox(height: 10),
            InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: _pickIcon,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
                      child: Icon(_icon.data, color: color, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(context.tr('chooseIcon'), style: const TextStyle(fontWeight: FontWeight.w600))),
                    const Icon(Icons.chevron_right_rounded),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 22),
            _Label(context.tr('visualIdentity')),
            const SizedBox(height: 10),
            Builder(builder: (context) {
              final autoColor = colorForName(_nameCtrl.text);
              final isAutoSelected = _colorFollowsName;
              final isPreset = !_colorFollowsName && kCategoryColors.contains(_colorHex);
              final isCustomSelected = !_colorFollowsName && !isPreset;

              return Wrap(
                spacing: 14,
                runSpacing: 14,
                children: [
                  Tooltip(
                    message: context.tr('autoColor'),
                    child: GestureDetector(
                      onTap: () => setState(() {
                        _colorFollowsName = true;
                        _colorHex = colorToHex(autoColor);
                      }),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: autoColor,
                          shape: BoxShape.circle,
                          border: isAutoSelected
                              ? Border.all(color: Theme.of(context).colorScheme.onSurface, width: 2)
                              : null,
                        ),
                        child: Icon(
                          isAutoSelected ? Icons.check_rounded : Icons.auto_awesome_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                  ...kCategoryColors.map((hex) {
                    final c = Color(int.parse(hex.replaceFirst('#', '0xFF')));
                    final isSelected = !_colorFollowsName && _colorHex == hex;
                    return GestureDetector(
                      onTap: () => setState(() {
                        _colorFollowsName = false;
                        _colorHex = hex;
                      }),
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
                  }),
                  Tooltip(
                    message: context.tr('customColor'),
                    child: GestureDetector(
                      onTap: _pickCustomColor,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: isCustomSelected ? color : Theme.of(context).cardColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isCustomSelected ? Theme.of(context).colorScheme.onSurface : Theme.of(context).dividerColor,
                            width: isCustomSelected ? 2 : 1,
                          ),
                        ),
                        child: Icon(
                          isCustomSelected ? Icons.check_rounded : Icons.add_rounded,
                          color: isCustomSelected ? Colors.white : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
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
