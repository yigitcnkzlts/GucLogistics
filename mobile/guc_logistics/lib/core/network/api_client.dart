import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  ApiClient({
    required FlutterSecureStorage storage,
    String baseUrl = const String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://10.0.2.2:8080',
    ),
  }) : _storage = storage {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    ));
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'access_token');
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401 &&
            !error.requestOptions.path.contains('/auth/refresh') &&
            !error.requestOptions.path.contains('/auth/login')) {
          final refreshed = await _tryRefresh();
          if (refreshed) {
            final token = await _storage.read(key: 'access_token');
            final req = error.requestOptions;
            req.headers['Authorization'] = 'Bearer $token';
            final response = await _dio.fetch(req);
            return handler.resolve(response);
          }
        }
        handler.next(error);
      },
    ));
  }

  late final Dio _dio;
  final FlutterSecureStorage _storage;

  Dio get dio => _dio;

  Future<bool> _tryRefresh() async {
    final refresh = await _storage.read(key: 'refresh_token');
    if (refresh == null || refresh.isEmpty) {
      return false;
    }
    try {
      final response = await _dio.post('/api/v1/auth/refresh', data: {'refreshToken': refresh});
      await _storage.write(key: 'access_token', value: response.data['accessToken'] as String);
      await _storage.write(key: 'refresh_token', value: response.data['refreshToken'] as String);
      return true;
    } catch (_) {
      await _storage.deleteAll();
      return false;
    }
  }
}
