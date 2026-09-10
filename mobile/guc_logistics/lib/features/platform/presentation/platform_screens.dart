import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/data/mock/mock_data.dart';
import '../../../core/di/providers.dart';
import '../../../core/domain/ops_models.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/services/platform_services.dart';
import '../../../core/theme/guc_theme.dart';
import '../../../core/widgets/guc_widgets.dart';
final connectivityOnlineProvider = StreamProvider<bool>((ref) {
  return ConnectivityService().online$;
});

class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final online = ref.watch(connectivityOnlineProvider).valueOrNull ?? true;
    if (online) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    return Material(
      color: Theme.of(context).colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(Icons.cloud_off, color: Theme.of(context).colorScheme.onErrorContainer),
            const SizedBox(width: 8),
            Expanded(child: Text(l10n.offlineModeBanner, style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer))),
          ],
        ),
      ),
    );
  }
}

class AdminModerationScreen extends ConsumerStatefulWidget {
  const AdminModerationScreen({super.key});

  @override
  ConsumerState<AdminModerationScreen> createState() => _AdminModerationScreenState();
}

class _AdminModerationScreenState extends ConsumerState<AdminModerationScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final loads = MockData.loads.where((e) => e.status == 'PUBLISHED' || e.status == 'UNPUBLISHED').toList();
    final docs = MockData.documents.where((d) => d.status == 'PENDING' || d.status == 'MISSING').toList();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.adminModeration)),
      body: ListView(
        padding: const EdgeInsets.all(GucSpacing.md),
        children: [
          Text(l10n.adminModerationHint),
          const SizedBox(height: GucSpacing.md),
          Text(l10n.reviewListings, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: GucSpacing.sm),
          ...loads.map(
            (load) => Padding(
              padding: const EdgeInsets.only(bottom: GucSpacing.sm),
              child: GucCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(load.companyName ?? load.title, style: const TextStyle(fontWeight: FontWeight.w800)),
                    Text(load.title),
                    Text('${load.pickupCity} → ${load.dropoffCity} · ${load.status}'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: GucButton(
                            label: l10n.approve,
                            onPressed: () async {
                              await ref.read(loadsRepositoryProvider).setPublished(load.id, true);
                              setState(() {});
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: GucButton(
                            label: l10n.unpublishLoad,
                            variant: GucButtonVariant.secondary,
                            onPressed: () async {
                              await ref.read(loadsRepositoryProvider).setPublished(load.id, false);
                              setState(() {});
                            },
                          ),
                        ),
                        IconButton(
                          tooltip: l10n.banCompany,
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${l10n.banCompany}: ${load.companyName}')));
                          },
                          icon: const Icon(Icons.gavel),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: GucSpacing.md),
          Text(l10n.reviewKyc, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: GucSpacing.sm),
          ...docs.map(
            (d) => ListTile(
              title: Text(d.title),
              subtitle: Text(d.status),
              trailing: Wrap(
                children: [
                  IconButton(
                    icon: const Icon(Icons.check_circle_outline),
                    onPressed: () {
                      final i = MockData.documents.indexWhere((x) => x.id == d.id);
                      if (i >= 0) {
                        final prev = MockData.documents[i];
                        MockData.documents[i] = DocItem(
                          id: prev.id,
                          type: prev.type,
                          title: prev.title,
                          status: 'APPROVED',
                          fileName: prev.fileName,
                          updatedAt: DateTime.now(),
                        );
                        setState(() {});
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.cancel_outlined),
                    onPressed: () {
                      final i = MockData.documents.indexWhere((x) => x.id == d.id);
                      if (i >= 0) {
                        final prev = MockData.documents[i];
                        MockData.documents[i] = DocItem(
                          id: prev.id,
                          type: prev.type,
                          title: prev.title,
                          status: 'REJECTED',
                          fileName: prev.fileName,
                          updatedAt: DateTime.now(),
                        );
                        setState(() {});
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FleetAssignScreen extends ConsumerStatefulWidget {
  const FleetAssignScreen({super.key});

  @override
  ConsumerState<FleetAssignScreen> createState() => _FleetAssignScreenState();
}

class _FleetAssignScreenState extends ConsumerState<FleetAssignScreen> {
  String? _vehicleId;
  String? _driverId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final fleet = MockData.fleet;
    final team = MockData.team.where((t) => t.role == 'DRIVER' || t.role == 'DISPATCHER').toList();
    _vehicleId ??= fleet.isNotEmpty ? fleet.first.id : null;
    _driverId ??= team.isNotEmpty ? team.first.id : null;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.fleetAssign)),
      body: ListView(
        padding: const EdgeInsets.all(GucSpacing.md),
        children: [
          Text(l10n.fleetAssignHint),
          const SizedBox(height: GucSpacing.md),
          DropdownButtonFormField<String>(
            initialValue: _vehicleId,
            decoration: InputDecoration(labelText: l10n.vehicles),
            items: fleet.map((v) => DropdownMenuItem(value: v.id, child: Text('${v.plate} · ${v.type}'))).toList(),
            onChanged: (v) => setState(() => _vehicleId = v),
          ),
          const SizedBox(height: GucSpacing.sm),
          DropdownButtonFormField<String>(
            initialValue: _driverId,
            decoration: InputDecoration(labelText: l10n.driver),
            items: team.map((t) => DropdownMenuItem(value: t.id, child: Text('${t.name} (${t.role})'))).toList(),
            onChanged: (v) => setState(() => _driverId = v),
          ),
          const SizedBox(height: GucSpacing.lg),
          GucButton(
            label: l10n.assignDriver,
            onPressed: () async {
              await ref.read(opsRepositoryProvider).assignDriver(vehicleId: _vehicleId!, driverId: _driverId!);
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.driverAssigned)));
              context.pop();
            },
          ),
          const SizedBox(height: GucSpacing.md),
          Text(l10n.activeAssignments, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
          ...fleet.map(
            (v) => ListTile(
              title: Text(v.plate),
              subtitle: Text(v.driverName ?? l10n.unassigned),
              trailing: GucBadge(label: v.status),
            ),
          ),
        ],
      ),
    );
  }
}

class ContractSignScreen extends ConsumerStatefulWidget {
  const ContractSignScreen({super.key});

  @override
  ConsumerState<ContractSignScreen> createState() => _ContractSignScreenState();
}

class _ContractSignScreenState extends ConsumerState<ContractSignScreen> {
  final _points = <Offset>[];
  bool _signed = MockData.contractSigned;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.eSignature)),
      body: ListView(
        padding: const EdgeInsets.all(GucSpacing.md),
        children: [
          Text(MockData.contractTemplate),
          const SizedBox(height: GucSpacing.md),
          Text(l10n.signBelow, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: GucSpacing.sm),
          Container(
            height: 160,
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.outline),
              borderRadius: BorderRadius.circular(12),
            ),
            child: GestureDetector(
              onPanUpdate: (d) => setState(() => _points.add(d.localPosition)),
              onPanEnd: (_) => setState(() => _points.add(Offset.infinite)),
              child: CustomPaint(painter: _SignaturePainter(_points), size: Size.infinite),
            ),
          ),
          const SizedBox(height: GucSpacing.sm),
          Row(
            children: [
              TextButton(onPressed: () => setState(() => _points.clear()), child: Text(l10n.clear)),
              const Spacer(),
              if (_signed) GucBadge(label: l10n.signed, tone: GucBadgeTone.success),
            ],
          ),
          GucButton(
            label: l10n.confirmSignature,
            onPressed: _points.where((p) => p != Offset.infinite).length < 8
                ? null
                : () {
                    MockData.contractSigned = true;
                    MockData.contractSignedAt = DateTime.now();
                    setState(() => _signed = true);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.signatureSaved)));
                  },
          ),
          if (MockData.contractSignedAt != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text('${l10n.signedAt}: ${DateFormat.yMMMd().add_Hm().format(MockData.contractSignedAt!)}'),
            ),
        ],
      ),
    );
  }
}

