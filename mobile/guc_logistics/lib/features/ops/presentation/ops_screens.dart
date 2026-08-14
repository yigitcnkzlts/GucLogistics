import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/di/providers.dart';
import '../../../core/domain/ops_models.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/services/platform_services.dart';
import '../../../core/theme/guc_theme.dart';
import '../../../core/widgets/guc_widgets.dart';
import '../../auth/domain/user_role.dart';

final docsProvider = FutureProvider.autoDispose<List<DocItem>>((ref) {
  return ref.watch(opsRepositoryProvider).documents();
});

final shipmentsProvider = FutureProvider.autoDispose<List<ShipmentTrack>>((ref) {
  return ref.watch(opsRepositoryProvider).shipments();
});

final fleetOpsProvider = FutureProvider.autoDispose<List<FleetVehicle>>((ref) {
  return ref.watch(opsRepositoryProvider).fleet();
});

final teamProvider = FutureProvider.autoDispose<List<TeamMember>>((ref) {
  return ref.watch(opsRepositoryProvider).team();
});

final subscriptionsProvider = FutureProvider.autoDispose<List<CorridorSubscription>>((ref) {
  return ref.watch(opsRepositoryProvider).subscriptions();
});

final backhaulsProvider = FutureProvider.autoDispose<List<BackhaulSuggestion>>((ref) {
  return ref.watch(opsRepositoryProvider).backhauls();
});

class OpsHubScreen extends ConsumerWidget {
  const OpsHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final role = ref.watch(appSettingsProvider).role;
    final isShipper = role?.isShipperSide ?? true;

    final tiles = <_OpsTile>[
      _OpsTile(Icons.route_outlined, l10n.shipmentTracking, l10n.shipmentTrackingHint, '/ops/tracking'),
      _OpsTile(Icons.folder_outlined, l10n.documents, l10n.documentsHint, '/ops/documents'),
      _OpsTile(Icons.payments_outlined, l10n.agreementsPayments, l10n.agreementsPaymentsHint, '/ops/payments'),
      if (!isShipper || role == UserRole.fleetOwner || role == UserRole.logisticsCompany)
        _OpsTile(Icons.garage_outlined, l10n.fleetPanel, l10n.fleetPanelHint, '/ops/fleet'),
      if (isShipper || role == UserRole.logisticsCompany || role == UserRole.fleetOwner)
        _OpsTile(Icons.groups_outlined, l10n.team, l10n.teamHint, '/ops/team'),
      _OpsTile(Icons.notifications_active_outlined, l10n.corridorAlerts, l10n.corridorAlertsHint, '/ops/subscriptions'),
      if (!isShipper) _OpsTile(Icons.u_turn_left, l10n.backhaul, l10n.backhaulHint, '/ops/backhaul'),
      if (!isShipper || role == UserRole.fleetOwner)
        _OpsTile(Icons.person_add_alt_1_outlined, l10n.fleetAssign, l10n.fleetAssignHint, '/ops/fleet-assign'),
      _OpsTile(Icons.draw_outlined, l10n.eSignature, l10n.eSignatureHint, '/ops/contract-sign'),
      _OpsTile(Icons.gps_fixed, l10n.liveGps, l10n.liveGpsHint, '/ops/live-gps'),
      _OpsTile(Icons.admin_panel_settings_outlined, l10n.adminModeration, l10n.adminModerationHint, '/admin/moderation'),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.operations)),
      body: ListView(
        padding: const EdgeInsets.all(GucSpacing.md),
        children: [
          Text(l10n.operationsSubtitle),
          const SizedBox(height: GucSpacing.md),
          ...tiles.map(
            (t) => Padding(
              padding: const EdgeInsets.only(bottom: GucSpacing.sm),
              child: GucCard(
                onTap: () => context.push(t.route),
                child: Row(
                  children: [
                    Icon(t.icon, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: GucSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                          Text(t.subtitle, style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OpsTile {
  const _OpsTile(this.icon, this.title, this.subtitle, this.route);
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;
}

class DocumentsScreen extends ConsumerWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(docsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.documents)),
      body: async.when(
        data: (docs) => ListView.separated(
          padding: const EdgeInsets.all(GucSpacing.md),
          itemCount: docs.length,
          separatorBuilder: (_, __) => const SizedBox(height: GucSpacing.sm),
          itemBuilder: (context, i) {
            final d = docs[i];
            return GucCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(d.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700))),
                      GucBadge(label: l10n.docStatus(d.status), tone: _docTone(d.status)),
                    ],
                  ),
                  if (d.fileName != null) Text(d.fileName!),
                  const SizedBox(height: GucSpacing.sm),
                  GucButton(
                    label: d.status == 'MISSING' ? l10n.uploadDocument : l10n.replaceDocument,
                    variant: GucButtonVariant.secondary,
                    onPressed: () async {
                      final source = await showModalBottomSheet<String>(
                        context: context,
                        builder: (ctx) => SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.photo_camera_outlined),
                                title: Text(l10n.takePhoto),
                                onTap: () => Navigator.pop(ctx, 'camera'),
                              ),
                              ListTile(
                                leading: const Icon(Icons.photo_library_outlined),
                                title: Text(l10n.chooseGallery),
                                onTap: () => Navigator.pop(ctx, 'gallery'),
                              ),
                              ListTile(
                                leading: const Icon(Icons.attach_file),
                                title: Text(l10n.chooseFile),
                                onTap: () => Navigator.pop(ctx, 'file'),
                              ),
                            ],
                          ),
                        ),
                      );
                      if (source == null) return;
                      String fileName;
                      if (source == 'camera' || source == 'gallery') {
                        fileName = await MediaPickerService().pickPhoto(fromCamera: source == 'camera') ??
                            '${d.type.toLowerCase()}_$source.jpg';
                      } else {
                        fileName = '${d.type.toLowerCase()}_file_${DateTime.now().millisecondsSinceEpoch}.pdf';
                      }
                      await ref.read(opsRepositoryProvider).uploadDocument(d.id, fileName);
                      ref.invalidate(docsProvider);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.documentSubmitted)));
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => GucErrorState(message: l10n.offlineOrError, onRetry: () => ref.invalidate(docsProvider)),
      ),
    );
  }

  GucBadgeTone _docTone(String status) => switch (status) {
        'APPROVED' => GucBadgeTone.success,
        'PENDING' => GucBadgeTone.warning,
        'REJECTED' => GucBadgeTone.danger,
        _ => GucBadgeTone.neutral,
      };
}

