import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/data/mock/mock_data.dart';
import '../../../core/di/providers.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/guc_theme.dart';
import '../../../core/widgets/guc_widgets.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final auth = ref.watch(authControllerProvider);
    final settings = ref.watch(appSettingsProvider);
    final session = ref.watch(sessionProfileProvider);
    final role = settings.role;
    final isShipper = role?.isShipperSide ?? true;
    final verified = isShipper
        ? session.valueOrNull?['companyVerified'] == true
        : session.valueOrNull?['driverVerified'] == true;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profile)),
      body: ListView(
        padding: const EdgeInsets.all(GucSpacing.md),
        children: [
          GucCard(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                  child: Icon(Icons.person, color: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(width: GucSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        auth.email ?? '—',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(role == null ? '—' : l10n.roleLabel(role.name)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: GucSpacing.sm),
          ListTile(
            leading: const Icon(Icons.badge_outlined),
            title: Text(isShipper ? l10n.companyProfile : l10n.driverProfile),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/profile/details'),
          ),
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: Text(l10n.editProfile),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/profile/edit'),
          ),
          ListTile(
            leading: const Icon(Icons.verified_outlined),
            title: Text(l10n.verification),
            trailing: session.hasValue
                ? GucBadge(
                    label: verified
                        ? (isShipper ? l10n.verifiedCompany : l10n.verifiedDriver)
                        : l10n.verificationPending,
                    tone: verified ? GucBadgeTone.success : GucBadgeTone.warning,
                  )
                : const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
            onTap: () => context.push('/verification'),
          ),
          if (role?.isDriverSide == true) ...[
            ListTile(
              leading: const Icon(Icons.search),
              title: Text(l10n.findLoads),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.go('/market'),
            ),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet_outlined),
              title: Text(l10n.earningsWallet),
              subtitle: Text('₺${MockData.earningsBalanceTry.toStringAsFixed(0)}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/carrier/earnings'),
            ),
            ListTile(
              leading: const Icon(Icons.my_location_outlined),
              title: Text(l10n.myAvailability),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/carrier/availability'),
            ),
            ListTile(
              leading: const Icon(Icons.local_shipping_outlined),
              title: Text(l10n.vehicles),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/vehicles'),
            ),
          ],
          if (isShipper)
            ListTile(
              leading: const Icon(Icons.dashboard_customize_outlined),
              title: Text(l10n.shipperTools),
              subtitle: Text(l10n.shipperToolsHint),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/shipper/tools'),
            ),
          ListTile(
            leading: const Icon(Icons.hub_outlined),
            title: Text(l10n.operations),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/ops'),
          ),
          ListTile(
            leading: const Icon(Icons.draw_outlined),
            title: Text(l10n.eSignature),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/ops/contract-sign'),
          ),
          ListTile(
            leading: const Icon(Icons.gps_fixed),
            title: Text(l10n.liveGps),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/ops/live-gps'),
          ),
          ListTile(
            leading: const Icon(Icons.admin_panel_settings_outlined),
            title: Text(l10n.adminModeration),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/admin/moderation'),
          ),
          ListTile(
            leading: const Icon(Icons.forum_outlined),
            title: Text(l10n.matches),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/matches'),
          ),
          ListTile(
            leading: const Icon(Icons.route_outlined),
            title: Text(l10n.howItWorks),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(isShipper ? '/help/how-it-works' : '/help/how-it-works-carrier'),
          ),
          ListTile(
            leading: const Icon(Icons.verified_user_outlined),
            title: Text(l10n.trustSafety),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/help/trust'),
          ),
          ListTile(
            leading: const Icon(Icons.support_agent_outlined),
            title: Text(l10n.supportFaq),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/help/support'),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.aboutAndPricing),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/about-pricing'),
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: Text(l10n.settings),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/settings'),
          ),
          const SizedBox(height: GucSpacing.lg),
          GucButton(
            label: l10n.logout,
            variant: GucButtonVariant.secondary,
            onPressed: () async {
              await ref.read(authControllerProvider.notifier).logout();
              await ref.read(appSettingsProvider.notifier).clearRole();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
    );
  }
}

