import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/data/mock/mock_data.dart';
import '../../../core/di/providers.dart';
import '../../../core/domain/models.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/guc_theme.dart';
import '../../../core/widgets/guc_widgets.dart';

final offersProvider = FutureProvider.autoDispose<List<OfferItem>>((ref) {
  return ref.watch(offersRepositoryProvider).listMine();
});

enum _OfferSort { priceAsc, priceDesc, trust, sla, newest }

class OffersScreen extends ConsumerStatefulWidget {
  const OffersScreen({super.key});

  @override
  ConsumerState<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends ConsumerState<OffersScreen> {
  bool _favoritesOnly = false;
  bool _adrOnly = false;
  _OfferSort _sort = _OfferSort.priceAsc;

  List<OfferItem> _filter(List<OfferItem> items) {
    final favorites = ref.read(appSettingsProvider).favoriteCarriers;
    var list = [...items];
    if (_favoritesOnly) {
      list = list.where((o) => o.carrierId != null && favorites.contains(o.carrierId)).toList();
    }
    if (_adrOnly) {
      list = list.where((o) {
        final load = MockData.loads.where((l) => l.id == o.loadId);
        return load.isNotEmpty && load.first.adr;
      }).toList();
    }
    switch (_sort) {
      case _OfferSort.priceAsc:
        list.sort((a, b) => a.amount.compareTo(b.amount));
      case _OfferSort.priceDesc:
        list.sort((a, b) => b.amount.compareTo(a.amount));
      case _OfferSort.trust:
        list.sort((a, b) => (b.trustScore ?? 0).compareTo(a.trustScore ?? 0));
      case _OfferSort.sla:
        list.sort((a, b) => (a.expiresAt ?? DateTime.now()).compareTo(b.expiresAt ?? DateTime.now()));
      case _OfferSort.newest:
        list.sort((a, b) => (b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0))
            .compareTo(a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0)));
    }
    return list;
  }

  Future<void> _reject(OfferItem offer) async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.rejectOffer),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: l10n.rejectReason),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.back)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.reject)),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(offersRepositoryProvider).reject(offer.id, reason: controller.text.trim().isEmpty ? null : controller.text.trim());
      ref.invalidate(offersProvider);
    }
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final role = ref.watch(appSettingsProvider).role;
    final isShipper = role?.isShipperSide ?? true;
    final offers = ref.watch(offersProvider);
    final canAccept = MockData.dispatcherPermissions.canAcceptOffers;

    return Scaffold(
      appBar: AppBar(
        title: Text(isShipper ? l10n.incomingOffers : l10n.myOffers),
        actions: [
          if (isShipper)
            IconButton(
              tooltip: l10n.compareOffers,
              onPressed: () => context.push('/shipper/compare-offers'),
              icon: const Icon(Icons.compare_arrows),
            ),
        ],
      ),
      body: Column(
        children: [
          if (isShipper)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(GucSpacing.md, GucSpacing.sm, GucSpacing.md, 0),
              child: Row(
                children: [
                  FilterChip(
                    label: Text(l10n.favoritesOnlyFilter),
                    selected: _favoritesOnly,
                    onSelected: (v) => setState(() => _favoritesOnly = v),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: Text(l10n.adrLoadsFilter),
                    selected: _adrOnly,
                    onSelected: (v) => setState(() => _adrOnly = v),
                  ),
                  const SizedBox(width: 8),
                  DropdownButton<_OfferSort>(
                    value: _sort,
                    items: [
                      DropdownMenuItem(value: _OfferSort.priceAsc, child: Text(l10n.sortPriceAsc)),
                      DropdownMenuItem(value: _OfferSort.priceDesc, child: Text(l10n.sortPriceDesc)),
                      DropdownMenuItem(value: _OfferSort.trust, child: Text(l10n.sortTrust)),
                      DropdownMenuItem(value: _OfferSort.sla, child: Text(l10n.sortSla)),
                      DropdownMenuItem(value: _OfferSort.newest, child: Text(l10n.sortNewest)),
                    ],
                    onChanged: (v) => setState(() => _sort = v ?? _OfferSort.priceAsc),
                  ),
                ],
              ),
            ),
          Expanded(
            child: offers.when(
              data: (raw) {
                final items = _filter(raw);
                if (items.isEmpty) return GucEmptyState(title: l10n.noData);
                return RefreshIndicator(
                  onRefresh: () async => ref.invalidate(offersProvider),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(GucSpacing.md),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: GucSpacing.sm),
                    itemBuilder: (context, index) {
                      final offer = items[index];
                      final open = offer.status == 'PENDING' || offer.status == 'COUNTERED';
                      return GucCard(
                        onTap: () => context.push('/offers/${offer.id}'),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              offer.loadTitle ?? offer.loadId,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: GucSpacing.xs),
                            if (offer.carrierName != null) Text('${l10n.carrier}: ${offer.carrierName}'),
                            Text(
                              '${offer.amount.toStringAsFixed(0)} ${offer.currency}'
                              '${offer.trustScore != null ? ' · ★ ${offer.trustScore!.toStringAsFixed(1)}' : ''}'
                              '${offer.transitHours != null ? ' · ${offer.transitHours}h' : ''}',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            if (offer.expiresAt != null)
                              Text(
                                offer.slaExpired ? l10n.slaExpired : '${l10n.slaUntil}: ${offer.expiresAt}',
                                style: TextStyle(color: offer.slaExpired ? Theme.of(context).colorScheme.error : null),
                              ),
                            if (offer.rejectReason != null) Text('${l10n.rejectReason}: ${offer.rejectReason}'),
                            const SizedBox(height: GucSpacing.xs),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                GucBadge(
                                  label: l10n.statusLabel(offer.status),
                                  tone: offer.status == 'ACCEPTED'
                                      ? GucBadgeTone.success
                                      : offer.status == 'REJECTED'
                                          ? GucBadgeTone.danger
                                          : offer.status == 'COUNTERED'
                                              ? GucBadgeTone.info
                                              : GucBadgeTone.warning,
                                ),
                                if (open) GucBadge(label: l10n.negotiation, icon: Icons.swap_horiz),
                              ],
                            ),
                            const SizedBox(height: GucSpacing.sm),
                            Row(
                              children: [
                                Expanded(
                                  child: GucButton(
                                    label: open ? l10n.openNegotiation : (offer.matchId != null ? l10n.openChat : l10n.offerRoom),
                                    onPressed: () {
                                      if (offer.status == 'ACCEPTED' && offer.matchId != null) {
                                        context.push('/matches/${offer.matchId}');
                                      } else {
                                        context.push('/offers/${offer.id}');
                                      }
                                    },
                                  ),
                                ),
                                if (isShipper && open) ...[
                                  const SizedBox(width: GucSpacing.sm),
                                  Expanded(
                                    child: GucButton(
                                      label: l10n.acceptAndMatch,
                                      variant: GucButtonVariant.secondary,
                                      onPressed: !canAccept
                                          ? null
                                          : () async {
                                              final matchId = await ref.read(offersRepositoryProvider).accept(offer.id);
                                              ref.invalidate(offersProvider);
                                              if (context.mounted && matchId != null) {
                                                context.push('/matches/$matchId');
                                              }
                                            },
                                    ),
                                  ),
                                  const SizedBox(width: GucSpacing.sm),
                                  IconButton(
                                    tooltip: l10n.rejectOffer,
                                    onPressed: () => _reject(offer),
                                    icon: const Icon(Icons.close),
                                  ),
                                ],
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
              error: (e, _) => GucErrorState(message: l10n.offlineOrError, onRetry: () => ref.invalidate(offersProvider)),
            ),
          ),
        ],
      ),
    );
  }
}
