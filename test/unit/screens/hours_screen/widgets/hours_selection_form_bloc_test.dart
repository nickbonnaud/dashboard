import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/models/hour.dart';
import 'package:dashboard/screens/hours_screen/widgets/hours_selection_form/bloc/hours_selection_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group("Hours Selection Form Bloc Tests", () {
    const Hour operatingHoursRange = Hour(start: TimeOfDay(hour: 8, minute: 0), end: TimeOfDay(hour: 20, minute: 00));
    late HoursSelectionFormBloc hoursSelectionFormBloc;
    late HoursSelectionFormState baseState;

    setUp(() {
      hoursSelectionFormBloc = HoursSelectionFormBloc(operatingHoursRange: operatingHoursRange);
      baseState = hoursSelectionFormBloc.state;
    });

    tearDown(() {
      hoursSelectionFormBloc.close();
    });

    test("Initial state of HoursSelectionFormBloc is HoursSelectionFormState.initial()", () {
      final HoursSelectionFormState initialState =HoursSelectionFormState.initial(operatingHoursRange: operatingHoursRange);
      expect(hoursSelectionFormBloc.state.isFinished, initialState.isFinished);
      expect(hoursSelectionFormBloc.state.operatingHoursGrid.operatingHoursGrid, initialState.operatingHoursGrid.operatingHoursGrid);
    });

    test("HoursSelectionFormState.initial() creates correct hours grid", () {
      TimeOfDay open = const TimeOfDay(hour: 9, minute: 0);
      TimeOfDay close = const TimeOfDay(hour: 21, minute: 0);
      int correctNumberColumns = 8;
      int correctNumberRows = 26;
      HoursSelectionFormState state = HoursSelectionFormState.initial(operatingHoursRange: Hour(start: open, end: close));
      expect(state.operatingHoursGrid.cols, correctNumberColumns);
      expect(state.operatingHoursGrid.rows, correctNumberRows);
      expect(state.operatingHoursGrid.operatingHoursGrid.length, correctNumberRows);
      expect(state.operatingHoursGrid.operatingHoursGrid[0].length, correctNumberColumns);
    });

    test("HoursSelectionFormState.initial() creates correct rows if close past midnight", () {
      TimeOfDay open = const TimeOfDay(hour: 22, minute: 0);
      TimeOfDay close = const TimeOfDay(hour: 1, minute: 0);
      int correctNumberRows = 8;
      HoursSelectionFormState state = HoursSelectionFormState.initial(operatingHoursRange: Hour(start: open, end: close));
      expect(state.operatingHoursGrid.rows, correctNumberRows);
      expect(state.operatingHoursGrid.operatingHoursGrid.length, correctNumberRows);
    });

    test("HoursSelectionFormState.initial() creates correct rows times not 30 minute increments", () {
      TimeOfDay open = const TimeOfDay(hour: 8, minute: 15);
      TimeOfDay close = const TimeOfDay(hour: 11, minute: 45);
      int correctNumberRows = 9;
      HoursSelectionFormState state = HoursSelectionFormState.initial(operatingHoursRange: Hour(start: open, end: close));
      expect(state.operatingHoursGrid.rows, correctNumberRows);
      expect(state.operatingHoursGrid.operatingHoursGrid.length, correctNumberRows);
    });

    blocTest<HoursSelectionFormBloc, HoursSelectionFormState>(
      "GridSelectionChanged event with drag updates grid cell to true", 
      build: () => hoursSelectionFormBloc,
      act: (bloc) => bloc.add(const GridSelectionChanged(indexX: 1, indexY: 1, isDrag: true)),
      verify: (_) {
        expect(hoursSelectionFormBloc.state.operatingHoursGrid.operatingHoursGrid[1][1], true);
      }
    );

    blocTest<HoursSelectionFormBloc, HoursSelectionFormState>(
      "GridSelectionChanged event with drag on cell already true maintains true", 
      build: () => hoursSelectionFormBloc,
      act: (bloc) {
        bloc.add(const GridSelectionChanged(indexX: 1, indexY: 1, isDrag: true));
        bloc.add(const GridSelectionChanged(indexX: 1, indexY: 1, isDrag: true));
      },
      verify: (_) {
        expect(hoursSelectionFormBloc.state.operatingHoursGrid.operatingHoursGrid[1][1], true);
      }
    );

    blocTest<HoursSelectionFormBloc, HoursSelectionFormState>(
      "GridSelectionChanged event tap updates grid cell to true", 
      build: () => hoursSelectionFormBloc,
      act: (bloc) => bloc.add(const GridSelectionChanged(indexX: 1, indexY: 1, isDrag: false)),
      verify: (_) {
        expect(hoursSelectionFormBloc.state.operatingHoursGrid.operatingHoursGrid[1][1], true);
      }
    );

    blocTest<HoursSelectionFormBloc, HoursSelectionFormState>(
      "GridSelectionChanged event tap on true cell updates grid cell to false", 
      build: () => hoursSelectionFormBloc,
      act: (bloc) {
        bloc.add(const GridSelectionChanged(indexX: 1, indexY: 1, isDrag: false));
        bloc.add(const GridSelectionChanged(indexX: 1, indexY: 1, isDrag: false));
      },
      verify: (_) {
        expect(hoursSelectionFormBloc.state.operatingHoursGrid.operatingHoursGrid[1][1], false);
      }
    );

    blocTest<HoursSelectionFormBloc, HoursSelectionFormState>(
      "Finished event changes state: [isFinished: true]", 
      build: () => hoursSelectionFormBloc,
      act: (bloc) => bloc.add(const Finished(isFinished: true)),
      expect: () => [baseState.update(isFinished: true)]
    );
  });
}