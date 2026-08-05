import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../core/l10n/app_localizations.dart';

class LoadDetailScreen extends ConsumerStatefulWidget {
  const LoadDetailScreen({super.key, required this.loadId});

  final String loadId;

  @override
  ConsumerState<LoadDetailScreen> createState() => _LoadDetailScreenState();
}

class _LoadDetailScreenState extends ConsumerState<LoadDetailScreen> {
  final _amount = TextEditingController(text: '1000');
  bool _submitting = false;

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Load detail')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: ref.read(loadsRepositoryProvider).getLoad(widget.loadId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final load = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Semantics(
                  header: true,
                  child: Text(load['title']?.toString() ?? '', style: Theme.of(context).textTheme.headlineSmall),
                ),
                const SizedBox(height: 8),
                Text(load['description']?.toString() ?? ''),
                const SizedBox(height: 16),
                Text('${load['pickupCity'] ?? ''} → ${load['dropoffCity'] ?? ''}'),
                Text('Status: ${load['status']}'),
                const Spacer(),
                TextField(
                  controller: _amount,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Offer amount (EUR)'),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: _submitting
                      ? null
                      : () async {
                          setState(() => _submitting = true);
                          try {
                            await ref.read(offersRepositoryProvider).submitOffer(
                                  loadId: widget.loadId,
                                  amount: double.parse(_amount.text),
                                  currency: 'EUR',
                                );
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(l10n.submitOffer)),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
                            }
                          } finally {
                            if (mounted) setState(() => _submitting = false);
                          }
                        },
                  child: Text(l10n.submitOffer),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
