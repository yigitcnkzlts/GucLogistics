import 'package:flutter_test/flutter_test.dart';
import 'package:guc_logistics/core/validation/auth_validators.dart';
import 'package:guc_logistics/core/validation/load_validators.dart';

void main() {
  group('AuthValidators', () {
    test('production password policy requires at least 12 characters', () {
      expect(AuthValidators.isStrongPassword('Short1!a'), isFalse);
      expect(AuthValidators.isStrongPassword('SecurePass1!'), isTrue);
    });

    test('email rejects malformed input', () {
      expect(AuthValidators.email('wrong', 'invalid'), 'invalid');
      expect(AuthValidators.email('ops@guc.test', 'invalid'), isNull);
    });
  });

  group('LoadValidators', () {
    test('accepts comma decimal weights and enforces road limit', () {
      expect(LoadValidators.weightTons('22,5'), isNull);
      expect(LoadValidators.weightTons('0'), isNotNull);
      expect(LoadValidators.weightTons('61'), isNotNull);
    });

    test('validates country, temperature and schedule', () {
      expect(LoadValidators.countryCode('TR'), isNull);
      expect(LoadValidators.countryCode('TUR'), isNotNull);
      expect(LoadValidators.temperatureRange('-18', '-15'), isNull);
      expect(LoadValidators.temperatureRange('4', '-2'), isNotNull);
      final pickup = DateTime(2026, 9, 10, 8);
      expect(LoadValidators.schedule(pickup, pickup.add(const Duration(hours: 8))), isNull);
      expect(LoadValidators.schedule(pickup, pickup), isNotNull);
    });
  });
}
