import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/config/app_config.dart';
import '../../../core/data/mock/mock_data.dart';
import '../../../core/di/providers.dart';
import '../../../core/domain/models.dart';
import '../../../core/domain/ops_models.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/services/platform_services.dart';
import '../../../core/theme/guc_theme.dart';
import '../../../core/widgets/guc_widgets.dart';
import '../../notifications/presentation/notifications_screen.dart';
import '../../ops/presentation/ops_screens.dart';

class ClaimsScreen extends ConsumerStatefulWidget {
  const ClaimsScreen({super.key});

  @override
  ConsumerState<ClaimsScreen> createState() => _ClaimsScreenState();
}

class _ClaimsScreenState extends ConsumerState<ClaimsScreen> {
  Future<void> _create() async {
    final l10n = AppLocalizations.of(context);
    var type = 'DELAY';
    final details = TextEditingController();
    final amount = TextEditingController(text: '100');
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: Text(l10n.openClaim),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: type,
                items: [
                  DropdownMenuItem(value: 'DELAY', child: Text(l10n.claimDelay)),
                  DropdownMenuItem(value: 'DAMAGE', child: Text(l10n.claimDamage)),
                  DropdownMenuItem(value: 'PAYMENT', child: Text(l10n.claimPayment)),
                ],
                onChanged: (v) => setLocal(() => type = v ?? 'DELAY'),
              ),
              TextField(controller: details, decoration: InputDecoration(labelText: l10n.message), maxLines: 3),
              TextField(controller: amount, decoration: InputDecoration(labelText: l10n.amount), keyboardType: TextInputType.number),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.back)),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.save)),
          ],
        ),
      ),
    );
    if (ok == true) {
      MockData.claims.insert(
        0,
        DisputeClaim(
          id: 'claim-${DateTime.now().millisecondsSinceEpoch}',
          loadId: 'load-3',
          matchId: 'match-1',
          type: type,
          title: type,
          status: 'OPEN',
          createdAt: DateTime.now(),
          details: details.text.trim(),
          amount: double.tryParse(amount.text),
        ),
      );
      setState(() {});
    }
    details.dispose();
    amount.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.claims)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _create,
        icon: const Icon(Icons.gavel),
        label: Text(l10n.openClaim),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(GucSpacing.md, GucSpacing.md, GucSpacing.md, 88),
        itemCount: MockData.claims.length,
        separatorBuilder: (_, __) => const SizedBox(height: GucSpacing.sm),
        itemBuilder: (context, i) {
          final c = MockData.claims[i];
          return GucCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                Text(c.details ?? ''),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  children: [
                    GucBadge(label: c.type),
                    GucBadge(label: c.status, tone: c.status == 'OPEN' ? GucBadgeTone.warning : GucBadgeTone.success),
                    if (c.amount != null) GucBadge(label: '€${c.amount!.toStringAsFixed(0)}'),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class PaymentLedgerScreen extends ConsumerStatefulWidget {
  const PaymentLedgerScreen({super.key});

  @override
  ConsumerState<PaymentLedgerScreen> createState() => _PaymentLedgerScreenState();
}

class _PaymentLedgerScreenState extends ConsumerState<PaymentLedgerScreen> {
  void _simulatePayout() {
    final l10n = AppLocalizations.of(context);
    MockData.ledger.insert(
      0,
      PaymentLedgerEntry(
        id: 'led-${DateTime.now().millisecondsSinceEpoch}',
        shipmentId: 'ship-1',
        label: 'Escrow release after delivery',
        amount: 2050,
        currency: 'EUR',
        kind: 'RELEASE',
        at: DateTime.now(),
      ),
    );
    MockData.ledger.insert(
      0,
      PaymentLedgerEntry(
        id: 'led-${DateTime.now().millisecondsSinceEpoch + 1}',
        shipmentId: 'ship-1',
        label: 'Carrier payout',
        amount: 1988.5,
        currency: 'EUR',
        kind: 'PAYOUT',
        at: DateTime.now(),
      ),
    );
    final i = MockData.shipments.indexWhere((s) => s.id == 'ship-1');
    if (i >= 0) {
      final s = MockData.shipments[i];
      MockData.shipments[i] = ShipmentTrack(
        id: s.id,
        matchId: s.matchId,
        loadId: s.loadId,
        title: s.title,
        route: s.route,
        steps: s.steps,
        paymentStatus: 'PAID',
        agreedAmount: s.agreedAmount,
        currency: s.currency,
        cmrPhotoName: s.cmrPhotoName,
        escrowHeld: false,
      );
    }
    ref.invalidate(shipmentsProvider);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.saved)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final fmt = DateFormat.MMMd().add_Hm();
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.paymentLedger),
        actions: [
          IconButton(
            tooltip: l10n.simulatePayout,
            onPressed: MockData.dispatcherPermissions.canManagePayments ? _simulatePayout : null,
            icon: const Icon(Icons.account_balance),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(GucSpacing.md),
        itemCount: MockData.ledger.length,
        separatorBuilder: (_, __) => const SizedBox(height: GucSpacing.sm),
        itemBuilder: (context, i) {
          final e = MockData.ledger[i];
          return GucCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(switch (e.kind) {
                'HOLD' => Icons.lock_outline,
                'RELEASE' => Icons.lock_open,
                'PAYOUT' => Icons.payments_outlined,
                _ => Icons.receipt_long,
              }),
              title: Text(e.label),
              subtitle: Text('${fmt.format(e.at)} · ${e.kind}'),
              trailing: Text('${e.amount.toStringAsFixed(2)} ${e.currency}', style: const TextStyle(fontWeight: FontWeight.w800)),
            ),
          );
        },
      ),
    );
  }
}

