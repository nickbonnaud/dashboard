import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/models/business/hours.dart';
import 'package:dashboard/models/hour.dart';
import 'package:dashboard/repositories/hours_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/edit_hours_screen/bloc/edit_hours_screen_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simple_animations/simple_animations.dart';

class MockHoursRepository extends Mock implements HoursRepository {}
class MockBusinessBloc extends Mock implements BusinessBloc {}
class MockHours extends Mock implements Hours {}

void main() {
  group("Edit Hours Screen Bloc Tests", () {
    late HoursRepository hoursRepository;
    late BusinessBloc businessBloc;
    late EditHoursScreenBloc editHoursScreenBloc;
    late Hours hours;

    late EditHoursScreenState baseState;

    setUp(() {
      hoursRepository = MockHoursRepository();
      businessBloc = MockBusinessBloc();
      hours = const Hours(identifier: "identifier", sunday: "9:00 AM - 10:00 PM", monday: "9:00 AM - 10:00 PM", tuesday: "9:00 AM - 2:00 PM || 5:00 PM - 11:00 PM", wednesday: "9:00 AM - 10:00 PM", thursday: "9:00 AM - 10:00 PM", friday: "9:00 AM - 10:00 PM", saturday: "9:00 AM - 10:00 PM", empty: false);
      editHoursScreenBloc = EditHoursScreenBloc(
        hoursRepository: hoursRepository,
        businessBloc: businessBloc,
        hours: hours
      );

      baseState = EditHoursScreenState.initial(hours: hours);
      registerFallbackValue(HoursUpdated(hours: hours));
    });

    tearDown(() {
      editHoursScreenBloc.close();
    });

    test("Initial state of EditHoursScreenBloc is EditHoursScreenState.initial()", () {
      expect(editHoursScreenBloc.state, EditHoursScreenState.initial(hours: hours));
    });

    blocTest<EditHoursScreenBloc, EditHoursScreenState>(
      "HoursChanged event changes state of hour modified", 
      build: () => editHoursScreenBloc,
      act: (bloc) => bloc.add(HoursChanged(day: 0, hours: [const Hour(start: TimeOfDay(hour: 6, minute: 30), end: TimeOfDay(hour: 22, minute: 15))].toList())),
      expect: () => [baseState.update(sunday: [const Hour(start: TimeOfDay(hour: 6, minute: 30), end: TimeOfDay(hour: 22, minute: 15))].toList())]
    );

    blocTest<EditHoursScreenBloc, EditHoursScreenState>(
      "Updated event changes state: [submitting: true], [isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.STOP]",
      build: () => editHoursScreenBloc,
      act: (bloc) {
        when(() => hoursRepository.update(identifier: "identifier", sunday: "sunday", monday: "monday", tuesday: "tuesday", wednesday: "wednesday", thursday: "thursday", friday: "friday", saturday: "saturday"))
          .thenAnswer((_) async => MockHours());
        when(() => businessBloc.add(any(that: isA<BusinessEvent>()))).thenReturn(null);
        bloc.add(const Updated(identifier: "identifier", sunday: "sunday", monday: "monday", tuesday: "tuesday", wednesday: "wednesday", thursday: "thursday", friday: "friday", saturday: "saturday"));
      },
      expect: () => [baseState.update(isSubmitting: true), baseState.update(isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.stop)]
    );

    blocTest<EditHoursScreenBloc, EditHoursScreenState>(
      "Updated event calls HoursRepository.update()",
      build: () => editHoursScreenBloc,
      act: (bloc) {
        when(() => hoursRepository.update(identifier: "identifier", sunday: "sunday", monday: "monday", tuesday: "tuesday", wednesday: "wednesday", thursday: "thursday", friday: "friday", saturday: "saturday"))
          .thenAnswer((_) async => MockHours());
        when(() => businessBloc.add(any(that: isA<BusinessEvent>()))).thenReturn(null);
        bloc.add(const Updated(identifier: "identifier", sunday: "sunday", monday: "monday", tuesday: "tuesday", wednesday: "wednesday", thursday: "thursday", friday: "friday", saturday: "saturday"));
      },
      verify: (_) {
        verify(() => hoursRepository.update(identifier: "identifier", sunday: "sunday", monday: "monday", tuesday: "tuesday", wednesday: "wednesday", thursday: "thursday", friday: "friday", saturday: "saturday")).called(1);
      }
    );

    blocTest<EditHoursScreenBloc, EditHoursScreenState>(
      "Updated event calls BusinessBloc.add()",
      build: () => editHoursScreenBloc,
      act: (bloc) {
        when(() => hoursRepository.update(identifier: "identifier", sunday: "sunday", monday: "monday", tuesday: "tuesday", wednesday: "wednesday", thursday: "thursday", friday: "friday", saturday: "saturday"))
          .thenAnswer((_) async => MockHours());
        when(() => businessBloc.add(any(that: isA<BusinessEvent>()))).thenReturn(null);
        bloc.add(const Updated(identifier: "identifier", sunday: "sunday", monday: "monday", tuesday: "tuesday", wednesday: "wednesday", thursday: "thursday", friday: "friday", saturday: "saturday"));
      },
      verify: (_) {
        verify(() => businessBloc.add(any(that: isA<HoursUpdated>()))).called(1);
      }
    );

    blocTest<EditHoursScreenBloc, EditHoursScreenState>(
      "Updated event on error changes state: [submitting: true], [isSubmitting: false, isFailure: true, errorMessage: exception.error, errorButtonControl: CustomAnimationControl.PLAY_FROM_START]",
      build: () => editHoursScreenBloc,
      act: (bloc) {
        when(() => hoursRepository.update(identifier: "identifier", sunday: "sunday", monday: "monday", tuesday: "tuesday", wednesday: "wednesday", thursday: "thursday", friday: "friday", saturday: "saturday"))
          .thenThrow(const ApiException(error: "error"));
        when(() => businessBloc.add(any(that: isA<BusinessEvent>()))).thenReturn(null);
        bloc.add(const Updated(identifier: "identifier", sunday: "sunday", monday: "monday", tuesday: "tuesday", wednesday: "wednesday", thursday: "thursday", friday: "friday", saturday: "saturday"));
      },
      expect: () => [baseState.update(isSubmitting: true), baseState.update(isSubmitting: false, isFailure: true, errorMessage: "error", errorButtonControl: CustomAnimationControl.playFromStart)]
    );

    blocTest<EditHoursScreenBloc, EditHoursScreenState>(
      "HourAdded event changes state of hour modified, adds hour", 
      build: () => editHoursScreenBloc,
      act: (bloc) => bloc.add(const HourAdded(hour: Hour(start: TimeOfDay(hour: 5, minute: 0), end: TimeOfDay(hour: 7, minute: 0)), day: 1)),
      expect: () => [baseState.update(monday: baseState.monday..add(const Hour(start: TimeOfDay(hour: 5, minute: 0), end: TimeOfDay(hour: 7, minute: 0))))]
    );

    blocTest<EditHoursScreenBloc, EditHoursScreenState>(
      "HourRemoved event changes state of hour modified, adds hour", 
      build: () => editHoursScreenBloc,
      act: (bloc) => bloc.add(const HourRemoved(day: 2)),
      expect: () => [baseState.update(tuesday: baseState.tuesday..removeLast())]
    );

    blocTest<EditHoursScreenBloc, EditHoursScreenState>(
      "Reset event changes state: isSuccess: false, isFailure: false, errorMessage: "", errorButtonControl: CustomAnimationControl.STOP", 
      build: () => editHoursScreenBloc,
      act: (bloc) => bloc.add(Reset()),
      expect: () => [baseState.update(isSuccess: false, isFailure: false, errorMessage: "", errorButtonControl: CustomAnimationControl.stop)]
    );
  });
}