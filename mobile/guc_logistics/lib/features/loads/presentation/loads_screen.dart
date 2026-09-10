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
import '../../../core/validation/load_validators.dart';
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
            if (load.pickupAddress != null && load.pickupAddress!.isNotEmpty)
              _InfoRow(label: 'Yükleme adresi', value: load.pickupAddress!),
            if (load.dropoffAddress != null && load.dropoffAddress!.isNotEmpty)
              _InfoRow(label: 'Teslimat adresi', value: load.dropoffAddress!),
            _InfoRow(label: l10n.loadType, value: load.loadType),
            _InfoRow(label: l10n.weightTons, value: '${load.weightTons.toStringAsFixed(1)} t (${load.weightKg.toStringAsFixed(0)} kg)'),
            if (load.palletCount != null) _InfoRow(label: l10n.palletCount, value: '${load.palletCount}'),
            if (load.volumeM3 != null) _InfoRow(label: 'Hacim', value: '${load.volumeM3} m³'),
            if (load.packagingType != null) _InfoRow(label: 'Ambalaj', value: load.packagingType!),
            if (load.cargoValue != null) _InfoRow(label: 'Yük değeri', value: '${load.cargoValue!.toStringAsFixed(0)} ${load.currency}'),
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
                if (load.customsRequired) const GucBadge(label: 'Gümrük', tone: GucBadgeTone.warning),
                if (load.insuranceRequired) const GucBadge(label: 'Ek sigorta', tone: GucBadgeTone.info),
                GucBadge(label: '${l10n.offerSlaHours}: ${load.offerSlaHours}h'),
              ],
            ),
            if (load.photos.isNotEmpty) ...[
              const SizedBox(height: GucSpacing.sm),
              Text(l10n.loadPhotos, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
              Wrap(spacing: 8, children: load.photos.map((p) => Chip(avatar: const Icon(Icons.image_outlined, size: 16), label: Text(p))).toList()),
            ],
            if (role?.isDriverSide == true) ...[
              const SizedBox(height: GucSpacing.md),
              _DriverCompatibilityCard(load: load, availability: MockData.carrierAvailability),
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

class _DriverCompatibilityCard extends StatelessWidget {
  const _DriverCompatibilityCard({required this.load, required this.availability});

  final LoadItem load;
  final CarrierAvailability availability;

  @override
  Widget build(BuildContext context) {
    final checks = <(String, bool)>[
      ('Kapasite uygun', load.weightKg <= availability.capacityKg),
      ('Araç tipi uygun', availability.vehicleFilter == 'Any' || load.vehicleType.toLowerCase().contains(availability.vehicleFilter.toLowerCase().split(' ').first)),
      ('ADR yeterliliği', !load.adr || availability.adrReady),
      ('Soğuk zincir', !load.coldChain || availability.refrigerated),
      ('Lift gereksinimi', !load.tailLift || availability.tailLift),
      ('Tarih uygun', (availability.availableFrom == null || !load.loadDate.isBefore(availability.availableFrom!)) && (availability.availableUntil == null || !load.loadDate.isAfter(availability.availableUntil!))),
    ];
    final passed = checks.where((e) => e.$2).length;
    final compatible = passed == checks.length;
    return GucCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(compatible ? Icons.verified : Icons.warning_amber_rounded, color: compatible ? Colors.green : Colors.orange),
            const SizedBox(width: GucSpacing.sm),
            Expanded(child: Text(compatible ? 'Aracınız bu yüke uygun' : 'Tekliften önce eksikleri kontrol edin', style: const TextStyle(fontWeight: FontWeight.w800))),
            GucBadge(label: '$passed/${checks.length}', tone: compatible ? GucBadgeTone.success : GucBadgeTone.warning),
          ]),
          const SizedBox(height: GucSpacing.sm),
          ...checks.map((c) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(children: [Icon(c.$2 ? Icons.check_circle : Icons.cancel, size: 18, color: c.$2 ? Colors.green : Colors.red), const SizedBox(width: 8), Text(c.$1)]),
              )),
        ],
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
  final _pickupAddress = TextEditingController();
  final _dropoffAddress = TextEditingController();
  final _volume = TextEditingController();
  final _packaging = TextEditingController(text: 'Paletli');
  final _cargoValue = TextEditingController();
  final _customsReference = TextEditingController();
  final _unNumber = TextEditingController();
  final _temperatureMin = TextEditingController(text: '-18');
  final _temperatureMax = TextEditingController(text: '-15');
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
  bool _customsRequired = false;
  bool _insuranceRequired = false;
  double? _pickupLat;
  double? _pickupLng;

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
    _pickupAddress.dispose();
    _dropoffAddress.dispose();
    _volume.dispose();
    _packaging.dispose();
    _cargoValue.dispose();
    _customsReference.dispose();
    _unNumber.dispose();
    _temperatureMin.dispose();
    _temperatureMax.dispose();
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
    final scheduleError = LoadValidators.schedule(_pickupAt, _deliveryAt);
    if (scheduleError != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(scheduleError)));
      return;
    }
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
        'pickupAddress': _pickupAddress.text.trim(),
        'pickupLat': _pickupLat,
        'pickupLng': _pickupLng,
        'dropoffCity': to,
        'dropoffCountry': _dropoffCountry.text.trim().toUpperCase(),
        'dropoffAddress': _dropoffAddress.text.trim(),
        'weightKg': weightKg,
        'volumeM3': double.tryParse(_volume.text.replaceAll(',', '.')),
        'packagingType': _packaging.text.trim(),
        'cargoValue': double.tryParse(_cargoValue.text.replaceAll(',', '.')),
        'vehicleRequirements': _vehicle.text.trim(),
        'loadType': _loadType.text.trim(),
        'currency': 'EUR',
        'price': double.tryParse(_price.text),
        'description': _description.text.trim().isEmpty ? null : _description.text.trim(),
        'loadDate': _pickupAt.toIso8601String(),
        'deliveryDate': _deliveryAt.toIso8601String(),
        'adr': _adr,
        'coldChain': _cold,
        'temperatureMin': _cold ? double.tryParse(_temperatureMin.text.replaceAll(',', '.')) : null,
        'temperatureMax': _cold ? double.tryParse(_temperatureMax.text.replaceAll(',', '.')) : null,
        'unNumber': _adr ? _unNumber.text.trim() : null,
        'tailLift': _tail,
        'forklift': _fork,
        'palletCount': int.tryParse(_pallets.text),
        'favoritesOnly': _favoritesOnly,
        'offerSlaHours': _slaHours,
        'photos': _photos,
        'customsRequired': _customsRequired,
        'customsReference': _customsRequired ? _customsReference.text.trim() : null,
        'insuranceRequired': _insuranceRequired,
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

  Future<void> _useCurrentPickupLocation() async {
    final position = await LocationService().currentPosition();
    if (!mounted) return;
    if (position == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Konum alınamadı. Konum iznini kontrol edin.')));
      return;
    }
    setState(() {
      _pickupLat = position.latitude;
      _pickupLng = position.longitude;
    });
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
            _LoadSectionHeader(icon: Icons.business_outlined, title: l10n.shipperLoadBasics, subtitle: 'İlan sahibi ve yükleme irtibatı'),
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
                    return LoadValidators.weightTons(v);
                  },
                ),
              ),
              const SizedBox(width: GucSpacing.sm),
              Expanded(child: GucTextField(label: l10n.palletCount, controller: _pallets, keyboardType: TextInputType.number)),
            ]),
            const SizedBox(height: GucSpacing.sm),
            Row(children: [
              Expanded(child: GucTextField(label: 'Hacim (m³)', controller: _volume, keyboardType: const TextInputType.numberWithOptions(decimal: true))),
              const SizedBox(width: GucSpacing.sm),
              Expanded(child: GucTextField(label: 'Ambalaj türü', controller: _packaging, validator: req)),
            ]),
            const SizedBox(height: GucSpacing.sm),
            GucTextField(label: 'Yük değeri (EUR)', controller: _cargoValue, keyboardType: const TextInputType.numberWithOptions(decimal: true)),
            const SizedBox(height: GucSpacing.md),
            _LoadSectionHeader(icon: Icons.verified_user_outlined, title: l10n.specialRequirements, subtitle: 'Araç, güvenlik ve mevzuat gereksinimleri'),
            CheckboxListTile(contentPadding: EdgeInsets.zero, value: _adr, onChanged: (v) => setState(() => _adr = v ?? false), title: Text(l10n.reqAdr)),
            CheckboxListTile(contentPadding: EdgeInsets.zero, value: _cold, onChanged: (v) => setState(() => _cold = v ?? false), title: Text(l10n.reqColdChain)),
            if (_cold)
              Row(children: [
                Expanded(child: GucTextField(label: 'Minimum °C', controller: _temperatureMin, keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true), validator: req)),
                const SizedBox(width: GucSpacing.sm),
                Expanded(child: GucTextField(label: 'Maksimum °C', controller: _temperatureMax, keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true), validator: req)),
              ]),
            if (_adr) ...[
              const SizedBox(height: GucSpacing.sm),
              GucTextField(label: 'UN tehlikeli madde numarası', controller: _unNumber, validator: req),
            ],
            CheckboxListTile(contentPadding: EdgeInsets.zero, value: _tail, onChanged: (v) => setState(() => _tail = v ?? false), title: Text(l10n.reqTailLift)),
            CheckboxListTile(contentPadding: EdgeInsets.zero, value: _fork, onChanged: (v) => setState(() => _fork = v ?? false), title: Text(l10n.reqForklift)),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _customsRequired,
              onChanged: (v) => setState(() => _customsRequired = v),
              title: const Text('Gümrük işlemi gerekli'),
              subtitle: const Text('T1/MRN veya gümrük referansı ekleyin'),
            ),
            if (_customsRequired)
              GucTextField(label: 'Gümrük / MRN referansı', controller: _customsReference, validator: req),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _insuranceRequired,
              onChanged: (v) => setState(() => _insuranceRequired = v),
              title: const Text('Ek yük sigortası gerekli'),
            ),
            const SizedBox(height: GucSpacing.md),
            _LoadSectionHeader(icon: Icons.route_outlined, title: l10n.route, subtitle: 'Kesin yükleme ve teslimat noktaları'),
            const SizedBox(height: GucSpacing.sm),
            DropdownButtonFormField<String>(
              initialValue: EuropeGeo.countries.contains(_pickupCountry.text.toUpperCase()) ? _pickupCountry.text.toUpperCase() : 'DE',
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
            GucTextField(label: 'Yükleme açık adresi', controller: _pickupAddress, validator: req, maxLines: 2),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: _useCurrentPickupLocation,
                icon: const Icon(Icons.my_location),
                label: Text(_pickupLat == null ? 'Mevcut konumu yükleme noktası yap' : 'Konum eklendi (${_pickupLat!.toStringAsFixed(4)}, ${_pickupLng!.toStringAsFixed(4)})'),
              ),
            ),
            const SizedBox(height: GucSpacing.sm),
            DropdownButtonFormField<String>(
              initialValue: EuropeGeo.regionsFor(_pickupCountry.text.toUpperCase()).contains(_pickupRegion)
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
              initialValue: EuropeGeo.citiesFor(country: _pickupCountry.text.toUpperCase(), region: _pickupRegion).contains(_pickupCity.text)
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
              Expanded(child: GucTextField(label: l10n.countryCode, controller: _dropoffCountry, validator: LoadValidators.countryCode)),
            ]),
            const SizedBox(height: GucSpacing.sm),
            GucTextField(label: 'Teslimat açık adresi', controller: _dropoffAddress, validator: req, maxLines: 2),
            const SizedBox(height: GucSpacing.md),
            _LoadSectionHeader(icon: Icons.schedule_outlined, title: l10n.schedule, subtitle: 'Gerçekçi yükleme ve teslimat penceresi'),
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

