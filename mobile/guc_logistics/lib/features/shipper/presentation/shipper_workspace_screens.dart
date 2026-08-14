import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/data/mock/mock_data.dart';
import '../../../core/di/providers.dart';
import '../../../core/domain/models.dart';
import '../../../core/domain/ops_models.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/guc_theme.dart';
import '../../../core/widgets/guc_widgets.dart';
import '../../ops/presentation/ops_screens.dart';

class ShipperToolsScreen extends ConsumerWidget {
  const ShipperToolsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tiles = [
      (Icons.route_outlined, l10n.routeTemplates, '/shipper/templates'),
      (Icons.compare_arrows, l10n.compareOffers, '/shipper/compare-offers'),
      (Icons.local_shipping_outlined, l10n.activeTracking, '/ops/tracking'),
      (Icons.map_outlined, l10n.liveMapOsm, '/shipper/live-map'),
      (Icons.payments_outlined, l10n.escrowSummary, '/shipper/payments'),
      (Icons.account_balance_wallet_outlined, l10n.paymentLedger, '/shipper/ledger'),
      (Icons.receipt_long_outlined, l10n.billingInfo, '/shipper/billing'),
      (Icons.picture_as_pdf_outlined, l10n.eInvoice, '/shipper/einvoice'),
      (Icons.gavel_outlined, l10n.claims, '/shipper/claims'),
      (Icons.insights_outlined, l10n.reports, '/shipper/reports'),
      (Icons.star_outline, l10n.favoriteCarriers, '/shipper/favorites'),
      (Icons.notifications_active_outlined, l10n.notificationPrefs, '/shipper/notifications'),
      (Icons.phonelink_ring_outlined, l10n.pushSimulation, '/shipper/push'),
      (Icons.admin_panel_settings_outlined, l10n.dispatcherPermissions, '/shipper/permissions'),
      (Icons.layers_outlined, l10n.batchLoads, '/loads/batch'),
      (Icons.folder_outlined, l10n.documents, '/ops/documents'),
      (Icons.groups_outlined, l10n.team, '/ops/team'),
      (Icons.description_outlined, l10n.contractTemplates, '/shipper/contracts'),
      (Icons.rate_review_outlined, l10n.ratings, '/shipper/ratings'),
      (Icons.hub_outlined, l10n.apiErp, '/shipper/api'),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.shipperTools)),
      body: ListView.separated(
        padding: const EdgeInsets.all(GucSpacing.md),
        itemCount: tiles.length,
        separatorBuilder: (_, __) => const SizedBox(height: GucSpacing.sm),
        itemBuilder: (context, i) {
          final t = tiles[i];
          return GucCard(
            onTap: () => context.push(t.$3),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(t.$1, color: Theme.of(context).colorScheme.primary),
              title: Text(t.$2),
              trailing: const Icon(Icons.chevron_right),
            ),
          );
        },
      ),
    );
  }
}

