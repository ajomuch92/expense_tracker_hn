import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/Helpers/icon_pack_manager.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

import '../l10n/app_localizations.dart';

/// Packs scanned when the user actually types a search query. Each pack
/// holds thousands of icons, so they're only touched on-demand instead of
/// being loaded upfront (that upfront load is what made the picker feel
/// slow to open).
const List<IconPack> _kSearchablePacks = [
  IconPack.roundedMaterial,
  IconPack.outlinedMaterial,
  IconPack.material,
];

/// Small curated set shown instantly when the picker opens, before the
/// user searches anything.
const Map<String, IconPickerIcon> kCuratedIconPack = {
  'shopping_cart_rounded': IconPickerIcon(name: 'shopping_cart_rounded', data: Icons.shopping_cart_rounded, pack: 'roundedMaterial'),
  'local_grocery_store_rounded': IconPickerIcon(name: 'local_grocery_store_rounded', data: Icons.local_grocery_store_rounded, pack: 'roundedMaterial'),
  'restaurant_rounded': IconPickerIcon(name: 'restaurant_rounded', data: Icons.restaurant_rounded, pack: 'roundedMaterial'),
  'fastfood_rounded': IconPickerIcon(name: 'fastfood_rounded', data: Icons.fastfood_rounded, pack: 'roundedMaterial'),
  'local_cafe_rounded': IconPickerIcon(name: 'local_cafe_rounded', data: Icons.local_cafe_rounded, pack: 'roundedMaterial'),
  'local_bar_rounded': IconPickerIcon(name: 'local_bar_rounded', data: Icons.local_bar_rounded, pack: 'roundedMaterial'),
  'local_pizza_rounded': IconPickerIcon(name: 'local_pizza_rounded', data: Icons.local_pizza_rounded, pack: 'roundedMaterial'),
  'directions_car_rounded': IconPickerIcon(name: 'directions_car_rounded', data: Icons.directions_car_rounded, pack: 'roundedMaterial'),
  'directions_bus_rounded': IconPickerIcon(name: 'directions_bus_rounded', data: Icons.directions_bus_rounded, pack: 'roundedMaterial'),
  'local_taxi_rounded': IconPickerIcon(name: 'local_taxi_rounded', data: Icons.local_taxi_rounded, pack: 'roundedMaterial'),
  'train_rounded': IconPickerIcon(name: 'train_rounded', data: Icons.train_rounded, pack: 'roundedMaterial'),
  'directions_bike_rounded': IconPickerIcon(name: 'directions_bike_rounded', data: Icons.directions_bike_rounded, pack: 'roundedMaterial'),
  'local_gas_station_rounded': IconPickerIcon(name: 'local_gas_station_rounded', data: Icons.local_gas_station_rounded, pack: 'roundedMaterial'),
  'flight_rounded': IconPickerIcon(name: 'flight_rounded', data: Icons.flight_rounded, pack: 'roundedMaterial'),
  'hotel_rounded': IconPickerIcon(name: 'hotel_rounded', data: Icons.hotel_rounded, pack: 'roundedMaterial'),
  'luggage_rounded': IconPickerIcon(name: 'luggage_rounded', data: Icons.luggage_rounded, pack: 'roundedMaterial'),
  'home_rounded': IconPickerIcon(name: 'home_rounded', data: Icons.home_rounded, pack: 'roundedMaterial'),
  'house_rounded': IconPickerIcon(name: 'house_rounded', data: Icons.house_rounded, pack: 'roundedMaterial'),
  'checkroom_rounded': IconPickerIcon(name: 'checkroom_rounded', data: Icons.checkroom_rounded, pack: 'roundedMaterial'),
  'local_laundry_service_rounded': IconPickerIcon(name: 'local_laundry_service_rounded', data: Icons.local_laundry_service_rounded, pack: 'roundedMaterial'),
  'favorite_rounded': IconPickerIcon(name: 'favorite_rounded', data: Icons.favorite_rounded, pack: 'roundedMaterial'),
  'local_hospital_rounded': IconPickerIcon(name: 'local_hospital_rounded', data: Icons.local_hospital_rounded, pack: 'roundedMaterial'),
  'local_pharmacy_rounded': IconPickerIcon(name: 'local_pharmacy_rounded', data: Icons.local_pharmacy_rounded, pack: 'roundedMaterial'),
  'spa_rounded': IconPickerIcon(name: 'spa_rounded', data: Icons.spa_rounded, pack: 'roundedMaterial'),
  'fitness_center_rounded': IconPickerIcon(name: 'fitness_center_rounded', data: Icons.fitness_center_rounded, pack: 'roundedMaterial'),
  'sports_soccer_rounded': IconPickerIcon(name: 'sports_soccer_rounded', data: Icons.sports_soccer_rounded, pack: 'roundedMaterial'),
  'sports_esports_rounded': IconPickerIcon(name: 'sports_esports_rounded', data: Icons.sports_esports_rounded, pack: 'roundedMaterial'),
  'event_rounded': IconPickerIcon(name: 'event_rounded', data: Icons.event_rounded, pack: 'roundedMaterial'),
  'celebration_rounded': IconPickerIcon(name: 'celebration_rounded', data: Icons.celebration_rounded, pack: 'roundedMaterial'),
  'school_rounded': IconPickerIcon(name: 'school_rounded', data: Icons.school_rounded, pack: 'roundedMaterial'),
  'menu_book_rounded': IconPickerIcon(name: 'menu_book_rounded', data: Icons.menu_book_rounded, pack: 'roundedMaterial'),
  'movie_rounded': IconPickerIcon(name: 'movie_rounded', data: Icons.movie_rounded, pack: 'roundedMaterial'),
  'music_note_rounded': IconPickerIcon(name: 'music_note_rounded', data: Icons.music_note_rounded, pack: 'roundedMaterial'),
  'headphones_rounded': IconPickerIcon(name: 'headphones_rounded', data: Icons.headphones_rounded, pack: 'roundedMaterial'),
  'card_giftcard_rounded': IconPickerIcon(name: 'card_giftcard_rounded', data: Icons.card_giftcard_rounded, pack: 'roundedMaterial'),
  'pets_rounded': IconPickerIcon(name: 'pets_rounded', data: Icons.pets_rounded, pack: 'roundedMaterial'),
  'child_care_rounded': IconPickerIcon(name: 'child_care_rounded', data: Icons.child_care_rounded, pack: 'roundedMaterial'),
  'phone_iphone_rounded': IconPickerIcon(name: 'phone_iphone_rounded', data: Icons.phone_iphone_rounded, pack: 'roundedMaterial'),
  'wifi_rounded': IconPickerIcon(name: 'wifi_rounded', data: Icons.wifi_rounded, pack: 'roundedMaterial'),
  'computer_rounded': IconPickerIcon(name: 'computer_rounded', data: Icons.computer_rounded, pack: 'roundedMaterial'),
  'tv_rounded': IconPickerIcon(name: 'tv_rounded', data: Icons.tv_rounded, pack: 'roundedMaterial'),
  'electrical_services_rounded': IconPickerIcon(name: 'electrical_services_rounded', data: Icons.electrical_services_rounded, pack: 'roundedMaterial'),
  'water_drop_rounded': IconPickerIcon(name: 'water_drop_rounded', data: Icons.water_drop_rounded, pack: 'roundedMaterial'),
  'work_rounded': IconPickerIcon(name: 'work_rounded', data: Icons.work_rounded, pack: 'roundedMaterial'),
  'business_center_rounded': IconPickerIcon(name: 'business_center_rounded', data: Icons.business_center_rounded, pack: 'roundedMaterial'),
  'savings_rounded': IconPickerIcon(name: 'savings_rounded', data: Icons.savings_rounded, pack: 'roundedMaterial'),
  'credit_card_rounded': IconPickerIcon(name: 'credit_card_rounded', data: Icons.credit_card_rounded, pack: 'roundedMaterial'),
  'receipt_long_rounded': IconPickerIcon(name: 'receipt_long_rounded', data: Icons.receipt_long_rounded, pack: 'roundedMaterial'),
  'park_rounded': IconPickerIcon(name: 'park_rounded', data: Icons.park_rounded, pack: 'roundedMaterial'),
  'beach_access_rounded': IconPickerIcon(name: 'beach_access_rounded', data: Icons.beach_access_rounded, pack: 'roundedMaterial'),
  'camera_alt_rounded': IconPickerIcon(name: 'camera_alt_rounded', data: Icons.camera_alt_rounded, pack: 'roundedMaterial'),
  'brush_rounded': IconPickerIcon(name: 'brush_rounded', data: Icons.brush_rounded, pack: 'roundedMaterial'),
  'more_horiz_rounded': IconPickerIcon(name: 'more_horiz_rounded', data: Icons.more_horiz_rounded, pack: 'roundedMaterial'),
};

