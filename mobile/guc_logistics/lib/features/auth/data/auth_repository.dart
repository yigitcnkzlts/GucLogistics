import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/config/app_config.dart';
import '../../../core/data/mock/mock_data.dart';
import '../../../core/network/api_client.dart';
import '../domain/user_role.dart';

class AuthRepository {
  AuthRepository(this._api, this._storage);

  final ApiClient _api;
  final FlutterSecureStorage _storage;

  Future<bool> hasSession() async {
    final token = await _storage.read(key: 'access_token');
    return token != null && token.isNotEmpty;
  }

  Future<Map<String, dynamic>?> currentSession() async {
    if (!await hasSession()) return null;
    if (AppConfig.useMockData) {
      return {
        'email': await _storage.read(key: 'email') ?? 'demo@guclogistics.com',
        'roles': [await _storage.read(key: 'role_api') ?? 'SHIPPER'],
        'companyName': MockData.companyName,
        'companyVerified': MockData.companyVerified,
        'companyVat': MockData.companyVat,
        'companyHq': MockData.companyHq,
        'driverDisplayName': MockData.driverDisplayName,
        'driverVerified': MockData.driverVerified,
        'driverLicense': MockData.driverLicense,
        'driverExperience': MockData.driverExperience,
        'driverBase': MockData.driverBase,
        'verificationUploads': Map<String, String>.from(MockData.verificationUploads),
      };
    }
    try {
      final response = await _api.dio.get('/api/v1/me');
      return Map<String, dynamic>.from(response.data as Map);
    } on DioException {
      return null;
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    if (AppConfig.useMockData) {
      await Future<void>.delayed(const Duration(milliseconds: 400));
      final normalized = email.trim().toLowerCase();
      final isShipperDemo = normalized == 'shipper@guclogistics.com' && password == 'GucShipper2026!';
      final isDriverDemo = normalized == 'driver@guclogistics.com' && password == 'GucDriver2026!';
      if (!isShipperDemo && !isDriverDemo) {
        throw StateError('Demo hesabı bilgileri hatalı.');
      }
      final role = isShipperDemo ? 'SHIPPER' : 'INDEPENDENT_DRIVER';
      await _storage.write(key: 'access_token', value: 'mock-access');
      await _storage.write(key: 'refresh_token', value: 'mock-refresh');
      await _storage.write(key: 'email', value: email);
      await _storage.write(key: 'role_api', value: role);
      return {
        'accessToken': 'mock-access',
        'refreshToken': 'mock-refresh',
        'email': email,
        'roles': [role],
        'mfaRequired': false,
      };
    }
    final response = await _api.dio.post('/api/v1/auth/login', data: {
      'email': email,
      'password': password,
      'deviceFingerprint': 'flutter-android',
      'platform': 'ANDROID',
      'deviceName': 'GucLogistics App',
    });
    await _persistTokens(response.data as Map);
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required UserRole role,
    String? phone,
    String? companyName,
    String? vatNumber,
    String? country,
  }) async {
    if (AppConfig.useMockData) {
      await Future<void>.delayed(const Duration(milliseconds: 400));
      await _storage.write(key: 'access_token', value: 'mock-access');
      await _storage.write(key: 'refresh_token', value: 'mock-refresh');
      await _storage.write(key: 'email', value: email);
      await _storage.write(key: 'role_api', value: role.apiValue);
      if (companyName != null && companyName.isNotEmpty) MockData.companyName = companyName;
      if (vatNumber != null && vatNumber.isNotEmpty) MockData.companyVat = vatNumber;
      if (phone != null && phone.isNotEmpty) MockData.shipperPhone = phone;
      return {
        'accessToken': 'mock-access',
        'roles': [role.apiValue],
        'mfaRequired': false,
      };
    }
    final response = await _api.dio.post('/api/v1/auth/register', data: {
      'email': email,
      'password': password,
      'phone': phone,
      'role': role.apiValue,
      'deviceFingerprint': 'flutter-android',
      'platform': 'ANDROID',
      'deviceName': 'GucLogistics App',
      'locale': 'en',
      'timezone': 'UTC',
    });
    await _persistTokens(response.data as Map);
    if (role.isShipperSide && companyName != null && companyName.isNotEmpty) {
      await _api.dio.post('/api/v1/companies', data: {
        'type': role == UserRole.shipper ? 'SHIPPER' : 'LOGISTICS',
        'legalName': companyName,
        'tradeName': companyName,
        'vatNumber': vatNumber,
        'country': (country == null || country.length != 2) ? 'TR' : country.toUpperCase(),
      });
    }
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<void> forgotPassword(String email) async {
    if (AppConfig.useMockData) {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      return;
    }
    // Endpoint may not exist yet — fail soft
    try {
      await _api.dio.post('/api/v1/auth/forgot-password', data: {'email': email});
    } catch (_) {}
  }

  Future<void> logout() async {
    if (!AppConfig.useMockData) {
      try {
        final refresh = await _storage.read(key: 'refresh_token');
        await _api.dio.post('/api/v1/auth/logout', data: {'refreshToken': refresh});
      } catch (_) {}
    }
    await _storage.deleteAll();
  }

  Future<void> persistRoleApi(UserRole role) => _storage.write(key: 'role_api', value: role.apiValue);

  Future<void> _persistTokens(Map data) async {
    if (data['mfaRequired'] == true) {
      throw StateError('MFA required');
    }
    await _storage.write(key: 'access_token', value: data['accessToken'] as String);
    await _storage.write(key: 'refresh_token', value: data['refreshToken'] as String);
  }
}
