import 'package:saurav_portfolio/data/methods/app_method.dart';

class Routes {
  static Future<String> get initialRoute async {
    final hasVisited = AppMethod.getHasVisited();
    return hasVisited ? home : landing;
  }

  static const landing = '/landing';
  static const home = '/home';
  static const projects = '/projects';
  static const projectDetail = '/project-detail';
  static const contact = '/contact';
}
