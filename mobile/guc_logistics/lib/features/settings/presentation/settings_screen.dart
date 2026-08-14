import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/providers.dart';
import '../../../core/l10n/app_localizations.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(appSettingsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        children: [
          SwitchListTile(
            secondary: const Icon(Icons.notifications_active_outlined),
            title: Text(l10n.pushNotifications),
            subtitle: Text(l10n.pushNotificationsHint),
            value: settings.pushEnabled,
            onChanged: (v) => ref.read(appSettingsProvider.notifier).setPushEnabled(v),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.language),
            subtitle: Text(settings.locale.languageCode.toUpperCase()),
            onTap: () => context.push('/settings/language'),
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode_outlined),
            title: Text(l10n.theme),
            subtitle: Text(switch (settings.themeMode) {
              ThemeMode.light => l10n.themeLight,
              ThemeMode.dark => l10n.themeDark,
              ThemeMode.system => l10n.themeSystem,
            }),
            onTap: () => context.push('/settings/theme'),
          ),
          ListTile(
            leading: const Icon(Icons.swap_horiz),
            title: Text(l10n.roleTitle),
            onTap: () => context.push('/role-select'),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.aboutAndPricing),
            onTap: () => context.push('/about-pricing'),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(l10n.privacyPolicy),
            onTap: () => context.push('/legal/privacy'),
          ),
          ListTile(
            leading: const Icon(Icons.gavel_outlined),
            title: Text(l10n.termsOfUse),
            onTap: () => context.push('/legal/terms'),
          ),
          ListTile(
            leading: const Icon(Icons.policy_outlined),
            title: Text(l10n.kvkkNotice),
            onTap: () => context.push('/legal/kvkk'),
          ),
        ],
      ),
    );
  }
}

class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final current = ref.watch(appSettingsProvider).locale;

    Widget tile(String title, Locale locale) {
      final selected = current.languageCode == locale.languageCode;
      return ListTile(
        title: Text(title),
        trailing: selected ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary) : null,
        onTap: () => ref.read(appSettingsProvider.notifier).setLocale(locale),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.language)),
      body: Column(
        children: [
          tile('English', const Locale('en')),
          tile('Türkçe', const Locale('tr')),
          tile('Deutsch', const Locale('de')),
          tile('Polski', const Locale('pl')),
          tile('Français', const Locale('fr')),
        ],
      ),
    );
  }
}

class ThemeSelectScreen extends ConsumerWidget {
  const ThemeSelectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final current = ref.watch(appSettingsProvider).themeMode;

    Widget tile(String title, ThemeMode mode) {
      return ListTile(
        title: Text(title),
        trailing: current == mode ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary) : null,
        onTap: () => ref.read(appSettingsProvider.notifier).setThemeMode(mode),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.theme)),
      body: Column(
        children: [
          tile(l10n.themeSystem, ThemeMode.system),
          tile(l10n.themeLight, ThemeMode.light),
          tile(l10n.themeDark, ThemeMode.dark),
        ],
      ),
    );
  }
}
