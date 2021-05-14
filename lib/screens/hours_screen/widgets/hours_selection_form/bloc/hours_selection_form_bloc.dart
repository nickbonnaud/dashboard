import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dashboard/models/hour.dart';
import 'package:dashboard/screens/hours_screen/widgets/hours_selection_form/model/hours_grid.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'hours_selection_form_event.dart';
part 'hours_selection_form_state.dart';

class HoursSelectionFormBloc extends Bloc<HoursSelectionFormEvent, HoursSelectionFormState> {
  HoursSelectionFormBloc({required Hour operatingHoursRange}) 
    : super(HoursSelectionFormState.initial(operatingHoursRange: operatingHoursRange));
  
  @override
  Stream<HoursSelectionFormState> mapEventToState(HoursSelectionFormEvent event) async* {
    if (event is GridSelectionChanged) {
      yield* _mapGridSelectionChangedToState(event: event);
    } else if (event is ToggleAllHours) {
      yield* _mapToggleAllHoursToState();
    } else if (event is Finished) {
      yield* _mapFinishedToState(event: event);
    }
  }

  Stream<HoursSelectionFormState> _mapGridSelectionChangedToState({required GridSelectionChanged event}) async* {
    if (event.isDrag) {
      yield state.update(operatingHoursGrid: state.operatingHoursGrid.update(x: event.indexX, y: event.indexY, selected: true));
    } else {
      if (state.operatingHoursGrid.isOpen(x: event.indexX, y: event.indexY)) {
        yield state.update(operatingHoursGrid: state.operatingHoursGrid.update(x: event.indexX, y: event.indexY, selected: false));
      } else {
        yield state.update(operatingHoursGrid: state.operatingHoursGrid.update(x: event.indexX, y: event.indexY, selected: true));
      }
    }
  }

  Stream<HoursSelectionFormState> _mapToggleAllHoursToState() async* {
    yield state.update(operatingHoursGrid: state.operatingHoursGrid.toggle());
  }

  Stream<HoursSelectionFormState> _mapFinishedToState({required Finished event}) async* {
    yield state.update(isFinished: event.isFinished);
  }
}
