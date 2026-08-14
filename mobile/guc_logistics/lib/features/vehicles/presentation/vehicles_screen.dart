import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../core/domain/models.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/guc_theme.dart';
import '../../../core/widgets/guc_widgets.dart';

final vehiclesProvider = FutureProvider.autoDispose<List<VehicleItem>>((ref) {
  return ref.watch(vehiclesRepositoryProvider).listMine();
});

class VehiclesScreen extends ConsumerWidget {
  const VehiclesScreen({super.key});

  Future<void> _edit(BuildContext context, WidgetRef ref, {VehicleItem? existing}) async {
    final l10n = AppLocalizations.of(context);
    final plate = TextEditingController(text: existing?.plate ?? '');
    final type = TextEditingController(text: existing?.type ?? 'Curtain trailer');
    final capacity = TextEditingController(text: existing?.capacityKg.toStringAsFixed(0) ?? '24000');
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(existing == null ? l10n.addVehicle : l10n.editVehicle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: plate, decoration: InputDecoration(labelText: l10n.plate)),
            TextField(controller: type, decoration: InputDecoration(labelText: l10n.vehicleType)),
            TextField(
              controller: capacity,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: l10n.capacity),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.back)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.save)),
        ],
      ),
    );
    if (ok == true) {
      final kg = double.tryParse(capacity.text) ?? 0;
      if (plate.text.trim().isEmpty || kg <= 0) return;
      await ref.read(vehiclesRepositoryProvider).upsert(
            id: existing?.id,
            plate: plate.text.trim(),
            type: type.text.trim(),
            capacityKg: kg,
            status: existing?.status ?? 'ACTIVE',
          );
      ref.invalidate(vehiclesProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.saved)));
      }
    }
    plate.dispose();
    type.dispose();
    capacity.dispose();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(vehiclesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.vehicles)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _edit(context, ref),
        icon: const Icon(Icons.add),
        label: Text(l10n.addVehicle),
      ),
      body: async.when(
        data: (items) {
          if (items.isEmpty) {
            return GucEmptyState(
              title: l10n.noData,
              subtitle: l10n.addVehicleHint,
              action: GucButton(label: l10n.addVehicle, expanded: false, onPressed: () => _edit(context, ref)),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(GucSpacing.md, GucSpacing.md, GucSpacing.md, 88),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: GucSpacing.sm),
            itemBuilder: (context, i) {
              final v = items[i];
              return GucCard(
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.local_shipping_outlined),
                      title: Text(v.plate),
                      subtitle: Text('${v.type}\n${l10n.capacity}: ${v.capacityKg.toStringAsFixed(0)} kg'),
                      isThreeLine: true,
                      trailing: GucBadge(label: l10n.statusLabel(v.status), tone: GucBadgeTone.success),
                    ),
                    Row(
                      children: [
                        TextButton(onPressed: () => _edit(context, ref, existing: v), child: Text(l10n.editVehicle)),
                        TextButton(
                          onPressed: () async {
                            await ref.read(vehiclesRepositoryProvider).delete(v.id);
                            ref.invalidate(vehiclesProvider);
                          },
                          child: Text(l10n.delete),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => GucErrorState(message: l10n.offlineOrError, onRetry: () => ref.invalidate(vehiclesProvider)),
      ),
    );
  }
}
