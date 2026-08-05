import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guc_logistics/core/l10n/app_localizations.dart';

void main() {
  test('english localization resolves brand title', () {
    final l10n = AppLocalizations(const Locale('en'));
    expect(l10n.appTitle, 'GucLogistics');
  });

  test('turkish localization resolves login label', () {
    final l10n = AppLocalizations(const Locale('tr'));
    expect(l10n.login, 'Giriş yap');
  });
}
