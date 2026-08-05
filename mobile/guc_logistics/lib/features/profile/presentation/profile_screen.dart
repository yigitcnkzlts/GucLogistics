import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../core/l10n/app_localizations.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final auth = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profile)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(auth.email ?? '-', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('${l10n.role}: ${auth.roles.join(', ')}'),
            const Spacer(),
            FilledButton.tonal(
              onPressed: () => ref.read(authControllerProvider.notifier).logout(),
              child: Text(l10n.logout),
            ),
          ],
        ),
      ),
    );
  }
}