/// Cap on search results so a broad query (e.g. a single letter) can't
/// force the grid to render thousands of tiles at once.
const int _kMaxSearchResults = 150;

/// Opens a lightweight icon picker: it shows [kCuratedIconPack] instantly,
/// and only scans the full Material icon catalog (thousands of icons)
/// once the user types a search query.
Future<IconPickerIcon?> showAppIconPicker(BuildContext context, {IconPickerIcon? preSelected}) {
  return showModalBottomSheet<IconPickerIcon>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (_) => _IconPickerSheet(preSelected: preSelected),
  );
}

class _IconPickerSheet extends StatefulWidget {
  final IconPickerIcon? preSelected;
  const _IconPickerSheet({this.preSelected});

  @override
  State<_IconPickerSheet> createState() => _IconPickerSheetState();
}

class _IconPickerSheetState extends State<_IconPickerSheet> {
  // Only this many tiles are built on the first frame (roughly enough to
  // fill the visible grid); the rest trickle in afterwards in small batches
  // so opening the sheet never blocks on building everything at once.
  static const _initialBatchSize = 24;
  static const _batchStep = 60;
  static const _batchInterval = Duration(milliseconds: 16);

  final _searchCtrl = TextEditingController();
  List<MapEntry<String, IconPickerIcon>>? _searchResults;
  int _visibleCount = _initialBatchSize;
  Timer? _revealTimer;

