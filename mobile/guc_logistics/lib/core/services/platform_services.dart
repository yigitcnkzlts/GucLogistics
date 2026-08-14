import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

import '../config/app_config.dart';
import '../data/mock/mock_data.dart';
import '../domain/models.dart';
import '../network/api_client.dart';

/// Offline JSON cache for lists when API is unreachable.
class OfflineCache {
  OfflineCache(this._box);
  final Box<String> _box;

  Future<void> putList(String key, List<Map<String, dynamic>> items) async {
    await _box.put(key, jsonEncode(items));
  }

  List<Map<String, dynamic>>? getList(String key) {
    final raw = _box.get(key);
    if (raw == null) return null;
    final decoded = jsonDecode(raw);
    if (decoded is! List) return null;
    return decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }
}

class ConnectivityService {
  Stream<bool> get online$ => Connectivity().onConnectivityChanged.map(_isOnline);

  Future<bool> isOnline() async => _isOnline(await Connectivity().checkConnectivity());

  static bool _isOnline(List<ConnectivityResult> r) => r.any((e) => e != ConnectivityResult.none);
}

class MediaPickerService {
  final _picker = ImagePicker();

  Future<String?> pickPhoto({required bool fromCamera}) async {
    try {
      final file = await _picker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1920,
      );
      if (file == null) return null;
      return file.name.isNotEmpty ? file.name : file.path.split(RegExp(r'[\\/]')).last;
    } catch (_) {
      // Emulator / missing permission: fall back to mock filename.
      final src = fromCamera ? 'camera' : 'gallery';
      return '${src}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    }
  }
}

class LocationService {
  Future<Position?> currentPosition() async {
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        return null;
      }
      return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    } catch (_) {
      return null;
    }
  }

  Stream<Position> watch() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 25),
    );
  }
}

/// Push token registration. FCM SDK wiring is optional; mock stores token locally + notifies inbox.
class PushService {
  PushService(this._api);
  final ApiClient _api;
  String? lastToken;

  Future<String> ensureToken() async {
    lastToken ??= 'mock-fcm-${DateTime.now().millisecondsSinceEpoch}';
    if (!AppConfig.useMockData) {
      try {
        await _api.dio.post('/api/v1/devices/push-token', data: {'token': lastToken, 'platform': defaultTargetPlatform.name});
      } catch (_) {
        // Backend stub may be absent — keep local token.
      }
    }
    return lastToken!;
  }

  Future<void> simulateIncoming(String title, String body) async {
    await ensureToken();
    MockData.notifications.insert(
      0,
      NotificationItem(
        id: 'push-${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        body: body,
        createdAt: DateTime.now(),
      ),
    );
  }
}

/// Escrow / payout orchestration against mock ledger or future PSP.
class PaymentService {
  PaymentService(this._api);
  final ApiClient _api;

  Future<List<PaymentLedgerEntry>> ledger() async {
    if (AppConfig.useMockData) return List.of(MockData.ledger);
    try {
      final res = await _api.dio.get('/api/v1/payments/ledger');
      final list = res.data is List ? res.data as List : const [];
      return list
          .map(
            (e) => PaymentLedgerEntry(
              id: e['id'].toString(),
              shipmentId: e['shipmentId']?.toString() ?? '',
              label: e['label']?.toString() ?? '',
              amount: (e['amount'] as num?)?.toDouble() ?? 0,
              currency: e['currency']?.toString() ?? 'EUR',
              kind: e['kind']?.toString() ?? 'HOLD',
              at: DateTime.tryParse(e['at']?.toString() ?? '') ?? DateTime.now(),
            ),
          )
          .toList();
    } catch (_) {
      return List.of(MockData.ledger);
    }
  }

  Future<void> releaseAndPayout(String shipmentId) async {
    if (!AppConfig.useMockData) {
      try {
        await _api.dio.post('/api/v1/payments/$shipmentId/release');
        return;
      } catch (_) {/* fall through to mock */}
    }
    MockData.ledger.insert(
      0,
      PaymentLedgerEntry(
        id: 'led-${DateTime.now().millisecondsSinceEpoch}',
        shipmentId: shipmentId,
        label: 'Escrow release',
        amount: 2050,
        currency: 'EUR',
        kind: 'RELEASE',
        at: DateTime.now(),
      ),
    );
    MockData.ledger.insert(
      0,
      PaymentLedgerEntry(
        id: 'led-${DateTime.now().millisecondsSinceEpoch + 1}',
        shipmentId: shipmentId,
        label: 'Carrier payout',
        amount: 1988.5,
        currency: 'EUR',
        kind: 'PAYOUT',
        at: DateTime.now(),
      ),
    );
  }
}
