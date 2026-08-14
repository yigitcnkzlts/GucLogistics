import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/data/mock/europe_geo.dart';
import '../../../core/data/mock/mock_data.dart';
import '../../../core/di/providers.dart';
import '../../../core/domain/models.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/services/platform_services.dart';
import '../../../core/theme/guc_theme.dart';
import '../../../core/widgets/guc_load_card.dart';
import '../../../core/widgets/guc_widgets.dart';
import '../../marketplace/data/marketplace_repository.dart';
final loadsListProvider = FutureProvider.autoDispose<List<LoadItem>>((ref) {
  final role = ref.watch(appSettingsProvider).role;
  final availableOnly = role?.isDriverSide ?? false;
  return ref.watch(loadsRepositoryProvider).listLoads(availableOnly: availableOnly);
});

final loadDetailProvider = FutureProvider.autoDispose.family<LoadItem, String>((ref, id) {
  return ref.watch(loadsRepositoryProvider).getLoad(id);
});

class LoadsScreen extends ConsumerWidget {
  const LoadsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final role = ref.watch(appSettingsProvider).role;
    final isShipper = role?.isShipperSide ?? true;
    final loads = ref.watch(loadsListProvider);

    return Scaffold(
      appBar: AppBar(title: Text(isShipper ? l10n.myLoads : l10n.availableLoads)),
      floatingActionButton: isShipper
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/loads/create'),
              icon: const Icon(Icons.add),
              label: Text(l10n.createLoad),
            )
          : null,
      body: loads.when(
        data: (items) {
          if (items.isEmpty) {
            return GucEmptyState(
              title: l10n.noData,
              action: isShipper
                  ? GucButton(
                      label: l10n.createLoad,
                      expanded: false,
                      onPressed: () => context.push('/loads/create'),
                    )
                  : null,
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(loadsListProvider),
            child: ListView.separated(
              padding: const EdgeInsets.all(GucSpacing.md),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: GucSpacing.sm),
              itemBuilder: (context, index) {
                final load = items[index];
                return GucLoadCard(load: load, onTap: () => context.push('/loads/${load.id}'));
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => GucErrorState(
          message: l10n.offlineOrError,
          onRetry: () => ref.invalidate(loadsListProvider),
        ),
      ),
    );
  }
}

class LoadDetailScreen extends ConsumerWidget {
  const LoadDetailScreen({super.key, required this.loadId});

  final String loadId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final role = ref.watch(appSettingsProvider).role;
    final async = ref.watch(loadDetailProvider(loadId));
    final dateFmt = DateFormat.yMMMd().add_Hm();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.loadDetail)),
      body: async.when(
        data: (load) => ListView(
          padding: const EdgeInsets.all(GucSpacing.md),
          children: [
            GucLoadCard(load: load),
            const SizedBox(height: GucSpacing.md),
            if (load.companyName != null && load.companyName!.isNotEmpty)
              _InfoRow(label: l10n.companyNameLabel, value: load.companyName!),
            if (load.factoryName != null && load.factoryName!.isNotEmpty)
              _InfoRow(label: l10n.factoryName, value: load.factoryName!),
            if (load.pickupRegion != null && load.pickupRegion!.isNotEmpty)
              _InfoRow(label: l10n.regionState, value: load.pickupRegion!),
            if (load.contactPerson != null && load.contactPerson!.isNotEmpty)
              _InfoRow(label: l10n.contactPerson, value: load.contactPerson!),
            if (load.contactPhone != null && load.contactPhone!.isNotEmpty)
              _InfoRow(label: l10n.contactPhone, value: load.contactPhone!),
            if (load.doorRamp != null && load.doorRamp!.isNotEmpty)
              _InfoRow(label: l10n.doorRamp, value: load.doorRamp!),
            if (load.referenceNo != null && load.referenceNo!.isNotEmpty)
              _InfoRow(label: l10n.referenceNo, value: load.referenceNo!),
            _InfoRow(label: l10n.loadType, value: load.loadType),
            _InfoRow(label: l10n.weightTons, value: '${load.weightTons.toStringAsFixed(1)} t (${load.weightKg.toStringAsFixed(0)} kg)'),
            if (load.palletCount != null) _InfoRow(label: l10n.palletCount, value: '${load.palletCount}'),
            _InfoRow(label: l10n.vehicleType, value: load.vehicleType),
            Wrap(
              spacing: 8,
              children: [
                if (load.adr) GucBadge(label: l10n.reqAdr, tone: GucBadgeTone.danger),
                if (load.coldChain) GucBadge(label: l10n.reqColdChain, tone: GucBadgeTone.info),
                if (load.tailLift) GucBadge(label: l10n.reqTailLift),
                if (load.forklift) GucBadge(label: l10n.reqForklift),
                if (load.favoritesOnly) GucBadge(label: l10n.favoritesOnly, tone: GucBadgeTone.warning),
                if (load.batchId != null) GucBadge(label: l10n.batchLoads, tone: GucBadgeTone.neutral),
                GucBadge(label: '${l10n.offerSlaHours}: ${load.offerSlaHours}h'),
              ],
            ),
            if (load.photos.isNotEmpty) ...[
              const SizedBox(height: GucSpacing.sm),
              Text(l10n.loadPhotos, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
              Wrap(spacing: 8, children: load.photos.map((p) => Chip(avatar: const Icon(Icons.image_outlined, size: 16), label: Text(p))).toList()),
            ],
            if (load.matchScore != null && role?.isDriverSide == true) ...[
              const SizedBox(height: GucSpacing.sm),
              GucCard(
                child: Row(
                  children: [
                    Icon(Icons.analytics_outlined, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: GucSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.matchScore, style: Theme.of(context).textTheme.labelLarge),
                          Text(
                            '${load.matchScore}%',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                    GucBadge(
                      label: load.matchScore! >= 85 ? l10n.matched : l10n.recommendedLoads,
                      tone: load.matchScore! >= 85 ? GucBadgeTone.success : GucBadgeTone.info,
                    ),
                  ],
                ),
              ),
            ],
            if (load.description != null) ...[
              const SizedBox(height: GucSpacing.md),
              Text(l10n.description, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: GucSpacing.xs),
              Text(load.description!),
            ],
            const SizedBox(height: GucSpacing.md),
            _InfoRow(label: l10n.status, value: l10n.statusLabel(load.status)),
            if (load.price != null)
              _InfoRow(label: l10n.expectedPrice, value: '${load.price!.toStringAsFixed(0)} ${load.currency}'),
            _InfoRow(label: l10n.pickupDateTime, value: dateFmt.format(load.loadDate)),
            _InfoRow(label: l10n.deliveryDateTime, value: dateFmt.format(load.deliveryDate)),
            const SizedBox(height: GucSpacing.sm),
            Text(l10n.matchingHint, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: GucSpacing.lg),
            if (load.status == 'MATCHED' && load.matchId != null)
              GucButton(
                label: l10n.openChat,
                icon: Icons.chat_outlined,
                onPressed: () => context.push('/matches/${load.matchId}'),
              )
            else if (role?.isDriverSide == true)
              GucButton(
                label: l10n.submitOffer,
                onPressed: () => context.push('/loads/$loadId/offer'),
              )
            else ...[
              GucButton(
                label: l10n.incomingOffers,
                variant: GucButtonVariant.secondary,
                onPressed: () => context.go('/offers'),
              ),
              const SizedBox(height: GucSpacing.sm),
              GucButton(
                label: l10n.editLoad,
                onPressed: () => context.push('/loads/${load.id}/edit'),
              ),
              const SizedBox(height: GucSpacing.sm),
              GucButton(
                label: load.status == 'UNPUBLISHED' ? l10n.publishLoad : l10n.unpublishLoad,
                variant: GucButtonVariant.secondary,
                onPressed: () async {
                  await ref.read(loadsRepositoryProvider).setPublished(load.id, load.status == 'UNPUBLISHED');
                  ref.invalidate(loadDetailProvider(loadId));
                  ref.invalidate(loadsListProvider);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.saved)));
                  }
                },
              ),
              const SizedBox(height: GucSpacing.sm),
              GucButton(
                label: l10n.republishLoad,
                variant: GucButtonVariant.tonal,
                onPressed: () async {
                  await ref.read(loadsRepositoryProvider).republishFrom(load);
                  ref.invalidate(loadsListProvider);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.loadPublishedHint)));
                    context.go('/loads');
                  }
                },
              ),
              if (load.matchId != null) ...[
                const SizedBox(height: GucSpacing.sm),
                GucButton(
                  label: l10n.openTracking,
                  onPressed: () => context.push('/ops/tracking'),
                ),
                const SizedBox(height: GucSpacing.sm),
                GucButton(
                  label: l10n.claims,
                  variant: GucButtonVariant.secondary,
                  onPressed: () => context.push('/shipper/claims'),
                ),
              ],
            ],
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => GucErrorState(message: l10n.offlineOrError, onRetry: () => ref.invalidate(loadDetailProvider(loadId))),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyMedium)),
          Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class CreateLoadScreen extends ConsumerStatefulWidget {
  const CreateLoadScreen({super.key, this.templateId});

  final String? templateId;

  @override
  ConsumerState<CreateLoadScreen> createState() => _CreateLoadScreenState();
}