class ProfileDetailsScreen extends ConsumerWidget {
  const ProfileDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final auth = ref.watch(authControllerProvider);
    final role = ref.watch(appSettingsProvider).role;
    final session = ref.watch(sessionProfileProvider).valueOrNull ?? const {};
    final isShipper = role?.isShipperSide ?? true;

    return Scaffold(
      appBar: AppBar(
        title: Text(isShipper ? l10n.companyProfile : l10n.driverProfile),
        actions: [
          IconButton(onPressed: () => context.push('/profile/edit'), icon: const Icon(Icons.edit_outlined)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(GucSpacing.md),
        children: [
          _row(context, l10n.email, auth.email ?? '—'),
          _row(context, l10n.roleTitle, role == null ? '—' : l10n.roleLabel(role.name)),
          if (isShipper) ...[
            _row(context, l10n.companyNameLabel, session['companyName']?.toString() ?? '—'),
            _row(context, l10n.vatLabel, session['companyVat']?.toString() ?? '—'),
            _row(context, l10n.hqLabel, session['companyHq']?.toString() ?? '—'),
          ] else ...[
            _row(context, l10n.displayName, session['driverDisplayName']?.toString() ?? '—'),
            _row(context, l10n.licenseLabel, session['driverLicense']?.toString() ?? '—'),
            _row(
              context,
              l10n.experienceLabel,
              '${session['driverExperience'] ?? '—'} ${l10n.years}',
            ),
            _row(context, l10n.baseLabel, session['driverBase']?.toString() ?? '—'),
          ],
        ],
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value) {
    return ListTile(title: Text(label), subtitle: Text(value));
  }
}

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _a;
  late final TextEditingController _b;
  late final TextEditingController _c;
  late final TextEditingController _d;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _a = TextEditingController();
    _b = TextEditingController();
    _c = TextEditingController();
    _d = TextEditingController();
    Future.microtask(() {
      final role = ref.read(appSettingsProvider).role;
      final isShipper = role?.isShipperSide ?? true;
      if (isShipper) {
        _a.text = MockData.companyName;
        _b.text = MockData.companyVat;
        _c.text = MockData.companyHq;
      } else {
        _a.text = MockData.driverDisplayName;
        _b.text = MockData.driverLicense;
        _c.text = MockData.driverExperience;
        _d.text = MockData.driverBase;
      }
      setState(() => _ready = true);
    });
  }

  @override
  void dispose() {
    _a.dispose();
    _b.dispose();
    _c.dispose();
    _d.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final role = ref.read(appSettingsProvider).role;
    final isShipper = role?.isShipperSide ?? true;
    if (isShipper) {
      MockData.companyName = _a.text.trim();
      MockData.companyVat = _b.text.trim();
      MockData.companyHq = _c.text.trim();
    } else {
      MockData.driverDisplayName = _a.text.trim();
      MockData.driverLicense = _b.text.trim();
      MockData.driverExperience = _c.text.trim();
      MockData.driverBase = _d.text.trim();
    }
    ref.invalidate(sessionProfileProvider);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).saved)));
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final role = ref.watch(appSettingsProvider).role;
    final isShipper = role?.isShipperSide ?? true;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.editProfile)),
      body: !_ready
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(GucSpacing.lg),
                children: [
                  if (isShipper) ...[
                    GucTextField(label: l10n.companyNameLabel, controller: _a, validator: (v) => (v == null || v.trim().isEmpty) ? l10n.requiredField : null),
                    const SizedBox(height: GucSpacing.sm),
                    GucTextField(label: l10n.vatLabel, controller: _b, validator: (v) => (v == null || v.trim().isEmpty) ? l10n.requiredField : null),
                    const SizedBox(height: GucSpacing.sm),
                    GucTextField(label: l10n.hqLabel, controller: _c, validator: (v) => (v == null || v.trim().isEmpty) ? l10n.requiredField : null),
                  ] else ...[
                    GucTextField(label: l10n.displayName, controller: _a, validator: (v) => (v == null || v.trim().isEmpty) ? l10n.requiredField : null),
                    const SizedBox(height: GucSpacing.sm),
                    GucTextField(label: l10n.licenseLabel, controller: _b, validator: (v) => (v == null || v.trim().isEmpty) ? l10n.requiredField : null),
                    const SizedBox(height: GucSpacing.sm),
                    GucTextField(label: l10n.experienceLabel, controller: _c, keyboardType: TextInputType.number),
                    const SizedBox(height: GucSpacing.sm),
                    GucTextField(label: l10n.baseLabel, controller: _d, validator: (v) => (v == null || v.trim().isEmpty) ? l10n.requiredField : null),
                  ],
                  const SizedBox(height: GucSpacing.lg),
                  GucButton(label: l10n.save, onPressed: _save),
                ],
              ),
            ),
    );
  }
}

