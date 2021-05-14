import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/models/business/hours.dart';
import 'package:dashboard/models/hour.dart';
import 'package:dashboard/repositories/hours_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/hours_screen/widgets/hours_selection_form/model/hours_grid.dart';
import 'package:dashboard/screens/hours_screen/widgets/hours_selection_form/widgets/bloc/hours_confirmation_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simple_animations/simple_animations.dart';

class MockHoursRepository extends Mock implements HoursRepository {}
class MockBusinessBloc extends Mock implements BusinessBloc {}
class MockHours extends Mock implements Hours {}

void main() {
  group("Hours Confirmation Form Bloc Tests", () {
    late HoursRepository hoursRepository;
    late BusinessBloc businessBloc;
    late HoursGrid hoursGrid;
    late List<TimeOfDay> hoursList;
    late HoursConfirmationFormBloc hoursConfirmationFormBloc;

    late HoursConfirmationFormState baseState;

    setUp(() {
      hoursRepository = MockHoursRepository();
      businessBloc = MockBusinessBloc();
      hoursGrid = HoursGrid.initial(operatingHoursRange: Hour(start: TimeOfDay(hour: 9, minute: 0), end: TimeOfDay(hour: 22, minute: 0))).toggle();
      hoursList = hoursGrid.hoursList(earliestStart: TimeOfDay(hour: 9, minute: 0));
      
      // hoursSelectionFormState = HoursSelectionFormState.initial();
      // hoursSelectionFormState = hoursSelectionFormState.update(operatingHoursGrid: hoursSelectionFormState.operatingHoursGrid.operatingHoursGrid.map((row) => row.map((_) => true).toList()).toList());

      // hoursList = List.generate(hoursSelectionFormState.rows - 1, (index) {
      //   TimeOfDay startHour = TimeOfDay(hour: 9, minute: 0);
      //   final DateTime now = DateTime.now();
      //   final DateTime openTime = DateTime(now.year, now.month, now.day, startHour.hour, startHour.minute < 30 ? 0 : 30);

      //   final DateTime updatedTime = openTime.add(Duration(minutes: 30 * index));
      //   return startHour.replacing(hour: updatedTime.hour, minute: updatedTime.minute);
      // });


      hoursConfirmationFormBloc = HoursConfirmationFormBloc(
        hoursRepository: hoursRepository,
        businessBloc: businessBloc,
        hoursGrid: hoursGrid,
        hoursList: hoursList
      );

      baseState = hoursConfirmationFormBloc.state;

      registerFallbackValue<BusinessEvent>(HoursUpdated(hours: MockHours()));
    });

    tearDown(() {
      hoursConfirmationFormBloc.close();
    });

    test("Initial state of HoursConfirmationFormBloc is HoursConfirmationFormState.initial()", () {
      expect(hoursConfirmationFormBloc.state, HoursConfirmationFormState.initial(hoursGrid: hoursGrid, hoursList: hoursList));
    });

    test("HoursConfirmationFormState.initial() sets each days hours as list of Hour", () {
      HoursConfirmationFormState state = HoursConfirmationFormState.initial(hoursGrid: hoursGrid, hoursList: hoursList);
      state.days.forEach((day) {
        expect(day, isA<List<Hour>>());
        // expect(day.first.start, isA<TimeOfDay>());
        // expect(day.first.end, isA<TimeOfDay>());
      });
    });

    test("HoursConfirmationFormState.initial() sets each days hours to correct time", () {
      HoursConfirmationFormState state = HoursConfirmationFormState.initial(hoursGrid: hoursGrid, hoursList: hoursList);
      state.days.forEach((day) {
        TimeOfDay start = TimeOfDay(hour: 9, minute: 0);
        TimeOfDay end = TimeOfDay(hour: 22, minute: 0);
        expect(day.first.start, start);
        expect(day.first.end, end);
      });
    });
    
    blocTest<HoursConfirmationFormBloc, HoursConfirmationFormState>(
      "HoursChanged event updates selected days hours",
      build: () => hoursConfirmationFormBloc,
      act: (bloc) {
        bloc.add(HoursChanged(
          day: 3,
          hours: [Hour(start: TimeOfDay(hour: 9, minute: 0), end: TimeOfDay(hour: 13, minute: 0)), Hour(start: TimeOfDay(hour: 6, minute: 00), end: TimeOfDay(hour: 22, minute: 0))]
        ));
      },
      expect: () => [baseState.update(wednesday: [Hour(start: TimeOfDay(hour: 9, minute: 0), end: TimeOfDay(hour: 13, minute: 0)), Hour(start: TimeOfDay(hour: 6, minute: 00), end: TimeOfDay(hour: 22, minute: 0))])],
    );

    blocTest<HoursConfirmationFormBloc, HoursConfirmationFormState>(
      "Submitted event updates state: [isSubmitting: true], [isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.STOP]",
      build: () => hoursConfirmationFormBloc,
      act: (bloc) {
        when(() => hoursRepository.store(sunday: any(named: "sunday"), monday: any(named: "monday"), tuesday: any(named: "tuesday"), wednesday: any(named: "wednesday"), thursday: any(named: "thursday"), friday: any(named: "friday"), saturday: any(named: "saturday")))
          .thenAnswer((_) async => MockHours());
        when(() => businessBloc.add(any(that: isA<HoursUpdated>()))).thenReturn(null);
        bloc.add(Submitted(
          sunday: "sunday",
          monday: "monday",
          tuesday: "tuesday",
          wednesday: "wednesday",
          thursday: "thursday",
          friday: "friday",
          saturday: "saturday"
        ));
      },
      expect: () => [baseState.update(isSubmitting: true), baseState.update(isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.STOP)],
    );

    blocTest<HoursConfirmationFormBloc, HoursConfirmationFormState>(
      "Submitted event calls hoursRepository.store()",
      build: () => hoursConfirmationFormBloc,
      act: (bloc) {
        when(() => hoursRepository.store(sunday: any(named: "sunday"), monday: any(named: "monday"), tuesday: any(named: "tuesday"), wednesday: any(named: "wednesday"), thursday: any(named: "thursday"), friday: any(named: "friday"), saturday: any(named: "saturday")))
          .thenAnswer((_) async => MockHours());
        when(() => businessBloc.add(any(that: isA<HoursUpdated>()))).thenReturn(null);
        bloc.add(Submitted(
          sunday: "sunday",
          monday: "monday",
          tuesday: "tuesday",
          wednesday: "wednesday",
          thursday: "thursday",
          friday: "friday",
          saturday: "saturday"
        ));
      },
      verify: (_) {
        verify(() => hoursRepository.store(sunday: any(named: "sunday"), monday: any(named: "monday"), tuesday: any(named: "tuesday"), wednesday: any(named: "wednesday"), thursday: any(named: "thursday"), friday: any(named: "friday"), saturday: any(named: "saturday"))).called(1);
      }
    );

    blocTest<HoursConfirmationFormBloc, HoursConfirmationFormState>(
      "Submitted event calls businessBloc.add()",
      build: () => hoursConfirmationFormBloc,
      act: (bloc) {
        when(() => hoursRepository.store(sunday: any(named: "sunday"), monday: any(named: "monday"), tuesday: any(named: "tuesday"), wednesday: any(named: "wednesday"), thursday: any(named: "thursday"), friday: any(named: "friday"), saturday: any(named: "saturday")))
          .thenAnswer((_) async => MockHours());
        when(() => businessBloc.add(any(that: isA<HoursUpdated>()))).thenReturn(null);
        bloc.add(Submitted(
          sunday: "sunday",
          monday: "monday",
          tuesday: "tuesday",
          wednesday: "wednesday",
          thursday: "thursday",
          friday: "friday",
          saturday: "saturday"
        ));
      },
      verify: (_) {
        verify(() => businessBloc.add(any(that: isA<HoursUpdated>()))).called(1);
      }
    );

    blocTest<HoursConfirmationFormBloc, HoursConfirmationFormState>(
      "Submitted event on error updates state: [isSubmitting: true], [isSubmitting: false, errorMessage: exception.error, errorButtonControl: CustomAnimationControl.PLAY_FROM_START]",
      build: () => hoursConfirmationFormBloc,
      act: (bloc) {
        when(() => hoursRepository.store(sunday: any(named: "sunday"), monday: any(named: "monday"), tuesday: any(named: "tuesday"), wednesday: any(named: "wednesday"), thursday: any(named: "thursday"), friday: any(named: "friday"), saturday: any(named: "saturday")))
          .thenThrow(ApiException(error: "error"));
        bloc.add(Submitted(
          sunday: "sunday",
          monday: "monday",
          tuesday: "tuesday",
          wednesday: "wednesday",
          thursday: "thursday",
          friday: "friday",
          saturday: "saturday"
        ));
      },
      expect: () => [baseState.update(isSubmitting: true), baseState.update(isSubmitting: false, errorMessage: "error", errorButtonControl: CustomAnimationControl.PLAY_FROM_START)],
    );

    blocTest<HoursConfirmationFormBloc, HoursConfirmationFormState>(
      "Reset event updates state: [isSuccess: false, errorMessage: "", errorButtonControl: CustomAnimationControl.STOP]",
      build: () => hoursConfirmationFormBloc,
      seed: () => baseState.update(errorMessage: "error", errorButtonControl: CustomAnimationControl.PLAY),
      act: (bloc) => bloc.add(Reset()),
      expect: () => [baseState.update(isSuccess: false, errorMessage: "", errorButtonControl: CustomAnimationControl.STOP)],
    );
  });
}