class _CreateLoadScreenState extends ConsumerState<CreateLoadScreen> {
  final _formKey = GlobalKey<FormState>();
  final _company = TextEditingController(text: MockData.companyName);
  final _factory = TextEditingController(text: 'BMW Logistics Plant');
  final _phone = TextEditingController(text: '+49 89 000 0000');
  final _person = TextEditingController(text: 'Anna Keller');
  final _door = TextEditingController(text: 'Dock B2');
  final _ref = TextEditingController();
  final _loadType = TextEditingController(text: 'Palletized');
  final _tons = TextEditingController(text: '8');
  final _pallets = TextEditingController(text: '20');
  final _pickupCity = TextEditingController(text: 'Munich');
  final _pickupCountry = TextEditingController(text: 'DE');
  final _dropoffCity = TextEditingController();
  final _dropoffCountry = TextEditingController(text: 'FR');
  final _vehicle = TextEditingController(text: 'Curtain trailer');
  final _price = TextEditingController(text: '1500');
  final _description = TextEditingController();
  String _pickupRegion = 'Bavaria';
  DateTime _pickupAt = DateTime.now().add(const Duration(days: 2)).copyWith(hour: 8, minute: 0);
  DateTime _deliveryAt = DateTime.now().add(const Duration(days: 4)).copyWith(hour: 17, minute: 0);
  bool _adr = false;
  bool _cold = false;
  bool _tail = false;
  bool _fork = false;
  bool _favoritesOnly = false;
  int _slaHours = 24;
  final _photos = <String>[];
  bool _loading = false;
  bool _saveTemplate = true;

