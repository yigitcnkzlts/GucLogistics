import '../../../core/config/app_config.dart';
import '../../../core/data/mock/mock_data.dart';
import '../../../core/network/api_client.dart';

class CompanyRepository {
  CompanyRepository(this._api);

  final ApiClient _api;

  Future<List<Map<String, dynamic>>> listMine() async {
    if (AppConfig.useMockData) {
      return [
        {
          'id': 'demo-company',
          'type': 'SHIPPER',
          'legalName': MockData.companyName,
          'tradeName': MockData.companyName,
          'country': 'TR',
          'status': MockData.companyVerified ? 'VERIFIED' : 'PENDING',
        },
      ];
    }
    final response = await _api.dio.get('/api/v1/companies/mine');
    final data = response.data;
    final list = data is List ? data : const [];
    return list.map((item) => Map<String, dynamic>.from(item as Map)).toList();
  }

  Future<Map<String, dynamic>> dashboard(String companyId, {int months = 12}) async {
    if (AppConfig.useMockData) {
      return {'source': 'demo', 'company': {'id': companyId, 'legalName': MockData.companyName}};
    }
    final response = await _api.dio.get('/api/v1/companies/$companyId/dashboard', queryParameters: {'months': months});
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> current() async {
    final companies = await listMine();
    if (companies.isEmpty) throw StateError('No company membership found.');
    return companies.first;
  }
}
