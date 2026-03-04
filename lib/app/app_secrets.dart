class AppSecrets {
  static const String catApiKey = String.fromEnvironment('CAT_API_KEY');
  static const String openRouterApiKey = String.fromEnvironment(
    'OPENROUTER_API_KEY',
  );

  static const String openRouterReferer = String.fromEnvironment(
    'OPENROUTER_REFERER',
    defaultValue: 'cat-tinder.app',
  );

  static const String openRouterTitle = String.fromEnvironment(
    'OPENROUTER_TITLE',
    defaultValue: 'CatTinder',
  );
  static const String appMetricaApiKey = String.fromEnvironment(
    'APPMETRICA_API_KEY',
  );

  static bool get hasCatApiKey => catApiKey.isNotEmpty;
  static bool get hasOpenRouterApiKey => openRouterApiKey.isNotEmpty;
  static bool get hasAppMetricaApiKey => appMetricaApiKey.isNotEmpty;
}