class EInvoiceScreen extends ConsumerStatefulWidget {
  const EInvoiceScreen({super.key});

  @override
  ConsumerState<EInvoiceScreen> createState() => _EInvoiceScreenState();
}

class _EInvoiceScreenState extends ConsumerState<EInvoiceScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = MockData.invoiceLocale;
    final body = switch (locale) {
      'tr' => 'E-Fatura taslağı\nFirma: ${MockData.companyName}\nVAT: ${MockData.billingVat}\nE-posta: ${MockData.invoiceEmail}\nTutar: €2.050,00\nDurum: Escrow / bloke',
      'de' => 'E-Rechnung Entwurf\nFirma: ${MockData.companyName}\nUSt-Id: ${MockData.billingVat}\nE-Mail: ${MockData.invoiceEmail}\nBetrag: €2.050,00\nStatus: Treuhand / gehalten',
      'fr' => 'Brouillon e-facture\nSociété: ${MockData.companyName}\nTVA: ${MockData.billingVat}\nEmail: ${MockData.invoiceEmail}\nMontant: €2 050,00\nStatut: Séquestre',
      'pl' => 'Szkic e-faktury\nFirma: ${MockData.companyName}\nNIP/VAT: ${MockData.billingVat}\nEmail: ${MockData.invoiceEmail}\nKwota: €2 050,00\nStatus: Escrow',
      _ => 'E-invoice draft\nCompany: ${MockData.companyName}\nVAT: ${MockData.billingVat}\nEmail: ${MockData.invoiceEmail}\nAmount: €2,050.00\nStatus: Escrow held',
    };

    return Scaffold(
      appBar: AppBar(title: Text(l10n.eInvoice)),
      body: ListView(
        padding: const EdgeInsets.all(GucSpacing.lg),
        children: [
          Text(l10n.invoiceLanguage),
          Wrap(
            spacing: 8,
            children: ['en', 'tr', 'de', 'pl', 'fr']
                .map(
                  (code) => ChoiceChip(
                    label: Text(code.toUpperCase()),
                    selected: locale == code,
                    onSelected: (_) => setState(() => MockData.invoiceLocale = code),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: GucSpacing.lg),
          GucCard(child: Text(body, style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5))),
          const SizedBox(height: GucSpacing.md),
          GucButton(
            label: l10n.sendEInvoice,
            onPressed: () async {
              if (!AppConfig.useMockData) {
                try {
                  await ref.read(apiClientProvider).dio.post('/api/v1/invoices/draft', data: {
                    'locale': MockData.invoiceLocale,
                    'company': MockData.companyName,
                    'vat': MockData.billingVat,
                    'email': MockData.invoiceEmail,
                  });
                } catch (_) {/* stub may be absent */}
              }
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.eInvoiceSent)));
              }
            },
          ),
        ],
      ),
    );
  }
}

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final role = ref.watch(appSettingsProvider).role;
    final driverSide = role?.isDriverSide ?? false;
    final spent = MockData.offers.where((o) => o.status == 'ACCEPTED').fold<double>(0, (a, b) => a + b.amount);
    final revenueTry = MockData.earnings.fold<double>(0, (a, b) => a + b.amount);
    final published = MockData.loads.where((e) => e.status == 'PUBLISHED').length;
    final matched = MockData.loads.where((e) => e.status == 'MATCHED').length;
    final completed = MockData.shipments.where((e) => e.steps.any((s) => s.code == 'DELIVERED' && s.done)).length;
    final totalOffers = MockData.offers.length;
    final acceptedOffers = MockData.offers.where((o) => o.status == 'ACCEPTED').length;
    final conversion = totalOffers == 0 ? 0 : acceptedOffers / totalOffers;
    final onTime = 0.94;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.reports)),
      body: ListView(
        padding: const EdgeInsets.all(GucSpacing.md),
        children: [
          GucCard(
            child: Row(children: [
              Icon(driverSide ? Icons.local_shipping_outlined : Icons.business_outlined, color: GucColors.freightOrange, size: 32),
              const SizedBox(width: GucSpacing.md),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(driverSide ? 'Taşıyıcı performans raporu' : 'Yük veren operasyon raporu', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                Text('Son güncelleme: ${DateFormat('dd.MM.yyyy HH:mm').format(DateTime.now())}'),
              ])),
            ]),
          ),
          const SizedBox(height: GucSpacing.md),
          _stat(context, driverSide ? 'Toplam kazanç' : l10n.monthlySpend, driverSide ? '₺${revenueTry.toStringAsFixed(0)}' : '€${spent.toStringAsFixed(0)}'),
          _stat(context, driverSide ? 'Uygun aktif yükler' : l10n.activeListings, '$published'),
          _stat(context, driverSide ? 'Kazanılan işler' : l10n.matchedLoads, '$matched'),
          _stat(context, 'Tamamlanan sefer', '$completed'),
          _stat(context, 'Teklif başarı oranı', '${(conversion * 100).toStringAsFixed(0)}%'),
          _stat(context, l10n.onTimeRate, '${(onTime * 100).toStringAsFixed(0)}%'),
          const SizedBox(height: GucSpacing.md),
          Text(driverSide ? 'Koridor kazancı' : l10n.corridorSpend, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: GucSpacing.sm),
          ...['DE → FR', 'NL → PL', 'IT → AT'].map(
            (c) => ListTile(
              title: Text(c),
              trailing: Text('€${(800 + c.hashCode % 900).toStringAsFixed(0)}'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: GucSpacing.sm),
      child: GucCard(
        child: Row(
          children: [
            Expanded(child: Text(label)),
            Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}

class DispatcherPermissionsScreen extends StatefulWidget {
  const DispatcherPermissionsScreen({super.key});

  @override
  State<DispatcherPermissionsScreen> createState() => _DispatcherPermissionsScreenState();
}

class _DispatcherPermissionsScreenState extends State<DispatcherPermissionsScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    var p = MockData.dispatcherPermissions;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.dispatcherPermissions)),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text(l10n.permPublish),
            value: p.canPublish,
            onChanged: (v) => setState(() => MockData.dispatcherPermissions = p = p.copyWith(canPublish: v)),
          ),
          SwitchListTile(
            title: Text(l10n.permAcceptOffers),
            value: p.canAcceptOffers,
            onChanged: (v) => setState(() => MockData.dispatcherPermissions = p = p.copyWith(canAcceptOffers: v)),
          ),
          SwitchListTile(
            title: Text(l10n.permManagePayments),
            value: p.canManagePayments,
            onChanged: (v) => setState(() => MockData.dispatcherPermissions = p = p.copyWith(canManagePayments: v)),
          ),
          SwitchListTile(
            title: Text(l10n.permInviteTeam),
            value: p.canInviteTeam,
            onChanged: (v) => setState(() => MockData.dispatcherPermissions = p = p.copyWith(canInviteTeam: v)),
          ),
          Padding(
            padding: const EdgeInsets.all(GucSpacing.md),
            child: Text(l10n.dispatcherPermissionsHint),
          ),
        ],
      ),
    );
  }
}

