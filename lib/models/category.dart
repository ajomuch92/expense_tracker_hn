import 'package:flutter/material.dart';

/// Icons available for categories. Stored in SQLite as their string key.
const Map<String, IconData> kCategoryIcons = {
  'cart': Icons.shopping_cart_rounded,
  'food': Icons.restaurant_rounded,
  'car': Icons.directions_car_rounded,
  'home': Icons.home_rounded,
  'travel': Icons.flight_rounded,
  'health': Icons.favorite_rounded,
  'event': Icons.event_rounded,
  'education': Icons.school_rounded,
  'entertainment': Icons.movie_rounded,
  'gift': Icons.card_giftcard_rounded,
  'pet': Icons.pets_rounded,
  'gym': Icons.fitness_center_rounded,
  'phone': Icons.phone_iphone_rounded,
  'other': Icons.more_horiz_rounded,
};

/// Palette offered when creating/editing a category.
const List<String> kCategoryColors = [
  '#2DD4BF', // teal
  '#F87171', // red
  '#A5B4FC', // indigo
  '#FBBF24', // amber
  '#93C5FD', // blue
  '#34D399', // green
  '#F472B6', // pink
  '#C084FC', // purple
];

class Category {
  final String id;
  final String name;
  final String icon;
  final String colorHex;
  final double? monthlyBudget;
  final DateTime createdAt;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.colorHex,
    required this.createdAt,
    this.monthlyBudget,
  });

  IconData get iconData => kCategoryIcons[icon] ?? Icons.more_horiz_rounded;
  Color get color => Color(int.parse(colorHex.replaceFirst('#', '0xFF')));

  Category copyWith({
    String? name,
    String? icon,
    String? colorHex,
    double? monthlyBudget,
    bool clearBudget = false,
  }) {
    return Category(
      id: id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      colorHex: colorHex ?? this.colorHex,
      createdAt: createdAt,
      monthlyBudget: clearBudget ? null : (monthlyBudget ?? this.monthlyBudget),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'icon': icon,
        'color': colorHex,
        'monthly_budget': monthlyBudget,
        'created_at': createdAt.toIso8601String(),
      };

  factory Category.fromMap(Map<String, dynamic> map) => Category(
        id: map['id'] as String,
        name: map['name'] as String,
        icon: map['icon'] as String,
        colorHex: map['color'] as String,
        monthlyBudget: (map['monthly_budget'] as num?)?.toDouble(),
        createdAt: DateTime.parse(map['created_at'] as String),
      );
}
