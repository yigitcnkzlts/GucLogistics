import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/data/mock/mock_data.dart';
import '../../../core/di/providers.dart';
import '../../../core/domain/models.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/guc_theme.dart';
import '../../../core/widgets/guc_load_card.dart';
import '../../../core/widgets/guc_widgets.dart';
import '../../auth/domain/user_role.dart';
import '../../legal/presentation/legal_screens.dart';

final homeLoadsProvider = FutureProvider.autoDispose<List<LoadItem>>((ref) {
  return ref.watch(loadsRepositoryProvider).listLoads();
});

final homeOffersProvider = FutureProvider.autoDispose<List<OfferItem>>((ref) {
  return ref.watch(offersRepositoryProvider).listMine();
});

final homeVehiclesProvider = FutureProvider.autoDispose<List<VehicleItem>>((ref) {
  return ref.watch(vehiclesRepositoryProvider).listMine();
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(appSettingsProvider).role ?? UserRole.shipper;
    return role.isDriverSide ? const DriverHomeBody() : const ShipperHomeBody();
  }
}

class ShipperHomeBody extends ConsumerWidget {
  const ShipperHomeBody({super.key});

  String _displayName(String? email) {
    if (email == null || email.isEmpty) return '—';
    final local = email.split('@').first;
    if (local.isEmpty) return email;
    return local[0].toUpperCase() + local.substring(1);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final auth = ref.watch(authControllerProvider);
    final companyAsync = ref.watch(sessionProfileProvider);
    final loadsAsync = ref.watch(homeLoadsProvider);
    final offersAsync = ref.watch(homeOffersProvider);
    final displayName = _displayName(auth.email);
    final companyName = companyAsync.valueOrNull?['companyName']?.toString();
    final verified = companyAsync.valueOrNull?['companyVerified'] == true;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.home),
        actions: [
          IconButton(
            tooltip: l10n.notifications,
            onPressed: () => context.push('/notifications'),
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(homeLoadsProvider);
          ref.invalidate(homeOffersProvider);
          ref.invalidate(sessionProfileProvider);
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 720;
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: wide ? GucSpacing.lg : GucSpacing.md,
                vertical: GucSpacing.md,
              ),
              children: [
                GucCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.welcomeBack,
                        style: theme.textTheme.labelLarge?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: GucSpacing.xxs),
                      Text(
                        l10n.welcomeUser(displayName),
                        style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (companyName != null && companyName.isNotEmpty) ...[
                        const SizedBox(height: GucSpacing.xs),
                        Text(
                          companyName,
                          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: GucSpacing.xs),
                      Text(
                        l10n.homeShipperSubtitle,
                        style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                      if (companyAsync.hasValue) ...[
                        const SizedBox(height: GucSpacing.sm),
                        InkWell(
                          onTap: () => context.push('/verification'),
                          borderRadius: BorderRadius.circular(999),
                          child: verified
                              ? GucBadge(
                                  label: l10n.verifiedCompany,
                                  tone: GucBadgeTone.success,
                                  icon: Icons.verified_outlined,
                                )
                              : GucBadge(
                                  label: l10n.verificationPending,
                                  tone: GucBadgeTone.warning,
                                  icon: Icons.hourglass_top_outlined,
                                ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: GucSpacing.md),
                loadsAsync.when(
                  data: (loads) {
                    final active = loads.where((e) => e.status == 'PUBLISHED' || e.status == 'MATCHED').length;
                    final completed = loads.where((e) => e.status == 'COMPLETED').length;
                    final pending = offersAsync.valueOrNull?.where((e) => e.status == 'PENDING').length ?? 0;
                    return _ShipperStatsRow(
                      wide: wide,
                      active: active,
                      pending: pending,
                      completed: completed,
                      activeLabel: l10n.activeLoads,
                      pendingLabel: l10n.pendingOffers,
                      completedLabel: l10n.completedShipments,
                    );
                  },
                  loading: () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: GucSpacing.lg),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (_, __) => GucErrorState(
                    message: l10n.offlineOrError,
                    onRetry: () => ref.invalidate(homeLoadsProvider),
                  ),
                ),
                const SizedBox(height: GucSpacing.md),
                GucButton(
                  label: l10n.createLoad,
                  icon: Icons.add,
                  onPressed: () => context.push('/loads/create'),
                ),
                const SizedBox(height: GucSpacing.sm),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ActionChip(label: Text(l10n.europeMarket), onPressed: () => context.go('/market')),
                    ActionChip(label: Text(l10n.compareOffers), onPressed: () => context.push('/shipper/compare-offers')),
                    ActionChip(label: Text(l10n.activeTracking), onPressed: () => context.push('/ops/tracking')),
                    ActionChip(label: Text(l10n.escrowSummary), onPressed: () => context.push('/shipper/payments')),
                    ActionChip(label: Text(l10n.shipperTools), onPressed: () => context.push('/shipper/tools')),
                    ActionChip(label: Text(l10n.reports), avatar: const Icon(Icons.analytics_outlined, size: 18), onPressed: () => context.push('/reports')),
                    ActionChip(label: Text(l10n.supportFaq), onPressed: () => context.push('/help/support')),
                  ],
                ),
                const SizedBox(height: GucSpacing.md),
                const HowItWorksHomeCard(forShipper: true),
                const SizedBox(height: GucSpacing.lg),
                _SectionHeader(
                  title: l10n.recentLoads,
                  actionLabel: l10n.seeAll,
                  onAction: () => context.go('/loads'),
                ),
                const SizedBox(height: GucSpacing.sm),
                if (loadsAsync.hasError && loadsAsync.valueOrNull == null)
                  const SizedBox.shrink()
                else if (loadsAsync.isLoading && loadsAsync.valueOrNull == null)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: GucSpacing.md),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if ((loadsAsync.valueOrNull ?? const []).isEmpty)
                  GucEmptyState(title: l10n.noData)
                else
                  ...loadsAsync.valueOrNull!.take(3).map(
                        (load) => Padding(
                          padding: const EdgeInsets.only(bottom: GucSpacing.sm),
                          child: GucLoadCard(
                            load: load,
                            onTap: () => context.push('/loads/${load.id}'),
                          ),
                        ),
                      ),
                const SizedBox(height: GucSpacing.md),
                _SectionHeader(
                  title: l10n.recentOffers,
                  actionLabel: l10n.seeAll,
                  onAction: () => context.go('/offers'),
                ),
                const SizedBox(height: GucSpacing.sm),
                offersAsync.when(
                  data: (offers) {
                    if (offers.isEmpty) return GucEmptyState(title: l10n.noData);
                    return Column(
                      children: offers.take(3).map((o) {
                        final pendingOffer = o.status == 'PENDING';
                        return Padding(
                          padding: const EdgeInsets.only(bottom: GucSpacing.sm),
                          child: GucCard(
                            onTap: () => context.go('/offers'),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        o.loadTitle ?? o.loadId,
                                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: GucSpacing.xxs),
                                      Text(
                                        '${o.amount.toStringAsFixed(0)} ${o.currency}',
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: scheme.primary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      if (o.message != null && o.message!.isNotEmpty) ...[
                                        const SizedBox(height: 2),
                                        Text(
                                          o.message!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: theme.textTheme.bodySmall,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                const SizedBox(width: GucSpacing.sm),
                                GucBadge(
                                  label: l10n.statusLabel(o.status),
                                  tone: pendingOffer
                                      ? GucBadgeTone.warning
                                      : o.status == 'ACCEPTED'
                                          ? GucBadgeTone.success
                                          : GucBadgeTone.neutral,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                  loading: () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: GucSpacing.md),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (_, __) => GucErrorState(
                    message: l10n.offlineOrError,
                    onRetry: () => ref.invalidate(homeOffersProvider),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        TextButton(
          onPressed: onAction,
          child: Text(actionLabel),
        ),
      ],
    );
  }
}

class _ShipperStatsRow extends StatelessWidget {
  const _ShipperStatsRow({
    required this.wide,
    required this.active,
    required this.pending,
    required this.completed,
    required this.activeLabel,
    required this.pendingLabel,
    required this.completedLabel,
  });

  final bool wide;
  final int active;
  final int pending;
  final int completed;
  final String activeLabel;
  final String pendingLabel;
  final String completedLabel;

  @override
  Widget build(BuildContext context) {
    final tiles = [
      _CompactStat(label: activeLabel, value: '$active', icon: Icons.inventory_2_outlined),
      _CompactStat(label: pendingLabel, value: '$pending', icon: Icons.request_quote_outlined),
      _CompactStat(label: completedLabel, value: '$completed', icon: Icons.check_circle_outline),
    ];

    if (wide) {
      return Row(
        children: [
          for (var i = 0; i < tiles.length; i++) ...[
            if (i > 0) const SizedBox(width: GucSpacing.sm),
            Expanded(child: tiles[i]),
          ],
        ],
      );
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < tiles.length; i++) ...[
            if (i > 0) const SizedBox(width: GucSpacing.xs),
            Expanded(child: tiles[i]),
          ],
        ],
      ),
    );
  }
}

class _CompactStat extends StatelessWidget {
  const _CompactStat({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GucCard(
      padding: const EdgeInsets.all(GucSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(height: GucSpacing.xs),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.labelSmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class DriverHomeBody extends ConsumerWidget {
  const DriverHomeBody({super.key});

  String _displayName(String? email, String? driverName) {
    if (driverName != null && driverName.isNotEmpty) return driverName;
    if (email == null || email.isEmpty) return '—';
    final local = email.split('@').first;
    if (local.isEmpty) return email;
    return local[0].toUpperCase() + local.substring(1);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final auth = ref.watch(authControllerProvider);
    final companyAsync = ref.watch(sessionProfileProvider);
    final loadsAsync = ref.watch(homeLoadsProvider);
    final offersAsync = ref.watch(homeOffersProvider);
    final vehiclesAsync = ref.watch(homeVehiclesProvider);
    final driverName = companyAsync.valueOrNull?['driverDisplayName']?.toString();
    final verified = companyAsync.valueOrNull?['driverVerified'] == true;
    final displayName = _displayName(auth.email, driverName);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.home),
        actions: [
          IconButton(
            tooltip: l10n.notifications,
            onPressed: () => context.push('/notifications'),
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(homeLoadsProvider);
          ref.invalidate(homeOffersProvider);
          ref.invalidate(homeVehiclesProvider);
          ref.invalidate(sessionProfileProvider);
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 720;
            final published = loadsAsync.valueOrNull?.where((e) => e.status == 'PUBLISHED').toList() ?? const <LoadItem>[];
            final pending = offersAsync.valueOrNull?.where((e) => e.status == 'PENDING').length ?? 0;
            final won = offersAsync.valueOrNull?.where((e) => e.status == 'ACCEPTED').length ?? 0;

            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: wide ? GucSpacing.lg : GucSpacing.md,
                vertical: GucSpacing.md,
              ),
              children: [
                GucCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.welcomeBack,
                        style: theme.textTheme.labelLarge?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: GucSpacing.xxs),
                      Text(
                        l10n.welcomeUser(displayName),
                        style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: GucSpacing.xs),
                      Text(
                        l10n.homeDriverSubtitle,
                        style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                      if (companyAsync.hasValue) ...[
                        const SizedBox(height: GucSpacing.sm),
                        InkWell(
                          onTap: () => context.push('/verification'),
                          borderRadius: BorderRadius.circular(999),
                          child: verified
                              ? GucBadge(
                                  label: l10n.verifiedDriver,
                                  tone: GucBadgeTone.success,
                                  icon: Icons.verified_outlined,
                                )
                              : GucBadge(
                                  label: l10n.verificationPending,
                                  tone: GucBadgeTone.warning,
                                  icon: Icons.hourglass_top_outlined,
                                ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: GucSpacing.md),
                _ShipperStatsRow(
                  wide: wide,
                  active: published.length,
                  pending: pending,
                  completed: won,
                  activeLabel: l10n.nearbyLoads,
                  pendingLabel: l10n.activeOffers,
                  completedLabel: l10n.wonJobs,
                ),
                const SizedBox(height: GucSpacing.md),
                GucCard(
                  onTap: () => context.push('/carrier/earnings'),
                  child: Row(
                    children: [
                      Icon(Icons.account_balance_wallet_outlined, color: scheme.primary, size: 32),
                      const SizedBox(width: GucSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.earningsWallet, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
                            Text('₺${MockData.earningsBalanceTry.toStringAsFixed(0)} · ${l10n.jobHistory}'),
                          ],
                        ),
                      ),
                      GucButton(
                        label: l10n.findLoads,
                        expanded: false,
                        onPressed: () => context.go('/market'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: GucSpacing.md),
                GucButton(
                  label: l10n.reports,
                  icon: Icons.analytics_outlined,
                  variant: GucButtonVariant.secondary,
                  onPressed: () => context.push('/reports'),
                ),
                const SizedBox(height: GucSpacing.md),
                const HowItWorksHomeCard(forShipper: false),
                const SizedBox(height: GucSpacing.lg),
                _SectionHeader(
                  title: l10n.vehicleStatus,
                  actionLabel: l10n.seeAll,
                  onAction: () => context.push('/vehicles'),
                ),
                const SizedBox(height: GucSpacing.sm),
                vehiclesAsync.when(
                  data: (vehicles) {
                    if (vehicles.isEmpty) {
                      return GucEmptyState(title: l10n.noData);
                    }
                    return Column(
                      children: vehicles.take(2).map((v) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: GucSpacing.sm),
                          child: GucCard(
                            onTap: () => context.push('/vehicles'),
                            child: Row(
                              children: [
                                Icon(Icons.local_shipping_outlined, color: scheme.primary),
                                const SizedBox(width: GucSpacing.sm),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        v.plate,
                                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                                      ),
                                      Text(
                                        '${v.type} · ${v.capacityKg.toStringAsFixed(0)} kg',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                GucBadge(label: l10n.statusLabel(v.status), tone: GucBadgeTone.success),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                  loading: () => const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator())),
                  error: (_, __) => GucErrorState(
                    message: l10n.offlineOrError,
                    onRetry: () => ref.invalidate(homeVehiclesProvider),
                  ),
                ),
                const SizedBox(height: GucSpacing.md),
                _SectionHeader(
                  title: l10n.recommendedLoads,
                  actionLabel: l10n.seeAll,
                  onAction: () => context.go('/market'),
                ),
                const SizedBox(height: GucSpacing.sm),
                if (loadsAsync.isLoading && loadsAsync.valueOrNull == null)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: GucSpacing.md),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (published.isEmpty)
                  GucEmptyState(
                    title: l10n.noData,
                    action: GucButton(
                      label: l10n.browseLoads,
                      expanded: false,
                      variant: GucButtonVariant.secondary,
                      onPressed: () => context.go('/market'),
                    ),
                  )
                else
                  ...published.take(3).map(
                        (load) => Padding(
                          padding: const EdgeInsets.only(bottom: GucSpacing.sm),
                          child: GucLoadCard(
                            load: load,
                            onTap: () => context.push('/loads/${load.id}'),
                          ),
                        ),
                      ),
              ],
            );
          },
        ),
      ),
    );
  }
}