  @override
  void initState() {
    super.initState();
    final id = widget.templateId;
    if (id != null) {
      for (final t in MockData.routeTemplates) {
        if (t.id == id) {
          _factory.text = t.factoryName;
          _phone.text = t.contactPhone ?? '';
          _person.text = t.contactPerson ?? '';
          _door.text = t.doorRamp ?? '';
          _loadType.text = t.loadType;
          _tons.text = t.weightTons.toString();
          _pickupCity.text = t.pickupCity;
          _pickupCountry.text = t.pickupCountry;
          _pickupRegion = EuropeGeo.regionOf(t.pickupCity) ?? _pickupRegion;
          _dropoffCity.text = t.dropoffCity;
          _dropoffCountry.text = t.dropoffCountry;
          _vehicle.text = t.vehicleType;
          _adr = t.adr;
          _cold = t.coldChain;
          _tail = t.tailLift;
          _fork = t.forklift;
          break;
        }
      }
    }
  }

  @override
  void dispose() {
    _factory.dispose();
    _phone.dispose();
    _person.dispose();
    _door.dispose();
    _ref.dispose();
    _loadType.dispose();
    _tons.dispose();
    _pallets.dispose();
    _pickupCity.dispose();
    _company.dispose();
    _pickupCountry.dispose();
    _dropoffCity.dispose();
    _dropoffCountry.dispose();
    _vehicle.dispose();
    _price.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime({required bool pickup}) async {
    final initial = pickup ? _pickupAt : _deliveryAt;
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null) return;
    final value = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    setState(() {
      if (pickup) {
        _pickupAt = value;
      } else {
        _deliveryAt = value;
      }
    });
  }

