import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/auth_repository.dart';

class AuthState {
  const AuthState({
    this.isAuthenticated = false,
    this.loading = true,
    this.email,
    this.roles = const [],
    this.error,
  });

  final bool isAuthenticated;
  final bool loading;
  final String? email;
  final List<String> roles;
  final String? error;

  AuthState copyWith({
    bool? isAuthenticated,
    bool? loading,
    String? email,
    List<String>? roles,
    String? error,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      loading: loading ?? this.loading,
      email: email ?? this.email,
      roles: roles ?? this.roles,
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

  Future<void> login(String email, String password) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final result = await _repository.login(email: email, password: password);
      state = AuthState(
        loading: false,
        isAuthenticated: true,
        email: email,
        roles: (result['roles'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString(), isAuthenticated: false);
    }
  }

  Future<void> register(String email, String password, String role) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final result = await _repository.register(email: email, password: password, role: role);
      state = AuthState(
        loading: false,
        isAuthenticated: true,
        email: email,
        roles: (result['roles'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString(), isAuthenticated: false);
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AuthState(loading: false);
  }
}
