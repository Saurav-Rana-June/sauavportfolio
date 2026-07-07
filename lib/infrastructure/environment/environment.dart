enum AppEnvironment { development, production }

class Environment {
  static const AppEnvironment current = AppEnvironment.development;

  static bool get isProduction => current == AppEnvironment.production;

  static String get apiBaseUrl {
    switch (current) {
      case AppEnvironment.development:
        return 'http://localhost:8080/api/v1';
      case AppEnvironment.production:
        return 'https://api.saurav.dev/v1';
    }
  }
}
