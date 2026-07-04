import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:uuid/uuid.dart';

/// Icons used by categories created before the icon picker was introduced.
/// Kept only so those categories keep rendering; new/edited categories are
/// stored via [IconPickerIcon] serialization instead (see [Category.icon]).
const Map<String, IconData> kLegacyCategoryIcons = {
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

/// Icon used for brand-new categories before the user picks one.
const IconPickerIcon kDefaultCategoryIcon = IconPickerIcon(
  name: 'shopping_cart_rounded',
  data: Icons.shopping_cart_rounded,
  pack: 'roundedMaterial',
);

/// Palette offered when creating/editing a category, in addition to the
/// name-derived and fully custom colors.
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

/// Deterministic color derived from a category name, so the same name
/// always maps to the same color (used as the default suggestion for new
/// categories, similar to how chat apps color avatars from a username).
Color colorForName(String name) {
  final trimmed = name.trim().toLowerCase();
  if (trimmed.isEmpty)
    return Color(int.parse(kCategoryColors.first.replaceFirst('#', '0xFF')));
  final hash = trimmed.codeUnits.fold<int>(
    0,
    (acc, unit) => (acc * 31 + unit) & 0x7fffffff,
  );
  final hue = (hash % 360).toDouble();
  return HSLColor.fromAHSL(1, hue, 0.62, 0.55).toColor();
}

String colorToHex(Color color) =>
    '#${(color.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';

/// Names + icons for the categories seeded into a brand-new database, so
/// the app isn't empty on first launch. Colors aren't listed here — they're
/// derived from the name via [colorForName], same as new user-created
/// categories default to.
const List<(String name, String iconKey, IconData icon)>
_kDefaultCategorySeeds = [
  ('Compras', 'shopping_cart_rounded', Icons.shopping_cart_rounded),
  ('Comida', 'restaurant_rounded', Icons.restaurant_rounded),
  ('Transporte', 'directions_car_rounded', Icons.directions_car_rounded),
  ('Hogar', 'home_rounded', Icons.home_rounded),
  ('Viajes', 'flight_rounded', Icons.flight_rounded),
  ('Salud', 'favorite_rounded', Icons.favorite_rounded),
  ('Eventos', 'event_rounded', Icons.event_rounded),
  ('Educación', 'school_rounded', Icons.school_rounded),
  ('Entretenimiento', 'movie_rounded', Icons.movie_rounded),
  ('Regalos', 'card_giftcard_rounded', Icons.card_giftcard_rounded),
  ('Mascotas', 'pets_rounded', Icons.pets_rounded),
  ('Gimnasio', 'fitness_center_rounded', Icons.fitness_center_rounded),
  ('Teléfono', 'phone_iphone_rounded', Icons.phone_iphone_rounded),
];

/// Builds fresh [Category] instances for the default seed set (new id and
/// `createdAt` each call), inserted only when the database is first created
/// — see `DbHelper._onCreate`. Deleting a seeded category afterwards is
/// final, it won't reappear on a later app launch.
List<Category> buildDefaultCategories() {
  const uuid = Uuid();
  final now = DateTime.now();
  return [
    for (var i = 0; i < _kDefaultCategorySeeds.length; i++)
      Category(
        id: uuid.v4(),
        name: _kDefaultCategorySeeds[i].$1,
        icon: Category.encodeIcon(
          IconPickerIcon(
            name: _kDefaultCategorySeeds[i].$2,
            data: _kDefaultCategorySeeds[i].$3,
            pack: 'roundedMaterial',
          ),
        ),
        colorHex: colorToHex(colorForName(_kDefaultCategorySeeds[i].$1)),
        // Offset so `ORDER BY created_at ASC` preserves the intended order.
        createdAt: now.add(Duration(milliseconds: i)),
      ),
  ];
}

class Category {
  final String id;
  final String name;
  final String icon;
  final String colorHex;
  final double? monthlyBudget;
  final String? description;
  final DateTime createdAt;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.colorHex,
    required this.createdAt,
    this.monthlyBudget,
    this.description,
  });

  /// Decodes [icon] into the picker's rich representation. Supports both
  /// the new JSON-serialized [IconPickerIcon] format and the legacy plain
  /// keys (e.g. `'cart'`) stored by categories created before the picker.
  IconPickerIcon get iconPickerIcon {
    try {
      final decoded = jsonDecode(icon);
      if (decoded is Map<String, dynamic>) {
        final result = deserializeIcon(decoded);
        if (result != null) return result;
      }
    } catch (_) {
      // Not JSON: fall through to the legacy key lookup below.
    }
    final legacy = kLegacyCategoryIcons[icon];
    if (legacy != null) {
      return IconPickerIcon(
        name: icon,
        data: legacy,
        pack: IconPack.custom.name,
      );
    }
    return kDefaultCategoryIcon;
  }

  IconData get iconData => iconPickerIcon.data;
  Color get color => Color(int.parse(colorHex.replaceFirst('#', '0xFF')));

  /// Encodes an [IconPickerIcon] for storage in the `icon` column.
  static String encodeIcon(IconPickerIcon icon) =>
      jsonEncode(serializeIcon(icon));

  Category copyWith({
    String? name,
    String? icon,
    String? colorHex,
    double? monthlyBudget,
    bool clearBudget = false,
    String? description,
    bool clearDescription = false,
  }) {
    return Category(
      id: id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      colorHex: colorHex ?? this.colorHex,
      createdAt: createdAt,
      monthlyBudget: clearBudget ? null : (monthlyBudget ?? this.monthlyBudget),
      description: clearDescription ? null : (description ?? this.description),
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'icon': icon,
    'color': colorHex,
    'monthly_budget': monthlyBudget,
    'description': description,
    'created_at': createdAt.toIso8601String(),
  };

  factory Category.fromMap(Map<String, dynamic> map) => Category(
    id: map['id'] as String,
    name: map['name'] as String,
    icon: map['icon'] as String,
    colorHex: map['color'] as String,
    monthlyBudget: (map['monthly_budget'] as num?)?.toDouble(),
    description: map['description'] as String?,
    createdAt: DateTime.parse(map['created_at'] as String),
  );
}
