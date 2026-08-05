import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../core/l10n/app_localizations.dart';

final offersProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
  return ref.watch(offersRepositoryProvider).listMine();
});

class OffersScreen extends ConsumerWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final offers = ref.watch(offersProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.offers)),
      body: offers.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('No offers yet'));
          }
          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final offer = items[index];
              return ListTile(
                title: Text('${offer['amount']} ${offer['currency']}'),
                subtitle: Text('Status: ${offer['status']}'),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }
}
