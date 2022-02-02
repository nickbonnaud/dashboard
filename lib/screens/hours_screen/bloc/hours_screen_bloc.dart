import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'hours_screen_event.dart';
part 'hours_screen_state.dart';

class HoursScreenBloc extends Bloc<HoursScreenEvent, HoursScreenState> {

  HoursScreenBloc()
    : super(HoursScreenState.initial()) { _eventHandler(); }

  void _eventHandler() {
    on<EarliestOpeningChanged>((event, emit) => _mapEarliestOpeningChangedToState(event: event, emit: emit));
    on<LatestClosingChanged>((event, emit) => _mapLatestClosingChangedToState(event: event, emit: emit));
    on<Reset>((event, emit) => _mapResetToState(emit: emit));
  }

  void _mapEarliestOpeningChangedToState({required EarliestOpeningChanged event, required Emitter<HoursScreenState> emit}) {
    emit(state.update(earliestStart: event.time));
  }

  void _mapLatestClosingChangedToState({required LatestClosingChanged event, required Emitter<HoursScreenState> emit}) {
    emit(state.update(latestEnd: event.time));
  }

  void _mapResetToState({required Emitter<HoursScreenState> emit}) {
    emit(HoursScreenState.initial());
  }
}