class RouteTemplatesScreen extends ConsumerWidget {
  const RouteTemplatesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final items = MockData.routeTemplates;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.routeTemplates)),
      body: ListView.separated(
        padding: const EdgeInsets.all(GucSpacing.md),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: GucSpacing.sm),
        itemBuilder: (context, i) {
          final t = items[i];
          return GucCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                Text('${t.factoryName} · ${t.pickupCity} → ${t.dropoffCity}'),
                Text('${t.weightTons} t · ${t.loadType}'),
                const SizedBox(height: GucSpacing.sm),
                GucButton(
                  label: l10n.republishFromTemplate,
                  onPressed: () => context.push('/loads/create?template=${t.id}'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CompareOffersScreen extends ConsumerWidget {
  const CompareOffersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final favorites = ref.watch(appSettingsProvider).favoriteCarriers;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.compareOffers)),
      body: FutureBuilder<List<OfferItem>>(
        future: ref.read(offersRepositoryProvider).listMine(),
        builder: (context, snap) {
          final items = (snap.data ?? const []).where((o) => o.status == 'PENDING' || o.status == 'COUNTERED').toList()
            ..sort((a, b) => a.amount.compareTo(b.amount));
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          if (items.isEmpty) return GucEmptyState(title: l10n.noData, subtitle: l10n.compareOffersEmpty);

          return ListView(
            padding: const EdgeInsets.all(GucSpacing.md),
            children: [
              Text(l10n.compareOffersHint),
              const SizedBox(height: GucSpacing.md),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  showCheckboxColumn: false,
                  columns: [
                    DataColumn(label: Text(l10n.carrier)),
                    DataColumn(label: Text(l10n.amount)),
                    DataColumn(label: Text(l10n.transitTime)),
                    DataColumn(label: Text(l10n.trustScore)),
                    DataColumn(label: Text(l10n.favorite)),
                  ],
                  rows: items.map((o) {
                    final fav = o.carrierId != null && favorites.contains(o.carrierId);
                    return DataRow(
                      cells: [
                        DataCell(Text(o.carrierName ?? '—')),
                        DataCell(Text('${o.amount.toStringAsFixed(0)} ${o.currency}')),
                        DataCell(Text(o.transitHours == null ? '—' : '${o.transitHours}h')),
                        DataCell(Text(o.trustScore?.toStringAsFixed(1) ?? '—')),
                        DataCell(Icon(fav ? Icons.star : Icons.star_border, color: fav ? Colors.amber : null)),
                      ],
                      onSelectChanged: (_) => context.push('/offers/${o.id}'),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class EscrowSummaryScreen extends ConsumerWidget {
  const EscrowSummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(shipmentsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.escrowSummary)),
      body: async.when(
        data: (items) {
          double held = 0, released = 0, paid = 0;
          for (final s in items) {
            if (s.paymentStatus == 'HELD') held += s.agreedAmount;
            if (s.paymentStatus == 'RELEASED') released += s.agreedAmount;
            if (s.paymentStatus == 'PAID') paid += s.agreedAmount;
          }
          return ListView(
            padding: const EdgeInsets.all(GucSpacing.md),
            children: [
              _moneyCard(context, l10n.paymentStatus('HELD'), held, GucBadgeTone.warning),
              const SizedBox(height: GucSpacing.sm),
              _moneyCard(context, l10n.paymentStatus('RELEASED'), released, GucBadgeTone.info),
              const SizedBox(height: GucSpacing.sm),
              _moneyCard(context, l10n.paymentStatus('PAID'), paid, GucBadgeTone.success),
              const SizedBox(height: GucSpacing.lg),
              ...items.map(
                (s) => Padding(
                  padding: const EdgeInsets.only(bottom: GucSpacing.sm),
                  child: GucCard(
                    onTap: () => context.push('/ops/tracking/${s.id}'),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                        Text('${s.agreedAmount.toStringAsFixed(0)} ${s.currency} · ${l10n.paymentStatus(s.paymentStatus)}'),
                        Text('${l10n.eta}: ${_eta(s)}'),
                        if (_delayed(s)) GucBadge(label: l10n.delayAlert, tone: GucBadgeTone.danger, icon: Icons.warning_amber),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => GucErrorState(message: l10n.offlineOrError, onRetry: () => ref.invalidate(shipmentsProvider)),
      ),
    );
  }

  Widget _moneyCard(BuildContext context, String label, double amount, GucBadgeTone tone) {
    return GucCard(
      child: Row(
        children: [
          Expanded(child: Text(label, style: Theme.of(context).textTheme.titleSmall)),
          Text('€${amount.toStringAsFixed(0)}', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  String _eta(ShipmentTrack s) {
    if (s.currentCode == 'DELIVERED') return '—';
    final hours = s.currentCode == 'IN_TRANSIT' ? 6 : 18;
    return DateTime.now().add(Duration(hours: hours)).toLocal().toString().substring(0, 16);
  }

  bool _delayed(ShipmentTrack s) => s.currentCode == 'IN_TRANSIT' && s.cmrPhotoName == null;
}

class BillingInfoScreen extends ConsumerStatefulWidget {
  const BillingInfoScreen({super.key});

  @override
  ConsumerState<BillingInfoScreen> createState() => _BillingInfoScreenState();
}

class _BillingInfoScreenState extends ConsumerState<BillingInfoScreen> {
  late final TextEditingController _vat;
  late final TextEditingController _email;
  late final TextEditingController _company;

  @override
  void initState() {
    super.initState();
    _vat = TextEditingController(text: MockData.billingVat);
    _email = TextEditingController(text: MockData.invoiceEmail);
    _company = TextEditingController(text: MockData.companyName);
  }

  @override
  void dispose() {
    _vat.dispose();
    _email.dispose();
    _company.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.billingInfo)),
      body: ListView(
        padding: const EdgeInsets.all(GucSpacing.lg),
        children: [
          GucTextField(label: l10n.companyNameLabel, controller: _company),
          const SizedBox(height: GucSpacing.sm),
          GucTextField(label: l10n.vatLabel, controller: _vat),
          const SizedBox(height: GucSpacing.sm),
          GucTextField(label: l10n.invoiceEmail, controller: _email, keyboardType: TextInputType.emailAddress),
          const SizedBox(height: GucSpacing.lg),
          GucButton(
            label: l10n.save,
            onPressed: () {
              MockData.companyName = _company.text.trim();
              MockData.billingVat = _vat.text.trim();
              MockData.companyVat = _vat.text.trim();
              MockData.invoiceEmail = _email.text.trim();
              ref.invalidate(sessionProfileProvider);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.saved)));
            },
          ),
          const SizedBox(height: GucSpacing.sm),
          GucButton(
            label: l10n.eInvoice,
            variant: GucButtonVariant.secondary,
            onPressed: () => context.push('/shipper/einvoice'),
          ),
        ],
      ),
    );
  }
}

class FavoriteCarriersScreen extends ConsumerWidget {
  const FavoriteCarriersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final favs = ref.watch(appSettingsProvider).favoriteCarriers;
    final carriers = MockData.carriers;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.favoriteCarriers)),
      body: ListView.separated(
        itemCount: carriers.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final c = carriers[i];
          final selected = favs.contains(c.id);
          return ListTile(
            title: Text(c.name),
            subtitle: Text('${c.baseCity}, ${c.baseCountry} · ★ ${c.trust.rating}'),
            trailing: IconButton(
              icon: Icon(selected ? Icons.star : Icons.star_border, color: selected ? Colors.amber : null),
              onPressed: () => ref.read(appSettingsProvider.notifier).toggleFavoriteCarrier(c.id),
            ),
            onTap: () => context.push('/market/carriers/${c.id}'),
          );
        },
      ),
    );
  }
}

class NotificationPrefsScreen extends ConsumerWidget {
  const NotificationPrefsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final s = ref.watch(appSettingsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.notificationPrefs)),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text(l10n.pushNotifications),
            value: s.pushEnabled,
            onChanged: (v) => ref.read(appSettingsProvider.notifier).setPushEnabled(v),
          ),
          SwitchListTile(
            title: Text(l10n.notifyNewOffers),
            value: s.notifyNewOffers,
            onChanged: (v) => ref.read(appSettingsProvider.notifier).setNotifyNewOffers(v),
          ),
          SwitchListTile(
            title: Text(l10n.notifyCounters),
            value: s.notifyCounters,
            onChanged: (v) => ref.read(appSettingsProvider.notifier).setNotifyCounters(v),
          ),
          SwitchListTile(
            title: Text(l10n.notifyMatches),
            value: s.notifyMatches,
            onChanged: (v) => ref.read(appSettingsProvider.notifier).setNotifyMatches(v),
          ),
        ],
      ),
    );
  }
}