  Future<void> _submit() async {
    if (!MockData.dispatcherPermissions.canPublish) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).noPublishPermission)));
      return;
    }
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final tons = double.tryParse(_tons.text.replaceAll(',', '.')) ?? 0;
      final weightKg = tons * 1000;
      final companyName = _company.text.trim().isEmpty ? MockData.companyName : _company.text.trim();
      final factoryName = _factory.text.trim();
      final from = _pickupCity.text.trim();
      final to = _dropoffCity.text.trim();
      await ref.read(loadsRepositoryProvider).createLoad({
        'title': '$factoryName · $from to $to',
        'factoryName': factoryName,
        'companyName': companyName,
        'contactPhone': _phone.text.trim(),
        'contactPerson': _person.text.trim(),
        'doorRamp': _door.text.trim(),
        'referenceNo': _ref.text.trim().isEmpty ? null : _ref.text.trim(),
        'pickupCity': from,
        'pickupCountry': _pickupCountry.text.trim().toUpperCase(),
        'pickupRegion': _pickupRegion,
        'dropoffCity': to,
        'dropoffCountry': _dropoffCountry.text.trim().toUpperCase(),
        'weightKg': weightKg,
        'vehicleRequirements': _vehicle.text.trim(),
        'loadType': _loadType.text.trim(),
        'currency': 'EUR',
        'price': double.tryParse(_price.text),
        'description': _description.text.trim().isEmpty ? null : _description.text.trim(),
        'loadDate': _pickupAt.toIso8601String(),
        'deliveryDate': _deliveryAt.toIso8601String(),
        'adr': _adr,
        'coldChain': _cold,
        'tailLift': _tail,
        'forklift': _fork,
        'palletCount': int.tryParse(_pallets.text),
        'favoritesOnly': _favoritesOnly,
        'offerSlaHours': _slaHours,
        'photos': _photos,
      });
      if (_saveTemplate) {
        MockData.routeTemplates.insert(
          0,
          RouteTemplate(
            id: 'tpl-${DateTime.now().millisecondsSinceEpoch}',
            name: '$from → $to',
            factoryName: factoryName,
            pickupCity: from,
            pickupCountry: _pickupCountry.text.trim().toUpperCase(),
            dropoffCity: to,
            dropoffCountry: _dropoffCountry.text.trim().toUpperCase(),
            loadType: _loadType.text.trim(),
            weightTons: tons,
            vehicleType: _vehicle.text.trim(),
            doorRamp: _door.text.trim(),
            contactPerson: _person.text.trim(),
            contactPhone: _phone.text.trim(),
            adr: _adr,
            coldChain: _cold,
            tailLift: _tail,
            forklift: _fork,
          ),
        );
      }
      ref.invalidate(loadsListProvider);
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.loadPublishedHint)));
        context.go('/loads');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final fmt = DateFormat.yMMMd().add_Hm();
    String? req(String? v) => (v == null || v.trim().isEmpty) ? l10n.requiredField : null;
    final verified = MockData.companyVerified;
    final band = MarketplaceRepository(ref.read(apiClientProvider)).bandForLoad(
      LoadItem(
        id: 'tmp',
        title: '',
        loadType: _loadType.text,
        pickupCountry: _pickupCountry.text.trim().toUpperCase(),
        pickupCity: _pickupCity.text.trim(),
        dropoffCountry: _dropoffCountry.text.trim().toUpperCase(),
        dropoffCity: _dropoffCity.text.trim(),
        weightKg: 1000,
        vehicleType: _vehicle.text,
        loadDate: _pickupAt,
        deliveryDate: _deliveryAt,
        status: 'PUBLISHED',
        currency: 'EUR',
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.createLoad),
        actions: [
          TextButton(onPressed: () => context.push('/shipper/templates'), child: Text(l10n.templates)),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(GucSpacing.md),
          children: [
            if (!verified)
              GucCard(
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber, color: Colors.orange),
                    const SizedBox(width: GucSpacing.sm),
                    Expanded(child: Text(l10n.unverifiedPublishWarning)),
                    TextButton(onPressed: () => context.push('/verification'), child: Text(l10n.verification)),
                  ],
                ),
              ),
            if (!verified) const SizedBox(height: GucSpacing.md),
            Text(l10n.createLoadIntro, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: GucSpacing.sm),
            GucBadge(
              label: '${l10n.marketPriceBand}: €${band.minEur.toStringAsFixed(0)}–€${band.maxEur.toStringAsFixed(0)} (${l10n.avg} €${band.avgEur.toStringAsFixed(0)})',
              tone: GucBadgeTone.info,
            ),
            const SizedBox(height: GucSpacing.md),
            Text(l10n.shipperLoadBasics, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: GucSpacing.sm),
            GucTextField(label: l10n.companyNamePublish, controller: _company, validator: req),
            const SizedBox(height: GucSpacing.sm),
            GucTextField(label: l10n.factoryName, controller: _factory, validator: req),
            const SizedBox(height: GucSpacing.sm),
            GucTextField(label: l10n.contactPerson, controller: _person, validator: req),
            const SizedBox(height: GucSpacing.sm),
            GucTextField(label: l10n.contactPhone, controller: _phone, keyboardType: TextInputType.phone, validator: req),
            const SizedBox(height: GucSpacing.sm),
            GucTextField(label: l10n.doorRamp, controller: _door),
            const SizedBox(height: GucSpacing.sm),
            GucTextField(label: l10n.referenceNo, controller: _ref),
            const SizedBox(height: GucSpacing.sm),
            GucTextField(label: l10n.loadType, controller: _loadType, validator: req),
            const SizedBox(height: GucSpacing.sm),
            Row(children: [
              Expanded(
                child: GucTextField(
                  label: l10n.weightTons,
                  controller: _tons,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) {
                    final n = double.tryParse((v ?? '').replaceAll(',', '.'));
                    if (n == null || n <= 0) return l10n.requiredField;
                    return null;
                  },
                ),
              ),
              const SizedBox(width: GucSpacing.sm),
              Expanded(child: GucTextField(label: l10n.palletCount, controller: _pallets, keyboardType: TextInputType.number)),
            ]),
            const SizedBox(height: GucSpacing.md),
            Text(l10n.specialRequirements, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
            CheckboxListTile(contentPadding: EdgeInsets.zero, value: _adr, onChanged: (v) => setState(() => _adr = v ?? false), title: Text(l10n.reqAdr)),
            CheckboxListTile(contentPadding: EdgeInsets.zero, value: _cold, onChanged: (v) => setState(() => _cold = v ?? false), title: Text(l10n.reqColdChain)),
            CheckboxListTile(contentPadding: EdgeInsets.zero, value: _tail, onChanged: (v) => setState(() => _tail = v ?? false), title: Text(l10n.reqTailLift)),
            CheckboxListTile(contentPadding: EdgeInsets.zero, value: _fork, onChanged: (v) => setState(() => _fork = v ?? false), title: Text(l10n.reqForklift)),
            const SizedBox(height: GucSpacing.md),
            Text(l10n.route, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: GucSpacing.sm),
            DropdownButtonFormField<String>(
              value: EuropeGeo.countries.contains(_pickupCountry.text.toUpperCase()) ? _pickupCountry.text.toUpperCase() : 'DE',
              decoration: InputDecoration(labelText: '${l10n.pickup} · ${l10n.country}', border: const OutlineInputBorder()),
              items: EuropeGeo.countries.map((c) => DropdownMenuItem(value: c, child: Text(EuropeGeo.countryLabel(c)))).toList(),
              onChanged: (v) {
                if (v == null) return;
                final regions = EuropeGeo.regionsFor(v);
                setState(() {
                  _pickupCountry.text = v;
                  _pickupRegion = regions.isNotEmpty ? regions.first : '';
                  final cities = EuropeGeo.citiesFor(country: v, region: _pickupRegion);
                  _pickupCity.text = cities.isNotEmpty ? cities.first : '';
                });
              },
              validator: (v) => (v == null || v.isEmpty) ? l10n.requiredField : null,
            ),
            const SizedBox(height: GucSpacing.sm),
            DropdownButtonFormField<String>(
              value: EuropeGeo.regionsFor(_pickupCountry.text.toUpperCase()).contains(_pickupRegion)
                  ? _pickupRegion
                  : (EuropeGeo.regionsFor(_pickupCountry.text.toUpperCase()).isNotEmpty
                      ? EuropeGeo.regionsFor(_pickupCountry.text.toUpperCase()).first
                      : null),
              decoration: InputDecoration(labelText: '${l10n.pickup} · ${l10n.regionState}', border: const OutlineInputBorder()),
              items: EuropeGeo.regionsFor(_pickupCountry.text.toUpperCase())
                  .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                  .toList(),
              onChanged: (v) {
                if (v == null) return;
                final cities = EuropeGeo.citiesFor(country: _pickupCountry.text.toUpperCase(), region: v);
                setState(() {
                  _pickupRegion = v;
                  _pickupCity.text = cities.isNotEmpty ? cities.first : '';
                });
              },
              validator: (v) => (v == null || v.isEmpty) ? l10n.requiredField : null,
            ),
            const SizedBox(height: GucSpacing.sm),
            DropdownButtonFormField<String>(
              value: EuropeGeo.citiesFor(country: _pickupCountry.text.toUpperCase(), region: _pickupRegion).contains(_pickupCity.text)
                  ? _pickupCity.text
                  : (EuropeGeo.citiesFor(country: _pickupCountry.text.toUpperCase(), region: _pickupRegion).isNotEmpty
                      ? EuropeGeo.citiesFor(country: _pickupCountry.text.toUpperCase(), region: _pickupRegion).first
                      : null),
              decoration: InputDecoration(labelText: '${l10n.pickup} · ${l10n.city}', border: const OutlineInputBorder()),
              items: EuropeGeo.citiesFor(country: _pickupCountry.text.toUpperCase(), region: _pickupRegion)
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) {
                if (v == null) return;
                setState(() {
                  _pickupCity.text = v;
                  _pickupRegion = EuropeGeo.regionOf(v) ?? _pickupRegion;
                });
              },
              validator: (v) => (v == null || v.isEmpty) ? l10n.requiredField : null,
            ),
            const SizedBox(height: GucSpacing.sm),
            Row(children: [
              Expanded(child: GucTextField(label: '${l10n.dropoff} · ${l10n.city}', controller: _dropoffCity, validator: req)),
              const SizedBox(width: GucSpacing.sm),
              Expanded(child: GucTextField(label: l10n.countryCode, controller: _dropoffCountry, validator: req)),
            ]),
            const SizedBox(height: GucSpacing.md),
            Text(l10n.schedule, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.pickupDateTime),
              subtitle: Text(fmt.format(_pickupAt)),
              trailing: const Icon(Icons.event),
              onTap: () => _pickDateTime(pickup: true),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.deliveryDateTime),
              subtitle: Text(fmt.format(_deliveryAt)),
              trailing: const Icon(Icons.event_available),
              onTap: () => _pickDateTime(pickup: false),
            ),
            const SizedBox(height: GucSpacing.md),
            GucTextField(label: l10n.vehicleType, controller: _vehicle, validator: req),
            const SizedBox(height: GucSpacing.sm),
            GucTextField(label: '${l10n.expectedPrice} (EUR)', controller: _price, keyboardType: TextInputType.number),
            const SizedBox(height: GucSpacing.sm),
            GucTextField(label: l10n.description, controller: _description, maxLines: 3),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.favoritesOnly),
              subtitle: Text(l10n.favoritesOnlyHint),
              value: _favoritesOnly,
              onChanged: (v) => setState(() => _favoritesOnly = v),
            ),
            Text('${l10n.offerSlaHours}: $_slaHours'),
            Slider(value: _slaHours.toDouble(), min: 2, max: 48, divisions: 23, onChanged: (v) => setState(() => _slaHours = v.round())),
            Text(l10n.loadPhotos),
            Wrap(
              spacing: 8,
              children: [
                ..._photos.map((p) => Chip(label: Text(p))),
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
                    final name = await MediaPickerService().pickPhoto(fromCamera: source == 'camera');
                    if (name != null) setState(() => _photos.add(name));
                  },
                ),
              ],
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.saveAsTemplate),
              value: _saveTemplate,
              onChanged: (v) => setState(() => _saveTemplate = v),
            ),
            const SizedBox(height: GucSpacing.lg),
            GucButton(label: l10n.publishLoad, loading: _loading, onPressed: _submit),
            const SizedBox(height: GucSpacing.sm),
            GucButton(label: l10n.browseEuropeLoads, variant: GucButtonVariant.secondary, onPressed: () => context.go('/market')),
          ],
        ),
      ),
    );
  }
}

