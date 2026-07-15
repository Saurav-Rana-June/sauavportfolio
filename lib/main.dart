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

  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1440, 1024),
      minTextAdapt: true,
      splitScreenMode: true,
      rebuildFactor: RebuildFactors.change,
      builder: (context, child) {
        return GetMaterialApp(
          title: AppConfig.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          initialRoute: Routes.initialRoute,
          getPages: Nav.routes,
        );
      },
    );
  }
}