class BatchCreateLoadsScreen extends ConsumerStatefulWidget {
  const BatchCreateLoadsScreen({super.key});

  @override
  ConsumerState<BatchCreateLoadsScreen> createState() => _BatchCreateLoadsScreenState();
}

class _BatchCreateLoadsScreenState extends ConsumerState<BatchCreateLoadsScreen> {
  int _count = 2;
  bool _loading = false;

  Future<void> _publish() async {
    setState(() => _loading = true);
    final batchId = 'batch-${DateTime.now().millisecondsSinceEpoch}';
    final tpl = MockData.routeTemplates.first;
    for (var i = 0; i < _count; i++) {
      final day = DateTime.now().add(Duration(days: 2 + i));
      await ref.read(loadsRepositoryProvider).createLoad({
        'title': '${tpl.factoryName} · batch ${i + 1}',
        'factoryName': tpl.factoryName,
        'contactPhone': tpl.contactPhone,
        'contactPerson': tpl.contactPerson,
        'doorRamp': tpl.doorRamp,
        'pickupCity': tpl.pickupCity,
        'pickupCountry': tpl.pickupCountry,
        'dropoffCity': tpl.dropoffCity,
        'dropoffCountry': tpl.dropoffCountry,
        'weightKg': tpl.weightTons * 1000,
        'vehicleRequirements': tpl.vehicleType,
        'loadType': tpl.loadType,
        'currency': 'EUR',
        'price': 1400 + i * 50,
        'loadDate': day.copyWith(hour: 8).toIso8601String(),
        'deliveryDate': day.add(const Duration(days: 2)).copyWith(hour: 17).toIso8601String(),
        'adr': tpl.adr,
        'coldChain': tpl.coldChain,
        'tailLift': tpl.tailLift,
        'forklift': tpl.forklift,
        'batchId': batchId,
      });
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).batchPublished)));
      context.go('/loads');
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.batchLoads)),
      body: Padding(
        padding: const EdgeInsets.all(GucSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.batchLoadsHint),
            const SizedBox(height: GucSpacing.lg),
            Text('${l10n.batchCount}: $_count'),
            Slider(value: _count.toDouble(), min: 2, max: 5, divisions: 3, onChanged: (v) => setState(() => _count = v.round())),
            const Spacer(),
            GucButton(label: l10n.publishBatch, loading: _loading, onPressed: _publish),
          ],
        ),
      ),
    );
  }
}