class SubmitOfferScreen extends ConsumerStatefulWidget {
  const SubmitOfferScreen({super.key, required this.loadId});

  final String loadId;

  @override
  ConsumerState<SubmitOfferScreen> createState() => _SubmitOfferScreenState();
}

class _SubmitOfferScreenState extends ConsumerState<SubmitOfferScreen> {
  final _amount = TextEditingController();
  final _message = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _amount.dispose();
    _message.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _loading = true);
    try {
      await ref.read(offersRepositoryProvider).submitOffer(
            loadId: widget.loadId,
            amount: double.tryParse(_amount.text) ?? 0,
            currency: 'EUR',
            message: _message.text.trim().isEmpty ? null : _message.text.trim(),
          );
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.saved)));
        context.go('/offers');
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.submitOffer)),
      body: Padding(
        padding: const EdgeInsets.all(GucSpacing.md),
        child: Column(
          children: [
            GucTextField(label: l10n.amount, controller: _amount, keyboardType: TextInputType.number),
            const SizedBox(height: GucSpacing.sm),
            GucTextField(label: l10n.message, controller: _message, maxLines: 3),
            const SizedBox(height: GucSpacing.lg),
            GucButton(label: l10n.submitOffer, loading: _loading, onPressed: _submit),
          ],
        ),
      ),
    );
  }
}
