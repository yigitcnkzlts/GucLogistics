import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/auth_controller.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/loads/presentation/load_detail_screen.dart';
import '../../features/loads/presentation/loads_screen.dart';
import '../../features/offers/presentation/offers_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../di/providers.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: '/loads',
    redirect: (context, state) {
      final loggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/register';
      if (!auth.isAuthenticated && !loggingIn) {
        return '/login';
      }
      if (auth.isAuthenticated && loggingIn) {
        return '/loads';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
      ShellRoute(
        builder: (context, state, child) => HomeShell(child: child),
        routes: [
          GoRoute(path: '/loads', builder: (_, __) => const LoadsScreen()),
          GoRoute(
            path: '/loads/:id',
            builder: (_, state) => LoadDetailScreen(loadId: state.pathParameters['id']!),
          ),
          GoRoute(path: '/offers', builder: (_, __) => const OffersScreen()),
          GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
        ],
      ),
    ],
  );
});

class HomeShell extends StatelessWidget {
  const HomeShell({super.key, required this.child});

  final Widget child;

  int _index(String location) {
    if (location.startsWith('/offers')) return 1;
    if (location.startsWith('/profile')) return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index(location),
        onDestinationSelected: (i) {
          switch (i) {
            case 0:
              context.go('/loads');
            case 1:
              context.go('/offers');
            case 2:
              context.go('/profile');
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.local_shipping_outlined),
            selectedIcon: Icon(Icons.local_shipping),
            label: 'Loads',
          ),
          NavigationDestination(
            icon: Icon(Icons.request_quote_outlined),
            selectedIcon: Icon(Icons.request_quote),
            label: 'Offers',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