  List<MapEntry<String, IconPickerIcon>> get _allEntries =>
      _searchResults ?? kCuratedIconPack.entries.toList(growable: false);

  @override
  void initState() {
    super.initState();
    _scheduleReveal();
  }

  @override
  void dispose() {
    _revealTimer?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _scheduleReveal() {
    _revealTimer?.cancel();
    _revealTimer = Timer.periodic(_batchInterval, (timer) {
      final total = _allEntries.length;
      if (!mounted || _visibleCount >= total) {
        timer.cancel();
        return;
      }
      setState(() => _visibleCount = (_visibleCount + _batchStep).clamp(0, total));
    });
  }

  void _onSearchChanged(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      setState(() {
        _searchResults = null;
        _visibleCount = _initialBatchSize;
      });
      _scheduleReveal();
      return;
    }
    final results = <MapEntry<String, IconPickerIcon>>[];
    for (final pack in _kSearchablePacks) {
      for (final entry in IconPackManager.getIcons(pack).entries) {
        if (entry.key.toLowerCase().contains(q)) {
          results.add(entry);
          if (results.length >= _kMaxSearchResults) break;
        }
      }
      if (results.length >= _kMaxSearchResults) break;
    }
    setState(() {
      _searchResults = results;
      _visibleCount = _initialBatchSize;
    });
    _scheduleReveal();
  }

  @override
  Widget build(BuildContext context) {
    final allEntries = _allEntries;
    final entries = allEntries.take(_visibleCount).toList();
    final isRevealing = _visibleCount < allEntries.length;
    final color = Theme.of(context).colorScheme.primary;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.92,
      expand: false,
      builder: (context, scrollController) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            TextField(
              controller: _searchCtrl,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: context.tr('searchIconHint'),
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () {
                          _searchCtrl.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
              ),
            ),
            if (isRevealing) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(minHeight: 2, value: _visibleCount / allEntries.length),
              ),
            ],
            const SizedBox(height: 12),
            Expanded(
              child: entries.isEmpty
                  ? Center(child: Text(context.tr('noResultsFor', [_searchCtrl.text])))
                  : GridView.builder(
                      controller: scrollController,
                      itemCount: entries.length,
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 64,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        final icon = entries[index].value;
                        final isSelected = icon == widget.preSelected;
                        return InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () => Navigator.of(context).pop(icon),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected ? color.withValues(alpha: 0.15) : Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected ? color : Theme.of(context).dividerColor,
                                width: isSelected ? 1.6 : 1,
                              ),
                            ),
                            child: Icon(icon.data, color: isSelected ? color : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