class VerificationScreen extends ConsumerStatefulWidget {
  const VerificationScreen({super.key});

  @override
  ConsumerState<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends ConsumerState<VerificationScreen> {
  Future<void> _upload(String key) async {
    final l10n = AppLocalizations.of(context);
    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(leading: const Icon(Icons.photo_camera_outlined), title: Text(l10n.takePhoto), onTap: () => Navigator.pop(ctx, 'camera')),
            ListTile(leading: const Icon(Icons.photo_library_outlined), title: Text(l10n.chooseGallery), onTap: () => Navigator.pop(ctx, 'gallery')),
            ListTile(leading: const Icon(Icons.attach_file), title: Text(l10n.chooseFile), onTap: () => Navigator.pop(ctx, 'file')),
          ],
        ),
      ),
    );
    if (choice == null) return;
    setState(() {
      MockData.verificationUploads[key] = 'PENDING';
      MockData.companyVerified = false;
      MockData.driverVerified = false;
    });
    ref.invalidate(sessionProfileProvider);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.documentSubmitted)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final role = ref.watch(appSettingsProvider).role;
    final isShipper = role?.isShipperSide ?? true;
    final verified = isShipper ? MockData.companyVerified : MockData.driverVerified;
    final steps = isShipper
        ? [
            ('identity', l10n.verifyIdentity),
            ('business', l10n.verifyBusiness),
            ('tax', l10n.verifyTax),
            ('insurance', l10n.verifyInsurance),
          ]
        : [
            ('identity', l10n.verifyIdentity),
            ('license', l10n.verifyLicenseDoc),
            ('insurance', l10n.verifyInsurance),
            ('vehicle', l10n.verifyVehicleDoc),
          ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.verification)),
      body: ListView(
        padding: const EdgeInsets.all(GucSpacing.lg),
        children: [
          GucBadge(
            label: verified
                ? (isShipper ? l10n.verifiedCompany : l10n.verifiedDriver)
                : l10n.verificationPending,
            tone: verified ? GucBadgeTone.success : GucBadgeTone.warning,
            icon: verified ? Icons.verified_outlined : Icons.hourglass_top,
          ),
          const SizedBox(height: GucSpacing.md),
          Text(verified ? l10n.verificationBodyVerified : l10n.verificationWizardHint),
          const SizedBox(height: GucSpacing.lg),
          ...steps.map((s) {
            final status = MockData.verificationUploads[s.$1] ?? 'MISSING';
            return Padding(
              padding: const EdgeInsets.only(bottom: GucSpacing.sm),
              child: GucCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(s.$2, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700))),
                        GucBadge(label: l10n.docStatus(status), tone: _tone(status)),
                      ],
                    ),
                    const SizedBox(height: GucSpacing.sm),
                    GucButton(
                      label: status == 'MISSING' ? l10n.uploadDocument : l10n.replaceDocument,
                      variant: GucButtonVariant.secondary,
                      onPressed: () => _upload(s.$1),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  GucBadgeTone _tone(String status) => switch (status) {
        'APPROVED' => GucBadgeTone.success,
        'PENDING' => GucBadgeTone.warning,
        'REJECTED' => GucBadgeTone.danger,
        _ => GucBadgeTone.neutral,
      };
}