class PushSimulationScreen extends ConsumerWidget {
  const PushSimulationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final s = ref.watch(appSettingsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.pushSimulation)),
      body: ListView(
        padding: const EdgeInsets.all(GucSpacing.md),
        children: [
          Text(l10n.pushSimulationHint),
          const SizedBox(height: GucSpacing.md),
          GucButton(
            label: l10n.fcmTokenRegistered,
            variant: GucButtonVariant.tonal,
            onPressed: () async {
              final token = await PushService(ref.read(apiClientProvider)).ensureToken();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${l10n.fcmTokenRegistered}: $token')));
              }
            },
          ),
          const SizedBox(height: GucSpacing.sm),
          GucButton(
            label: l10n.simulateNewOfferPush,
            onPressed: s.notifyNewOffers
                ? () async {
                    await PushService(ref.read(apiClientProvider)).simulateIncoming(
                      'New offer',
                      'Nordic Haulage offered €1,420 on Munich → Lyon',
                    );
                    ref.invalidate(notificationsProvider);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.pushDelivered)));
                    }
                  }
                : null,
          ),
          const SizedBox(height: GucSpacing.sm),
          GucButton(
            label: l10n.simulateMatchPush,
            variant: GucButtonVariant.secondary,
            onPressed: s.notifyMatches
                ? () async {
                    await PushService(ref.read(apiClientProvider)).simulateIncoming(
                      'Match confirmed',
                      'Open tracking and chat for Milano → Wien',
                    );
                    ref.invalidate(notificationsProvider);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.pushDelivered)));
                    }
                  }
                : null,
          ),
          const SizedBox(height: GucSpacing.md),
          GucButton(label: l10n.notifications, variant: GucButtonVariant.tonal, onPressed: () => context.push('/notifications')),
        ],
      ),
    );
  }
}

