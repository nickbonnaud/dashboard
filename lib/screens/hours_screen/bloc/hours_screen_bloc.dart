import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'hours_screen_event.dart';
part 'hours_screen_state.dart';

class HoursScreenBloc extends Bloc<HoursScreenEvent, HoursScreenState> {

  HoursScreenBloc() : super(HoursScreenState.initial());

  @override
  Stream<HoursScreenState> mapEventToState(HoursScreenEvent event) async* {
    if (event is EarliestOpeningChanged) {
      yield* _mapEarliestOpeningChangedToState(event: event);
    } else if (event is LatestClosingChanged) {
      yield* _mapLatestClosingChangedToState(event: event);
    } else if (event is Reset) {
      yield HoursScreenState.initial();
    }
  }

  Stream<HoursScreenState> _mapEarliestOpeningChangedToState({required EarliestOpeningChanged event}) async* {
    yield state.update(earliestStart: event.time);
  }

  Stream<HoursScreenState> _mapLatestClosingChangedToState({required LatestClosingChanged event}) async* {
    yield state.update(latestEnd: event.time);
  }
}
