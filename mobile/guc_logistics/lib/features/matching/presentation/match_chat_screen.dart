import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/di/providers.dart';
import '../../../core/domain/models.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/guc_theme.dart';
import '../../../core/utils/contact_actions.dart';
import '../../../core/widgets/guc_widgets.dart';
import '../../platform/presentation/platform_screens.dart';

final matchDetailProvider = FutureProvider.autoDispose.family<MatchThread, String>((ref, id) {
  return ref.watch(matchesRepositoryProvider).getMatch(id);
});

final matchMessagesProvider = FutureProvider.autoDispose.family<List<ChatMessage>, String>((ref, id) {
  return ref.watch(matchesRepositoryProvider).listMessages(id);
});

class MatchChatScreen extends ConsumerStatefulWidget {
  const MatchChatScreen({super.key, required this.matchId});

  final String matchId;

  @override
  ConsumerState<MatchChatScreen> createState() => _MatchChatScreenState();
}

class _MatchChatScreenState extends ConsumerState<MatchChatScreen> {
  final _controller = TextEditingController();
  bool _sending = false;
  Timer? _poll;

  @override
  void initState() {
    super.initState();
    _poll = Timer.periodic(const Duration(seconds: 6), (_) {
      if (!mounted) return;
      ref.invalidate(matchMessagesProvider(widget.matchId));
    });
  }

  @override
  void dispose() {
    _poll?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final role = ref.read(appSettingsProvider).role;
    final senderRole = (role?.isShipperSide ?? true) ? 'SHIPPER' : 'CARRIER';
    setState(() => _sending = true);
    try {
      await ref.read(matchesRepositoryProvider).sendMessage(
            matchId: widget.matchId,
            body: text,
            senderRole: senderRole,
          );
      _controller.clear();
      ref.invalidate(matchMessagesProvider(widget.matchId));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final matchAsync = ref.watch(matchDetailProvider(widget.matchId));
    final messagesAsync = ref.watch(matchMessagesProvider(widget.matchId));
    final role = ref.watch(appSettingsProvider).role;
    final isShipper = role?.isShipperSide ?? true;
    final timeFmt = DateFormat.Hm();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.matchChat)),
      body: Column(
        children: [
          const OfflineBanner(),
          matchAsync.when(
            data: (match) => Material(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
              child: Padding(
                padding: const EdgeInsets.all(GucSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      match.loadTitle,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text('${l10n.agreedPrice}: ${match.agreedAmount.toStringAsFixed(0)} ${match.currency}'),
                    if (match.routeLabel != null) Text(match.routeLabel!),
                    Text('${l10n.shipper}: ${match.shipperName}${match.shipperPhone != null ? ' · ${match.shipperPhone}' : ''}'),
                    Text('${l10n.carrier}: ${match.carrierName}${match.carrierPhone != null ? ' · ${match.carrierPhone}' : ''}'),
                    const SizedBox(height: 6),
                    GucBadge(label: l10n.matched, tone: GucBadgeTone.success, icon: Icons.handshake_outlined),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        FilledButton.icon(
                          onPressed: () => launchPhoneCall(isShipper ? match.carrierPhone : match.shipperPhone),
                          icon: const Icon(Icons.call),
                          label: Text(l10n.callNow),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => launchSms(
                            isShipper ? match.carrierPhone : match.shipperPhone,
                            body: '${match.loadTitle} — ${l10n.matched}',
                          ),
                          icon: const Icon(Icons.sms_outlined),
                          label: Text(l10n.sendSms),
                        ),
                        TextButton.icon(
                          onPressed: () => copyPhone(
                            context,
                            isShipper ? match.carrierPhone : match.shipperPhone,
                            l10n.phoneCopied,
                          ),
                          icon: const Icon(Icons.copy),
                          label: Text(l10n.copyPhone),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            loading: () => const LinearProgressIndicator(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          Expanded(
            child: messagesAsync.when(
              data: (messages) {
                if (messages.isEmpty) {
                  return GucEmptyState(title: l10n.chatEmpty);
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(GucSpacing.md),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final mine = (isShipper && msg.senderRole == 'SHIPPER') || (!isShipper && msg.senderRole == 'CARRIER');
                    return Align(
                      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: GucSpacing.sm),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.8),
                        decoration: BoxDecoration(
                          color: mine
                              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.15)
                              : Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(msg.body),
                            const SizedBox(height: 4),
                            Text(
                              timeFmt.format(msg.createdAt),
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => GucErrorState(
                message: l10n.offlineOrError,
                onRetry: () => ref.invalidate(matchMessagesProvider(widget.matchId)),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(GucSpacing.md, 0, GucSpacing.md, GucSpacing.md),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(hintText: l10n.typeMessage),
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: GucSpacing.sm),
                  IconButton.filled(
                    onPressed: _sending ? null : _send,
                    icon: _sending
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.send),
                    tooltip: l10n.sendMessage,
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
