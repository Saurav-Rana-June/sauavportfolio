import 'package:saurav_portfolio/data/methods/app_method.dart';

class SessionCleanup {
  static Future<void> clearSession() async {
    await AppMethod.clearAll();
  }
}
