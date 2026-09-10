import '../../../core/config/app_config.dart';
import '../../../core/data/mock/europe_geo.dart';
import '../../../core/data/mock/mock_data.dart';
import '../../../core/domain/models.dart';
import '../../../core/network/api_client.dart';

class MarketplaceRepository {
  MarketplaceRepository(this._api);

  final ApiClient _api;

  Future<List<CorridorPreset>> corridors() async {
    if (AppConfig.useMockData) return List.of(MockData.corridors);
    return List.of(MockData.corridors);
  }

  Future<MarketPriceBand?> priceBand(String corridorId) async {
    final bands = MockData.priceBands.where((e) => e.corridorId == corridorId);
    return bands.isEmpty ? null : bands.first;
  }

  Future<List<LoadItem>> discoverLoads({
    String? corridorId,
    String? viewerCarrierId,
    List<String> favoriteCarrierIds = const [],
    String? country,
    String? region,
    String? city,
  }) async {
    if (AppConfig.useMockData) {
      await Future<void>.delayed(const Duration(milliseconds: 180));
      var items = MockData.loads.where((e) => e.status == 'PUBLISHED' || e.status == 'MATCHED').toList();
      if (viewerCarrierId != null) {
        items = items.where((e) => !e.favoritesOnly || favoriteCarrierIds.contains(viewerCarrierId)).toList();
      }

      CorridorPreset? corridor;
      for (final c in MockData.corridors) {
        if (c.id == corridorId) {
          corridor = c;
          break;
        }
      }
      if (corridor != null && corridor.id != 'all-eu' && corridor.fromCountries.isNotEmpty) {
        items = items.where((load) {
          final fromOk = corridor!.fromCountries.contains(load.pickupCountry);
          final toOk = corridor.toCountries.isEmpty || corridor.toCountries.contains(load.dropoffCountry);
          return fromOk && toOk;
        }).toList();
      }

      if (country != null && country != EuropeGeo.all) {
        items = items.where((e) => e.pickupCountry == country).toList();
      }
      if (region != null && region != EuropeGeo.all) {
        items = items.where((e) {
          final r = e.pickupRegion ?? EuropeGeo.regionOf(e.pickupCity);
          return r == region;
        }).toList();
      }
      if (city != null && city != EuropeGeo.all) {
        items = items.where((e) => e.pickupCity == city).toList();
      }

      if (viewerCarrierId != null) {
        final pref = MockData.carrierAvailability;
        if (pref.vehicleFilter != 'Any') {
          items = items.where((e) => e.vehicleType.toLowerCase().contains(pref.vehicleFilter.toLowerCase().split(' ').first)).toList();
        }
        if (pref.adrReady == false) {
          // Non-ADR drivers skip ADR loads
          items = items.where((e) => !e.adr).toList();
        }
        items = items.where((e) => e.weightKg <= pref.capacityKg).toList();
        if (pref.preferredDestination != 'Any') {
          items = items.where((e) => e.dropoffCountry == pref.preferredDestination).toList();
        }
        if (!pref.refrigerated) {
          items = items.where((e) => !e.coldChain).toList();
        }
        if (!pref.tailLift) {
          items = items.where((e) => !e.tailLift).toList();
        }
        if (pref.availableFrom != null) {
          items = items.where((e) => !e.loadDate.isBefore(pref.availableFrom!)).toList();
        }
        if (pref.availableUntil != null) {
          items = items.where((e) => !e.loadDate.isAfter(pref.availableUntil!)).toList();
        }
        final minEur = pref.minPriceTry / 36;
        items = items.where((e) => (e.price ?? 0) >= minEur * 0.5).toList();
      }
      return items;
    }
    final response = await _api.dio.get('/api/v1/loads', queryParameters: {'page': 0, 'size': 50});
    final content = (response.data['content'] as List)
        .map((e) => LoadItem.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
    return content;
  }

  List<ShipperCompanyListing> shipperCompaniesFrom(List<LoadItem> loads) {
    final map = <String, ShipperCompanyListing>{};
    for (final load in loads) {
      final name = load.companyName?.trim();
      if (name == null || name.isEmpty) continue;
      final existing = map[name];
      final factories = {...?existing?.factories, if (load.factoryName?.isNotEmpty == true) load.factoryName!}.toList()..sort();
      map[name] = ShipperCompanyListing(
        companyName: name,
        country: load.pickupCountry,
        region: load.pickupRegion ?? EuropeGeo.regionOf(load.pickupCity) ?? '-',
        city: load.pickupCity,
        factories: factories,
        activeLoads: (existing?.activeLoads ?? 0) + 1,
        verified: load.companyVerified || (existing?.verified ?? false),
      );
    }
    final list = map.values.toList()..sort((a, b) => a.companyName.compareTo(b.companyName));
    return list;
  }

  Future<List<CarrierListing>> discoverCarriers({String? corridorId}) async {
    if (AppConfig.useMockData) {
      await Future<void>.delayed(const Duration(milliseconds: 180));
      var items = List<CarrierListing>.of(MockData.carriers);
      if (corridorId != null && corridorId != 'all-eu') {
        items = items.where((c) => c.corridors.contains(corridorId)).toList();
      }
      items.sort((a, b) => (b.matchScore ?? 0).compareTo(a.matchScore ?? 0));
      return items;
    }
    return List.of(MockData.carriers);
  }

  Future<CarrierListing?> getCarrier(String id) async {
    for (final c in MockData.carriers) {
      if (c.id == id) return c;
    }
    return null;
  }

  Future<List<MapPin>> mapPins({
    required bool forLoads,
    String? corridorId,
    String? viewerCarrierId,
    List<String> favoriteCarrierIds = const [],
    String? country,
    String? region,
    String? city,
  }) async {
    if (forLoads) {
      final loads = await discoverLoads(
        corridorId: corridorId,
        viewerCarrierId: viewerCarrierId,
        favoriteCarrierIds: favoriteCarrierIds,
        country: country,
        region: region,
        city: city,
      );
      return loads.map((load) {
        final coords = MockData.cityPins[load.pickupCity] ?? const [0.5, 0.5];
        final company = load.companyName ?? load.factoryName ?? '';
        return MapPin(
          id: load.id,
          label: company.isEmpty ? '${load.pickupCity} → ${load.dropoffCity}' : company,
          subtitle: '${load.factoryName ?? load.pickupCity} · ${load.weightKg.toStringAsFixed(0)} kg',
          mapX: coords[0],
          mapY: coords[1],
          kind: 'load',
          verified: load.companyVerified,
        );
      }).toList();
    }
    final carriers = await discoverCarriers(corridorId: corridorId);
    return carriers
        .map(
          (c) => MapPin(
            id: c.id,
            label: c.name,
            subtitle: '${c.baseCity}, ${c.baseCountry} · ${c.availableHours}h',
            mapX: c.mapX,
            mapY: c.mapY,
            kind: 'carrier',
            verified: c.verified,
          ),
        )
        .toList();
  }

  MarketPriceBand bandForLoad(LoadItem load) {
    for (final corridor in MockData.corridors) {
      if (corridor.id == 'all-eu') continue;
      if (corridor.fromCountries.contains(load.pickupCountry) &&
          (corridor.toCountries.isEmpty || corridor.toCountries.contains(load.dropoffCountry))) {
        final band = MockData.priceBands.where((b) => b.corridorId == corridor.id);
        if (band.isNotEmpty) return band.first;
      }
    }
    return MockData.priceBands.firstWhere((b) => b.corridorId == 'all-eu');
  }
}
