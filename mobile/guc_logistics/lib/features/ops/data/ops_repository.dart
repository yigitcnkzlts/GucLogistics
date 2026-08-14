import '../../../core/config/app_config.dart';
import '../../../core/data/mock/mock_data.dart';
import '../../../core/domain/ops_models.dart';
import '../../../core/network/api_client.dart';

class OpsRepository {
  OpsRepository(this._api);

  final ApiClient _api;

  Future<List<DocItem>> documents() async {
    if (AppConfig.useMockData) {
      await Future<void>.delayed(const Duration(milliseconds: 180));
      return List.of(MockData.documents);
    }
    final response = await _api.dio.get('/api/v1/ops/documents');
    final list = response.data as List? ?? const [];
    return list.map((e) => _docFromJson(Map<String, dynamic>.from(e as Map))).toList();
  }

  Future<void> uploadDocument(String id, String fileName) async {
    if (AppConfig.useMockData) {
      await Future<void>.delayed(const Duration(milliseconds: 250));
      final i = MockData.documents.indexWhere((d) => d.id == id);
      if (i < 0) return;
      final prev = MockData.documents[i];
      MockData.documents[i] = DocItem(
        id: prev.id,
        type: prev.type,
        title: prev.title,
        status: 'PENDING',
        fileName: fileName,
        updatedAt: DateTime.now(),
      );
      return;
    }
    await _api.dio.post('/api/v1/ops/documents/$id/upload', data: {'fileName': fileName});
  }

  Future<List<ShipmentTrack>> shipments() async {
    if (AppConfig.useMockData) {
      await Future<void>.delayed(const Duration(milliseconds: 180));
      return List.of(MockData.shipments);
    }
    final response = await _api.dio.get('/api/v1/ops/shipments');
    final list = response.data as List? ?? const [];
    return list.map((e) => _shipFromJson(Map<String, dynamic>.from(e as Map))).toList();
  }

  Future<ShipmentTrack> getShipment(String id) async {
    if (AppConfig.useMockData) {
      return MockData.shipments.firstWhere((e) => e.id == id, orElse: () => MockData.shipments.first);
    }
    final response = await _api.dio.get('/api/v1/ops/shipments/$id');
    return _shipFromJson(Map<String, dynamic>.from(response.data as Map));
  }

  Future<void> advanceShipment(String id) async {
    if (AppConfig.useMockData) {
      final i = MockData.shipments.indexWhere((s) => s.id == id);
      if (i < 0) return;
      final s = MockData.shipments[i];
      final steps = List<TrackingStep>.from(s.steps);
      final next = steps.indexWhere((e) => !e.done);
      if (next < 0) return;
      steps[next] = TrackingStep(
        code: steps[next].code,
        labelKey: steps[next].labelKey,
        done: true,
        at: DateTime.now(),
        note: steps[next].note,
      );
      var payment = s.paymentStatus;
      if (steps[next].code == 'DELIVERED' && payment == 'HELD') {
        payment = 'RELEASED';
      }
      MockData.shipments[i] = ShipmentTrack(
        id: s.id,
        matchId: s.matchId,
        loadId: s.loadId,
        title: s.title,
        route: s.route,
        steps: steps,
        paymentStatus: payment,
        agreedAmount: s.agreedAmount,
        currency: s.currency,
        cmrPhotoName: s.cmrPhotoName,
        escrowHeld: payment == 'HELD',
      );
      return;
    }
    await _api.dio.post('/api/v1/ops/shipments/$id/advance');
  }

  Future<void> attachCmr(String id, String fileName) async {
    if (AppConfig.useMockData) {
      final i = MockData.shipments.indexWhere((s) => s.id == id);
      if (i < 0) return;
      final s = MockData.shipments[i];
      MockData.shipments[i] = ShipmentTrack(
        id: s.id,
        matchId: s.matchId,
        loadId: s.loadId,
        title: s.title,
        route: s.route,
        steps: s.steps,
        paymentStatus: s.paymentStatus,
        agreedAmount: s.agreedAmount,
        currency: s.currency,
        cmrPhotoName: fileName,
        escrowHeld: s.escrowHeld,
      );
      return;
    }
    await _api.dio.post('/api/v1/ops/shipments/$id/cmr', data: {'fileName': fileName});
  }

  Future<void> markPaid(String id) async {
    if (AppConfig.useMockData) {
      final i = MockData.shipments.indexWhere((s) => s.id == id);
      if (i < 0) return;
      final s = MockData.shipments[i];
      MockData.shipments[i] = ShipmentTrack(
        id: s.id,
        matchId: s.matchId,
        loadId: s.loadId,
        title: s.title,
        route: s.route,
        steps: s.steps,
        paymentStatus: 'PAID',
        agreedAmount: s.agreedAmount,
        currency: s.currency,
        cmrPhotoName: s.cmrPhotoName,
        escrowHeld: false,
      );
      return;
    }
    await _api.dio.post('/api/v1/ops/shipments/$id/mark-paid');
  }

  Future<List<FleetVehicle>> fleet() async {
    if (AppConfig.useMockData) {
      await Future<void>.delayed(const Duration(milliseconds: 160));
      return List.of(MockData.fleet);
    }
    final response = await _api.dio.get('/api/v1/ops/fleet');
    final list = response.data as List? ?? const [];
    return list.map((e) => _fleetFromJson(Map<String, dynamic>.from(e as Map))).toList();
  }

