import 'package:dashboard/screens/account_menu_screen/account_menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/screen_builder.dart';

void main() {
  group("Account Screen Tests", () {
    late ScreenBuilder screenBuilder;
    late NavigatorObserver observer;

    setUpAll(() {
      observer = MockNavigatorObserver();
      screenBuilder = ScreenBuilder(child: AccountMenuScreen(), observer: observer);
      registerFallbackValue<Route>(MockRoute());
    });
    
    testWidgets("Test menu list shows up", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets("Test Menu displays all menu items", (tester) async {
      final List<String> routTitles = AccountMenuScreen().routeTitles;
      await screenBuilder.createScreen(tester: tester);
      routTitles.forEach((title) => expect(find.text(title), findsOneWidget));
    });

    testWidgets("Tapping menu buttton navigates to corresponding screen", (tester) async {
      final List<String> routeTitles = AccountMenuScreen().routeTitles;
      String title = (routeTitles..shuffle()).first;
      await screenBuilder.createScreen(tester: tester);
      await tester.tap(find.text(title));
      await tester.pumpAndSettle();
      verify(() => observer.didPush(any(that: isA<Route>()), any(that: isA<Route>())));
    });
  });
}