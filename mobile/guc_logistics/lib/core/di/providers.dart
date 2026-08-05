import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/presentation/auth_controller.dart';
import '../../features/loads/data/loads_repository.dart';
import '../../features/offers/data/offers_repository.dart';
import '../network/api_client.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(storage: ref.watch(secureStorageProvider));
});

final loadsCacheBoxProvider = Provider<Box<String>>((ref) {
  return Hive.box<String>('loads_cache');
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(apiClientProvider), ref.watch(secureStorageProvider));
});

final loadsRepositoryProvider = Provider<LoadsRepository>((ref) {
  return LoadsRepository(ref.watch(apiClientProvider), ref.watch(loadsCacheBoxProvider));
});

final offersRepositoryProvider = Provider<OffersRepository>((ref) {
  return OffersRepository(ref.watch(apiClientProvider));
});

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref.watch(authRepositoryProvider))..bootstrap();
});
