class AppConfig {
  const AppConfig._();

  static const bool useMockData = bool.fromEnvironment(
    'USE_MOCK_DATA',
    defaultValue: true,
  );

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8080',
  );
}
