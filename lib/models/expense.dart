class Expense {
  final String id;
  final String categoryId;
  final double amount;
  final DateTime date;
  final String? notes;
  final DateTime createdAt;

  const Expense({
    required this.id,
    required this.categoryId,
    required this.amount,
    required this.date,
    required this.createdAt,
    this.notes,
  });

  Expense copyWith({
    String? categoryId,
    double? amount,
    DateTime? date,
    String? notes,
  }) {
    return Expense(
      id: id,
      categoryId: categoryId ?? this.categoryId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'category_id': categoryId,
        'amount': amount,
        'date': date.toIso8601String(),
        'notes': notes,
        'created_at': createdAt.toIso8601String(),
      };

  factory Expense.fromMap(Map<String, dynamic> map) => Expense(
        id: map['id'] as String,
        categoryId: map['category_id'] as String,
        amount: (map['amount'] as num).toDouble(),
        date: DateTime.parse(map['date'] as String),
        notes: map['notes'] as String?,
        createdAt: DateTime.parse(map['created_at'] as String),
      );
}
