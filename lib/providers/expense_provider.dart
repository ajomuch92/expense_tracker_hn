import 'package:flutter/material.dart';

import '../db/db_helper.dart';
import '../models/category.dart';
import '../models/expense.dart';
import '../utils/date_filter.dart';

class ExpenseProvider extends ChangeNotifier {
  final DbHelper _db = DbHelper.instance;

  List<Category> _categories = [];
  List<Expense> _expenses = [];
  bool _loading = true;

  PeriodPreset _preset = PeriodPreset.lastWeek;
  DateRange? _customRange;

  List<Category> get categories => _categories;
  List<Expense> get expenses => _expenses;
  bool get loading => _loading;
  PeriodPreset get preset => _preset;
  DateRange get activeRange => DateRange.forPreset(_preset, custom: _customRange);

  Future<void> load() async {
    _loading = true;
    notifyListeners();
    _categories = await _db.getCategories();
    _expenses = await _db.getExpenses();
    _loading = false;
    notifyListeners();
  }

  void setPreset(PeriodPreset preset) {
    _preset = preset;
    notifyListeners();
  }

  void setCustomRange(DateRange range) {
    _customRange = range;
    _preset = PeriodPreset.custom;
    notifyListeners();
  }

  Category? categoryById(String id) {
    for (final c in _categories) {
      if (c.id == id) return c;
    }
    return null;
  }

  List<Expense> get filteredExpenses {
    final range = activeRange;
    final list = _expenses.where((e) => range.contains(e.date)).toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  double get filteredTotal => filteredExpenses.fold(0.0, (sum, e) => sum + e.amount);

  /// Category breakdown (categoryId -> total spent) for the active range,
  /// used to render the donut chart & percentages.
  Map<String, double> get filteredTotalsByCategory {
    final map = <String, double>{};
    for (final e in filteredExpenses) {
      map[e.categoryId] = (map[e.categoryId] ?? 0) + e.amount;
    }
    return map;
  }

  double totalSpentForCategory(String categoryId, {DateRange? range}) {
    final r = range ?? DateRange.forPreset(PeriodPreset.thisMonth);
    return _expenses
        .where((e) => e.categoryId == categoryId && r.contains(e.date))
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  double get totalMonthlyBudget =>
      _categories.fold(0.0, (sum, c) => sum + (c.monthlyBudget ?? 0));

  List<Expense> expensesForCategory(String categoryId) =>
      _expenses.where((e) => e.categoryId == categoryId).toList()
        ..sort((a, b) => b.date.compareTo(a.date));

  // ----------------- Mutations -----------------

  Future<void> addExpense(Expense e) async {
    await _db.insertExpense(e);
    await load();
  }

  Future<void> updateExpense(Expense e) async {
    await _db.updateExpense(e);
    await load();
  }

  Future<void> deleteExpense(String id) async {
    await _db.deleteExpense(id);
    await load();
  }

  Future<void> addCategory(Category c) async {
    await _db.insertCategory(c);
    await load();
  }

  Future<void> updateCategory(Category c) async {
    await _db.updateCategory(c);
    await load();
  }

  Future<void> deleteCategory(String id) async {
    await _db.deleteCategory(id);
    await load();
  }
}