class OsmLiveMapScreen extends ConsumerWidget {
  const OsmLiveMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final shipment = MockData.shipments.isEmpty ? null : MockData.shipments.first;
    final pickup = MockData.cityLatLng['Milan'] ?? const [45.46, 9.19];
    final drop = MockData.cityLatLng['Vienna'] ?? const [48.21, 16.37];
    final truck = LatLng(
      pickup[0] + (drop[0] - pickup[0]) * 0.55,
      pickup[1] + (drop[1] - pickup[1]) * 0.55,
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.liveMapOsm)),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: truck,
                initialZoom: 6.2,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.guclogistics.guc_logistics',
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: [LatLng(pickup[0], pickup[1]), LatLng(drop[0], drop[1])],
                      strokeWidth: 4,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    Marker(point: LatLng(pickup[0], pickup[1]), width: 40, height: 40, child: const Icon(Icons.trip_origin, color: Colors.green)),
                    Marker(point: LatLng(drop[0], drop[1]), width: 40, height: 40, child: const Icon(Icons.flag, color: Colors.red)),
                    Marker(point: truck, width: 48, height: 48, child: const Icon(Icons.local_shipping, color: Colors.blue, size: 36)),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(GucSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(shipment?.title ?? l10n.noData, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                Text('${l10n.eta}: ${DateTime.now().add(const Duration(hours: 6)).toLocal().toString().substring(0, 16)}'),
                Text(l10n.gpsLiveHint),
                const SizedBox(height: GucSpacing.sm),
                GucButton(label: l10n.openTracking, onPressed: () => context.push('/ops/tracking/${shipment?.id ?? 'ship-1'}')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EditLoadScreen extends ConsumerStatefulWidget {
  const EditLoadScreen({super.key, required this.loadId});
  final String loadId;

  @override
  ConsumerState<EditLoadScreen> createState() => _EditLoadScreenState();
}

class _EditLoadScreenState extends ConsumerState<EditLoadScreen> {
  LoadItem? _load;
  late TextEditingController _price;
  late TextEditingController _desc;
  late TextEditingController _phone;
  bool _favoritesOnly = false;
  int _sla = 24;

  @override
  void initState() {
    super.initState();
    _price = TextEditingController();
    _desc = TextEditingController();
    _phone = TextEditingController();
    Future.microtask(() async {
      final load = await ref.read(loadsRepositoryProvider).getLoad(widget.loadId);
      _load = load;
      _price.text = load.price?.toStringAsFixed(0) ?? '';
      _desc.text = load.description ?? '';
      _phone.text = load.contactPhone ?? '';
      _favoritesOnly = load.favoritesOnly;
      _sla = load.offerSlaHours;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _price.dispose();
    _desc.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final load = _load;
    if (load == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: Text(l10n.editLoad)),
      body: ListView(
        padding: const EdgeInsets.all(GucSpacing.lg),
        children: [
          Text(load.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: GucSpacing.md),
          GucTextField(label: l10n.contactPhone, controller: _phone),
          const SizedBox(height: GucSpacing.sm),
          GucTextField(label: l10n.expectedPrice, controller: _price, keyboardType: TextInputType.number),
          const SizedBox(height: GucSpacing.sm),
          GucTextField(label: l10n.description, controller: _desc, maxLines: 3),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.favoritesOnly),
            subtitle: Text(l10n.favoritesOnlyHint),
            value: _favoritesOnly,
            onChanged: (v) => setState(() => _favoritesOnly = v),
          ),
          Text('${l10n.offerSlaHours}: $_sla'),
          Slider(value: _sla.toDouble(), min: 2, max: 48, divisions: 23, onChanged: (v) => setState(() => _sla = v.round())),
          const SizedBox(height: GucSpacing.md),
          Text(l10n.loadPhotos),
          Wrap(
            spacing: 8,
            children: [
              ...load.photos.map((p) => Chip(label: Text(p))),
              ActionChip(
                label: Text(l10n.addPhoto),
                onPressed: () async {
                  final source = await showModalBottomSheet<String>(
                    context: context,
                    builder: (ctx) => SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(leading: const Icon(Icons.photo_camera), title: Text(l10n.takePhoto), onTap: () => Navigator.pop(ctx, 'camera')),
                          ListTile(leading: const Icon(Icons.photo_library), title: Text(l10n.chooseGallery), onTap: () => Navigator.pop(ctx, 'gallery')),
                        ],
                      ),
                    ),
                  );
                  if (source == null) return;
                  await ref.read(loadsRepositoryProvider).addPhoto(load.id, '${source}_${DateTime.now().millisecondsSinceEpoch}.jpg');
                  final updated = await ref.read(loadsRepositoryProvider).getLoad(load.id);
                  if (!mounted) return;
                  setState(() => _load = updated);
                },
              ),
            ],
          ),
          const SizedBox(height: GucSpacing.lg),
          GucButton(
            label: l10n.save,
            onPressed: () async {
              await ref.read(loadsRepositoryProvider).updateLoad(load.id, {
                'contactPhone': _phone.text.trim(),
                'price': double.tryParse(_price.text),
                'description': _desc.text.trim(),
                'favoritesOnly': _favoritesOnly,
                'offerSlaHours': _sla,
              });
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.saved)));
              context.pop();
            },
          ),
          const SizedBox(height: GucSpacing.sm),
          GucButton(
            label: load.status == 'UNPUBLISHED' ? l10n.publishLoad : l10n.unpublishLoad,
            variant: GucButtonVariant.secondary,
            onPressed: () async {
              await ref.read(loadsRepositoryProvider).setPublished(load.id, load.status == 'UNPUBLISHED');
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.saved)));
              context.pop();
            },
          ),
        ],
      ),
    );
  }
}