class ContractsScreen extends StatelessWidget {
  const ContractsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.contractTemplates)),
      body: ListView(
        padding: const EdgeInsets.all(GucSpacing.md),
        children: [
          GucCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(MockData.contractTemplate, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: GucSpacing.sm),
                Text(l10n.contractTemplateBody),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RatingsScreen extends ConsumerStatefulWidget {
  const RatingsScreen({super.key});

  @override
  ConsumerState<RatingsScreen> createState() => _RatingsScreenState();
}

class _RatingsScreenState extends ConsumerState<RatingsScreen> {
  int _score = 5;
  final _comment = TextEditingController();

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.ratings)),
      body: ListView(
        padding: const EdgeInsets.all(GucSpacing.lg),
        children: [
          Text(l10n.rateDeliveryHint),
          const SizedBox(height: GucSpacing.md),
          Row(
            children: List.generate(
              5,
              (i) => IconButton(
                onPressed: () => setState(() => _score = i + 1),
                icon: Icon(i < _score ? Icons.star : Icons.star_border, color: Colors.amber),
              ),
            ),
          ),
          GucTextField(label: l10n.message, controller: _comment, maxLines: 3),
          const SizedBox(height: GucSpacing.md),
          GucButton(
            label: l10n.submitRating,
            onPressed: () {
              MockData.ratings.insert(
                0,
                DeliveryRating(
                  id: 'rate-${DateTime.now().millisecondsSinceEpoch}',
                  matchId: 'match-1',
                  carrierName: MockData.driverDisplayName,
                  score: _score,
                  comment: _comment.text.trim().isEmpty ? null : _comment.text.trim(),
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.saved)));
              setState(() {});
            },
          ),
          const SizedBox(height: GucSpacing.lg),
          ...MockData.ratings.map(
            (r) => ListTile(
              leading: Text('${r.score}★'),
              title: Text(r.carrierName),
              subtitle: Text(r.comment ?? '—'),
            ),
          ),
        ],
      ),
    );
  }
}

