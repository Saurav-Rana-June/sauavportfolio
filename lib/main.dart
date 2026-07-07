import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:saurav_portfolio/config.dart';
import 'package:saurav_portfolio/controllers/global.controller.dart';
import 'package:saurav_portfolio/data/methods/app_method.dart';
import 'package:saurav_portfolio/infrastructure/navigation/navigation.dart';
import 'package:saurav_portfolio/infrastructure/navigation/routes.dart';
import 'package:saurav_portfolio/infrastructure/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppMethod.initStorage();
  Get.put(GlobalController());

  final initialRoute = await Routes.initialRoute;

  runApp(PortfolioApp(initialRoute: initialRoute));
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key, required this.initialRoute});

  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1440, 900),
      minTextAdapt: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: AppConfig.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          initialRoute: initialRoute,
          getPages: Nav.routes,
          defaultTransition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 250),
        );
      },
    );
  }
}
