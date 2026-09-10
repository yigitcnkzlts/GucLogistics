import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/data/mock/europe_geo.dart';
import '../../../core/data/mock/mock_data.dart';
import '../../../core/di/providers.dart';
import '../../../core/domain/models.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/guc_theme.dart';
import '../../../core/widgets/guc_load_card.dart';
import '../../../core/widgets/guc_widgets.dart';
import '../../ops/presentation/ops_screens.dart';
import '../../platform/presentation/platform_screens.dart';

final marketCorridorProvider = StateProvider<String>((ref) => 'all-eu');
final marketCountryProvider = StateProvider<String>((ref) => EuropeGeo.all);
final marketRegionProvider = StateProvider<String>((ref) => EuropeGeo.all);
final marketCityProvider = StateProvider<String>((ref) => EuropeGeo.all);
final marketSearchProvider = StateProvider<String>((ref) => '');

final marketLoadsProvider = FutureProvider.autoDispose<List<LoadItem>>((ref) async {
  final corridor = ref.watch(marketCorridorProvider);
  final country = ref.watch(marketCountryProvider);
  final region = ref.watch(marketRegionProvider);
  final city = ref.watch(marketCityProvider);
  final q = ref.watch(marketSearchProvider).trim().toLowerCase();
  final settings = ref.watch(appSettingsProvider);
  final isCarrier = settings.role?.isDriverSide == true;
  final items = await ref.watch(marketplaceRepositoryProvider).discoverLoads(
        corridorId: corridor,
        viewerCarrierId: isCarrier ? MockData.currentCarrierId : null,
        favoriteCarrierIds: settings.favoriteCarriers,
        country: country,
        region: region,
        city: city,
      );
  if (q.isEmpty) return items;
  return items.where((e) {
    final hay = [
      e.title,
      e.companyName,
      e.factoryName,
      e.pickupCity,
      e.dropoffCity,
      e.description,
      e.pickupCountry,
      e.dropoffCountry,
    ].whereType<String>().join(' ').toLowerCase();
    return hay.contains(q);
  }).toList();
});

final marketCarriersProvider = FutureProvider.autoDispose<List<CarrierListing>>((ref) {
  final corridor = ref.watch(marketCorridorProvider);
  return ref.watch(marketplaceRepositoryProvider).discoverCarriers(corridorId: corridor);
});

final marketPinsProvider = FutureProvider.autoDispose<List<MapPin>>((ref) {
  final corridor = ref.watch(marketCorridorProvider);
  final country = ref.watch(marketCountryProvider);
  final region = ref.watch(marketRegionProvider);
  final city = ref.watch(marketCityProvider);
  final settings = ref.watch(appSettingsProvider);
  final isCarrier = settings.role?.isDriverSide == true;
  return ref.watch(marketplaceRepositoryProvider).mapPins(
        forLoads: true,
        corridorId: corridor,
        viewerCarrierId: isCarrier ? MockData.currentCarrierId : null,
        favoriteCarrierIds: settings.favoriteCarriers,
        country: country,
        region: region,
        city: city,
      );
});

final marketBandProvider = FutureProvider.autoDispose<MarketPriceBand?>((ref) {
  final corridor = ref.watch(marketCorridorProvider);
  return ref.watch(marketplaceRepositoryProvider).priceBand(corridor);
});