class _LoadSectionHeader extends StatelessWidget {
  const _LoadSectionHeader({required this.icon, required this.title, required this.subtitle});

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: GucSpacing.sm, bottom: GucSpacing.sm),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: GucColors.navy.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: GucColors.navy),
          ),
          const SizedBox(width: GucSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
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
  final _formKey = GlobalKey<FormState>();
  final _amount = TextEditingController();
  final _message = TextEditingController();
  final _plate = TextEditingController();
  final _vehicleType = TextEditingController();
  final _driverName = TextEditingController(text: MockData.driverDisplayName);
  final _driverPhone = TextEditingController(text: MockData.driverPhone);
  final _transitHours = TextEditingController(text: '24');
  List<VehicleItem> _vehicles = const [];
  String? _vehicleId;
  DateTime _availableAt = DateTime.now().add(const Duration(days: 1));
  bool _loading = false;

  String _label(String tr, String en) => Localizations.localeOf(context).languageCode == 'tr' ? tr : en;

  @override
  void initState() {
    super.initState();
    Future<void>(() async {
      try {
        final vehicles = await ref.read(vehiclesRepositoryProvider).listMine();
        if (!mounted) return;
        setState(() {
          _vehicles = vehicles;
          if (vehicles.isNotEmpty) _selectVehicle(vehicles.first, rebuild: false);
        });
      } catch (_) {
        // Manual vehicle entry remains available when the fleet service is offline.
      }
    });
  }

  void _selectVehicle(VehicleItem vehicle, {bool rebuild = true}) {
    void update() {
      _vehicleId = vehicle.id;
      _plate.text = vehicle.plate;
      _vehicleType.text = vehicle.type;
    }
    rebuild ? setState(update) : update();
  }

  @override
  void dispose() {
    _amount.dispose();
    _message.dispose();
    _plate.dispose();
    _vehicleType.dispose();
    _driverName.dispose();
    _driverPhone.dispose();
    _transitHours.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final load = await ref.read(loadsRepositoryProvider).getLoad(widget.loadId);
    if (!mounted) return;
    final selected = _vehicles.where((v) => v.id == _vehicleId);
    final warnings = <String>[
      if (selected.isNotEmpty && load.weightKg > selected.first.capacityKg) 'Yük ağırlığı seçilen aracın kapasitesini aşıyor.',
      if (load.adr && !MockData.carrierAvailability.adrReady) 'ADR yükü için yeterlilik işaretlenmemiş.',
      if (load.coldChain && !MockData.carrierAvailability.refrigerated) 'Soğuk zincir uyumluluğu işaretlenmemiş.',
      if (load.tailLift && !MockData.carrierAvailability.tailLift) 'Yük liftli araç gerektiriyor.',
    ];
    if (warnings.isNotEmpty) {
      final proceed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          icon: const Icon(Icons.warning_amber_rounded, color: Colors.orange),
          title: const Text('Araç uygunluk uyarısı'),
          content: Text(warnings.map((e) => '• $e').join('\n')),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Aracı değiştir')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Yine de devam et')),
          ],
        ),
      );
      if (proceed != true || !mounted) return;
    }
    setState(() => _loading = true);
    try {
      await ref.read(offersRepositoryProvider).submitOffer(
            loadId: widget.loadId,
            amount: double.tryParse(_amount.text.replaceAll(',', '.')) ?? 0,
            currency: 'EUR',
            message: _message.text.trim().isEmpty ? null : _message.text.trim(),
            vehicleId: _vehicleId,
            vehiclePlate: _plate.text.trim().toUpperCase(),
            vehicleType: _vehicleType.text.trim(),
            driverName: _driverName.text.trim(),
            driverPhone: _driverPhone.text.trim(),
            estimatedTransitHours: int.parse(_transitHours.text),
            availableAt: _availableAt,
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
      appBar: AppBar(
        title: const Text('GucLogistics'),
        actions: const [Padding(padding: EdgeInsets.only(right: 16), child: Icon(Icons.notifications_none))],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(GucSpacing.md),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
            Text(
              l10n.submitOffer,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900, color: GucColors.navy),
            ),
            const SizedBox(height: GucSpacing.xs),
            Text(_label('Yük için teklifinizi girin ve yük verene iletin.', 'Enter your offer and send it to the shipper.')),
            const SizedBox(height: GucSpacing.lg),
            Consumer(
              builder: (context, ref, _) => ref.watch(loadDetailProvider(widget.loadId)).when(
                    data: (load) => GucCard(
                      child: Row(
                        children: [
                          const CircleAvatar(child: Icon(Icons.route_outlined)),
                          const SizedBox(width: GucSpacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${load.pickupCity} → ${load.dropoffCity}', style: const TextStyle(fontWeight: FontWeight.w800)),
                                Text('${load.weightKg.toStringAsFixed(0)} kg · ${load.vehicleType}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    loading: () => const LinearProgressIndicator(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
            ),
            const SizedBox(height: GucSpacing.md),
            Text(_label('Teklif bilgileri', 'Offer details'), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: GucSpacing.sm),
            GucTextField(
              label: l10n.amount,
              controller: _amount,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) => (double.tryParse((v ?? '').replaceAll(',', '.')) ?? 0) <= 0 ? l10n.requiredField : null,
            ),
            const SizedBox(height: GucSpacing.sm),
            GucTextField(label: l10n.message, controller: _message, maxLines: 3),
            const SizedBox(height: GucSpacing.lg),
            Text(_label('Araç ve şoför', 'Vehicle and driver'), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            if (_vehicles.isNotEmpty) ...[
              const SizedBox(height: GucSpacing.sm),
              DropdownButtonFormField<String>(
                initialValue: _vehicleId,
                decoration: InputDecoration(labelText: _label('Kayıtlı tırını seç', 'Select a registered truck')),
                items: _vehicles.map((v) => DropdownMenuItem(
                  value: v.id,
                  child: Row(children: [const Icon(Icons.local_shipping_outlined, color: GucColors.freightOrange), const SizedBox(width: 8), Text('${v.plate} · ${v.type}')]),
                )).toList(),
                onChanged: (id) {
                  final matches = _vehicles.where((v) => v.id == id);
                  if (matches.isNotEmpty) _selectVehicle(matches.first);
                },
              ),
            ],
            const SizedBox(height: GucSpacing.sm),
            GucTextField(label: _label('Plaka', 'Plate'), controller: _plate, validator: _required),
            const SizedBox(height: GucSpacing.sm),
            GucTextField(label: _label('Araç tipi (tenteli, frigorifik, lowbed...)', 'Vehicle type (curtainsider, refrigerated, lowbed...)'), controller: _vehicleType, validator: _required),
            const SizedBox(height: GucSpacing.sm),
            GucTextField(label: _label('Şoför adı soyadı', 'Driver full name'), controller: _driverName, validator: _required),
            const SizedBox(height: GucSpacing.sm),
            GucTextField(label: _label('Şoför telefonu', 'Driver phone'), controller: _driverPhone, keyboardType: TextInputType.phone, validator: _phoneValidator),
            const SizedBox(height: GucSpacing.sm),
            GucTextField(label: _label('Tahmini taşıma süresi (saat)', 'Estimated transit time (hours)'), controller: _transitHours, keyboardType: TextInputType.number, validator: _positiveInt),
            const SizedBox(height: GucSpacing.sm),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(_label('Yüklemeye hazır olacağı zaman', 'Ready for loading at')),
              subtitle: Text(DateFormat('dd.MM.yyyy HH:mm').format(_availableAt)),
              trailing: const Icon(Icons.event_outlined),
              onTap: _pickAvailability,
            ),
            const SizedBox(height: GucSpacing.lg),
            GucButton(label: l10n.submitOffer, loading: _loading, onPressed: _submit),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _required(String? value) => (value == null || value.trim().isEmpty) ? AppLocalizations.of(context).requiredField : null;

  String? _phoneValidator(String? value) => (value == null || value.trim().length < 8) ? AppLocalizations.of(context).requiredField : null;

  String? _positiveInt(String? value) => (int.tryParse(value ?? '') ?? 0) <= 0 ? AppLocalizations.of(context).requiredField : null;

  Future<void> _pickAvailability() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _availableAt,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 180)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_availableAt));
    if (time == null || !mounted) return;
    setState(() => _availableAt = DateTime(date.year, date.month, date.day, time.hour, time.minute));
  }
}
