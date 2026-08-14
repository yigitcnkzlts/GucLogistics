import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../theme/guc_theme.dart';

class GucButton extends StatelessWidget {
  const GucButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.expanded = true,
    this.variant = GucButtonVariant.primary,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final bool expanded;
  final GucButtonVariant variant;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final child = loading
        ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2))
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: GucSpacing.xs)],
              Text(label),
            ],
          );

    final button = switch (variant) {
      GucButtonVariant.primary => FilledButton(onPressed: loading ? null : onPressed, child: child),
      GucButtonVariant.secondary => OutlinedButton(onPressed: loading ? null : onPressed, child: child),
      GucButtonVariant.tonal => FilledButton.tonal(onPressed: loading ? null : onPressed, child: child),
    };

    return Semantics(
      button: true,
      label: label,
      child: expanded ? SizedBox(width: double.infinity, child: button) : button,
    );
  }
}

enum GucButtonVariant { primary, secondary, tonal }

class GucTextField extends StatelessWidget {
  const GucTextField({
    super.key,
    required this.label,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
  });

  final String label;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      textField: true,
      label: label,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        onChanged: onChanged,
        maxLines: maxLines,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}

class GucCard extends StatelessWidget {
  const GucCard({super.key, required this.child, this.onTap, this.padding});

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: padding ?? const EdgeInsets.all(GucSpacing.md),
      child: child,
    );
    return Card(
      clipBehavior: Clip.antiAlias,
      child: onTap == null ? content : InkWell(onTap: onTap, child: content),
    );
  }
}

class GucBadge extends StatelessWidget {
  const GucBadge({
    super.key,
    required this.label,
    this.tone = GucBadgeTone.neutral,
    this.icon,
  });

  final String label;
  final GucBadgeTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (bg, fg) = switch (tone) {
      GucBadgeTone.success => (GucColors.success.withValues(alpha: 0.15), GucColors.success),
      GucBadgeTone.warning => (GucColors.warning.withValues(alpha: 0.18), GucColors.warning),
      GucBadgeTone.danger => (scheme.error.withValues(alpha: 0.15), scheme.error),
      GucBadgeTone.neutral => (scheme.surfaceContainerHighest, scheme.onSurfaceVariant),
      GucBadgeTone.info => (scheme.secondary.withValues(alpha: 0.15), scheme.secondary),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 14, color: fg), const SizedBox(width: 4)],
          Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: fg, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

enum GucBadgeTone { neutral, success, warning, danger, info }

class GucStatTile extends StatelessWidget {
  const GucStatTile({super.key, required this.label, required this.value, this.icon});

  final String label;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return GucCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: GucSpacing.xs),
          Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class GucEmptyState extends StatelessWidget {
  const GucEmptyState({super.key, required this.title, this.subtitle, this.action});

  final String title;
  final String? subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(GucSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined, size: 48, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: GucSpacing.sm),
            Text(title, style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
            if (subtitle != null) ...[
              const SizedBox(height: GucSpacing.xs),
              Text(subtitle!, textAlign: TextAlign.center),
            ],
            if (action != null) ...[const SizedBox(height: GucSpacing.md), action!],
          ],
        ),
      ),
    );
  }
}

class GucErrorState extends StatelessWidget {
  const GucErrorState({super.key, required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final retryLabel = Localizations.of<AppLocalizations>(context, AppLocalizations)?.retry ?? 'Retry';
    return GucEmptyState(
      title: message,
      action: onRetry == null
          ? null
          : GucButton(label: retryLabel, onPressed: onRetry, expanded: false, variant: GucButtonVariant.secondary),
    );
  }
}

Future<bool> showGucConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Confirm',
  String cancelLabel = 'Cancel',
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: Text(cancelLabel)),
        FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(confirmLabel)),
      ],
    ),
  );
  return result ?? false;
}
