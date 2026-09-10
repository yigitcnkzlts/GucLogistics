class LoadValidators {
  const LoadValidators._();

  static String? countryCode(String? value) {
    final code = value?.trim() ?? '';
    return RegExp(r'^[A-Za-z]{2}$').hasMatch(code) ? null : 'İki harfli ülke kodu girin';
  }

  static String? weightTons(String? value) {
    final tons = double.tryParse((value ?? '').replaceAll(',', '.'));
    return tons != null && tons > 0 && tons <= 60 ? null : '0–60 ton arasında değer girin';
  }

  static String? temperatureRange(String? minimum, String? maximum) {
    final min = double.tryParse((minimum ?? '').replaceAll(',', '.'));
    final max = double.tryParse((maximum ?? '').replaceAll(',', '.'));
    if (min == null || max == null) return 'Geçerli sıcaklık aralığı girin';
    return min <= max ? null : 'Minimum sıcaklık maksimumdan büyük olamaz';
  }

  static String? schedule(DateTime pickup, DateTime delivery) =>
      delivery.isAfter(pickup) ? null : 'Teslim zamanı yükleme zamanından sonra olmalıdır';
}
