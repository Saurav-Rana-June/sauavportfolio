import 'package:get/get.dart';
import 'package:saurav_portfolio/infrastructure/navigation/bindings/controllers/contact.controller.binding.dart';
import 'package:saurav_portfolio/infrastructure/navigation/bindings/controllers/home.controller.binding.dart';
import 'package:saurav_portfolio/infrastructure/navigation/bindings/controllers/landing.controller.binding.dart';
import 'package:saurav_portfolio/infrastructure/navigation/bindings/controllers/project_detail.controller.binding.dart';
import 'package:saurav_portfolio/infrastructure/navigation/bindings/controllers/projects.controller.binding.dart';
import 'package:saurav_portfolio/infrastructure/navigation/routes.dart';
import 'package:saurav_portfolio/presentation/screens.dart';

class Nav {
  static List<GetPage<dynamic>> routes = [
    GetPage(
      name: Routes.landing,
      page: () => const LandingScreen(),
      binding: LandingControllerBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeScreen(),
      binding: HomeControllerBinding(),
    ),
    GetPage(
      name: Routes.projects,
      page: () => const ProjectsScreen(),
      binding: ProjectsControllerBinding(),
    ),
    GetPage(
      name: Routes.projectDetail,
      page: () => const ProjectDetailScreen(),
      binding: ProjectDetailControllerBinding(),
    ),
    GetPage(
      name: Routes.contact,
      page: () => const ContactScreen(),
      binding: ContactControllerBinding(),
    ),
  ];
}
