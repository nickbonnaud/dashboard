import 'package:dashboard/boot_phases/phase_one.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:responsive_framework/responsive_framework.dart';

class MockRoute extends Mock implements Route {}
class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class ScreenBuilder {
  final Widget child;
  final NavigatorObserver observer;

  ScreenBuilder({required this.child, required this.observer});

  Future<void> createScreen({required WidgetTester tester, bool shouldPump = true}) async {
    await tester.pumpWidget(
      PhaseOne(
        testApp: MaterialApp(
          home: child,
          navigatorObservers: [observer],
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (_) => Container(),
              settings: const RouteSettings(name: "test")
            );
          },
          builder: (context, widget) {
            SizeConfig().init(context);
            return ResponsiveWrapper.builder(
              ClampingScrollWrapper.builder(context, widget!),
              defaultScale: true,
              minWidth: 480,
              maxWidth: 1200,
              breakpoints: [
                const ResponsiveBreakpoint.resize(480, name: MOBILE),
                const ResponsiveBreakpoint.autoScale(800, name: TABLET),
                const ResponsiveBreakpoint.resize(1000, name: DESKTOP),
                const ResponsiveBreakpoint.autoScale(2460, name: '4K'),
              ]
            );
          },
        )
      )
    );
    if (shouldPump) {
      await tester.pumpAndSettle();
    }
  }
}
