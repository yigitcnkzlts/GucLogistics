import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/domain/user_role.dart';
import '../../features/auth/presentation/auth_controller.dart';
import '../../features/loads/data/loads_repository.dart';
import '../../features/marketplace/data/marketplace_repository.dart';
import '../../features/matching/data/matches_repository.dart';
import '../../features/notifications/data/notifications_repository.dart';
import '../../features/offers/data/offers_repository.dart';
import '../../features/ops/data/ops_repository.dart';
import '../../features/vehicles/data/vehicles_repository.dart';
import '../network/api_client.dart';
import '../storage/prefs_service.dart';

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

final vehiclesRepositoryProvider = Provider<VehiclesRepository>((ref) {
  return VehiclesRepository(ref.watch(apiClientProvider));
});

final notificationsRepositoryProvider = Provider<NotificationsRepository>((ref) {
  return NotificationsRepository(ref.watch(apiClientProvider));
});

final offlineCacheBoxProvider = Provider<Box<String>>((ref) {
  return Hive.box<String>('offline_cache');
});

final matchesRepositoryProvider = Provider<MatchesRepository>((ref) {
  return MatchesRepository(ref.watch(apiClientProvider), ref.watch(offlineCacheBoxProvider));
});

final marketplaceRepositoryProvider = Provider<MarketplaceRepository>((ref) {
  return MarketplaceRepository(ref.watch(apiClientProvider));
});

final opsRepositoryProvider = Provider<OpsRepository>((ref) {
  return OpsRepository(ref.watch(apiClientProvider));
});

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref.watch(authRepositoryProvider))..bootstrap();
});

final sessionProfileProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final session = await ref.watch(authRepositoryProvider).currentSession();
  return session ?? const {};
});

class AppSettingsState {
  const AppSettingsState({
    required this.themeMode,
    required this.locale,
    this.role,
    this.onboardingSeen = false,
    this.favoriteCorridors = const [],
    this.favoriteCarriers = const [],
    this.pushEnabled = true,
    this.notifyNewOffers = true,
    this.notifyCounters = true,
    this.notifyMatches = true,
  });

  final ThemeMode themeMode;
  final Locale locale;
  final UserRole? role;
  final bool onboardingSeen;
  final List<String> favoriteCorridors;
  final List<String> favoriteCarriers;
  final bool pushEnabled;
  final bool notifyNewOffers;
  final bool notifyCounters;
  final bool notifyMatches;

  AppSettingsState copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    UserRole? role,
    bool? onboardingSeen,
    List<String>? favoriteCorridors,
    List<String>? favoriteCarriers,
    bool? pushEnabled,
    bool? notifyNewOffers,
    bool? notifyCounters,
    bool? notifyMatches,
    bool clearRole = false,
  }) {
    return AppSettingsState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      role: clearRole ? null : (role ?? this.role),
      onboardingSeen: onboardingSeen ?? this.onboardingSeen,
      favoriteCorridors: favoriteCorridors ?? this.favoriteCorridors,
      favoriteCarriers: favoriteCarriers ?? this.favoriteCarriers,
      pushEnabled: pushEnabled ?? this.pushEnabled,
      notifyNewOffers: notifyNewOffers ?? this.notifyNewOffers,
      notifyCounters: notifyCounters ?? this.notifyCounters,
      notifyMatches: notifyMatches ?? this.notifyMatches,
    );
  }
}

class AppSettingsController extends StateNotifier<AppSettingsState> {
  AppSettingsController(this._prefs)
      : super(AppSettingsState(
          themeMode: _prefs.themeMode,
          locale: _prefs.locale,
          role: _prefs.role,
          onboardingSeen: _prefs.onboardingSeen,
          favoriteCorridors: _prefs.favoriteCorridors,
          favoriteCarriers: _prefs.favoriteCarriers,
          pushEnabled: _prefs.pushEnabled,
          notifyNewOffers: _prefs.notifyNewOffers,
          notifyCounters: _prefs.notifyCounters,
          notifyMatches: _prefs.notifyMatches,
        ));

  final PrefsService _prefs;

  Future<void> setThemeMode(ThemeMode mode) async {
    await _prefs.setThemeMode(mode);
    state = state.copyWith(themeMode: mode);
  }

  Future<void> setLocale(Locale locale) async {
    await _prefs.setLocale(locale);
    state = state.copyWith(locale: locale);
  }

  Future<void> completeOnboarding() async {
    await _prefs.setOnboardingSeen(true);
    state = state.copyWith(onboardingSeen: true);
  }

  Future<void> setRole(UserRole role) async {
    await _prefs.setRole(role);
    state = state.copyWith(role: role);
  }

  Future<void> clearRole() async {
    await _prefs.clearSessionLocal();
    state = state.copyWith(clearRole: true);
  }

  Future<void> toggleFavoriteCorridor(String id) async {
    await _prefs.toggleFavoriteCorridor(id);
    state = state.copyWith(favoriteCorridors: _prefs.favoriteCorridors);
  }

  Future<void> toggleFavoriteCarrier(String id) async {
    await _prefs.toggleFavoriteCarrier(id);
    state = state.copyWith(favoriteCarriers: _prefs.favoriteCarriers);
  }

  Future<void> setPushEnabled(bool enabled) async {
    await _prefs.setPushEnabled(enabled);
    state = state.copyWith(pushEnabled: enabled);
  }

  Future<void> setNotifyNewOffers(bool enabled) async {
    await _prefs.setNotifyNewOffers(enabled);
    state = state.copyWith(notifyNewOffers: enabled);
  }

  Future<void> setNotifyCounters(bool enabled) async {
    await _prefs.setNotifyCounters(enabled);
    state = state.copyWith(notifyCounters: enabled);
  }

  Future<void> setNotifyMatches(bool enabled) async {
    await _prefs.setNotifyMatches(enabled);
    state = state.copyWith(notifyMatches: enabled);
  }
}

final appSettingsProvider =
    StateNotifierProvider<AppSettingsController, AppSettingsState>((ref) {
  return AppSettingsController(ref.watch(prefsServiceProvider));
});
