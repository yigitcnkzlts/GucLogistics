import '../../../core/config/app_config.dart';
import '../../../core/network/api_client.dart';

class DriversRepository {
  DriversRepository(this._api);

  final ApiClient _api;

  Future<Map<String, dynamic>> getMine() async {
    if (AppConfig.useMockData) {
      return const {
        'id': 'demo-driver',
        'userId': 'demo-user',
        'licenseNumber': 'TR-34-LOGIWAY',
        'licenseCountry': 'TR',
        'yearsExperience': 8,
        'status': 'ACTIVE',
      };
    }
    final response = await _api.dio.get('/api/v1/drivers/me');
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> createProfile({
    required String licenseNumber,
    required String licenseCountry,
    required int yearsExperience,
    String? companyId,
  }) async {
    final response = await _api.dio.post(
      '/api/v1/drivers/profile',
      data: {
        'licenseNumber': licenseNumber,
        'licenseCountry': licenseCountry.toUpperCase(),
        'yearsExperience': yearsExperience,
        if (companyId != null && companyId.isNotEmpty) 'companyId': companyId,
      },
    );
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> updateMine({
    String? licenseNumber,
    String? licenseCountry,
    int? yearsExperience,
    String? companyId,
  }) async {
    final response = await _api.dio.patch(
      '/api/v1/drivers/me',
      data: {
        if (licenseNumber != null) 'licenseNumber': licenseNumber,
        if (licenseCountry != null) 'licenseCountry': licenseCountry.toUpperCase(),
        if (yearsExperience != null) 'yearsExperience': yearsExperience,
        if (companyId != null) 'companyId': companyId,
      },
    );
    return Map<String, dynamic>.from(response.data as Map);
  }
}
