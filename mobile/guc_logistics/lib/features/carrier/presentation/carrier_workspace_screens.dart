import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/data/mock/europe_geo.dart';
import '../../../core/data/mock/mock_data.dart';
import '../../../core/domain/models.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/guc_theme.dart';
import '../../../core/widgets/guc_widgets.dart';
import '../../marketplace/presentation/marketplace_screen.dart';

class CarrierEarningsScreen extends ConsumerWidget {
  const CarrierEarningsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final fmt = DateFormat.yMMMd();
    final items = [...MockData.earnings]..sort((a, b) => b.at.compareTo(a.at));
    final balance = MockData.earningsBalanceTry;
    final month = DateTime.now().month;
    final monthTotal = items
        .where((e) => e.at.month == month && e.at.year == DateTime.now().year)
        .fold<double>(0, (a, b) => a + b.amount);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.earningsWallet)),
      body: ListView(
        padding: const EdgeInsets.all(GucSpacing.md),
        children: [
          GucCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.walletBalance, style: Theme.of(context).textTheme.labelLarge),
                Text(
                  '₺${balance.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Text('${l10n.thisMonth}: ₺${monthTotal.toStringAsFixed(0)}'),
                Text(l10n.earningsHint, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(height: GucSpacing.md),
          Text(l10n.jobHistory, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: GucSpacing.sm),
          if (items.isEmpty)
            GucEmptyState(title: l10n.noData)
          else
            ...items.map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: GucSpacing.sm),
                child: GucCard(
                  onTap: () => context.push('/matches/${e.matchId}'),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(e.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                    subtitle: Text('${e.route}\n${fmt.format(e.at)} · ${e.status}'),
                    isThreeLine: true,
                    trailing: Text(
                      '+${e.amount.toStringAsFixed(0)} ${e.currency}',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class CarrierAvailabilityScreen extends ConsumerStatefulWidget {
  const CarrierAvailabilityScreen({super.key});

  @override
  ConsumerState<CarrierAvailabilityScreen> createState() => _CarrierAvailabilityScreenState();
}

class _CarrierAvailabilityScreenState extends ConsumerState<CarrierAvailabilityScreen> {
  late CarrierAvailability _a;

  @override
  void initState() {
    super.initState();
    _a = MockData.carrierAvailability;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final regions = EuropeGeo.regionsFor(_a.country);
    final cities = EuropeGeo.citiesFor(country: _a.country, region: _a.region);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.myAvailability)),
      body: ListView(
        padding: const EdgeInsets.all(GucSpacing.md),
        children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.availableForLoads),
            subtitle: Text(l10n.availableForLoadsHint),
            value: _a.available,
            onChanged: (v) => setState(() => _a = _a.copyWith(available: v)),
          ),
          DropdownButtonFormField<String>(
            value: _a.country,
            decoration: InputDecoration(labelText: l10n.country),
            items: EuropeGeo.countries.map((c) => DropdownMenuItem(value: c, child: Text(EuropeGeo.countryLabel(c)))).toList(),
            onChanged: (v) {
              if (v == null) return;
              final r = EuropeGeo.regionsFor(v).first;
              final city = EuropeGeo.citiesFor(country: v, region: r).first;
              setState(() => _a = _a.copyWith(country: v, region: r, city: city));
            },
          ),
          const SizedBox(height: GucSpacing.sm),
          DropdownButtonFormField<String>(
            value: regions.contains(_a.region) ? _a.region : regions.first,
            decoration: InputDecoration(labelText: l10n.regionState),
            items: regions.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
            onChanged: (v) {
              if (v == null) return;
              final city = EuropeGeo.citiesFor(country: _a.country, region: v).first;
              setState(() => _a = _a.copyWith(region: v, city: city));
            },
          ),
          const SizedBox(height: GucSpacing.sm),
          DropdownButtonFormField<String>(
            value: cities.contains(_a.city) ? _a.city : (cities.isNotEmpty ? cities.first : null),
            decoration: InputDecoration(labelText: l10n.city),
            items: cities.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
            onChanged: (v) => setState(() => _a = _a.copyWith(city: v)),
          ),
          const SizedBox(height: GucSpacing.md),
          Text('${l10n.minAcceptPrice}: ₺${_a.minPriceTry.toStringAsFixed(0)}'),
          Slider(
            value: _a.minPriceTry.clamp(5000, 80000),
            min: 5000,
            max: 80000,
            divisions: 15,
            onChanged: (v) => setState(() => _a = _a.copyWith(minPriceTry: v.roundToDouble())),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.adrReady),
            value: _a.adrReady,
            onChanged: (v) => setState(() => _a = _a.copyWith(adrReady: v)),
          ),
          DropdownButtonFormField<String>(
            value: _a.vehicleFilter,
            decoration: InputDecoration(labelText: l10n.vehicleType),
            items: const ['Any', 'Curtain trailer', 'Reefer trailer', 'Lowbed', 'Flatbed', 'Box truck 18t']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => setState(() => _a = _a.copyWith(vehicleFilter: v)),
          ),
          const SizedBox(height: GucSpacing.lg),
          GucButton(
            label: l10n.save,
            onPressed: () {
              MockData.carrierAvailability = _a;
              ref.invalidate(marketLoadsProvider);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.saved)));
              context.pop();
            },
          ),
        ],
      ),
    );
  }
}
