import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/providers.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/guc_theme.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 900), _navigate);
  }

  void _navigate() {
    if (!mounted) return;
    final auth = ref.read(authControllerProvider);
    final settings = ref.read(appSettingsProvider);
    if (auth.loading) {
      Future<void>.delayed(const Duration(milliseconds: 200), _navigate);
      return;
    }
    if (!settings.onboardingSeen) {
      context.go('/onboarding');
    } else if (!auth.isAuthenticated) {
      context.go('/login');
    } else if (settings.role == null) {
      context.go('/role-select');
    } else {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [GucColors.forest, scheme.surface],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.local_shipping, size: 64, color: Colors.white.withValues(alpha: 0.95)),
              const SizedBox(height: GucSpacing.md),
              Text(
                l10n.appTitle,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: GucSpacing.xs),
              Text(l10n.tagline, style: TextStyle(color: Colors.white.withValues(alpha: 0.85))),
              const SizedBox(height: GucSpacing.xl),
              const CircularProgressIndicator(color: Colors.white),
              const SizedBox(height: GucSpacing.sm),
              Text(l10n.splashLoading, style: TextStyle(color: Colors.white.withValues(alpha: 0.8))),
            ],
          ),
        ),
      ),
    );
  }
}
