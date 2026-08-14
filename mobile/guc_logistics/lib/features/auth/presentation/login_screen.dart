import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/data/mock/mock_data.dart';
import '../../../core/di/providers.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/guc_theme.dart';
import '../../../core/validation/auth_validators.dart';
import '../../../core/widgets/guc_widgets.dart';
import '../domain/user_role.dart';

enum AuthAudience { shipper, carrier }

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(GucSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: GucSpacing.xl),
              Text(l10n.appTitle, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: GucSpacing.xs),
              Text(l10n.tagline),
              const SizedBox(height: GucSpacing.xl),
              Text(l10n.chooseAccountType, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: GucSpacing.sm),
              Text(l10n.chooseAccountTypeHint),
              const SizedBox(height: GucSpacing.lg),
              GucCard(
                onTap: () => context.push('/login/shipper'),
                child: Row(
                  children: [
                    Icon(Icons.inventory_2_outlined, color: Theme.of(context).colorScheme.primary, size: 32),
                    const SizedBox(width: GucSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.shipperGateTitle, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                          Text(l10n.shipperGateBody),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
              const SizedBox(height: GucSpacing.sm),
              GucCard(
                onTap: () => context.push('/login/carrier'),
                child: Row(
                  children: [
                    Icon(Icons.local_shipping_outlined, color: Theme.of(context).colorScheme.primary, size: 32),
                    const SizedBox(width: GucSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.carrierGateTitle, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                          Text(l10n.carrierGateBody),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
              const Spacer(),
              TextButton(onPressed: () => context.push('/about-pricing'), child: Text(l10n.aboutAndPricing)),
            ],
          ),
        ),
      ),
    );
  }
}

class SideLoginScreen extends ConsumerStatefulWidget {
  const SideLoginScreen({super.key, required this.audience});

  final AuthAudience audience;

  @override
  ConsumerState<SideLoginScreen> createState() => _SideLoginScreenState();
}

class _SideLoginScreenState extends ConsumerState<SideLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController(text: 'demo@guclogistics.com');
  final _password = TextEditingController(text: 'DemoPass123!');

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _afterAuth() async {
    final role = ref.read(appSettingsProvider).role;
    if (role == null) {
      context.go(widget.audience == AuthAudience.shipper ? '/role-select/shipper' : '/role-select/carrier');
      return;
    }
    final okSide = widget.audience == AuthAudience.shipper ? role.isShipperSide : role.isDriverSide;
    if (!okSide) {
      context.go(widget.audience == AuthAudience.shipper ? '/role-select/shipper' : '/role-select/carrier');
      return;
    }
    context.go('/home');
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await ref.read(authControllerProvider.notifier).login(_email.text.trim(), _password.text);
    if (!mounted || !ok) return;
    await _afterAuth();
  }

  Future<void> _social(String provider) async {
    final email = provider == 'google' ? 'google.user@guclogistics.com' : 'apple.user@guclogistics.com';
    final ok = await ref.read(authControllerProvider.notifier).login(email, 'SocialLogin!1');
    if (!mounted || !ok) return;
    await _afterAuth();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final auth = ref.watch(authControllerProvider);
    final isShipper = widget.audience == AuthAudience.shipper;

    return Scaffold(
      appBar: AppBar(title: Text(isShipper ? l10n.shipperGateTitle : l10n.carrierGateTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(GucSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.login, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: GucSpacing.lg),
                GucTextField(
                  label: l10n.email,
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => AuthValidators.email(v, l10n.invalidEmail),
                ),
                const SizedBox(height: GucSpacing.sm),
                GucTextField(
                  label: l10n.password,
                  controller: _password,
                  obscureText: true,
                  validator: (v) => AuthValidators.loginPassword(v, l10n.passwordRequired),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(onPressed: () => context.push('/forgot-password'), child: Text(l10n.forgotPassword)),
                ),
                if (auth.error != null)
                  Text(auth.error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                const SizedBox(height: GucSpacing.md),
                GucButton(label: l10n.login, loading: auth.loading, onPressed: _submit),
                const SizedBox(height: GucSpacing.sm),
                GucButton(
                  label: l10n.register,
                  variant: GucButtonVariant.secondary,
                  onPressed: () => context.push(isShipper ? '/register/shipper' : '/register/carrier'),
                ),
                const SizedBox(height: GucSpacing.sm),
                Wrap(
                  spacing: 4,
                  children: [
                    TextButton(onPressed: () => context.push('/legal/kvkk'), child: Text(l10n.kvkkNotice)),
                    TextButton(onPressed: () => context.push('/legal/privacy'), child: Text(l10n.privacyPolicy)),
                    TextButton(onPressed: () => context.push('/legal/terms'), child: Text(l10n.termsOfUse)),
                  ],
                ),
                const SizedBox(height: GucSpacing.lg),
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(l10n.orContinueWith, style: Theme.of(context).textTheme.bodySmall),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: GucSpacing.md),
                GucButton(
                  label: l10n.continueWithGoogle,
                  icon: Icons.g_mobiledata,
                  variant: GucButtonVariant.secondary,
                  loading: auth.loading,
                  onPressed: () => _social('google'),
                ),
                const SizedBox(height: GucSpacing.sm),
                GucButton(
                  label: l10n.continueWithApple,
                  icon: Icons.apple,
                  variant: GucButtonVariant.tonal,
                  loading: auth.loading,
                  onPressed: () => _social('apple'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SideRegisterScreen extends ConsumerStatefulWidget {
  const SideRegisterScreen({super.key, required this.audience});

  final AuthAudience audience;

  @override
  ConsumerState<SideRegisterScreen> createState() => _SideRegisterScreenState();
}

class _SideRegisterScreenState extends ConsumerState<SideRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _displayName = TextEditingController();
  final _phone = TextEditingController();
  late UserRole _role;
  bool _acceptedLegal = false;
  bool _acceptedKvkk = false;
  String? _legalError;

  @override
  void initState() {
    super.initState();
    _role = widget.audience == AuthAudience.shipper ? UserRole.shipper : UserRole.independentDriver;
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    _displayName.dispose();
    _phone.dispose();
    super.dispose();
  }

  List<UserRole> get _roles => widget.audience == AuthAudience.shipper
      ? const [UserRole.shipper, UserRole.logisticsCompany]
      : const [UserRole.independentDriver, UserRole.fleetOwner];

  Future<void> _submit() async {
    setState(() => _legalError = null);
    final l10n = AppLocalizations.of(context);
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptedLegal || !_acceptedKvkk) {
      setState(() => _legalError = l10n.acceptLegalRequired);
      return;
    }
    final ok = await ref.read(authControllerProvider.notifier).register(
          _email.text.trim(),
          _password.text,
          _role,
        );
    if (!mounted || !ok) return;
    if (widget.audience == AuthAudience.carrier) {
      final name = _displayName.text.trim();
      final phone = _phone.text.trim();
      if (name.isNotEmpty) MockData.driverDisplayName = name;
      if (phone.isNotEmpty) MockData.driverPhone = phone;
    }
    await ref.read(appSettingsProvider.notifier).setRole(_role);
    if (mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final auth = ref.watch(authControllerProvider);
    final isShipper = widget.audience == AuthAudience.shipper;

    return Scaffold(
      appBar: AppBar(title: Text(isShipper ? l10n.registerShipper : l10n.registerCarrier)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(GucSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<UserRole>(
                  initialValue: _role,
                  decoration: InputDecoration(labelText: l10n.roleTitle),
                  items: _roles
                      .map((r) => DropdownMenuItem(value: r, child: Text(l10n.roleLabel(r.name))))
                      .toList(),
                  onChanged: (v) => setState(() => _role = v ?? _role),
                ),
                const SizedBox(height: GucSpacing.md),
                if (!isShipper) ...[
                  GucTextField(label: l10n.displayName, controller: _displayName, validator: (v) => (v == null || v.trim().isEmpty) ? l10n.requiredField : null),
                  const SizedBox(height: GucSpacing.sm),
                  GucTextField(
                    label: l10n.phoneNumber,
                    controller: _phone,
                    keyboardType: TextInputType.phone,
                    validator: (v) => (v == null || v.trim().length < 8) ? l10n.requiredField : null,
                  ),
                  const SizedBox(height: GucSpacing.sm),
                ],
                GucTextField(
                  label: l10n.email,
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => AuthValidators.email(v, l10n.invalidEmail),
                ),
                const SizedBox(height: GucSpacing.sm),
                GucTextField(
                  label: l10n.password,
                  controller: _password,
                  obscureText: true,
                  validator: (v) => AuthValidators.registerPassword(
                    v,
                    tooShort: l10n.passwordTooShort,
                    needUpper: l10n.passwordNeedUpper,
                    needLower: l10n.passwordNeedLower,
                    needDigit: l10n.passwordNeedDigit,
                    needSpecial: l10n.passwordNeedSpecial,
                  ),
                ),
                const SizedBox(height: GucSpacing.xs),
                Text(l10n.passwordRulesHint, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: GucSpacing.sm),
                GucTextField(
                  label: l10n.confirmPassword,
                  controller: _confirm,
                  obscureText: true,
                  validator: (v) => AuthValidators.confirmPassword(v, _password.text, l10n.passwordMismatch),
                ),
                const SizedBox(height: GucSpacing.md),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _acceptedLegal,
                  onChanged: (v) => setState(() => _acceptedLegal = v ?? false),
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(l10n.acceptLegalPrefix),
                  subtitle: Wrap(
                    spacing: 4,
                    children: [
                      TextButton(onPressed: () => context.push('/legal/terms'), child: Text(l10n.termsOfUse)),
                      TextButton(onPressed: () => context.push('/legal/privacy'), child: Text(l10n.privacyPolicy)),
                    ],
                  ),
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _acceptedKvkk,
                  onChanged: (v) => setState(() => _acceptedKvkk = v ?? false),
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(l10n.kvkkNotice),
                  subtitle: TextButton(onPressed: () => context.push('/legal/kvkk'), child: Text(l10n.kvkkNotice)),
                ),
                if (_legalError != null)
                  Text(_legalError!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                if (auth.error != null) ...[
                  const SizedBox(height: GucSpacing.sm),
                  Text(auth.error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                ],
                const SizedBox(height: GucSpacing.lg),
                GucButton(label: l10n.register, loading: auth.loading, onPressed: _submit),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  bool _sent = false;
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await ref.read(authRepositoryProvider).forgotPassword(_email.text.trim());
    if (mounted) {
      setState(() {
        _loading = false;
        _sent = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.forgotPassword)),
      body: Padding(
        padding: const EdgeInsets.all(GucSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_sent)
                Text(l10n.resetSent)
              else ...[
                GucTextField(
                  label: l10n.email,
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => AuthValidators.email(v, l10n.invalidEmail),
                ),
                const SizedBox(height: GucSpacing.lg),
                GucButton(label: l10n.sendResetLink, loading: _loading, onPressed: _submit),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class RoleSelectScreen extends ConsumerWidget {
  const RoleSelectScreen({super.key, this.audience});

  final AuthAudience? audience;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final all = [
      (UserRole.shipper, Icons.business_outlined, l10n.roleShipper, AuthAudience.shipper),
      (UserRole.logisticsCompany, Icons.hub_outlined, l10n.roleLogistics, AuthAudience.shipper),
      (UserRole.independentDriver, Icons.local_shipping_outlined, l10n.roleDriver, AuthAudience.carrier),
      (UserRole.fleetOwner, Icons.garage_outlined, l10n.roleFleet, AuthAudience.carrier),
    ];
    final roles = audience == null ? all : all.where((r) => r.$4 == audience).toList();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.roleTitle)),
      body: ListView(
        padding: const EdgeInsets.all(GucSpacing.lg),
        children: [
          Text(l10n.roleSubtitle),
          const SizedBox(height: GucSpacing.lg),
          ...roles.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: GucSpacing.sm),
                child: GucCard(
                  onTap: () async {
                    await ref.read(appSettingsProvider.notifier).setRole(r.$1);
                    final auth = ref.read(authRepositoryProvider);
                    await auth.persistRoleApi(r.$1);
                    if (context.mounted) context.go('/home');
                  },
                  child: Row(
                    children: [
                      Icon(r.$2, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: GucSpacing.md),
                      Expanded(child: Text(r.$3, style: Theme.of(context).textTheme.titleMedium)),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

/// Legacy register route redirect target kept for old links.
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginScreen();
  }
}
