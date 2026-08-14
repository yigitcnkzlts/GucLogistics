import '../../../core/config/app_config.dart';
import '../../../core/data/mock/mock_data.dart';
import '../../../core/domain/models.dart';
import '../../../core/network/api_client.dart';

class VehiclesRepository {
  VehiclesRepository(this._api);
  final ApiClient _api;

  Future<List<VehicleItem>> listMine() async {
    if (AppConfig.useMockData) {
      await Future<void>.delayed(const Duration(milliseconds: 200));
      return List.of(MockData.vehicles);
    }
    final response = await _api.dio.get('/api/v1/vehicles/mine');
    final list = response.data is List ? response.data as List : const [];
    return list.map((e) => VehicleItem.fromJson(Map<String, dynamic>.from(e as Map))).toList();
  }

  Future<void> upsert({
    String? id,
    required String plate,
    required String type,
    required double capacityKg,
    String status = 'ACTIVE',
  }) async {
    if (AppConfig.useMockData) {
      await Future<void>.delayed(const Duration(milliseconds: 220));
      if (id == null) {
        MockData.vehicles.insert(
          0,
          VehicleItem(
            id: 'veh-${DateTime.now().millisecondsSinceEpoch}',
            plate: plate,
            type: type,
            capacityKg: capacityKg,
            status: status,
          ),
        );
        return;
      }
      final i = MockData.vehicles.indexWhere((v) => v.id == id);
      if (i >= 0) {
        MockData.vehicles[i] = VehicleItem(
          id: id,
          plate: plate,
          type: type,
          capacityKg: capacityKg,
          status: status,
        );
      }
      return;
    }
    if (id == null) {
      await _api.dio.post('/api/v1/vehicles', data: {
        'plate': plate,
        'type': type,
        'capacityKg': capacityKg,
        'status': status,
      });
    } else {
      await _api.dio.put('/api/v1/vehicles/$id', data: {
        'plate': plate,
        'type': type,
        'capacityKg': capacityKg,
        'status': status,
      });
    }
  }

  Future<void> delete(String id) async {
    if (AppConfig.useMockData) {
      MockData.vehicles.removeWhere((v) => v.id == id);
      return;
    }
    await _api.dio.delete('/api/v1/vehicles/$id');
  }
}
