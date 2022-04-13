import 'package:dashboard/repositories/hours_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/hours_screen/hours_screen.dart';
import 'package:dashboard/screens/hours_screen/widgets/hours_selection_form/hours_selection_form.dart';
import 'package:dashboard/screens/hours_screen/widgets/hours_selection_form/widgets/hours_confirmation_form.dart';
import 'package:dashboard/screens/hours_screen/widgets/max_hours_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../helpers/mock_data_generator.dart';
import '../../helpers/screen_builder.dart';

class MockHoursRepository extends Mock implements HoursRepository {}

void main() {
  group("Hours Screen Tests", () {
    late MockDataGenerator mockDataGenerator;
    late NavigatorObserver observer;
    late HoursRepository hoursRepository;
    late ScreenBuilder screenBuilder;

    setUp(() {
      mockDataGenerator = MockDataGenerator();
      observer = MockNavigatorObserver();
      hoursRepository = MockHoursRepository();

      screenBuilder = ScreenBuilder(
        child: HoursScreen(hoursRepository: hoursRepository), 
        observer: observer
      );

      when(() => hoursRepository.store(sunday: any(named: "sunday"), monday: any(named: "monday"), tuesday: any(named: "tuesday"), wednesday: any(named: "wednesday"), thursday: any(named: "thursday"), friday: any(named: "friday"), saturday: any(named: "saturday")))
        .thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 500), () => mockDataGenerator.createHours()));

      registerFallbackValue(MockRoute());
    });

    Future<void> _setupSelectionForm({required WidgetTester tester}) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      await tester.pump();

      await tester.tap(find.byKey(const Key("openingTimeFieldKey")));
      await tester.pump();
      await tester.tap(find.text("AM"));
      await tester.pump();
      await tester.tap(find.text("Set"));
      await tester.pump();

      await tester.tap(find.byKey(const Key("closingTimeFieldKey")));
      await tester.pump();
      await tester.tap(find.text("PM"));
      await tester.pump();
      await tester.tap(find.text("Set"));
      await tester.pump();
    }

    Future<void> _setUpConfirmationForm({required WidgetTester tester}) async {
      await _setupSelectionForm(tester: tester);
      await tester.tap(find.byKey(const Key("toggleAllButtonKey")));
      await tester.pump();
      await tester.drag(find.text("Drag or click to select hours."), const Offset(0.0, -500));
      await tester.pump();
      await tester.tap(find.byKey(const Key("submitButtonKey")));
      await tester.pump();
    }
    
    testWidgets("HomeScreen creates AppBar", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets("HomeScreen creates title", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.text("Operating Hours"), findsOneWidget);
    });

    testWidgets("HomeScreen new initial widget is MaxHoursForm", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.byType(MaxHoursForm), findsOneWidget);
    });

    testWidgets("MaxHoursForm contains earliest opening TextFormField", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.byKey(const Key("openingTimeFieldKey")), findsOneWidget);
    });

    testWidgets("MaxHoursForm contains latest closing TextFormField", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.byKey(const Key("closingTimeFieldKey")), findsOneWidget);
    });

    testWidgets("Tapping EarliestOpeningTextField displays DatePicker", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.byKey(const Key("timePickerKey")), findsNothing);
      await tester.tap(find.byKey(const Key("openingTimeFieldKey")));
      await tester.pump();
      expect(find.byKey(const Key("timePickerKey")), findsOneWidget);
    });

    testWidgets("Tapping LatestClosingTextField displays DatePicker", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.byKey(const Key("timePickerKey")), findsNothing);
      await tester.tap(find.byKey(const Key("closingTimeFieldKey")));
      await tester.pump();
      expect(find.byKey(const Key("timePickerKey")), findsOneWidget);
    });

    testWidgets("Setting DatePicker for EarliestOpeningTextField changes textField", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      await tester.pump();
      expect(tester.widget<TextFormField>(find.byKey(const Key("openingTimeFieldKey"))).controller?.text.isEmpty, true);
      await tester.tap(find.byKey(const Key("openingTimeFieldKey")));
      await tester.pump();
      await tester.tap(find.text("Set"));
      await tester.pump();
      expect(tester.widget<TextFormField>(find.byKey(const Key("openingTimeFieldKey"))).controller?.text.isEmpty, false);
    });

    testWidgets("Setting DatePicker for LatestClosingTextField changes textField", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      await tester.pump();
      expect(tester.widget<TextFormField>(find.byKey(const Key("closingTimeFieldKey"))).controller?.text.isEmpty, true);
      await tester.tap(find.byKey(const Key("closingTimeFieldKey")));
      await tester.pump();
      await tester.tap(find.text("Set"));
      await tester.pump();
      expect(tester.widget<TextFormField>(find.byKey(const Key("closingTimeFieldKey"))).controller?.text.isEmpty, false);
    });

    testWidgets("Canceling DatePicker for EarliestOpeningTextField does not changes textField", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      await tester.pump();
      expect(tester.widget<TextFormField>(find.byKey(const Key("openingTimeFieldKey"))).controller?.text.isEmpty, true);
      await tester.tap(find.byKey(const Key("openingTimeFieldKey")));
      await tester.pump();
      await tester.tap(find.text("Cancel"));
      await tester.pump();
      expect(tester.widget<TextFormField>(find.byKey(const Key("openingTimeFieldKey"))).controller?.text.isEmpty, true);
    });

    testWidgets("Canceling DatePicker for LatestClosingTextField does not changes textField", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      await tester.pump();
      expect(tester.widget<TextFormField>(find.byKey(const Key("closingTimeFieldKey"))).controller?.text.isEmpty, true);
      await tester.tap(find.byKey(const Key("closingTimeFieldKey")));
      await tester.pump();
      await tester.tap(find.text("Cancel"));
      await tester.pump();
      expect(tester.widget<TextFormField>(find.byKey(const Key("closingTimeFieldKey"))).controller?.text.isEmpty, true);
    });

    testWidgets("Setting Earliest & Latest hours hides MaxHoursScreen shows HoursSelectionForm", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      await tester.pump();
      expect(find.byType(MaxHoursForm), findsOneWidget);
      expect(find.byType(HoursSelectionForm), findsNothing);

      await tester.tap(find.byKey(const Key("openingTimeFieldKey")));
      await tester.pump();
      await tester.tap(find.text("AM"));
      await tester.pump();
      await tester.tap(find.text("Set"));
      await tester.pump();

      await tester.tap(find.byKey(const Key("closingTimeFieldKey")));
      await tester.pump();
      await tester.tap(find.text("PM"));
      await tester.pump();
      await tester.tap(find.text("Set"));
      await tester.pump();

      expect(find.byType(MaxHoursForm), findsNothing);
      expect(find.byType(HoursSelectionForm), findsOneWidget);
    });

    testWidgets("Hours Selection Form contains Hours Selection Grid", (tester) async {
      await _setupSelectionForm(tester: tester);
      expect(find.byKey(const Key("hoursSelectionGrid")), findsOneWidget);
    });

    testWidgets("Hours Selection Form creates toggleAllButton", (tester) async {
      await _setupSelectionForm(tester: tester);
      expect(find.byKey(const Key("toggleAllButtonKey")), findsOneWidget);
    });

    testWidgets("Tapping toggle button toggles select all", (tester) async {
      await _setupSelectionForm(tester: tester);
      expect(find.text("Select All?"), findsOneWidget);
      await tester.tap(find.byKey(const Key("toggleAllButtonKey")));
      await tester.pump();
      expect(find.text("Select All?"), findsNothing);
      expect(find.text("Clear All?"), findsOneWidget);
      await tester.tap(find.byKey(const Key("toggleAllButtonKey")));
      await tester.pump();
      expect(find.text("Select All?"), findsOneWidget);
    });

    testWidgets("Tapping empty grid tile changes selects time", (tester) async {
      await _setupSelectionForm(tester: tester);
      expect(tester.widget<Container>(find.byKey(const Key("empty-1-1"))).color, Colors.white);
      await tester.tap(find.byKey(const Key("empty-1-1")));
      await tester.pump();
      expect(tester.widget<Container>(find.byKey(const Key("filled-1-1"))).color, const Color(0xFF016fb9));
    });

    testWidgets("Hours Selection grid contains all days", (tester) async {
      await _setupSelectionForm(tester: tester);
      expect(find.text("Sun"), findsOneWidget);
      expect(find.text("Mon"), findsOneWidget);
      expect(find.text("Tue"), findsOneWidget);
      expect(find.text("Wed"), findsOneWidget);
      expect(find.text("Thu"), findsOneWidget);
      expect(find.text("Fri"), findsOneWidget);
      expect(find.text("Sat"), findsOneWidget);
    });

    testWidgets("Hours Selection Form creates Reset Max Hours Button", (tester) async {
      await _setupSelectionForm(tester: tester);
      expect(find.byKey(const Key("resetMaxHoursButtonKey")), findsOneWidget);
    });

    testWidgets("Tapping Reset Max Hours Button Key goes to MaxHoursForm", (tester) async {
      await _setupSelectionForm(tester: tester);
      expect(find.byType(MaxHoursForm), findsNothing);
      await tester.drag(find.text("Drag or click to select hours."), const Offset(0.0, -500));
      await tester.pump();
      await tester.tap(find.byKey(const Key("resetMaxHoursButtonKey")));
      await tester.pump();
      expect(find.byType(MaxHoursForm), findsOneWidget); 
    });

    testWidgets("Hours Selection Form creates Submit Button", (tester) async {
      await _setupSelectionForm(tester: tester);
      expect(find.byKey(const Key("submitButtonKey")), findsOneWidget);
    });

    testWidgets("Submit Button is disabled on empty grid", (tester) async {
      await _setupSelectionForm(tester: tester);
      expect(tester.widget<ElevatedButton>(find.byKey(const Key("submitButtonKey"))).enabled, false);
    });

    testWidgets("Tapping Submit Button shows HoursConfirmationForm", (tester) async {
      await _setupSelectionForm(tester: tester);
      expect(find.byType(HoursConfirmationForm), findsNothing);
      await tester.tap(find.byKey(const Key("toggleAllButtonKey")));
      await tester.pump();
      await tester.drag(find.text("Drag or click to select hours."), const Offset(0.0, -500));
      await tester.pump();
      await tester.tap(find.byKey(const Key("submitButtonKey")));
      await tester.pump();
      expect(find.byType(HoursConfirmationForm), findsOneWidget); 
    });

    testWidgets("HoursConfirmationForm creates hours list", (tester) async {
      await _setUpConfirmationForm(tester: tester);
      expect(find.byKey(const Key("hoursList")), findsOneWidget);
    });

    testWidgets("Tapping Hour button shows TimePicker", (tester) async {
      await _setUpConfirmationForm(tester: tester);
      await tester.drag(find.byKey(const Key("scrollKey")), const Offset(0.0, 500));
      await tester.pump();
      await tester.tap(find.byType(TextButton).first);
      await tester.pump();
      expect(find.byKey(const Key("timePickerKey")), findsOneWidget);
    });

    testWidgets("Changing hour on timePicker dismisses timePicker", (tester) async {
      await _setUpConfirmationForm(tester: tester);
      await tester.drag(find.byKey(const Key("scrollKey")), const Offset(0.0, 500));
      await tester.pump();
      await tester.tap(find.byType(TextButton).first);
      await tester.pump();
      expect(find.byKey(const Key("timePickerKey")), findsOneWidget);
      await tester.tap(find.text("Cancel"));
      await tester.pump();
      expect(find.byKey(const Key("timePickerKey")), findsNothing);
    });
    
    testWidgets("Changing hour on timePicker changes hours list", (tester) async {
      await _setUpConfirmationForm(tester: tester);
      expect(find.textContaining('AM'), findsNWidgets(7));
      await tester.drag(find.byKey(const Key("scrollKey")), const Offset(0.0, 500));
      await tester.pump();
      await tester.tap(find.byType(TextButton).first);
      await tester.pump();
      await tester.tap(find.text("AM"));
      await tester.pump();
      expect(find.textContaining('AM'), findsNWidgets(8));
    });

    testWidgets("Pressing cancel on timePicker dismisses picker without changing dates", (tester) async {
      await _setUpConfirmationForm(tester: tester);
      expect(find.textContaining('AM'), findsNWidgets(7));
      await tester.drag(find.byKey(const Key("scrollKey")), const Offset(0.0, 500));
      await tester.pump();
      await tester.tap(find.byType(TextButton).first);
      await tester.pump();
      await tester.tap(find.text("Cancel"));
      await tester.pump();
      expect(find.textContaining('AM'), findsNWidgets(7));
    });

    testWidgets("HoursConfirmationForm creates goBackButton", (tester) async {
      await _setUpConfirmationForm(tester: tester);
      expect(find.byKey(const Key("goBackButtonKey")), findsOneWidget);
    });

    testWidgets("Tapping GoBackButton hides HoursConfirmationForm and shows HoursSelectionForm", (tester) async {
      await _setUpConfirmationForm(tester: tester);
      expect(find.byType(HoursConfirmationForm), findsOneWidget);
      expect(find.byKey(const Key("hoursSelectionFormKey")), findsNothing);
      await tester.drag(find.byKey(const Key("scrollKey")), const Offset(0.0, -100));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key("goBackButtonKey")));
      await tester.pump();
      expect(find.byType(HoursConfirmationForm), findsNothing);
      expect(find.byKey(const Key("hoursSelectionFormKey")), findsOneWidget);
    });

    testWidgets("HoursConfirmationForm creates submitButton", (tester) async {
      await _setUpConfirmationForm(tester: tester);
      expect(find.byKey(const Key("submitButtonKey")), findsOneWidget);
    });

    testWidgets("Tapping SubmitButton shows CircularProgressIndicator", (tester) async {
      await _setUpConfirmationForm(tester: tester);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      await tester.drag(find.byKey(const Key("scrollKey")), const Offset(0.0, -100));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key("submitButtonKey")));
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump(const Duration(seconds: 4));
    });

    testWidgets("Tapping SubmitButton on success shows Toast", (tester) async {
      await _setUpConfirmationForm(tester: tester);
      expect(find.text("Hours Saved!"), findsNothing);
      await tester.drag(find.byKey(const Key("scrollKey")), const Offset(0.0, -100));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key("submitButtonKey")));
      await tester.pump(const Duration(seconds: 2));
      expect(find.text("Hours Saved!"), findsOneWidget);
      await tester.pump(const Duration(seconds: 2));
    });

    testWidgets("Tapping SubmitButton on success pops nav", (tester) async {
      await _setUpConfirmationForm(tester: tester);
      expect(find.text("Hours Saved!"), findsNothing);
      await tester.drag(find.byKey(const Key("scrollKey")), const Offset(0.0, -100));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key("submitButtonKey")));
      await tester.pump(const Duration(seconds: 4));
      verify(() => observer.didPop(any(), any()));
    });

    testWidgets("Tapping SubmitButton on error shows error message", (tester) async {
      when(() => hoursRepository.store(sunday: any(named: "sunday"), monday: any(named: "monday"), tuesday: any(named: "tuesday"), wednesday: any(named: "wednesday"), thursday: any(named: "thursday"), friday: any(named: "friday"), saturday: any(named: "saturday")))
        .thenThrow(const ApiException(error: "An error occurred!"));
      
      await _setUpConfirmationForm(tester: tester);
      expect(find.text("An error occurred!"), findsNothing);
      await tester.drag(find.byKey(const Key("scrollKey")), const Offset(0.0, -100));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key("submitButtonKey")));
      await tester.pumpAndSettle();
      expect(find.text("An error occurred!"), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));
      expect(find.text("An error occurred!"), findsNothing);
    });
  });
}