class MarketplaceScreen extends ConsumerWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final role = ref.watch(appSettingsProvider).role;
    final isShipper = role?.isShipperSide ?? true;
    final corridorId = ref.watch(marketCorridorProvider);
    final country = ref.watch(marketCountryProvider);
    final region = ref.watch(marketRegionProvider);
    final city = ref.watch(marketCityProvider);
    final favorites = ref.watch(appSettingsProvider).favoriteCorridors;
    final band = ref.watch(marketBandProvider).valueOrNull;
    final pins = ref.watch(marketPinsProvider);
    final loads = ref.watch(marketLoadsProvider);
    final carriers = ref.watch(marketCarriersProvider);
    final regions = EuropeGeo.regionsFor(country == EuropeGeo.all ? null : country);
    final cities = EuropeGeo.citiesFor(
      country: country == EuropeGeo.all ? null : country,
      region: region == EuropeGeo.all ? null : region,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(isShipper ? l10n.europeMarket : l10n.findLoads),
        actions: [
          IconButton(
            tooltip: l10n.notifications,
            onPressed: () => context.push('/notifications'),
            icon: const Icon(Icons.notifications_outlined),
          ),
          if (isShipper)
            IconButton(
              tooltip: l10n.myLoads,
              onPressed: () => context.push('/loads'),
              icon: const Icon(Icons.inventory_2_outlined),
            )
          else ...[
            IconButton(
              tooltip: l10n.myAvailability,
              onPressed: () => context.push('/carrier/availability'),
              icon: const Icon(Icons.my_location_outlined),
            ),
            IconButton(
              tooltip: l10n.earningsWallet,
              onPressed: () => context.push('/carrier/earnings'),
              icon: const Icon(Icons.account_balance_wallet_outlined),
            ),
          ],
        ],
      ),
      floatingActionButton: isShipper
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/loads/create'),
              icon: const Icon(Icons.add),
              label: Text(l10n.createLoad),
            )
          : null,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(marketLoadsProvider);
          ref.invalidate(marketCarriersProvider);
          ref.invalidate(marketPinsProvider);
          ref.invalidate(marketBandProvider);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(GucSpacing.md),
          children: [
            const OfflineBanner(),
            Text(
              isShipper ? l10n.marketShipperSubtitle : l10n.findLoadsSubtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (!isShipper) ...[
              const SizedBox(height: GucSpacing.sm),
              GucCard(
                onTap: () => context.push('/carrier/availability'),
                child: Row(
                  children: [
                    Icon(
                      MockData.carrierAvailability.available ? Icons.check_circle : Icons.pause_circle_outline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: GucSpacing.sm),
                    Expanded(
                      child: Text(
                        MockData.carrierAvailability.available
                            ? '${l10n.availableForLoads}: ${MockData.carrierAvailability.city}, ${MockData.carrierAvailability.country}'
                            : l10n.notAvailableNow,
                      ),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ],
            const SizedBox(height: GucSpacing.md),
            Text(l10n.corridors, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: GucSpacing.xs),
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: MockCorridors.chips.map((c) {
                  final selected = corridorId == c.id;
                  final fav = favorites.contains(c.id);
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onLongPress: c.id == 'all-eu'
                          ? null
                          : () => ref.read(appSettingsProvider.notifier).toggleFavoriteCorridor(c.id),
                      child: FilterChip(
                        selected: selected,
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (fav) ...[
                              Icon(Icons.star, size: 14, color: Theme.of(context).colorScheme.primary),
                              const SizedBox(width: 4),
                            ],
                            Text(c.label),
                          ],
                        ),
                        onSelected: (_) => ref.read(marketCorridorProvider.notifier).state = c.id,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            if (favorites.isNotEmpty) ...[
              const SizedBox(height: GucSpacing.xs),
              Text(
                '${l10n.favoriteCorridors}: ${favorites.map(MockCorridors.labelOf).whereType<String>().join(' · ')}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: GucSpacing.md),
            TextField(
              decoration: InputDecoration(
                labelText: l10n.searchLoads,
                hintText: l10n.searchLoadsHint,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
              ),
              onChanged: (v) => ref.read(marketSearchProvider.notifier).state = v,
            ),
            const SizedBox(height: GucSpacing.md),
            Text(l10n.locationFilter, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
            Text(l10n.locationFilterHint, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: GucSpacing.xs),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: country,
                    isExpanded: true,
                    decoration: InputDecoration(labelText: l10n.country, border: const OutlineInputBorder()),
                    items: [
                      DropdownMenuItem(value: EuropeGeo.all, child: Text(l10n.allCountries)),
                      ...EuropeGeo.countries.map((c) => DropdownMenuItem(value: c, child: Text(EuropeGeo.countryLabel(c)))),
                    ],
                    onChanged: (v) {
                      ref.read(marketCountryProvider.notifier).state = v ?? EuropeGeo.all;
                      ref.read(marketRegionProvider.notifier).state = EuropeGeo.all;
                      ref.read(marketCityProvider.notifier).state = EuropeGeo.all;
                    },
                  ),
                ),
                const SizedBox(width: GucSpacing.sm),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: region,
                    isExpanded: true,
                    decoration: InputDecoration(labelText: l10n.regionState, border: const OutlineInputBorder()),
                    items: [
                      DropdownMenuItem(value: EuropeGeo.all, child: Text(l10n.allRegions)),
                      ...regions.map((r) => DropdownMenuItem(value: r, child: Text(r))),
                    ],
                    onChanged: country == EuropeGeo.all
                        ? null
                        : (v) {
                            ref.read(marketRegionProvider.notifier).state = v ?? EuropeGeo.all;
                            ref.read(marketCityProvider.notifier).state = EuropeGeo.all;
                          },
                  ),
                ),
              ],
            ),
            const SizedBox(height: GucSpacing.sm),
            DropdownButtonFormField<String>(
              initialValue: city,
              isExpanded: true,
              decoration: InputDecoration(labelText: l10n.city, border: const OutlineInputBorder()),
              items: [
                DropdownMenuItem(value: EuropeGeo.all, child: Text(l10n.allCities)),
                ...cities.map((c) => DropdownMenuItem(value: c, child: Text(c))),
              ],
              onChanged: country == EuropeGeo.all
                  ? null
                  : (v) => ref.read(marketCityProvider.notifier).state = v ?? EuropeGeo.all,
            ),
            const SizedBox(height: GucSpacing.md),
            if (band != null)
              GucCard(
                child: Row(
                  children: [
                    Icon(Icons.stacked_line_chart, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: GucSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.marketPriceBand, style: Theme.of(context).textTheme.labelLarge),
                          Text(
                            '€${band.minEur.toStringAsFixed(0)} – €${band.maxEur.toStringAsFixed(0)} · ${l10n.avg} €${band.avgEur.toStringAsFixed(0)}',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: GucSpacing.md),
            Text(l10n.europeMap, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
            Text(l10n.mapDisclaimer, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: GucSpacing.xs),
            pins.when(
              data: (items) => EuropeMapBoard(
                pins: items,
                onPinTap: (pin) {
                  if (pin.kind == 'load') {
                    context.push('/loads/${pin.id}');
                  } else {
                    context.push('/market/carriers/${pin.id}');
                  }
                },
              ),
              loading: () => const SizedBox(height: 180, child: Center(child: CircularProgressIndicator())),
              error: (_, __) => GucErrorState(message: l10n.offlineOrError, onRetry: () => ref.invalidate(marketPinsProvider)),
            ),
            if (!isShipper) ...[
              const SizedBox(height: GucSpacing.md),
              _SectionLink(
                title: l10n.backhaul,
                action: l10n.seeAll,
                onTap: () => context.push('/ops/backhaul'),
              ),
              const SizedBox(height: GucSpacing.xs),
              ...?ref.watch(backhaulsProvider).valueOrNull?.take(2).map(
                    (b) => Padding(
                      padding: const EdgeInsets.only(bottom: GucSpacing.sm),
                      child: GucCard(
                        onTap: () => context.push('/loads/${b.loadId}'),
                        child: Row(
                          children: [
                            Icon(Icons.u_turn_left, color: Theme.of(context).colorScheme.primary),
                            const SizedBox(width: GucSpacing.sm),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(b.route, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                                  Text(b.reason, maxLines: 1, overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            ),
                            GucBadge(label: '${b.matchScore}%', tone: GucBadgeTone.success),
                          ],
                        ),
                      ),
                    ),
                  ),
            ],
            const SizedBox(height: GucSpacing.lg),
            if (isShipper) ...[
              Text(
                l10n.shipperCompanies,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              Text(l10n.shipperCompaniesHint, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: GucSpacing.sm),
              loads.when(
                data: (items) {
                  final companies = ref.read(marketplaceRepositoryProvider).shipperCompaniesFrom(items);
                  if (companies.isEmpty) return GucEmptyState(title: l10n.noData);
                  return Column(
                    children: companies
                        .map(
                          (c) => Padding(
                            padding: const EdgeInsets.only(bottom: GucSpacing.sm),
                            child: GucCard(
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: CircleAvatar(
                                  child: Text(c.companyName.isNotEmpty ? c.companyName[0].toUpperCase() : '?'),
                                ),
                                title: Text(c.companyName, style: const TextStyle(fontWeight: FontWeight.w800)),
                                subtitle: Text(
                                  '${c.city}, ${c.region}, ${c.country}\n'
                                  '${l10n.factories}: ${c.factories.isEmpty ? '—' : c.factories.join(', ')}\n'
                                  '${l10n.activeListings}: ${c.activeLoads}',
                                ),
                                isThreeLine: true,
                                trailing: c.verified
                                    ? GucBadge(label: l10n.verified, tone: GucBadgeTone.success, icon: Icons.verified_outlined)
                                    : null,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const SizedBox.shrink(),
              ),
              const SizedBox(height: GucSpacing.lg),
            ],
            Text(
              l10n.europeLoadBoard,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            Text(l10n.europeLoadBoardHint, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: GucSpacing.sm),
            loads.when(
              data: (items) {
                if (items.isEmpty) return GucEmptyState(title: l10n.noData);
                final repo = ref.read(marketplaceRepositoryProvider);
                return Column(
                  children: items.map((load) {
                    final bandForLoad = repo.bandForLoad(load);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: GucSpacing.sm),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GucLoadCard(load: load, onTap: () => context.push('/loads/${load.id}')),
                          Padding(
                            padding: const EdgeInsets.only(left: 4, top: 4),
                            child: Text(
                              '${l10n.marketPriceBand}: €${bandForLoad.minEur.toStringAsFixed(0)}–€${bandForLoad.maxEur.toStringAsFixed(0)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => GucErrorState(message: l10n.offlineOrError, onRetry: () => ref.invalidate(marketLoadsProvider)),
            ),
            if (isShipper) ...[
              const SizedBox(height: GucSpacing.lg),
              Text(
                l10n.availableCarriers,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: GucSpacing.sm),
              carriers.when(
                data: (items) {
                  if (items.isEmpty) return GucEmptyState(title: l10n.noData);
                  return Column(
                    children: items
                        .map(
                          (c) => Padding(
                            padding: const EdgeInsets.only(bottom: GucSpacing.sm),
                            child: _CarrierCard(
                              carrier: c,
                              onTap: () => context.push('/market/carriers/${c.id}'),
                            ),
                          ),
                        )
                        .toList(),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => GucErrorState(message: l10n.offlineOrError, onRetry: () => ref.invalidate(marketCarriersProvider)),
              ),
            ],
            const SizedBox(height: 72),
          ],
        ),
      ),
    );
  }
}

class _SectionLink extends StatelessWidget {
  const _SectionLink({required this.title, required this.action, required this.onTap});

  final String title;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
        ),
        TextButton(onPressed: onTap, child: Text(action)),
      ],
    );
  }
}

class MockCorridors {
  static List<CorridorPreset> get chips => const [
        CorridorPreset(id: 'all-eu', label: 'All Europe', fromCountries: [], toCountries: []),
        CorridorPreset(id: 'de-fr', label: 'DE → FR', fromCountries: ['DE'], toCountries: ['FR']),
        CorridorPreset(id: 'nl-pl', label: 'NL → PL', fromCountries: ['NL'], toCountries: ['PL']),
        CorridorPreset(id: 'tr-eu', label: 'TR → EU', fromCountries: ['TR'], toCountries: ['BG', 'DE', 'FR', 'PL', 'AT', 'HU', 'CZ', 'IT']),
        CorridorPreset(id: 'benelux', label: 'Benelux', fromCountries: ['NL', 'BE', 'LU'], toCountries: ['DE', 'FR', 'PL', 'IT', 'AT']),
        CorridorPreset(id: 'it-at', label: 'IT → AT', fromCountries: ['IT'], toCountries: ['AT']),
        CorridorPreset(id: 'cz-hu', label: 'CZ → HU', fromCountries: ['CZ'], toCountries: ['HU']),
      ];

  static String? labelOf(String id) {
    for (final c in chips) {
      if (c.id == id) return c.label;
    }
    return null;
  }
}

class EuropeMapBoard extends StatelessWidget {
  const EuropeMapBoard({super.key, required this.pins, required this.onPinTap});

  final List<MapPin> pins;
  final ValueChanged<MapPin> onPinTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AspectRatio(
      aspectRatio: 16 / 10,
      child: GucCard(
        padding: EdgeInsets.zero,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          scheme.primary.withValues(alpha: 0.18),
                          scheme.secondary.withValues(alpha: 0.12),
                          scheme.surface,
                        ],
                      ),
                    ),
                  ),
                  CustomPaint(size: Size.infinite, painter: _GridPainter(scheme.outlineVariant.withValues(alpha: 0.35))),
                  Positioned(
                    left: 12,
                    top: 10,
                    child: Text(
                      'EUROPE',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                            color: scheme.onSurface.withValues(alpha: 0.7),
                          ),
                    ),
                  ),
                  ...pins.map((pin) {
                    final left = pin.mapX * constraints.maxWidth - 14;
                    final top = pin.mapY * constraints.maxHeight - 14;
                    return Positioned(
                      left: left.clamp(4, constraints.maxWidth - 28),
                      top: top.clamp(4, constraints.maxHeight - 28),
                      child: GestureDetector(
                        onTap: () => onPinTap(pin),
                        child: Tooltip(
                          message: '${pin.label}\n${pin.subtitle}',
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: pin.kind == 'load' ? scheme.primary : scheme.secondary,
                              shape: BoxShape.circle,
                              border: Border.all(color: scheme.surface, width: 2),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 4, offset: const Offset(0, 1)),
                              ],
                            ),
                            child: Icon(
                              pin.kind == 'load' ? Icons.inventory_2 : Icons.local_shipping,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  _GridPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    const step = 36.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CarrierCard extends StatelessWidget {
  const _CarrierCard({required this.carrier, required this.onTap});

  final CarrierListing carrier;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return GucCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  carrier.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (carrier.verified)
                GucBadge(label: l10n.verified, tone: GucBadgeTone.success, icon: Icons.verified_outlined),
            ],
          ),
          const SizedBox(height: 4),
          Text('${carrier.baseCity}, ${carrier.baseCountry} · ${carrier.vehicleType}'),
          const SizedBox(height: GucSpacing.xs),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              GucBadge(label: '★ ${carrier.trust.rating.toStringAsFixed(1)}', tone: GucBadgeTone.info),
              GucBadge(label: '${carrier.trust.completedJobs} ${l10n.completedJobs}'),
              GucBadge(
                label: l10n.availableInHours(carrier.availableHours),
                tone: carrier.availableHours <= 24 ? GucBadgeTone.success : GucBadgeTone.warning,
              ),
              if (carrier.matchScore != null)
                GucBadge(label: '${l10n.matchScore} ${carrier.matchScore}%', tone: GucBadgeTone.success),
            ],
          ),
        ],
      ),
    );
  }
}

class CarrierDetailScreen extends ConsumerWidget {
  const CarrierDetailScreen({super.key, required this.carrierId});

  final String carrierId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return FutureBuilder<CarrierListing?>(
      future: ref.read(marketplaceRepositoryProvider).getCarrier(carrierId),
      builder: (context, snapshot) {
        final carrier = snapshot.data;
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (carrier == null) {
          return Scaffold(appBar: AppBar(), body: GucEmptyState(title: l10n.noData));
        }
        return Scaffold(
          appBar: AppBar(title: Text(carrier.name)),
          body: ListView(
            padding: const EdgeInsets.all(GucSpacing.md),
            children: [
              if (carrier.verified)
                GucBadge(label: l10n.verifiedCarrier, tone: GucBadgeTone.success, icon: Icons.verified_outlined),
              const SizedBox(height: GucSpacing.md),
              _row(context, l10n.baseLabel, '${carrier.baseCity}, ${carrier.baseCountry}'),
              _row(context, l10n.vehicleType, carrier.vehicleType),
              _row(context, l10n.capacity, '${carrier.capacityKg.toStringAsFixed(0)} kg'),
              if (carrier.plate != null) _row(context, l10n.plate, carrier.plate!),
              _row(context, l10n.trustScore, carrier.trust.rating.toStringAsFixed(1)),
              _row(context, l10n.completedJobs, '${carrier.trust.completedJobs}'),
              _row(context, l10n.onTimeRate, '${(carrier.trust.onTimeRate * 100).toStringAsFixed(0)}%'),
              _row(context, l10n.delayRate, '${(carrier.trust.delayRate * 100).toStringAsFixed(0)}%'),
              _row(context, l10n.liveAvailability, l10n.availableInHours(carrier.availableHours)),
              _row(context, l10n.corridors, carrier.corridors.map(MockCorridors.labelOf).whereType<String>().join(' · ')),
              const SizedBox(height: GucSpacing.lg),
              Text(l10n.matchingHint),
              const SizedBox(height: GucSpacing.md),
              GucButton(
                label: l10n.createLoad,
                onPressed: () => context.push('/loads/create'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _row(BuildContext context, String label, String value) {
    return ListTile(contentPadding: EdgeInsets.zero, title: Text(label), subtitle: Text(value));
  }
}
