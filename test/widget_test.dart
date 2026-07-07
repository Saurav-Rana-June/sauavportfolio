import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:saurav_portfolio/controllers/global.controller.dart';
import 'package:saurav_portfolio/presentation/landing/landing.screen.dart';
import 'package:saurav_portfolio/presentation/landing/controllers/landing.controller.dart';

void main() {
  setUp(() {
    Get.testMode = true;
    Get.put(GlobalController());
    Get.put(LandingController());
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('Landing screen renders portfolio intro', (tester) async {
    await tester.pumpWidget(
      const GetMaterialApp(home: LandingScreen()),
    );

    expect(find.text('Saurav'), findsOneWidget);
    expect(find.text('Enter Portfolio'), findsOneWidget);
  });
}