  Future<void> assignDriver({required String vehicleId, required String driverId}) async {
    if (AppConfig.useMockData) {
      final driver = MockData.team.where((t) => t.id == driverId);
      final name = driver.isEmpty ? 'Driver' : driver.first.name;
      final i = MockData.fleet.indexWhere((v) => v.id == vehicleId);
      if (i >= 0) {
        MockData.fleet[i] = MockData.fleet[i].copyWith(driverName: name, status: 'ACTIVE');
      }
      return;
    }
    await _api.dio.post('/api/v1/ops/fleet/$vehicleId/assign', data: {'driverId': driverId});
  }

  Future<List<TeamMember>> team() async {
    if (AppConfig.useMockData) {
      await Future<void>.delayed(const Duration(milliseconds: 160));
      return List.of(MockData.team);
    }
    final response = await _api.dio.get('/api/v1/ops/team');
    final list = response.data as List? ?? const [];
    return list.map((e) => _teamFromJson(Map<String, dynamic>.from(e as Map))).toList();
  }

  Future<List<CorridorSubscription>> subscriptions() async {
    if (AppConfig.useMockData) {
      await Future<void>.delayed(const Duration(milliseconds: 160));
      return List.of(MockData.subscriptions);
    }
    final response = await _api.dio.get('/api/v1/ops/subscriptions');
    final list = response.data as List? ?? const [];
    return list.map((e) => _subFromJson(Map<String, dynamic>.from(e as Map))).toList();
  }

  Future<void> toggleSubscription(String corridorId) async {
    if (AppConfig.useMockData) {
      final i = MockData.subscriptions.indexWhere((s) => s.corridorId == corridorId);
      if (i < 0) return;
      final s = MockData.subscriptions[i];
      MockData.subscriptions[i] = s.copyWith(active: !s.active);
      return;
    }
    await _api.dio.post('/api/v1/ops/subscriptions/$corridorId/toggle');
  }

  Future<void> setMinPrice(String corridorId, double price) async {
    if (AppConfig.useMockData) {
      final i = MockData.subscriptions.indexWhere((s) => s.corridorId == corridorId);
      if (i < 0) return;
      final s = MockData.subscriptions[i];
      MockData.subscriptions[i] = s.copyWith(minAcceptPrice: price);
      return;
    }
    await _api.dio.put('/api/v1/ops/subscriptions/$corridorId/min-price', data: {'minAcceptPrice': price});
  }

  Future<List<BackhaulSuggestion>> backhauls() async {
    if (AppConfig.useMockData) {
      await Future<void>.delayed(const Duration(milliseconds: 160));
      return List.of(MockData.backhauls);
    }
    final response = await _api.dio.get('/api/v1/ops/backhauls');
    final list = response.data as List? ?? const [];
    return list
        .map(
          (e) => BackhaulSuggestion(
            id: e['id'] as String,
            loadId: e['loadId'] as String,
            title: e['title'] as String,
            route: e['route'] as String,
            reason: e['reason'] as String? ?? '',
            matchScore: (e['matchScore'] as num?)?.toInt() ?? 0,
          ),
        )
        .toList();
  }

  DocItem _docFromJson(Map<String, dynamic> j) => DocItem(
        id: j['id'] as String,
        type: j['type'] as String? ?? 'OTHER',
        title: j['title'] as String? ?? '',
        status: j['status'] as String? ?? 'MISSING',
        fileName: j['fileName'] as String?,
      );

  ShipmentTrack _shipFromJson(Map<String, dynamic> j) => ShipmentTrack(
        id: j['id'] as String,
        matchId: j['matchId'] as String? ?? '',
        loadId: j['loadId'] as String? ?? '',
        title: j['title'] as String? ?? '',
        route: j['route'] as String? ?? '',
        steps: const [],
        paymentStatus: j['paymentStatus'] as String? ?? 'PENDING',
        agreedAmount: (j['agreedAmount'] as num?)?.toDouble() ?? 0,
        currency: j['currency'] as String? ?? 'EUR',
        cmrPhotoName: j['cmrPhotoName'] as String?,
        escrowHeld: j['escrowHeld'] as bool? ?? false,
      );

  FleetVehicle _fleetFromJson(Map<String, dynamic> j) => FleetVehicle(
        id: j['id'] as String,
        plate: j['plate'] as String? ?? '',
        type: j['type'] as String? ?? '',
        capacityKg: (j['capacityKg'] as num?)?.toDouble() ?? 0,
        status: j['status'] as String? ?? 'ACTIVE',
        docStatus: j['docStatus'] as String? ?? 'MISSING',
        driverName: j['driverName'] as String?,
        availableHours: (j['availableHours'] as num?)?.toInt(),
      );

  TeamMember _teamFromJson(Map<String, dynamic> j) => TeamMember(
        id: j['id'] as String,
        name: j['name'] as String? ?? '',
        role: j['role'] as String? ?? 'DRIVER',
        email: j['email'] as String? ?? '',
        active: j['active'] as bool? ?? true,
      );

  CorridorSubscription _subFromJson(Map<String, dynamic> j) => CorridorSubscription(
        corridorId: j['corridorId'] as String,
        label: j['label'] as String? ?? '',
        active: j['active'] as bool? ?? false,
        minAcceptPrice: (j['minAcceptPrice'] as num?)?.toDouble(),
      );
}
