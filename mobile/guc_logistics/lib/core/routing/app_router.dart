import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/domain/user_role.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/legal/presentation/legal_screens.dart';
import '../../features/loads/presentation/loads_screen.dart';
import '../../features/marketplace/presentation/marketplace_screen.dart';
import '../../features/matching/presentation/match_chat_screen.dart';
import '../../features/matching/presentation/matches_inbox_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/offers/presentation/offer_negotiation_screen.dart';
import '../../features/offers/presentation/offers_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/onboarding/presentation/splash_screen.dart';
import '../../features/ops/presentation/ops_screens.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/carrier/presentation/carrier_workspace_screens.dart';
import '../../features/platform/presentation/platform_screens.dart';
import '../../features/shipper/presentation/shipper_advanced_screens.dart';
import '../../features/shipper/presentation/shipper_workspace_screens.dart';
import '../../features/vehicles/presentation/vehicles_screen.dart';
import '../di/providers.dart';
import '../l10n/app_localizations.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authControllerProvider);
  final settings = ref.watch(appSettingsProvider);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: _RouterRefresh(ref),
    redirect: (context, state) {
      final loc = state.matchedLocation;
      final public = {
        '/splash',
        '/onboarding',
        '/login',
        '/login/shipper',
        '/login/carrier',
        '/register',
        '/register/shipper',
        '/register/carrier',
        '/forgot-password',
        '/legal/privacy',
        '/legal/terms',
        '/legal/kvkk',
        '/about',
        '/pricing',
        '/about-pricing',
        '/help/how-it-works',
        '/help/how-it-works-carrier',
        '/help/trust',
        '/help/support',
      };
      if (auth.loading && loc == '/splash') return null;
      if (loc == '/splash') return null;

      if (!settings.onboardingSeen && loc != '/onboarding') {
        return '/onboarding';
      }
      if (settings.onboardingSeen && loc == '/onboarding') {
        return auth.isAuthenticated ? (settings.role == null ? '/role-select' : '/home') : '/login';
      }

      final loggingIn = loc.startsWith('/login') || loc.startsWith('/register') || loc == '/forgot-password';
      if (!auth.isAuthenticated && !public.contains(loc) && loc != '/onboarding') {
        return '/login';
      }
      if (auth.isAuthenticated && loggingIn) {
        return settings.role == null ? '/role-select' : '/home';
      }
      if (auth.isAuthenticated &&
          settings.role == null &&
          loc != '/role-select' &&
          loc != '/role-select/shipper' &&
          loc != '/role-select/carrier') {
        return '/role-select';
      }
      final role = settings.role;
      if (auth.isAuthenticated && role != null) {
        final shipperOnly = loc == '/loads/create' ||
            loc == '/loads/batch' ||
            loc.startsWith('/shipper/') ||
            loc.startsWith('/admin/');
        final carrierOnly = loc == '/vehicles' ||
            loc.startsWith('/carrier/') ||
            (loc.startsWith('/loads/') && loc.endsWith('/offer'));
        if (shipperOnly && !role.isShipperSide) return '/home';
        if (carrierOnly && !role.isDriverSide) return '/home';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/login/shipper', builder: (_, __) => const SideLoginScreen(audience: AuthAudience.shipper)),
      GoRoute(path: '/login/carrier', builder: (_, __) => const SideLoginScreen(audience: AuthAudience.carrier)),
      GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
      GoRoute(path: '/register/shipper', builder: (_, __) => const SideRegisterScreen(audience: AuthAudience.shipper)),
      GoRoute(path: '/register/carrier', builder: (_, __) => const SideRegisterScreen(audience: AuthAudience.carrier)),
      GoRoute(path: '/forgot-password', builder: (_, __) => const ForgotPasswordScreen()),
      GoRoute(path: '/role-select', builder: (_, __) => const RoleSelectScreen()),
      GoRoute(path: '/role-select/shipper', builder: (_, __) => const RoleSelectScreen(audience: AuthAudience.shipper)),
      GoRoute(path: '/role-select/carrier', builder: (_, __) => const RoleSelectScreen(audience: AuthAudience.carrier)),
      GoRoute(
        path: '/legal/privacy',
        builder: (_, __) => const LegalDocumentScreen(titleKey: 'privacyPolicy', bodyKey: 'privacyBody'),
      ),
      GoRoute(
        path: '/legal/terms',
        builder: (_, __) => const LegalDocumentScreen(titleKey: 'termsOfUse', bodyKey: 'termsBody'),
      ),
      GoRoute(
        path: '/legal/kvkk',
        builder: (_, __) => const LegalDocumentScreen(titleKey: 'kvkkNotice', bodyKey: 'kvkkBody'),
      ),
      GoRoute(path: '/about', builder: (_, __) => const LegalDocumentScreen(titleKey: 'aboutUs', bodyKey: 'aboutBody')),
      GoRoute(path: '/pricing', builder: (_, __) => const LegalDocumentScreen(titleKey: 'pricing', bodyKey: 'pricingBody')),
      GoRoute(path: '/about-pricing', builder: (_, __) => const AboutPricingHubScreen()),
      GoRoute(path: '/help/how-it-works', builder: (_, __) => const HowItWorksScreen(forShipper: true)),
      GoRoute(path: '/help/how-it-works-carrier', builder: (_, __) => const HowItWorksScreen(forShipper: false)),
      GoRoute(path: '/help/trust', builder: (_, __) => const TrustSafetyScreen()),
      GoRoute(path: '/help/support', builder: (_, __) => const SupportFaqScreen()),
      ShellRoute(
        builder: (context, state, child) => RoleShell(child: child),
        routes: [
          GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
          GoRoute(path: '/market', builder: (_, __) => const MarketplaceScreen()),
          GoRoute(path: '/loads', builder: (_, __) => const LoadsScreen()),
          GoRoute(
            path: '/loads/create',
            builder: (_, state) => CreateLoadScreen(templateId: state.uri.queryParameters['template']),
          ),
          GoRoute(path: '/loads/batch', builder: (_, __) => const BatchCreateLoadsScreen()),
          GoRoute(
            path: '/loads/:id',
            builder: (_, state) => LoadDetailScreen(loadId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: '/loads/:id/edit',
            builder: (_, state) => EditLoadScreen(loadId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: '/loads/:id/offer',
            builder: (_, state) => SubmitOfferScreen(loadId: state.pathParameters['id']!),
          ),
          GoRoute(path: '/offers', builder: (_, __) => const OffersScreen()),
          GoRoute(
            path: '/offers/:id',
            builder: (_, state) => OfferNegotiationScreen(offerId: state.pathParameters['id']!),
          ),
          GoRoute(path: '/ops', builder: (_, __) => const OpsHubScreen()),
          GoRoute(path: '/matches', builder: (_, __) => const MatchesInboxScreen()),
          GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
          GoRoute(
            path: '/market/carriers/:id',
            builder: (_, state) => CarrierDetailScreen(carrierId: state.pathParameters['id']!),
          ),
        ],
      ),
      GoRoute(path: '/notifications', builder: (_, __) => const NotificationsScreen()),
      GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
      GoRoute(path: '/settings/language', builder: (_, __) => const LanguageScreen()),
      GoRoute(path: '/settings/theme', builder: (_, __) => const ThemeSelectScreen()),
      GoRoute(path: '/vehicles', builder: (_, __) => const VehiclesScreen()),
      GoRoute(path: '/verification', builder: (_, __) => const VerificationScreen()),
      GoRoute(path: '/profile/details', builder: (_, __) => const ProfileDetailsScreen()),
      GoRoute(path: '/profile/edit', builder: (_, __) => const ProfileEditScreen()),
      GoRoute(path: '/shipper/tools', builder: (_, __) => const ShipperToolsScreen()),
      GoRoute(path: '/shipper/templates', builder: (_, __) => const RouteTemplatesScreen()),
      GoRoute(path: '/shipper/compare-offers', builder: (_, __) => const CompareOffersScreen()),
      GoRoute(path: '/shipper/payments', builder: (_, __) => const EscrowSummaryScreen()),
      GoRoute(path: '/shipper/billing', builder: (_, __) => const BillingInfoScreen()),
      GoRoute(path: '/shipper/favorites', builder: (_, __) => const FavoriteCarriersScreen()),
      GoRoute(path: '/shipper/notifications', builder: (_, __) => const NotificationPrefsScreen()),
      GoRoute(path: '/shipper/contracts', builder: (_, __) => const ContractsScreen()),
      GoRoute(path: '/shipper/ratings', builder: (_, __) => const RatingsScreen()),
      GoRoute(path: '/shipper/api', builder: (_, __) => const ApiErpScreen()),
      GoRoute(path: '/shipper/live-map', builder: (_, __) => const OsmLiveMapScreen()),
      GoRoute(path: '/shipper/claims', builder: (_, __) => const ClaimsScreen()),
      GoRoute(path: '/shipper/ledger', builder: (_, __) => const PaymentLedgerScreen()),
      GoRoute(path: '/shipper/einvoice', builder: (_, __) => const EInvoiceScreen()),
      GoRoute(path: '/shipper/reports', builder: (_, __) => const ReportsScreen()),
      GoRoute(path: '/reports', builder: (_, __) => const ReportsScreen()),
      GoRoute(path: '/shipper/permissions', builder: (_, __) => const DispatcherPermissionsScreen()),
      GoRoute(path: '/shipper/push', builder: (_, __) => const PushSimulationScreen()),
      GoRoute(path: '/carrier/earnings', builder: (_, __) => const CarrierEarningsScreen()),
      GoRoute(path: '/carrier/availability', builder: (_, __) => const CarrierAvailabilityScreen()),
      GoRoute(path: '/admin/moderation', builder: (_, __) => const AdminModerationScreen()),
      GoRoute(path: '/ops/fleet-assign', builder: (_, __) => const FleetAssignScreen()),
      GoRoute(path: '/ops/contract-sign', builder: (_, __) => const ContractSignScreen()),
      GoRoute(path: '/ops/live-gps', builder: (_, __) => const LiveGpsScreen()),
      GoRoute(path: '/ops/tracking', builder: (_, __) => const TrackingListScreen()),
      GoRoute(
        path: '/ops/tracking/:id',
        builder: (_, state) => TrackingDetailScreen(shipmentId: state.pathParameters['id']!),
      ),
      GoRoute(path: '/ops/documents', builder: (_, __) => const DocumentsScreen()),
      GoRoute(path: '/ops/payments', builder: (_, __) => const PaymentsScreen()),
      GoRoute(path: '/ops/fleet', builder: (_, __) => const FleetOpsScreen()),
      GoRoute(path: '/ops/team', builder: (_, __) => const TeamScreen()),
      GoRoute(path: '/ops/subscriptions', builder: (_, __) => const SubscriptionsScreen()),
      GoRoute(path: '/ops/backhaul', builder: (_, __) => const BackhaulScreen()),
      GoRoute(
        path: '/matches/:id',
        builder: (_, state) => MatchChatScreen(matchId: state.pathParameters['id']!),
      ),
    ],
  );
});