class TrackingListScreen extends ConsumerWidget {
  const TrackingListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(shipmentsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.shipmentTracking)),
      body: async.when(
        data: (items) {
          if (items.isEmpty) return GucEmptyState(title: l10n.noData);
          return ListView.separated(
            padding: const EdgeInsets.all(GucSpacing.md),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: GucSpacing.sm),
            itemBuilder: (context, i) {
              final s = items[i];
              return GucCard(
                onTap: () => context.push('/ops/tracking/${s.id}'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                    Text(s.route),
                    const SizedBox(height: 6),
                    GucBadge(label: l10n.trackLabel(s.currentCode), tone: GucBadgeTone.info),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => GucErrorState(message: l10n.offlineOrError, onRetry: () => ref.invalidate(shipmentsProvider)),
      ),
    );
  }
}

class TrackingDetailScreen extends ConsumerWidget {
  const TrackingDetailScreen({super.key, required this.shipmentId});

  final String shipmentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return FutureBuilder<ShipmentTrack>(
      future: ref.read(opsRepositoryProvider).getShipment(shipmentId),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final s = snap.data!;
        final fmt = DateFormat.MMMd().add_Hm();
        return Scaffold(
          appBar: AppBar(title: Text(l10n.shipmentTracking)),
          body: ListView(
            padding: const EdgeInsets.all(GucSpacing.md),
            children: [
              Text(s.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
              Text(s.route),
              const SizedBox(height: GucSpacing.md),
              ...s.steps.map((step) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    step.done ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: step.done ? GucColors.success : Theme.of(context).colorScheme.outline,
                  ),
                  title: Text(l10n.trackLabel(step.code)),
                  subtitle: Text([
                    if (step.at != null) fmt.format(step.at!),
                    if (step.note != null) step.note!,
                  ].where((e) => e.isNotEmpty).join(' · ')),
                );
              }),
              const SizedBox(height: GucSpacing.md),
              GucCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.cmrPhoto, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                    Text(s.cmrPhotoName ?? l10n.noData),
                    const SizedBox(height: GucSpacing.sm),
                    GucButton(
                      label: l10n.uploadCmrPhoto,
                      variant: GucButtonVariant.secondary,
                      onPressed: () async {
                        final source = await showModalBottomSheet<String>(
                          context: context,
                          builder: (ctx) => SafeArea(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.photo_camera_outlined),
                                  title: Text(l10n.takePhoto),
                                  onTap: () => Navigator.pop(ctx, 'camera'),
                                ),
                                ListTile(
                                  leading: const Icon(Icons.photo_library_outlined),
                                  title: Text(l10n.chooseGallery),
                                  onTap: () => Navigator.pop(ctx, 'gallery'),
                                ),
                              ],
                            ),
                          ),
                        );
                        if (source == null) return;
                        await ref.read(opsRepositoryProvider).attachCmr(s.id, 'cmr_${source}_${DateTime.now().millisecondsSinceEpoch}.jpg');
                        ref.invalidate(shipmentsProvider);
                        if (context.mounted) context.pushReplacement('/ops/tracking/${s.id}');
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: GucSpacing.md),
              GucButton(
                label: l10n.advanceStatus,
                onPressed: () async {
                  await ref.read(opsRepositoryProvider).advanceShipment(s.id);
                  ref.invalidate(shipmentsProvider);
                  if (context.mounted) context.pushReplacement('/ops/tracking/${s.id}');
                },
              ),
              const SizedBox(height: GucSpacing.sm),
              GucButton(
                label: l10n.openChat,
                variant: GucButtonVariant.secondary,
                onPressed: () => context.push('/matches/${s.matchId}'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class PaymentsScreen extends ConsumerWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(shipmentsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.agreementsPayments)),
      body: async.when(
        data: (items) {
          if (items.isEmpty) return GucEmptyState(title: l10n.noData);
          return ListView.separated(
            padding: const EdgeInsets.all(GucSpacing.md),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: GucSpacing.sm),
            itemBuilder: (context, i) {
              final s = items[i];
              return GucCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                    Text('${l10n.agreedPrice}: ${s.agreedAmount.toStringAsFixed(0)} ${s.currency}'),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      children: [
                        GucBadge(label: l10n.paymentStatus(s.paymentStatus), tone: GucBadgeTone.info),
                        if (s.escrowHeld) GucBadge(label: l10n.escrowHeld, tone: GucBadgeTone.warning, icon: Icons.lock_outline),
                      ],
                    ),
                    const SizedBox(height: GucSpacing.sm),
                    Text(l10n.agreementSummary, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                    Text('• ${l10n.route}: ${s.route}'),
                    Text('• ${l10n.agreedPrice}: ${s.agreedAmount.toStringAsFixed(0)} ${s.currency}'),
                    Text('• ${l10n.escrowHint}'),
                    const SizedBox(height: GucSpacing.sm),
                    Text(l10n.paymentTimeline, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                    Text(l10n.paymentTimelineBody),
                    const SizedBox(height: GucSpacing.sm),
                    if (s.paymentStatus == 'HELD')
                      Text(l10n.waitingDeliveryRelease, style: Theme.of(context).textTheme.bodySmall),
                    if (s.paymentStatus == 'RELEASED')
                      GucButton(
                        label: l10n.markPaid,
                        onPressed: () async {
                          await ref.read(opsRepositoryProvider).markPaid(s.id);
                          ref.invalidate(shipmentsProvider);
                        },
                      ),
                    if (s.paymentStatus == 'PAID')
                      GucBadge(label: l10n.paymentStatus('PAID'), tone: GucBadgeTone.success, icon: Icons.check_circle_outline),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => GucErrorState(message: l10n.offlineOrError, onRetry: () => ref.invalidate(shipmentsProvider)),
      ),
    );
  }
}

class FleetOpsScreen extends ConsumerWidget {
  const FleetOpsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(fleetOpsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.fleetPanel)),
      body: async.when(
        data: (items) => ListView.separated(
          padding: const EdgeInsets.all(GucSpacing.md),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: GucSpacing.sm),
          itemBuilder: (context, i) {
            final v = items[i];
            return GucCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(v.plate, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                  Text('${v.type} · ${v.capacityKg.toStringAsFixed(0)} kg'),
                  if (v.driverName != null) Text('${l10n.driver}: ${v.driverName}'),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    children: [
                      GucBadge(label: l10n.statusLabel(v.status), tone: GucBadgeTone.info),
                      GucBadge(label: l10n.docStatus(v.docStatus), tone: v.docStatus == 'APPROVED' ? GucBadgeTone.success : GucBadgeTone.warning),
                      if (v.availableHours != null)
                        GucBadge(label: l10n.availableInHours(v.availableHours!), tone: GucBadgeTone.success),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => GucErrorState(message: l10n.offlineOrError, onRetry: () => ref.invalidate(fleetOpsProvider)),
      ),
    );
  }
}

class TeamScreen extends ConsumerWidget {
  const TeamScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(teamProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.team)),
      body: async.when(
        data: (items) => ListView.separated(
          itemCount: items.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, i) {
            final m = items[i];
            return ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person_outline)),
              title: Text(m.name),
              subtitle: Text('${l10n.teamRole(m.role)} · ${m.email}'),
              trailing: GucBadge(label: m.active ? l10n.statusActive : l10n.pending, tone: m.active ? GucBadgeTone.success : GucBadgeTone.neutral),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => GucErrorState(message: l10n.offlineOrError, onRetry: () => ref.invalidate(teamProvider)),
      ),
    );
  }
}

