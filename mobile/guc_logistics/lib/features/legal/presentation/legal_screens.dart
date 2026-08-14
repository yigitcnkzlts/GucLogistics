import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/guc_theme.dart';
import '../../../core/widgets/guc_widgets.dart';

class LegalDocumentScreen extends StatelessWidget {
  const LegalDocumentScreen({super.key, required this.titleKey, required this.bodyKey});

  final String titleKey;
  final String bodyKey;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = switch (titleKey) {
      'privacyPolicy' => l10n.privacyPolicy,
      'termsOfUse' => l10n.termsOfUse,
      'kvkkNotice' => l10n.kvkkNotice,
      'aboutUs' => l10n.aboutUs,
      'pricing' => l10n.pricing,
      _ => titleKey,
    };
    final body = switch (bodyKey) {
      'privacyBody' => l10n.privacyBody,
      'termsBody' => l10n.termsBody,
      'kvkkBody' => l10n.kvkkBody,
      'aboutBody' => l10n.aboutBody,
      'pricingBody' => l10n.pricingBody,
      _ => bodyKey,
    };

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(GucSpacing.lg),
        children: [
          Text(body, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.45)),
        ],
      ),
    );
  }
}

class AboutPricingHubScreen extends StatelessWidget {
  const AboutPricingHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tiles = <(IconData, String, String)>[
      (Icons.info_outline, l10n.aboutUs, '/about'),
      (Icons.route_outlined, l10n.howItWorks, '/help/how-it-works'),
      (Icons.verified_user_outlined, l10n.trustSafety, '/help/trust'),
      (Icons.payments_outlined, l10n.pricing, '/pricing'),
      (Icons.support_agent_outlined, l10n.supportFaq, '/help/support'),
      (Icons.privacy_tip_outlined, l10n.privacyPolicy, '/legal/privacy'),
      (Icons.gavel_outlined, l10n.termsOfUse, '/legal/terms'),
      (Icons.policy_outlined, l10n.kvkkNotice, '/legal/kvkk'),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(l10n.aboutAndPricing)),
      body: ListView.separated(
        padding: const EdgeInsets.all(GucSpacing.md),
        itemCount: tiles.length,
        separatorBuilder: (_, __) => const SizedBox(height: GucSpacing.sm),
        itemBuilder: (context, i) {
          final t = tiles[i];
          return GucCard(
            onTap: () => context.push(t.$3),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(t.$1),
              title: Text(t.$2),
              trailing: const Icon(Icons.chevron_right),
            ),
          );
        },
      ),
    );
  }
}

class HowItWorksScreen extends StatelessWidget {
  const HowItWorksScreen({super.key, this.forShipper = true});

  final bool forShipper;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final steps = forShipper
        ? [
            (l10n.howStep1ShipperTitle, l10n.howStep1ShipperBody),
            (l10n.howStep2ShipperTitle, l10n.howStep2ShipperBody),
            (l10n.howStep3ShipperTitle, l10n.howStep3ShipperBody),
          ]
        : [
            (l10n.howStep1CarrierTitle, l10n.howStep1CarrierBody),
            (l10n.howStep2CarrierTitle, l10n.howStep2CarrierBody),
            (l10n.howStep3CarrierTitle, l10n.howStep3CarrierBody),
          ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.howItWorks)),
      body: ListView(
        padding: const EdgeInsets.all(GucSpacing.md),
        children: [
          Text(l10n.howItWorksIntro, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: GucSpacing.md),
          for (var i = 0; i < steps.length; i++) ...[
            GucCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(child: Text('${i + 1}')),
                  const SizedBox(width: GucSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(steps[i].$1, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Text(steps[i].$2),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: GucSpacing.sm),
          ],
          GucButton(
            label: l10n.trustSafety,
            variant: GucButtonVariant.secondary,
            onPressed: () => context.push('/help/trust'),
          ),
        ],
      ),
    );
  }
}

class TrustSafetyScreen extends StatelessWidget {
  const TrustSafetyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = [
      (Icons.verified_outlined, l10n.trustVerifyTitle, l10n.trustVerifyBody),
      (Icons.lock_outline, l10n.trustEscrowTitle, l10n.trustEscrowBody),
      (Icons.chat_outlined, l10n.trustMatchTitle, l10n.trustMatchBody),
      (Icons.gavel_outlined, l10n.trustClaimsTitle, l10n.trustClaimsBody),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(l10n.trustSafety)),
      body: ListView.separated(
        padding: const EdgeInsets.all(GucSpacing.md),
        itemCount: items.length + 1,
        separatorBuilder: (_, __) => const SizedBox(height: GucSpacing.sm),
        itemBuilder: (context, i) {
          if (i == 0) {
            return Text(l10n.trustSafetyIntro);
          }
          final item = items[i - 1];
          return GucCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(item.$1, color: Theme.of(context).colorScheme.primary),
              title: Text(item.$2, style: const TextStyle(fontWeight: FontWeight.w800)),
              subtitle: Text(item.$3),
            ),
          );
        },
      ),
    );
  }
}

class SupportFaqScreen extends StatelessWidget {
  const SupportFaqScreen({super.key});

  Future<void> _launch(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final faqs = [
      (l10n.faq1Q, l10n.faq1A),
      (l10n.faq2Q, l10n.faq2A),
      (l10n.faq3Q, l10n.faq3A),
      (l10n.faq4Q, l10n.faq4A),
      (l10n.faq5Q, l10n.faq5A),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.supportFaq)),
      body: ListView(
        padding: const EdgeInsets.all(GucSpacing.md),
        children: [
          Text(l10n.supportIntro),
          const SizedBox(height: GucSpacing.md),
          GucCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.contactUs, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: GucSpacing.sm),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.email_outlined),
                  title: Text(l10n.supportEmail),
                  subtitle: const Text('support@guclogistics.com'),
                  onTap: () => _launch(Uri.parse('mailto:support@guclogistics.com?subject=GucLogistics%20Support')),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.chat_outlined),
                  title: Text(l10n.supportWhatsapp),
                  subtitle: const Text('+90 850 000 00 00'),
                  onTap: () => _launch(Uri.parse('https://wa.me/908500000000')),
                ),
              ],
            ),
          ),
          const SizedBox(height: GucSpacing.lg),
          Text(l10n.faqTitle, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: GucSpacing.sm),
          ...faqs.map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: GucSpacing.sm),
              child: ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: Text(f.$1, style: const TextStyle(fontWeight: FontWeight.w700)),
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(f.$2),
                    ),
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

/// Compact 3-step card for home screens.
class HowItWorksHomeCard extends StatelessWidget {
  const HowItWorksHomeCard({super.key, required this.forShipper});

  final bool forShipper;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final steps = forShipper
        ? [l10n.howStep1ShipperTitle, l10n.howStep2ShipperTitle, l10n.howStep3ShipperTitle]
        : [l10n.howStep1CarrierTitle, l10n.howStep2CarrierTitle, l10n.howStep3CarrierTitle];

    return GucCard(
      onTap: () => context.push(forShipper ? '/help/how-it-works' : '/help/how-it-works-carrier'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(l10n.howItWorks, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
              ),
              Text(l10n.seeAll, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
            ],
          ),
          const SizedBox(height: 4),
          Text(l10n.howItWorksHomeHint, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: GucSpacing.sm),
          for (var i = 0; i < steps.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  CircleAvatar(radius: 12, child: Text('${i + 1}', style: const TextStyle(fontSize: 12))),
                  const SizedBox(width: 8),
                  Expanded(child: Text(steps[i])),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
