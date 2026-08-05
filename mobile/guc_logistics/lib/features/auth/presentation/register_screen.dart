import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/providers.dart';
import '../../../core/l10n/app_localizations.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  String _role = 'SHIPPER';

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final auth = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.register)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _email,
              decoration: InputDecoration(labelText: l10n.email),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _password,
              obscureText: true,
              decoration: InputDecoration(labelText: l10n.password),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _role,
              decoration: InputDecoration(labelText: l10n.role),
              items: const [
                DropdownMenuItem(value: 'SHIPPER', child: Text('Shipper')),
                DropdownMenuItem(value: 'LOGISTICS_COMPANY', child: Text('Logistics company')),
                DropdownMenuItem(value: 'INDEPENDENT_DRIVER', child: Text('Independent driver')),
                DropdownMenuItem(value: 'FLEET_OWNER', child: Text('Fleet owner')),
              ],
              onChanged: (v) => setState(() => _role = v ?? 'SHIPPER'),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: auth.loading
                  ? null
                  : () => ref
                      .read(authControllerProvider.notifier)
                      .register(_email.text.trim(), _password.text, _role),
              child: Text(l10n.register),
            ),
            TextButton(onPressed: () => context.go('/login'), child: Text(l10n.login)),
          ],
        ),
      ),
    );
  }
}