class _RouterRefresh extends ChangeNotifier {
  _RouterRefresh(this._ref) {
    _ref.listen(authControllerProvider, (_, __) => notifyListeners());
    _ref.listen(appSettingsProvider, (_, __) => notifyListeners());
  }

  final Ref _ref;
}

class _NavItem {
  const _NavItem({required this.route, required this.icon, required this.selectedIcon, required this.label});
  final String route;
  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

class RoleShell extends ConsumerWidget {
  const RoleShell({super.key, required this.child});

  final Widget child;

  List<_NavItem> _items(AppLocalizations l10n, UserRole role) {
    switch (role) {
      case UserRole.shipper:
        return [
          _NavItem(route: '/home', icon: Icons.home_outlined, selectedIcon: Icons.home, label: l10n.home),
          _NavItem(route: '/market', icon: Icons.public_outlined, selectedIcon: Icons.public, label: l10n.europeMarket),
          _NavItem(route: '/loads', icon: Icons.inventory_2_outlined, selectedIcon: Icons.inventory_2, label: l10n.myLoads),
          _NavItem(route: '/offers', icon: Icons.request_quote_outlined, selectedIcon: Icons.request_quote, label: l10n.offers),
          _NavItem(route: '/profile', icon: Icons.person_outline, selectedIcon: Icons.person, label: l10n.profile),
        ];
      case UserRole.logisticsCompany:
        return [
          _NavItem(route: '/home', icon: Icons.home_outlined, selectedIcon: Icons.home, label: l10n.home),
          _NavItem(route: '/market', icon: Icons.public_outlined, selectedIcon: Icons.public, label: l10n.europeMarket),
          _NavItem(route: '/offers', icon: Icons.request_quote_outlined, selectedIcon: Icons.request_quote, label: l10n.offers),
          _NavItem(route: '/ops', icon: Icons.hub_outlined, selectedIcon: Icons.hub, label: l10n.operations),
          _NavItem(route: '/profile', icon: Icons.person_outline, selectedIcon: Icons.person, label: l10n.profile),
        ];
      case UserRole.independentDriver:
        return [
          _NavItem(route: '/home', icon: Icons.home_outlined, selectedIcon: Icons.home, label: l10n.home),
          _NavItem(route: '/market', icon: Icons.search, selectedIcon: Icons.search, label: l10n.findLoads),
          _NavItem(route: '/offers', icon: Icons.request_quote_outlined, selectedIcon: Icons.request_quote, label: l10n.myOffers),
          _NavItem(route: '/matches', icon: Icons.forum_outlined, selectedIcon: Icons.forum, label: l10n.matches),
          _NavItem(route: '/profile', icon: Icons.person_outline, selectedIcon: Icons.person, label: l10n.profile),
        ];
      case UserRole.fleetOwner:
        return [
          _NavItem(route: '/home', icon: Icons.home_outlined, selectedIcon: Icons.home, label: l10n.home),
          _NavItem(route: '/market', icon: Icons.search, selectedIcon: Icons.search, label: l10n.findLoads),
          _NavItem(route: '/offers', icon: Icons.request_quote_outlined, selectedIcon: Icons.request_quote, label: l10n.myOffers),
          _NavItem(route: '/ops', icon: Icons.hub_outlined, selectedIcon: Icons.hub, label: l10n.operations),
          _NavItem(route: '/profile', icon: Icons.person_outline, selectedIcon: Icons.person, label: l10n.profile),
        ];
    }
  }

  int _index(String location, List<_NavItem> items) {
    final hasLoadsTab = items.any((e) => e.route == '/loads');
    for (var i = 0; i < items.length; i++) {
      final route = items[i].route;
      if (location == route || location.startsWith('$route/')) return i;
      if (!hasLoadsTab && route == '/market' && location.startsWith('/loads')) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final role = ref.watch(appSettingsProvider).role ?? UserRole.shipper;
    final items = _items(l10n, role);
    final location = GoRouterState.of(context).uri.toString();
    final selected = _index(location, items).clamp(0, items.length - 1);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selected,
        onDestinationSelected: (i) => context.go(items[i].route),
        destinations: [
          for (final item in items)
            NavigationDestination(
              icon: Icon(item.icon),
              selectedIcon: Icon(item.selectedIcon),
              label: item.label,
            ),
        ],
      ),
    );
  }
}
