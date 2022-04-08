import 'package:dashboard/models/status.dart';
import 'package:dashboard/screens/onboard_screen/onboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/screen_builder.dart';

void main() {
  group("Onboard Screen Tests", () {
    late NavigatorObserver observer;
    late ScreenBuilder screenBuilder;


    setUp(() {
      observer = MockNavigatorObserver();
      registerFallbackValue(MockRoute());
    });

    void _setScreenBuilder({required int code}) {
      screenBuilder = ScreenBuilder(
        child: OnboardScreen(accountStatus: Status(name: "status", code: code)), 
        observer: observer
      );
    }

    testWidgets("Onboard Screen creates AppBar", (tester) async {
      _setScreenBuilder(code: 100);
      await screenBuilder.createScreen(tester: tester);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets("Onboard Screen Body creates Stepper", (tester) async {
      _setScreenBuilder(code: 100);
      await screenBuilder.createScreen(tester: tester);
      expect(find.byType(Stepper), findsOneWidget);
    });

    testWidgets("Onboard Screen Body active step with 100 code is Profile", (tester) async {
      _setScreenBuilder(code: 100);
      await screenBuilder.createScreen(tester: tester);
      expect(tester.widget<Stepper>(find.byType(Stepper)).currentStep, 0);
      expect(find.text("Get Started"), findsWidgets);
    });

    testWidgets("Tapping Profile step button navigates to Profile Screen", (tester) async {
      _setScreenBuilder(code: 100);
      await screenBuilder.createScreen(tester: tester);
      await tester.tap(find.text("Get Started").first);
      verify(() => observer.didPush(any(), any()));
    });

    testWidgets("Onboard Screen Body active step with 101 code is Logos", (tester) async {
      _setScreenBuilder(code: 101);
      await screenBuilder.createScreen(tester: tester);
      expect(tester.widget<Stepper>(find.byType(Stepper)).currentStep, 1);
      expect(find.text("Add Logos"), findsWidgets);
    });

    testWidgets("Tapping Logos step button navigates to Logos Screen", (tester) async {
      _setScreenBuilder(code: 101);
      await screenBuilder.createScreen(tester: tester);
      await tester.tap(find.text("Add Logos").at(1));
      verify(() => observer.didPush(any(), any()));
    });

    testWidgets("Onboard Screen Body active step with 102 code is Business Details", (tester) async {
      _setScreenBuilder(code: 102);
      await screenBuilder.createScreen(tester: tester);
      expect(tester.widget<Stepper>(find.byType(Stepper)).currentStep, 2);
      expect(find.text("Add Details"), findsWidgets);
    });

    testWidgets("Business Details step button navigates to Business Account Screen", (tester) async {
      _setScreenBuilder(code: 102);
      await screenBuilder.createScreen(tester: tester);
      await tester.tap(find.text("Add Details").at(2));
      verify(() => observer.didPush(any(), any()));
    });

    testWidgets("Onboard Screen Body active step with 103 code is Owners", (tester) async {
      _setScreenBuilder(code: 103);
      await screenBuilder.createScreen(tester: tester);
      expect(tester.widget<Stepper>(find.byType(Stepper)).currentStep, 3);
      expect(find.text("Add Owners"), findsWidgets);
    });

    testWidgets("Owners step button navigates to Onboard Owners Screen", (tester) async {
      _setScreenBuilder(code: 103);
      await screenBuilder.createScreen(tester: tester);
      await tester.tap(find.text("Add Owners").at(3));
      verify(() => observer.didPush(any(), any()));
    });

    testWidgets("Onboard Screen Body active step with 104 code is Banking", (tester) async {
      _setScreenBuilder(code: 104);
      await screenBuilder.createScreen(tester: tester);
      expect(tester.widget<Stepper>(find.byType(Stepper)).currentStep, 4);
      expect(find.text("Setup Account"), findsWidgets);
    });

    testWidgets("Banking step button navigates to Onboard Bank Screen", (tester) async {
      _setScreenBuilder(code: 104);
      await screenBuilder.createScreen(tester: tester);
      await tester.tap(find.text("Setup Account").at(4));
      verify(() => observer.didPush(any(), any()));
    });

    testWidgets("Onboard Screen Body active step with 105 code is Location", (tester) async {
      _setScreenBuilder(code: 105);
      await screenBuilder.createScreen(tester: tester);
      expect(tester.widget<Stepper>(find.byType(Stepper)).currentStep, 5);
      expect(find.text("Review Location"), findsWidgets);
    });

    testWidgets("Location step button navigates to Onboard Location Screen", (tester) async {
      _setScreenBuilder(code: 105);
      await screenBuilder.createScreen(tester: tester);

      await tester.drag(find.text("Account Setup"), const Offset(0, -200));
      await tester.pump();

      await tester.tap(find.text("Review Location").at(5));
      verify(() => observer.didPush(any(), any()));
    });

    testWidgets("Onboard Screen Body active step with 106 code is Point of Sale", (tester) async {
      _setScreenBuilder(code: 106);
      await screenBuilder.createScreen(tester: tester);
      expect(tester.widget<Stepper>(find.byType(Stepper)).currentStep, 6);
      expect(find.text("Connect POS"), findsWidgets);
    });

    // testWidgets("Point of Sale step button navigates to Onboard POS Screen", (tester) async {
    //   _setScreenBuilder(code: 106);
    //   await screenBuilder.createScreen(tester: tester);

    //   await tester.drag(find.text("Account Setup"), Offset(0, -200));
    //   await tester.pump();

    //   await tester.tap(find.text("Connect POS").at(6));
    //   verify(() => observer.didPush(any(), any()));
    // });

    testWidgets("Onboard Screen Body active step with 107 code is Hours", (tester) async {
      _setScreenBuilder(code: 107);
      await screenBuilder.createScreen(tester: tester);
      expect(tester.widget<Stepper>(find.byType(Stepper)).currentStep, 7);
      expect(find.text("Set Hours"), findsWidgets);
    });

    testWidgets("Hours step button navigates to Onboard Hours Screen", (tester) async {
      _setScreenBuilder(code: 107);
      await screenBuilder.createScreen(tester: tester);

      await tester.drag(find.text("Account Setup"), const Offset(0, -200));
      await tester.pump();

      await tester.tap(find.text("Set Hours").at(7));
      verify(() => observer.didPush(any(), any()));
    });

  });
}