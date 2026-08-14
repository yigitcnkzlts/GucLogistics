import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/domain/user_role.dart';

final prefsServiceProvider = Provider<PrefsService>((ref) {
  throw UnimplementedError('PrefsService must be overridden in main()');
});

class PrefsService {
  PrefsService(this._prefs);

  final SharedPreferences _prefs;

  static Future<PrefsService> create() async {
    return PrefsService(await SharedPreferences.getInstance());
  }

  static const _onboarding = 'onboarding_seen';
  static const _theme = 'theme_mode';
  static const _locale = 'locale';
  static const _role = 'user_role';
  static const _favoriteCorridors = 'favorite_corridors';
  static const _favoriteCarriers = 'favorite_carriers';
  static const _pushEnabled = 'push_enabled';
  static const _notifyOffers = 'notify_offers';
  static const _notifyCounters = 'notify_counters';
  static const _notifyMatches = 'notify_matches';

  bool get onboardingSeen => _prefs.getBool(_onboarding) ?? false;

  bool get pushEnabled => _prefs.getBool(_pushEnabled) ?? true;
  bool get notifyNewOffers => _prefs.getBool(_notifyOffers) ?? true;
  bool get notifyCounters => _prefs.getBool(_notifyCounters) ?? true;
  bool get notifyMatches => _prefs.getBool(_notifyMatches) ?? true;

  Future<void> setPushEnabled(bool value) => _prefs.setBool(_pushEnabled, value);
  Future<void> setNotifyNewOffers(bool value) => _prefs.setBool(_notifyOffers, value);
  Future<void> setNotifyCounters(bool value) => _prefs.setBool(_notifyCounters, value);
  Future<void> setNotifyMatches(bool value) => _prefs.setBool(_notifyMatches, value);

  Future<void> setOnboardingSeen(bool value) => _prefs.setBool(_onboarding, value);

  ThemeMode get themeMode {
    switch (_prefs.getString(_theme)) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) {
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    return _prefs.setString(_theme, value);
  }

  Locale get locale {
    final code = _prefs.getString(_locale) ?? 'en';
    return Locale(code);
  }

  Future<void> setLocale(Locale locale) => _prefs.setString(_locale, locale.languageCode);

  UserRole? get role {
    final raw = _prefs.getString(_role);
    if (raw == null) return null;
    for (final value in UserRole.values) {
      if (value.name == raw) return value;
    }
    return null;
  }

  Future<void> setRole(UserRole role) => _prefs.setString(_role, role.name);

  Future<void> clearSessionLocal() async {
    await _prefs.remove(_role);
  }

  List<String> get favoriteCorridors => _prefs.getStringList(_favoriteCorridors) ?? const [];

  Future<void> setFavoriteCorridors(List<String> ids) => _prefs.setStringList(_favoriteCorridors, ids);

  Future<void> toggleFavoriteCorridor(String id) async {
    final current = [...favoriteCorridors];
    if (current.contains(id)) {
      current.remove(id);
    } else {
      current.add(id);
    }
    await setFavoriteCorridors(current);
  }

  List<String> get favoriteCarriers => _prefs.getStringList(_favoriteCarriers) ?? const ['car-1', 'car-3'];

  Future<void> setFavoriteCarriers(List<String> ids) => _prefs.setStringList(_favoriteCarriers, ids);

  Future<void> toggleFavoriteCarrier(String id) async {
    final current = [...favoriteCarriers];
    if (current.contains(id)) {
      current.remove(id);
    } else {
      current.add(id);
    }
    await setFavoriteCarriers(current);
  }
}
