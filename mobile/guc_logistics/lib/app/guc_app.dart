import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/di/providers.dart';
import '../core/l10n/app_localizations.dart';
import '../core/routing/app_router.dart';
import '../core/theme/guc_theme.dart';

class GucApp extends ConsumerWidget {
  const GucApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final settings = ref.watch(appSettingsProvider);

    return MaterialApp.router(
      title: 'GucLogistics',
      theme: GucTheme.light,
      darkTheme: GucTheme.dark,
      themeMode: settings.themeMode,
      locale: settings.locale,
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
