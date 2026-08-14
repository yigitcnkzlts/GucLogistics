import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../domain/models.dart';
import '../l10n/app_localizations.dart';
import '../theme/guc_theme.dart';
import 'guc_widgets.dart';

class GucLoadCard extends StatelessWidget {
  const GucLoadCard({super.key, required this.load, this.onTap});

  final LoadItem load;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final price = load.price != null
        ? '${load.price!.toStringAsFixed(0)} ${load.currency}'
        : (load.offerStatus ?? load.status);

    return GucCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  load.companyName?.isNotEmpty == true
                      ? load.companyName!
                      : (load.factoryName?.isNotEmpty == true ? load.factoryName! : load.title),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (load.companyVerified)
                GucBadge(label: l10n.verified, tone: GucBadgeTone.success, icon: Icons.verified_outlined),
            ],
          ),
          if (load.factoryName != null && load.factoryName!.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              '${l10n.factoryName}: ${load.factoryName}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          Text(load.title, style: Theme.of(context).textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: GucSpacing.sm),
          _RouteRow(
            from: [
              load.pickupCity,
              if (load.pickupRegion != null && load.pickupRegion!.isNotEmpty) load.pickupRegion!,
              load.pickupCountry,
            ].join(', '),
            to: '${load.dropoffCity}, ${load.dropoffCountry}',
          ),
          const SizedBox(height: GucSpacing.sm),
          Wrap(
            spacing: GucSpacing.xs,
            runSpacing: GucSpacing.xs,
            children: [
              GucBadge(label: load.loadType, tone: GucBadgeTone.info),
              GucBadge(label: '${load.weightTons.toStringAsFixed(1)} t'),
              GucBadge(label: load.vehicleType),
              if (load.contactPhone != null && load.contactPhone!.isNotEmpty)
                GucBadge(label: load.contactPhone!, icon: Icons.phone_outlined),
              if (load.matchScore != null)
                GucBadge(label: '${load.matchScore}%', tone: GucBadgeTone.success, icon: Icons.bolt_outlined),
              if (load.status == 'MATCHED')
                GucBadge(label: l10n.matched, tone: GucBadgeTone.success),
            ],
          ),
          const SizedBox(height: GucSpacing.sm),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${l10n.pickupDateTime}: ${DateFormat.MMMd().add_Hm().format(load.loadDate)}\n${l10n.deliveryDateTime}: ${DateFormat.MMMd().add_Hm().format(load.deliveryDate)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              Text(
                price,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RouteRow extends StatelessWidget {
  const _RouteRow({required this.from, required this.to});

  final String from;
  final String to;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.trip_origin, size: 16, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 6),
        Expanded(child: Text(from, style: Theme.of(context).textTheme.bodyMedium)),
        const Icon(Icons.arrow_forward, size: 16),
        const SizedBox(width: 6),
        Icon(Icons.flag_outlined, size: 16, color: Theme.of(context).colorScheme.secondary),
        const SizedBox(width: 6),
        Expanded(child: Text(to, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.end)),
      ],
    );
  }
}
