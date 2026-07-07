import 'package:saurav_portfolio/infrastructure/environment/environment.dart';

class AppConfig {
  static const String appName = 'Saurav Portfolio';
  static const String appVersion = '1.0.0';

  static String get apiBaseUrl => Environment.apiBaseUrl;
  static bool get isProduction => Environment.isProduction;
}
