import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Lightweight hand-written localizations (works without flutter gen-l10n CLI).
class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = [Locale('en'), Locale('tr')];

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static final Map<String, Map<String, String>> _values = {
    'en': {
      'appTitle': 'GucLogistics',
      'login': 'Sign in',
      'register': 'Create account',
      'email': 'Email',
      'password': 'Password',
      'loads': 'Loads',
      'offers': 'Offers',
      'profile': 'Profile',
      'logout': 'Sign out',
      'role': 'Role',
      'submitOffer': 'Submit offer',
      'offlineBanner': 'You are offline. Showing cached loads.',
    },
    'tr': {
      'appTitle': 'GucLogistics',
      'login': 'Giriş yap',
      'register': 'Hesap oluştur',
      'email': 'E-posta',
      'password': 'Şifre',
      'loads': 'Yükler',
      'offers': 'Teklifler',
      'profile': 'Profil',
      'logout': 'Çıkış yap',
      'role': 'Rol',
      'submitOffer': 'Teklif ver',
      'offlineBanner': 'Çevrimdışısınız. Önbellekteki yükler gösteriliyor.',
    },
  };

  String _t(String key) => _values[locale.languageCode]?[key] ?? _values['en']![key]!;

  String get appTitle => _t('appTitle');
  String get login => _t('login');
  String get register => _t('register');
  String get email => _t('email');
  String get password => _t('password');
  String get loads => _t('loads');
  String get offers => _t('offers');
  String get profile => _t('profile');
  String get logout => _t('logout');
  String get role => _t('role');
  String get submitOffer => _t('submitOffer');
  String get offlineBanner => _t('offlineBanner');
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'tr'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture(AppLocalizations(locale));
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}
