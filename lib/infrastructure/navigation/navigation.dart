import 'package:get/get.dart';
import 'package:saurav_portfolio/infrastructure/navigation/bindings/controllers/home.controller.binding.dart';
import 'package:saurav_portfolio/infrastructure/navigation/bindings/controllers/project_details.controller.binding.dart';
import 'package:saurav_portfolio/infrastructure/navigation/routes.dart';
import 'package:saurav_portfolio/presentation/home/home.screen.dart';
import 'package:saurav_portfolio/presentation/project_details/project_details.screen.dart';

class Nav {
  static List<GetPage<dynamic>> routes = [
    GetPage(
      name: Routes.home,
      page: () => const HomeScreen(),
      binding: HomeControllerBinding(),
    ),
    GetPage(
      name: Routes.projectDetails,
      page: () => const ProjectDetailsScreen(),
      binding: ProjectDetailsControllerBinding(),
    ),
  ];
}
