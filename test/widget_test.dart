import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:saurav_portfolio/controllers/global.controller.dart';
import 'package:saurav_portfolio/data/models/portfolio/profile.model.dart';
import 'package:saurav_portfolio/presentation/home/controllers/home.controller.dart';
import 'package:saurav_portfolio/presentation/home/home.screen.dart';

void main() {
  setUp(() {
    Get.testMode = true;
    Get.put(GlobalController());
    final controller = Get.put(HomeController());
    controller.globalController.setProfile(
      ProfileModel(
        name: 'Saurav Rana',
        title: 'Flutter Developer',
        bio: 'Test bio',
        email: 'hello@saurav.dev',
        location: 'India',
        skills: const ['Flutter'],
      ),
    );
    controller.isLoading.value = false;
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('Home screen renders portfolio sections', (tester) async {
    tester.view.physicalSize = const Size(1440, 3000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(1440, 900),
        builder: (_, __) => const GetMaterialApp(home: HomeScreen()),
      ),
    );
    await tester.pump();

    expect(find.text('About Me'), findsOneWidget);
    expect(find.text('Saurav Rana'), findsWidgets);
  });
}
