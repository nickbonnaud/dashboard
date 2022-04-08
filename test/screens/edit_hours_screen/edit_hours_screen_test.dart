import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/global_widgets/app_bars/default_app_bar.dart';
import 'package:dashboard/models/business/hours.dart';
import 'package:dashboard/repositories/hours_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/edit_hours_screen/edit_hours_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mock_data_generator.dart';
import '../../helpers/screen_builder.dart';

class MockHoursRepository extends Mock implements HoursRepository {}
class MockBusinessBloc extends Mock implements BusinessBloc {}
class MockHours extends Mock implements Hours {}

void main() {
  group("Edit Hours Screen Tests", () {
    final List<String> _days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    
    late MockDataGenerator mockDataGenerator;
    late NavigatorObserver observer;
    late HoursRepository hoursRepository;
    late BusinessBloc businessBloc;
    late Hours hours;
    late ScreenBuilder screenBuilder;

    setUpAll(() {
      mockDataGenerator = MockDataGenerator();
      observer = MockNavigatorObserver();
      hoursRepository = MockHoursRepository();
      businessBloc = MockBusinessBloc();
      hours = mockDataGenerator.createHours();

      screenBuilder = ScreenBuilder(
        child: EditHoursScreen(
          hoursRepository: hoursRepository,
          businessBloc: businessBloc,
          hours: hours,
        ), 
        observer: observer
      );

      when(() => hoursRepository.update(identifier: any(named: "identifier"), sunday: any(named: "sunday"), monday: any(named: "monday"), tuesday: any(named: "tuesday"), wednesday: any(named: "wednesday"), thursday: any(named: "thursday"), friday: any(named: "friday"), saturday: any(named: "saturday")))
        .thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 500), () => mockDataGenerator.createHours()));


      registerFallbackValue(MockRoute());
    });

    testWidgets("Edit Hours Screen creates DefaultAppBar", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byType(DefaultAppBar), findsOneWidget);
    });

    testWidgets("Edit Hours Screen displays correct headers", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.text("Change Operating Hours."), findsOneWidget);
      expect(find.text("Select individual hours to edit."), findsOneWidget);
    });

    testWidgets("Edit Hours Screen displays each days hours", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      hours.days.asMap().forEach((index, hour) {
        expect(find.text("${_days[index]}:"), findsOneWidget);
        if (hour.toLowerCase() != "closed") {
          expect(find.byKey(Key(_days[index])), findsOneWidget);
        }
      });
      expect(find.text('Closed'), findsOneWidget);
    });

    testWidgets("Tapping add Hours button shows TimePicker", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.text("Add Hour"), findsNothing);
      await tester.tap(find.byIcon(Icons.add_circle).first);
      await tester.pump();
      expect(find.text("Add Hour"), findsOneWidget);
    });

    testWidgets("Tapping Set on timePicker adds hour", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byType(TextButton), findsNWidgets(14));
      await tester.tap(find.byIcon(Icons.add_circle).first);
      await tester.pump();
      await tester.tap(find.text("Set"));
      await tester.pump();
      expect(find.byType(TextButton), findsNWidgets(16));
    });

    testWidgets("Tapping Remove hour button removes hours", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byType(TextButton), findsNWidgets(14));
      int openHourIndex = hours.days.indexOf(hours.days.firstWhere((hour) => hour.toLowerCase() != "closed"));
      await tester.tap(find.byIcon(Icons.do_disturb_on_rounded).at(openHourIndex));
      await tester.pump();
      expect(find.byType(TextButton), findsNWidgets(12));
    });

    testWidgets("Remove hour button is disabled if hour is closed", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byType(TextButton), findsNWidgets(14));
      int closedHourIndex = hours.days.indexOf(hours.days.firstWhere((hour) => hour.toLowerCase() == "closed"));
      await tester.tap(find.byIcon(Icons.do_disturb_on_rounded).at(closedHourIndex));
      await tester.pump();
      expect(find.byType(TextButton), findsNWidgets(14));
    });

    testWidgets("Tapping Hour button to edit shows timePicker", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.text("Edit Operating Hour"), findsNothing);
      String hourToEdit = hours.days.firstWhere((hour) => hour.toLowerCase() != "closed").split(" - ").first;
      await tester.tap(find.text(hourToEdit).first);
      await tester.pump();
      expect(find.text("Edit Operating Hour"), findsOneWidget);
    });

    testWidgets("Tapping Cancel on Edit timePicker dismisses timePicker", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      String hourToEdit = hours.days.firstWhere((hour) => hour.toLowerCase() != "closed").split(" - ").first;
      await tester.tap(find.text(hourToEdit).first);
      await tester.pump();
      expect(find.text("Edit Operating Hour"), findsOneWidget);
      await tester.tap(find.text("Cancel"));
      await tester.pump();
      expect(find.text("Edit Operating Hour"), findsNothing);
    });

    testWidgets("Changing time on datePicker changes selected Hour", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      String hourToEdit = hours.days.firstWhere((hour) => hour.toLowerCase() != "closed").split(" - ").first;
      expect(find.textContaining("AM"), findsNWidgets(6));
      await tester.tap(find.text(hourToEdit).first);
      await tester.pump();
      await tester.tap(find.text("PM"));
      await tester.pump();
      await tester.tap(find.text("Change"));
      await tester.pump();
      expect(find.textContaining("AM"), findsNWidgets(5));
    });

    testWidgets("Edit Hours Screen creates SubmitButton", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byKey(const Key("submitButtonKey")), findsOneWidget);
    });

    testWidgets("SubmitButton is disabled if hours unchanged", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(tester.widget<ElevatedButton>(find.byKey(const Key("submitButtonKey"))).enabled, false);
    });

    testWidgets("SubmitButton is enabled if hours changed", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(tester.widget<ElevatedButton>(find.byKey(const Key("submitButtonKey"))).enabled, false);
      String hourToEdit = hours.days.firstWhere((hour) => hour.toLowerCase() != "closed").split(" - ").first;
      await tester.tap(find.text(hourToEdit).first);
      await tester.pump();
      await tester.tap(find.text("PM"));
      await tester.pump();
      await tester.tap(find.text("Change"));
      await tester.pump();
      expect(tester.widget<ElevatedButton>(find.byKey(const Key("submitButtonKey"))).enabled, true);
    });

    testWidgets("Tapping submit button shows CircularProgressIndicator", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      String hourToEdit = hours.days.firstWhere((hour) => hour.toLowerCase() != "closed").split(" - ").first;
      await tester.tap(find.text(hourToEdit).first);
      await tester.pump();
      await tester.tap(find.text("PM"));
      await tester.pump();
      await tester.tap(find.text("Change"));
      await tester.pump();
      await tester.drag(find.byKey(const Key("scrollKey")), const Offset(0.0, -500));
      await tester.pump();
      await tester.tap(find.byKey(const Key("submitButtonKey")));
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump(const Duration(seconds: 4));
    });

    testWidgets("Tapping submit button shows toast on success", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.text("Hours Updated!"), findsNothing);
      String hourToEdit = hours.days.firstWhere((hour) => hour.toLowerCase() != "closed").split(" - ").first;
      await tester.tap(find.text(hourToEdit).first);
      await tester.pump();
      await tester.tap(find.text("PM"));
      await tester.pump();
      await tester.tap(find.text("Change"));
      await tester.pump();
      await tester.drag(find.byKey(const Key("scrollKey")), const Offset(0.0, -500));
      await tester.pump();
      await tester.tap(find.byKey(const Key("submitButtonKey")));
      await tester.pump(const Duration(seconds: 2));
      expect(find.text("Hours Updated!"), findsOneWidget);
      await tester.pump(const Duration(seconds: 2));
    });

    testWidgets("Tapping submit button on success pops nav", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      String hourToEdit = hours.days.firstWhere((hour) => hour.toLowerCase() != "closed").split(" - ").first;
      await tester.tap(find.text(hourToEdit).first);
      await tester.pump();
      await tester.tap(find.text("PM"));
      await tester.pump();
      await tester.tap(find.text("Change"));
      await tester.pump();
      await tester.drag(find.byKey(const Key("scrollKey")), const Offset(0.0, -500));
      await tester.pump();
      await tester.tap(find.byKey(const Key("submitButtonKey")));
      await tester.pump(const Duration(seconds: 4));
      verify(() => observer.didPop(any(), any()));
    });

    testWidgets("Tapping submit button on error shows error message", (tester) async {
      when(() => hoursRepository.update(identifier: any(named: "identifier"), sunday: any(named: "sunday"), monday: any(named: "monday"), tuesday: any(named: "tuesday"), wednesday: any(named: "wednesday"), thursday: any(named: "thursday"), friday: any(named: "friday"), saturday: any(named: "saturday")))
        .thenThrow(const ApiException(error: "An error occurred!"));

      await screenBuilder.createScreen(tester: tester);
      expect(find.text("An error Occurred!"), findsNothing);
      String hourToEdit = hours.days.firstWhere((hour) => hour.toLowerCase() != "closed").split(" - ").first;
      await tester.tap(find.text(hourToEdit).first);
      await tester.pump();
      await tester.tap(find.text("PM"));
      await tester.pump();
      await tester.tap(find.text("Change"));
      await tester.pump();
      await tester.drag(find.byKey(const Key("scrollKey")), const Offset(0.0, -500));
      await tester.pump();
      await tester.tap(find.byKey(const Key("submitButtonKey")));
      await tester.pumpAndSettle();
      expect(find.text("An error occurred!"), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));
      expect(find.text("An error occurred!"), findsNothing);
    });
  });
}