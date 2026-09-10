class AuthValidators {
  static final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final upper = RegExp(r'[A-Z]');
  static final lower = RegExp(r'[a-z]');
  static final digit = RegExp(r'[0-9]');
  static final special = RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-+=\[\]\\;/]');

  static String? email(String? value, String invalidMessage) {
    final v = value?.trim() ?? '';
    if (v.isEmpty || !emailRegex.hasMatch(v)) return invalidMessage;
    return null;
  }

  static String? loginPassword(String? value, String requiredMessage) {
    if (value == null || value.isEmpty) return requiredMessage;
    return null;
  }

  static String? registerPassword(String? value, {
    required String tooShort,
    required String needUpper,
    required String needLower,
    required String needDigit,
    required String needSpecial,
  }) {
    final v = value ?? '';
    if (v.length < 12) return tooShort;
    if (!upper.hasMatch(v)) return needUpper;
    if (!lower.hasMatch(v)) return needLower;
    if (!digit.hasMatch(v)) return needDigit;
    if (!special.hasMatch(v)) return needSpecial;
    return null;
  }

  static String? confirmPassword(String? value, String password, String mismatch) {
    if (value != password) return mismatch;
    return null;
  }

  static bool isStrongPassword(String value) =>
      registerPassword(
        value,
        tooShort: 'x',
        needUpper: 'x',
        needLower: 'x',
        needDigit: 'x',
        needSpecial: 'x',
      ) ==
      null;
}
