import 'package:bloc/bloc.dart';
import 'package:dashboard/models/hour.dart';
import 'package:dashboard/screens/hours_screen/widgets/hours_selection_form/model/hours_grid.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'hours_selection_form_event.dart';
part 'hours_selection_form_state.dart';

class HoursSelectionFormBloc extends Bloc<HoursSelectionFormEvent, HoursSelectionFormState> {
  HoursSelectionFormBloc({required Hour operatingHoursRange}) 
    : super(HoursSelectionFormState.initial(operatingHoursRange: operatingHoursRange)) {
      _eventHandler();
  }
  
  void _eventHandler() {
    on<GridSelectionChanged>((event, emit) => _mapGridSelectionChangedToState(event: event, emit: emit));
    on<ToggleAllHours>((event, emit) => _mapToggleAllHoursToState(emit: emit));
    on<Finished>((event, emit) => _mapFinishedToState(event: event, emit: emit));
  }

  void _mapGridSelectionChangedToState({required GridSelectionChanged event, required Emitter<HoursSelectionFormState> emit}) {
    if (event.isDrag) {
      emit(state.update(operatingHoursGrid: state.operatingHoursGrid.update(x: event.indexX, y: event.indexY, selected: true)));
    } else {
      if (state.operatingHoursGrid.isOpen(x: event.indexX, y: event.indexY)) {
        emit(state.update(operatingHoursGrid: state.operatingHoursGrid.update(x: event.indexX, y: event.indexY, selected: false)));
      } else {
        emit(state.update(operatingHoursGrid: state.operatingHoursGrid.update(x: event.indexX, y: event.indexY, selected: true)));
      }
    }
  }

  void _mapToggleAllHoursToState({required Emitter<HoursSelectionFormState> emit}) {
    emit(state.update(operatingHoursGrid: state.operatingHoursGrid.toggle()));
  }

  void _mapFinishedToState({required Finished event, required Emitter<HoursSelectionFormState> emit}) {
    emit(state.update(isFinished: event.isFinished));
  }
}
