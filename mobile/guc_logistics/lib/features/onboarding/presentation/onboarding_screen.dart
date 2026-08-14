import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/providers.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/guc_theme.dart';
import '../../../core/widgets/guc_widgets.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await ref.read(appSettingsProvider.notifier).completeOnboarding();
    if (mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pages = [
      (Icons.inventory_2_outlined, l10n.onboarding1Title, l10n.onboarding1Body),
      (Icons.route_outlined, l10n.onboarding2Title, l10n.onboarding2Body),
      (Icons.verified_user_outlined, l10n.onboarding3Title, l10n.onboarding3Body),
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(GucSpacing.lg),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(onPressed: _finish, child: Text(l10n.skip)),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: pages.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (context, i) {
                    final page = pages[i];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(page.$1, size: 72, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(height: GucSpacing.lg),
                        Text(
                          page.$2,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: GucSpacing.sm),
                        Text(page.$3, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge),
                      ],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pages.length,
                  (i) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i == _index
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: GucSpacing.lg),
              GucButton(
                label: _index == pages.length - 1 ? l10n.getStarted : l10n.continueLabel,
                onPressed: () {
                  if (_index == pages.length - 1) {
                    _finish();
                  } else {
                    _controller.nextPage(duration: const Duration(milliseconds: 280), curve: Curves.easeOut);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
