import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/auth_repository.dart';
import '../domain/user_role.dart';

class AuthState {
  const AuthState({
    this.isAuthenticated = false,
    this.loading = true,
    this.email,
    this.roles = const [],
    this.mfaToken,
    this.error,
  });

  final bool isAuthenticated;
  final bool loading;
  final String? email;
  final List<String> roles;
  final String? mfaToken;
  final String? error;

  AuthState copyWith({
    bool? isAuthenticated,
    bool? loading,
    String? email,
    List<String>? roles,
    String? mfaToken,
    String? error,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      loading: loading ?? this.loading,
      email: email ?? this.email,
      roles: roles ?? this.roles,
      mfaToken: mfaToken ?? this.mfaToken,
      error: error,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._repository) : super(const AuthState());

  final AuthRepository _repository;

  Future<void> bootstrap() async {
    final session = await _repository.currentSession();
    if (session == null) {
      state = const AuthState(loading: false);
      return;
    }
    state = AuthState(
      loading: false,
      isAuthenticated: true,
      email: session['email'] as String?,
      roles: (session['roles'] as List?)?.map((e) => e.toString()).toList() ?? const [],
    );
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final result = await _repository.login(email: email, password: password);
      if (result['mfaRequired'] == true) {
        state = AuthState(loading: false, email: email, mfaToken: result['accessToken'] as String?);
        return false;
      }
      state = AuthState(
        loading: false,
        isAuthenticated: true,
        email: email,
        roles: (result['roles'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      );
      return true;
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString(), isAuthenticated: false);
      return false;
    }
  }

  Future<bool> verifyMfa(String code) async {
    final token = state.mfaToken;
    if (token == null) return false;
    state = state.copyWith(loading: true, error: null);
    try {
      final result = await _repository.verifyMfa(mfaToken: token, code: code);
      state = AuthState(loading: false, isAuthenticated: true, email: state.email, roles: (result['roles'] as List?)?.map((e) => e.toString()).toList() ?? const []);
      return true;
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> register(
    String email,
    String password,
    UserRole role, {
    String? phone,
    String? companyName,
    String? vatNumber,
    String? country,
  }) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final result = await _repository.register(
        email: email,
        password: password,
        role: role,
        phone: phone,
        companyName: companyName,
        vatNumber: vatNumber,
        country: country,
      );
      await _repository.persistRoleApi(role);
      state = AuthState(
        loading: false,
        isAuthenticated: true,
        email: email,
        roles: (result['roles'] as List?)?.map((e) => e.toString()).toList() ?? [role.apiValue],
      );
      return true;
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString(), isAuthenticated: false);
      return false;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AuthState(loading: false);
  }
}
