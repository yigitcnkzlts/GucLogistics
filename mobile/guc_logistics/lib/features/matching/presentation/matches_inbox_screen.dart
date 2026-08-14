import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/di/providers.dart';
import '../../../core/domain/models.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/guc_theme.dart';
import '../../../core/utils/contact_actions.dart';
import '../../../core/widgets/guc_widgets.dart';

final matchesInboxProvider = FutureProvider.autoDispose<List<MatchThread>>((ref) {
  return ref.watch(matchesRepositoryProvider).listMine();
});

class MatchesInboxScreen extends ConsumerWidget {
  const MatchesInboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(matchesInboxProvider);
    final fmt = DateFormat.MMMd().add_Hm();
    final isShipper = ref.watch(appSettingsProvider).role?.isShipperSide ?? true;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.matches)),
      body: async.when(
        data: (items) {
          if (items.isEmpty) {
            return GucEmptyState(title: l10n.noMatchesYet, subtitle: l10n.noMatchesHint);
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(matchesInboxProvider),
            child: ListView.separated(
              padding: const EdgeInsets.all(GucSpacing.md),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: GucSpacing.sm),
              itemBuilder: (context, i) {
                final m = items[i];
                final phone = isShipper ? m.carrierPhone : m.shipperPhone;
                return GucCard(
                  onTap: () => context.push('/matches/${m.id}'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(m.loadTitle, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Text('${m.shipperName} · ${m.carrierName}'),
                      if (m.routeLabel != null) Text(m.routeLabel!),
                      if (phone != null) Text(phone, style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        children: [
                          GucBadge(
                            label: '${m.agreedAmount.toStringAsFixed(0)} ${m.currency}',
                            tone: GucBadgeTone.success,
                          ),
                          GucBadge(label: fmt.format(m.createdAt)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => launchPhoneCall(phone),
                              icon: const Icon(Icons.call, size: 18),
                              label: Text(l10n.callNow),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => launchSms(phone, body: m.loadTitle),
                              icon: const Icon(Icons.sms_outlined, size: 18),
                              label: Text(l10n.sendSms),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => GucErrorState(message: l10n.offlineOrError, onRetry: () => ref.invalidate(matchesInboxProvider)),
      ),
    );
  }
}
