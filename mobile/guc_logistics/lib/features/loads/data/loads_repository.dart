import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

import '../../../core/config/app_config.dart';
import '../../../core/data/mock/europe_geo.dart';
import '../../../core/data/mock/mock_data.dart';
import '../../../core/domain/models.dart';
import '../../../core/network/api_client.dart';

class LoadsRepository {
  LoadsRepository(this._api, this._cache);

  final ApiClient _api;
  final Box<String> _cache;

  Future<List<LoadItem>> listLoads({bool mine = false, bool availableOnly = false}) async {
    if (AppConfig.useMockData) {
      await Future<void>.delayed(const Duration(milliseconds: 250));
      var items = List<LoadItem>.of(MockData.loads);
      if (availableOnly) {
        items = items.where((e) => e.status == 'PUBLISHED').toList();
      }
      return items;
    }
    try {
      final response = await _api.dio.get('/api/v1/loads', queryParameters: {'page': 0, 'size': 50});
      final content = (response.data['content'] as List)
          .map((e) => LoadItem.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
      await _cache.put(
        'latest',
        jsonEncode(content
            .map((e) => {
                  'id': e.id,
                  'title': e.title,
                  'pickupCountry': e.pickupCountry,
                  'pickupCity': e.pickupCity,
                  'dropoffCountry': e.dropoffCountry,
                  'dropoffCity': e.dropoffCity,
                  'weightKg': e.weightKg,
                  'status': e.status,
                  'currency': e.currency,
                  'vehicleRequirements': e.vehicleType,
                  'readyFrom': e.loadDate.toIso8601String(),
                  'readyTo': e.deliveryDate.toIso8601String(),
                  'companyVerified': e.companyVerified,
                  'pickupAddress': e.pickupAddress,
                  'dropoffAddress': e.dropoffAddress,
                  'volumeM3': e.volumeM3,
                  'packagingType': e.packagingType,
                  'cargoValue': e.cargoValue,
                  'customsRequired': e.customsRequired,
                  'customsReference': e.customsReference,
                  'unNumber': e.unNumber,
                  'temperatureMin': e.temperatureMin,
                  'temperatureMax': e.temperatureMax,
                  'insuranceRequired': e.insuranceRequired,
                })
            .toList()),
      );
      return availableOnly ? content.where((e) => e.status == 'PUBLISHED').toList() : content;
    } on DioException {
      final cached = _cache.get('latest');
      if (cached == null) rethrow;
      final list = jsonDecode(cached) as List;
      final content = list.map((e) => LoadItem.fromJson(Map<String, dynamic>.from(e as Map))).toList();
      return availableOnly ? content.where((e) => e.status == 'PUBLISHED').toList() : content;
    }
  }

  Future<LoadItem> getLoad(String id) async {
    if (AppConfig.useMockData) {
      return MockData.loads.firstWhere(
        (e) => e.id == id,
        orElse: () => MockData.loads.first,
      );
    }
    final response = await _api.dio.get('/api/v1/loads/$id');
    return LoadItem.fromJson(Map<String, dynamic>.from(response.data as Map));
  }

  Future<void> createLoad(Map<String, dynamic> payload) async {
    if (AppConfig.useMockData) {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      final now = DateTime.now();
      MockData.loads.insert(
        0,
        LoadItem(
          id: 'load-${now.millisecondsSinceEpoch}',
          title: payload['title']?.toString() ?? 'New load',
          loadType: payload['loadType']?.toString() ?? 'General',
          pickupCountry: payload['pickupCountry']?.toString() ?? '',
          pickupCity: payload['pickupCity']?.toString() ?? '',
          dropoffCountry: payload['dropoffCountry']?.toString() ?? '',
          dropoffCity: payload['dropoffCity']?.toString() ?? '',
          weightKg: (payload['weightKg'] as num?)?.toDouble() ?? 0,
          vehicleType: payload['vehicleRequirements']?.toString() ?? payload['vehicleType']?.toString() ?? 'Truck',
          loadDate: DateTime.tryParse(payload['loadDate']?.toString() ?? '') ?? now.add(const Duration(days: 2)),
          deliveryDate: DateTime.tryParse(payload['deliveryDate']?.toString() ?? '') ?? now.add(const Duration(days: 4)),
          status: 'PUBLISHED',
          currency: payload['currency']?.toString() ?? 'EUR',
          price: (payload['price'] as num?)?.toDouble(),
          description: payload['description']?.toString(),
          companyVerified: MockData.companyVerified,
          matchScore: 80,
          factoryName: payload['factoryName']?.toString(),
          companyName: payload['companyName']?.toString() ?? MockData.companyName,
          contactPhone: payload['contactPhone']?.toString(),
          contactPerson: payload['contactPerson']?.toString(),
          doorRamp: payload['doorRamp']?.toString(),
          referenceNo: payload['referenceNo']?.toString(),
          adr: payload['adr'] == true,
          coldChain: payload['coldChain'] == true,
          tailLift: payload['tailLift'] == true,
          forklift: payload['forklift'] == true,
          palletCount: (payload['palletCount'] as num?)?.toInt(),
          batchId: payload['batchId']?.toString(),
          favoritesOnly: payload['favoritesOnly'] == true,
          offerSlaHours: (payload['offerSlaHours'] as num?)?.toInt() ?? 24,
          photos: (payload['photos'] as List?)?.map((e) => e.toString()).toList() ?? const [],
          pickupRegion: payload['pickupRegion']?.toString() ??
              EuropeGeo.regionOf(payload['pickupCity']?.toString() ?? ''),
          pickupLat: MockData.cityLatLng[payload['pickupCity']?.toString()]?[0],
          pickupLng: MockData.cityLatLng[payload['pickupCity']?.toString()]?[1],
          dropoffLat: MockData.cityLatLng[payload['dropoffCity']?.toString()]?[0],
          dropoffLng: MockData.cityLatLng[payload['dropoffCity']?.toString()]?[1],
          pickupAddress: payload['pickupAddress']?.toString(),
          dropoffAddress: payload['dropoffAddress']?.toString(),
          volumeM3: (payload['volumeM3'] as num?)?.toDouble(),
          packagingType: payload['packagingType']?.toString(),
          cargoValue: (payload['cargoValue'] as num?)?.toDouble(),
          customsRequired: payload['customsRequired'] == true,
          customsReference: payload['customsReference']?.toString(),
          unNumber: payload['unNumber']?.toString(),
          temperatureMin: (payload['temperatureMin'] as num?)?.toDouble(),
          temperatureMax: (payload['temperatureMax'] as num?)?.toDouble(),
          insuranceRequired: payload['insuranceRequired'] == true,
        ),
      );
      return;
    }
    final companies = await _api.dio.get('/api/v1/companies/mine');
    final companyList = companies.data is List ? companies.data as List : const [];
    if (companyList.isEmpty) {
      throw StateError('A verified shipper company is required before publishing a load.');
    }
    final company = Map<String, dynamic>.from(companyList.first as Map);
    final operationalNotes = <String>[
      if (payload['description'] != null) payload['description'].toString(),
      if (payload['packagingType'] != null) 'Packaging: ${payload['packagingType']}',
      if (payload['palletCount'] != null) 'Pallets: ${payload['palletCount']}',
      if (payload['customsRequired'] == true) 'Customs required: ${payload['customsReference'] ?? 'yes'}',
      if (payload['unNumber'] != null) 'UN: ${payload['unNumber']}',
      if (payload['temperatureMin'] != null) 'Temperature: ${payload['temperatureMin']}..${payload['temperatureMax']} C',
      if (payload['insuranceRequired'] == true) 'Cargo insurance required',
    ].join('\n');
    final response = await _api.dio.post('/api/v1/loads', data: {
      'shipperCompanyId': company['id'],
      'title': payload['title'],
      'description': operationalNotes,
      'pickupCountry': payload['pickupCountry'],
      'pickupCity': payload['pickupCity'],
      'pickupAddress': payload['pickupAddress'],
      'pickupLat': payload['pickupLat'],
      'pickupLng': payload['pickupLng'],
      'dropoffCountry': payload['dropoffCountry'],
      'dropoffCity': payload['dropoffCity'],
      'dropoffAddress': payload['dropoffAddress'],
      'dropoffLat': payload['dropoffLat'],
      'dropoffLng': payload['dropoffLng'],
      'readyFrom': payload['loadDate'],
      'readyTo': payload['deliveryDate'],
      'weightKg': payload['weightKg'],
      'volumeM3': payload['volumeM3'],
      'vehicleRequirements': payload['vehicleRequirements'],
      'loadType': payload['loadType'],
      'palletCount': payload['palletCount'],
      'packagingType': payload['packagingType'],
      'cargoValue': payload['cargoValue'],
      'contactPerson': payload['contactPerson'],
      'contactPhone': payload['contactPhone'],
      'referenceNo': payload['referenceNo'],
      'doorRamp': payload['doorRamp'],
      'adr': payload['adr'],
      'unNumber': payload['unNumber'],
      'coldChain': payload['coldChain'],
      'temperatureMin': payload['temperatureMin'],
      'temperatureMax': payload['temperatureMax'],
      'tailLift': payload['tailLift'],
      'forklift': payload['forklift'],
      'customsRequired': payload['customsRequired'],
      'customsReference': payload['customsReference'],
      'insuranceRequired': payload['insuranceRequired'],
      'expectedPrice': payload['price'],
      'currency': payload['currency'],
    });
    final created = Map<String, dynamic>.from(response.data as Map);
    await _api.dio.post('/api/v1/loads/${created['id']}/publish');
  }

  Future<void> updateLoad(String id, Map<String, dynamic> payload) async {
    if (AppConfig.useMockData) {
      final i = MockData.loads.indexWhere((e) => e.id == id);
      if (i < 0) return;
      final prev = MockData.loads[i];
      MockData.loads[i] = prev.copyWith(
        title: payload['title']?.toString(),
        factoryName: payload['factoryName']?.toString(),
        contactPhone: payload['contactPhone']?.toString(),
        contactPerson: payload['contactPerson']?.toString(),
        doorRamp: payload['doorRamp']?.toString(),
        referenceNo: payload['referenceNo']?.toString(),
        pickupCity: payload['pickupCity']?.toString(),
        pickupCountry: payload['pickupCountry']?.toString(),
        dropoffCity: payload['dropoffCity']?.toString(),
        dropoffCountry: payload['dropoffCountry']?.toString(),
        weightKg: (payload['weightKg'] as num?)?.toDouble(),
        vehicleType: payload['vehicleRequirements']?.toString() ?? payload['vehicleType']?.toString(),
        loadType: payload['loadType']?.toString(),
        price: (payload['price'] as num?)?.toDouble(),
        description: payload['description']?.toString(),
        loadDate: DateTime.tryParse(payload['loadDate']?.toString() ?? ''),
        deliveryDate: DateTime.tryParse(payload['deliveryDate']?.toString() ?? ''),
        adr: payload['adr'] as bool?,
        coldChain: payload['coldChain'] as bool?,
        tailLift: payload['tailLift'] as bool?,
        forklift: payload['forklift'] as bool?,
        palletCount: (payload['palletCount'] as num?)?.toInt(),
        favoritesOnly: payload['favoritesOnly'] as bool?,
        offerSlaHours: (payload['offerSlaHours'] as num?)?.toInt(),
        photos: (payload['photos'] as List?)?.map((e) => e.toString()).toList(),
        status: payload['status']?.toString(),
      );
      return;
    }
    await _api.dio.patch('/api/v1/loads/$id', data: payload);
  }

  Future<void> setPublished(String id, bool published) async {
    if (AppConfig.useMockData) {
      final i = MockData.loads.indexWhere((e) => e.id == id);
      if (i < 0) return;
      MockData.loads[i] = MockData.loads[i].copyWith(status: published ? 'PUBLISHED' : 'UNPUBLISHED');
      return;
    }
    if (published) {
      await _api.dio.post('/api/v1/loads/$id/publish');
    } else {
      // Backend may not expose unpublish yet — soft-fail via PATCH status.
      try {
        await _api.dio.post('/api/v1/loads/$id/unpublish');
      } catch (_) {
        await _api.dio.patch('/api/v1/loads/$id', data: {'status': 'DRAFT'});
      }
    }
  }

  Future<void> addPhoto(String id, String label) async {
    if (AppConfig.useMockData) {
      final i = MockData.loads.indexWhere((e) => e.id == id);
      if (i < 0) return;
      final photos = [...MockData.loads[i].photos, label];
      MockData.loads[i] = MockData.loads[i].copyWith(photos: photos);
      return;
    }
    await _api.dio.post('/api/v1/loads/$id/photos', data: {'label': label});
  }

  Future<void> republishFrom(LoadItem source) async {
    final now = DateTime.now();
    await createLoad({
      'title': source.title,
      'factoryName': source.factoryName,
      'contactPhone': source.contactPhone,
      'contactPerson': source.contactPerson,
      'doorRamp': source.doorRamp,
      'referenceNo': source.referenceNo,
      'pickupCity': source.pickupCity,
      'pickupCountry': source.pickupCountry,
      'dropoffCity': source.dropoffCity,
      'dropoffCountry': source.dropoffCountry,
      'weightKg': source.weightKg,
      'vehicleRequirements': source.vehicleType,
      'loadType': source.loadType,
      'currency': source.currency,
      'price': source.price,
      'description': source.description,
      'loadDate': now.add(const Duration(days: 2)).toIso8601String(),
      'deliveryDate': now.add(const Duration(days: 4)).toIso8601String(),
      'adr': source.adr,
      'coldChain': source.coldChain,
      'tailLift': source.tailLift,
      'forklift': source.forklift,
      'palletCount': source.palletCount,
    });
  }
}
