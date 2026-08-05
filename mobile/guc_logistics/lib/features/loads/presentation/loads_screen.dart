import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/providers.dart';
import '../../../core/l10n/app_localizations.dart';

final loadsProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
  return ref.watch(loadsRepositoryProvider).listLoads();
});

class LoadsScreen extends ConsumerWidget {
  const LoadsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final loads = ref.watch(loadsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.loads)),
      body: loads.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('No loads yet'));
          }
          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final load = items[index];
              return ListTile(
                title: Text(load['title']?.toString() ?? 'Load'),
                subtitle: Text(
                  '${load['pickupCountry'] ?? ''} → ${load['dropoffCountry'] ?? ''} · ${load['status'] ?? ''}',
                ),
                onTap: () => context.go('/loads/${load['id']}'),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (ref.read(loadsRepositoryProvider).hasCachedLoads)
                  Text(l10n.offlineBanner),
                Text(e.toString()),
                TextButton(onPressed: () => ref.refresh(loadsProvider), child: const Text('Retry')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