class ApiErpScreen extends StatefulWidget {
  const ApiErpScreen({super.key});

  @override
  State<ApiErpScreen> createState() => _ApiErpScreenState();
}

class _ApiErpScreenState extends State<ApiErpScreen> {
  late final TextEditingController _endpoint;

  @override
  void initState() {
    super.initState();
    _endpoint = TextEditingController(text: MockData.erpEndpoint ?? 'https://erp.example.com/api/loads');
  }

  @override
  void dispose() {
    _endpoint.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.apiErp)),
      body: Padding(
        padding: const EdgeInsets.all(GucSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.apiErpHint),
            const SizedBox(height: GucSpacing.md),
            GucTextField(label: l10n.erpEndpoint, controller: _endpoint),
            const SizedBox(height: GucSpacing.lg),
            GucButton(
              label: l10n.save,
              onPressed: () {
                MockData.erpEndpoint = _endpoint.text.trim();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.saved)));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class LiveMapMockScreen extends ConsumerWidget {
  const LiveMapMockScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(shipmentsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.liveMapMock)),
      body: async.when(
        data: (items) {
          if (items.isEmpty) return GucEmptyState(title: l10n.noData);
          final s = items.first;
          return ListView(
            padding: const EdgeInsets.all(GucSpacing.md),
            children: [
              Text(l10n.liveMapMockHint),
              const SizedBox(height: GucSpacing.md),
              AspectRatio(
                aspectRatio: 16 / 10,
                child: GucCard(
                  padding: EdgeInsets.zero,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                              Theme.of(context).colorScheme.surface,
                            ],
                          ),
                        ),
                      ),
                      const Positioned(left: 40, top: 50, child: Icon(Icons.trip_origin, size: 28)),
                      const Positioned(right: 50, bottom: 40, child: Icon(Icons.flag, size: 28)),
                      const Positioned(left: 120, top: 90, child: Icon(Icons.local_shipping, size: 36, color: Colors.blue)),
                      Positioned(
                        left: 12,
                        bottom: 12,
                        child: Text('${s.title}\n${l10n.eta}: ${_etaLabel(s)}\n${l10n.trackLabel(s.currentCode)}'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: GucSpacing.md),
              if (s.cmrPhotoName == null) GucBadge(label: l10n.awaitingCmr, tone: GucBadgeTone.warning),
              if (_delayed(s)) ...[
                const SizedBox(height: GucSpacing.sm),
                GucBadge(label: l10n.delayAlert, tone: GucBadgeTone.danger, icon: Icons.warning_amber),
              ],
              const SizedBox(height: GucSpacing.md),
              GucButton(label: l10n.openTracking, onPressed: () => context.push('/ops/tracking/${s.id}')),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => GucErrorState(message: l10n.offlineOrError, onRetry: () => ref.invalidate(shipmentsProvider)),
      ),
    );
  }

  String _etaLabel(ShipmentTrack s) {
    final hours = s.currentCode == 'IN_TRANSIT' ? 6 : 18;
    return DateTime.now().add(Duration(hours: hours)).toLocal().toString().substring(0, 16);
  }

  bool _delayed(ShipmentTrack s) => s.currentCode == 'IN_TRANSIT' && s.cmrPhotoName == null;
}
