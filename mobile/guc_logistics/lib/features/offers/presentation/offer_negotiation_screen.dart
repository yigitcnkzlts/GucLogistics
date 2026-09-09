import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/data/mock/mock_data.dart';
import '../../../core/di/providers.dart';
import '../../../core/domain/models.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/guc_theme.dart';
import '../../../core/widgets/guc_widgets.dart';
import 'offers_screen.dart';

final offerDetailProvider = FutureProvider.autoDispose.family<OfferItem, String>((ref, id) {
  return ref.watch(offersRepositoryProvider).getOffer(id);
});

class OfferNegotiationScreen extends ConsumerStatefulWidget {
  const OfferNegotiationScreen({super.key, required this.offerId});

  final String offerId;

  @override
  ConsumerState<OfferNegotiationScreen> createState() => _OfferNegotiationScreenState();
}

class _OfferNegotiationScreenState extends ConsumerState<OfferNegotiationScreen> {
  final _amount = TextEditingController();
  final _message = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _amount.dispose();
    _message.dispose();
    super.dispose();
  }

  Future<void> _counter(bool isShipper) async {
    final amount = double.tryParse(_amount.text.trim());
    if (amount == null || amount <= 0) return;
    setState(() => _busy = true);
    try {
      await ref.read(offersRepositoryProvider).counterOffer(
            offerId: widget.offerId,
            amount: amount,
            byRole: isShipper ? 'SHIPPER' : 'CARRIER',
            message: _message.text.trim().isEmpty ? null : _message.text.trim(),
          );
      ref.invalidate(offerDetailProvider(widget.offerId));
      ref.invalidate(offersProvider);
      _amount.clear();
      _message.clear();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _accept() async {
    if (!MockData.dispatcherPermissions.canAcceptOffers) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.permAcceptOffers)));
      return;
    }
    setState(() => _busy = true);
    try {
      final matchId = await ref.read(offersRepositoryProvider).accept(widget.offerId);
      ref.invalidate(offerDetailProvider(widget.offerId));
      ref.invalidate(offersProvider);
      if (!mounted) return;
      if (matchId != null) {
        context.push('/matches/$matchId');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _reject() async {
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
    if (ok != true) {
      controller.dispose();
      return;
    }
    setState(() => _busy = true);
    try {
      await ref.read(offersRepositoryProvider).reject(
            widget.offerId,
            reason: controller.text.trim().isEmpty ? null : controller.text.trim(),
          );
      ref.invalidate(offerDetailProvider(widget.offerId));
      ref.invalidate(offersProvider);
    } finally {
      controller.dispose();
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final role = ref.watch(appSettingsProvider).role;
    final isShipper = role?.isShipperSide ?? true;
    final async = ref.watch(offerDetailProvider(widget.offerId));
    final timeFmt = DateFormat.MMMd().add_Hm();

    return Scaffold(
      appBar: AppBar(
        title: const Text('GucLogistics'),
        actions: const [Padding(padding: EdgeInsets.only(right: 16), child: Icon(Icons.notifications_none))],
      ),
      body: async.when(
        data: (offer) {
          final tr = Localizations.localeOf(context).languageCode == 'tr';
          final open = offer.status == 'PENDING' || offer.status == 'COUNTERED';
          final accepted = offer.status == 'ACCEPTED';
          return ListView(
            padding: const EdgeInsets.all(GucSpacing.md),
            children: [
              Text(
                tr ? 'Teklif Detayı' : 'Offer Details',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900, color: GucColors.navy),
              ),
              const SizedBox(height: GucSpacing.md),
              Text(
                offer.loadTitle ?? offer.loadId,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: GucSpacing.xs),
              if (offer.carrierName != null)
                Text('${l10n.carrier}: ${offer.carrierName}'),
              const SizedBox(height: GucSpacing.sm),
              GucBadge(label: l10n.statusLabel(offer.status), tone: _tone(offer.status)),
              const SizedBox(height: GucSpacing.sm),
              Text(
                '${l10n.agreedPrice}: ${offer.amount.toStringAsFixed(0)} ${offer.currency}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              if (offer.vehiclePlate != null) ...[
                const SizedBox(height: GucSpacing.md),
                GucCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tr ? 'Araç ve şoför bilgileri' : 'Vehicle and driver details', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: GucSpacing.xs),
                      Text('${offer.vehiclePlate} · ${offer.vehicleType ?? '-'}'),
                      Text('${offer.driverName ?? '-'} · ${offer.driverPhone ?? '-'}'),
                      if (offer.transitHours != null) Text(tr ? 'Tahmini taşıma: ${offer.transitHours} saat' : 'Estimated transit: ${offer.transitHours} hours'),
                      if (offer.availableAt != null) Text('${tr ? 'Yüklemeye hazır' : 'Ready for loading'}: ${timeFmt.format(offer.availableAt!)}'),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: GucSpacing.md),
              Text(l10n.matchingHint, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: GucSpacing.lg),
              Text(l10n.rounds, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: GucSpacing.sm),
              ...offer.rounds.map((round) {
                final mine = (isShipper && round.byRole == 'SHIPPER') || (!isShipper && round.byRole == 'CARRIER');
                return Padding(
                  padding: const EdgeInsets.only(bottom: GucSpacing.sm),
                  child: Align(
                    alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.85),
                      child: GucCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              round.byRole == 'SHIPPER' ? l10n.shipper : l10n.carrier,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            Text(
                              '${round.amount.toStringAsFixed(0)} ${round.currency}',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            if (round.message != null && round.message!.isNotEmpty) Text(round.message!),
                            const SizedBox(height: 4),
                            Text(timeFmt.format(round.createdAt), style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
              if (accepted && offer.matchId != null) ...[
                const SizedBox(height: GucSpacing.md),
                GucButton(
                  label: l10n.openChat,
                  icon: Icons.chat_outlined,
                  onPressed: () => context.push('/matches/${offer.matchId}'),
                ),
              ],
              if (open) ...[
                const SizedBox(height: GucSpacing.lg),
                Text(l10n.yourCounter, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: GucSpacing.sm),
                GucTextField(
                  label: l10n.amount,
                  controller: _amount,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: GucSpacing.sm),
                GucTextField(
                  label: l10n.message,
                  controller: _message,
                  maxLines: 3,
                ),
                const SizedBox(height: GucSpacing.md),
                GucButton(
                  label: l10n.counterOffer,
                  loading: _busy,
                  variant: GucButtonVariant.secondary,
                  onPressed: () => _counter(isShipper),
                ),
                if (isShipper) ...[
                  const SizedBox(height: GucSpacing.sm),
                  GucButton(
                    label: l10n.acceptAndMatch,
                    loading: _busy,
                    onPressed: MockData.dispatcherPermissions.canAcceptOffers ? _accept : null,
                  ),
                  const SizedBox(height: GucSpacing.sm),
                  GucButton(
                    label: l10n.reject,
                    loading: _busy,
                    variant: GucButtonVariant.tonal,
                    onPressed: _reject,
                  ),
                ],
                if (!isShipper && offer.status == 'COUNTERED') ...[
                  const SizedBox(height: GucSpacing.sm),
                  Text(
                    l10n.matchingHint,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => GucErrorState(
          message: l10n.offlineOrError,
          onRetry: () => ref.invalidate(offerDetailProvider(widget.offerId)),
        ),
      ),
    );
  }

  GucBadgeTone _tone(String status) => switch (status) {
        'ACCEPTED' => GucBadgeTone.success,
        'REJECTED' => GucBadgeTone.danger,
        'COUNTERED' => GucBadgeTone.info,
        _ => GucBadgeTone.warning,
      };
}