class _SignaturePainter extends CustomPainter {
  _SignaturePainter(this.points);
  final List<Offset> points;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black87
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < points.length - 1; i++) {
      if (points[i] == Offset.infinite || points[i + 1] == Offset.infinite) continue;
      canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SignaturePainter oldDelegate) => true;
}

class LiveGpsScreen extends ConsumerStatefulWidget {
  const LiveGpsScreen({super.key});

  @override
  ConsumerState<LiveGpsScreen> createState() => _LiveGpsScreenState();
}

class _LiveGpsScreenState extends ConsumerState<LiveGpsScreen> {
  String _status = '…';
  double? _lat;
  double? _lng;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _status = l10n.locating);
    final pos = await LocationService().currentPosition();
    if (!mounted) return;
    if (pos == null) {
      setState(() => _status = l10n.locationDenied);
      return;
    }
    setState(() {
      _lat = pos.latitude;
      _lng = pos.longitude;
      _status = l10n.gpsLive;
      MockData.lastDriverLat = pos.latitude;
      MockData.lastDriverLng = pos.longitude;
      MockData.lastDriverLocationAt = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.liveGps)),
      body: ListView(
        padding: const EdgeInsets.all(GucSpacing.md),
        children: [
          Text(_status),
          if (_lat != null) Text('Lat: ${_lat!.toStringAsFixed(5)}  Lng: ${_lng!.toStringAsFixed(5)}'),
          if (MockData.lastDriverLocationAt != null)
            Text('${l10n.lastUpdate}: ${DateFormat.Hms().format(MockData.lastDriverLocationAt!)}'),
          const SizedBox(height: GucSpacing.md),
          GucButton(label: l10n.refreshLocation, onPressed: _refresh),
          const SizedBox(height: GucSpacing.sm),
          GucButton(
            label: l10n.openOsmMap,
            variant: GucButtonVariant.secondary,
            onPressed: () => context.push('/shipper/live-map'),
          ),
        ],
      ),
    );
  }
}