class SubscriptionsScreen extends ConsumerWidget {
  const SubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(subscriptionsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.corridorAlerts)),
      body: async.when(
        data: (items) => ListView.separated(
          padding: const EdgeInsets.all(GucSpacing.md),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: GucSpacing.sm),
          itemBuilder: (context, i) {
            final s = items[i];
            return GucCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(s.label),
                    subtitle: Text(l10n.corridorAlertHint),
                    value: s.active,
                    onChanged: (_) async {
                      await ref.read(opsRepositoryProvider).toggleSubscription(s.corridorId);
                      ref.invalidate(subscriptionsProvider);
                    },
                  ),
                  Text('${l10n.minAcceptPrice}: ${s.minAcceptPrice?.toStringAsFixed(0) ?? '—'} EUR'),
                  const SizedBox(height: GucSpacing.sm),
                  GucButton(
                    label: l10n.editMinPrice,
                    variant: GucButtonVariant.secondary,
                    onPressed: () async {
                      final controller = TextEditingController(text: s.minAcceptPrice?.toStringAsFixed(0) ?? '');
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text(l10n.minAcceptPrice),
                          content: TextField(controller: controller, keyboardType: TextInputType.number),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.back)),
                            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.save)),
                          ],
                        ),
                      );
                      if (ok == true) {
                        final price = double.tryParse(controller.text);
                        if (price != null) {
                          await ref.read(opsRepositoryProvider).setMinPrice(s.corridorId, price);
                          ref.invalidate(subscriptionsProvider);
                        }
                      }
                      controller.dispose();
                    },
                  ),
                ],
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => GucErrorState(message: l10n.offlineOrError, onRetry: () => ref.invalidate(subscriptionsProvider)),
      ),
    );
  }
}

class BackhaulScreen extends ConsumerWidget {
  const BackhaulScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(backhaulsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.backhaul)),
      body: async.when(
        data: (items) => ListView.separated(
          padding: const EdgeInsets.all(GucSpacing.md),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: GucSpacing.sm),
          itemBuilder: (context, i) {
            final b = items[i];
            return GucCard(
              onTap: () => context.push('/loads/${b.loadId}'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(b.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                  Text(b.route),
                  const SizedBox(height: 4),
                  Text(b.reason),
                  const SizedBox(height: 6),
                  GucBadge(label: '${l10n.matchScore} ${b.matchScore}%', tone: GucBadgeTone.success),
                ],
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => GucErrorState(message: l10n.offlineOrError, onRetry: () => ref.invalidate(backhaulsProvider)),
      ),
    );
  }
}
