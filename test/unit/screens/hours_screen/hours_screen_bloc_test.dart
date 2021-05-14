import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/screens/hours_screen/bloc/hours_screen_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group("Hours Screen Bloc Tests", () {
    late HoursScreenBloc hoursScreenBloc;
    late HoursScreenState baseState;
    
    setUp(() {
      hoursScreenBloc = HoursScreenBloc();
      baseState = hoursScreenBloc.state;
    });

    tearDown(() {
      hoursScreenBloc.close();
    });
    
    test("HoursScreenBloc initial state is HoursScreenState.initial()", () {
      expect(hoursScreenBloc.state, HoursScreenState.initial());
    });

    blocTest<HoursScreenBloc, HoursScreenState>(
      "EarliestOpeningChanged event changes state: [earliesStart: startTime]",
      build: () => hoursScreenBloc,
      act: (bloc) => bloc.add(EarliestOpeningChanged(time: TimeOfDay(hour: 6, minute: 0))),
      expect: () => [baseState.update(earliestStart: TimeOfDay(hour: 6, minute: 0))]
    );

    blocTest<HoursScreenBloc, HoursScreenState>(
      "LatestClosingChanged event changes state: [latestEnd: endTime]",
      build: () => hoursScreenBloc,
      act: (bloc) => bloc.add(LatestClosingChanged(time: TimeOfDay(hour: 20, minute: 0))),
      expect: () => [baseState.update(latestEnd: TimeOfDay(hour: 20, minute: 0))]
    );

    blocTest<HoursScreenBloc, HoursScreenState>(
      "Reset event changes state: HoursScreenState.initial()",
      build: () => hoursScreenBloc,
      act: (bloc) => bloc.add(Reset()),
      expect: () => [HoursScreenState.initial()]
    );
  });
}