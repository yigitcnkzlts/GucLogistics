import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/di/providers.dart';
import '../../../core/domain/models.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/widgets/guc_widgets.dart';

final notificationsProvider = FutureProvider.autoDispose<List<NotificationItem>>((ref) {
  return ref.watch(notificationsRepositoryProvider).list();
});

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(notificationsProvider);
    final fmt = DateFormat.MMMd().add_Hm();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.notifications)),
      body: async.when(
        data: (items) {
          if (items.isEmpty) return GucEmptyState(title: l10n.noData);
          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final n = items[i];
              return ListTile(
                leading: Icon(n.read ? Icons.notifications_none : Icons.notifications_active_outlined),
                title: Text(n.title, style: TextStyle(fontWeight: n.read ? FontWeight.w500 : FontWeight.w700)),
                subtitle: Text('${n.body}\n${fmt.format(n.createdAt)}'),
                isThreeLine: true,
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => GucErrorState(message: l10n.offlineOrError, onRetry: () => ref.invalidate(notificationsProvider)),
      ),
    );
  }
}
