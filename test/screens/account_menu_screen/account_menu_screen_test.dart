import 'dart:math';

import 'package:dashboard/screens/account_menu_screen/account_menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/screen_builder.dart';

void main() {
  group("Account Menu Screen Tests", () {
    late ScreenBuilder screenBuilder;
    late NavigatorObserver observer;

    setUpAll(() {
      observer = MockNavigatorObserver();
      screenBuilder = ScreenBuilder(child: const AccountMenuScreen(), observer: observer);
      registerFallbackValue(MockRoute());
    });
    
    testWidgets("menu list shows up", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets("Menu displays all menu items", (tester) async {
      final List<String> routeTitles = const AccountMenuScreen().routeTitles;
      await screenBuilder.createScreen(tester: tester);
      for (var title in routeTitles) {
        expect(find.text(title), findsOneWidget);
      }
    });

    testWidgets("Tapping menu buttton navigates to corresponding screen", (tester) async {
      final List<String> routeTitles = const AccountMenuScreen().routeTitles;
      String title = routeTitles[Random().nextInt(routeTitles.length)];
      await screenBuilder.createScreen(tester: tester);
      await tester.tap(find.text(title));
      await tester.pumpAndSettle();
      verify(() => observer.didPush(any(that: isA<Route>()), any(that: isA<Route>())));
    });
  });
}