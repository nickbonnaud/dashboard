import 'package:bloc/bloc.dart';
import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/models/business/hours.dart';
import 'package:dashboard/models/hour.dart';
import 'package:dashboard/repositories/hours_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_animations/simple_animations.dart';

part 'edit_hours_screen_event.dart';
part 'edit_hours_screen_state.dart';

class EditHoursScreenBloc extends Bloc<EditHoursScreenEvent, EditHoursScreenState> {
  final HoursRepository _hoursRepository;
  final BusinessBloc _businessBloc;

  EditHoursScreenBloc({required HoursRepository hoursRepository, required BusinessBloc businessBloc, required Hours hours}) 
    : _hoursRepository = hoursRepository,
      _businessBloc = businessBloc,
      super(EditHoursScreenState.initial(hours: hours)) {
        _eventHandler();
  }

  void _eventHandler() {
    on<HoursChanged>((event, emit) => _mapHoursChangedToState(event: event, emit: emit));
    on<Updated>((event, emit) async => await _mapUpdatedToState(event: event, emit: emit));
    on<HourAdded>((event, emit) => _mapHourAddedToState(event: event, emit: emit));
    on<HourRemoved>((event, emit) => _mapHourRemovedToState(event: event, emit: emit));
    on<Reset>((event, emit) => _mapResetToState(emit: emit));
  }
  
  void _mapHoursChangedToState({required HoursChanged event, required Emitter<EditHoursScreenState> emit}) {
    switch (event.day) {
      case 0:
        emit(state.update(sunday: event.hours));
        break;
      case 1:
        emit(state.update(monday: event.hours));
        break;
      case 2:
        emit(state.update(tuesday: event.hours));
        break;
      case 3:
        emit(state.update(wednesday: event.hours));
        break;
      case 4:
        emit(state.update(thursday: event.hours));
        break;
      case 5:
        emit(state.update(friday: event.hours));
        break;
      case 6:
        emit(state.update(saturday: event.hours));
        break;
    }
  }

  Future<void> _mapUpdatedToState({required Updated event, required Emitter<EditHoursScreenState> emit}) async {
    emit(state.update(isSubmitting: true));

    try {
      Hours hours = await _hoursRepository.update(
        identifier: event.identifier,
        sunday: event.sunday,
        monday: event.monday,
        tuesday: event.tuesday,
        wednesday: event.wednesday,
        thursday: event.thursday,
        friday: event.friday,
        saturday: event.saturday
      );
      _updateBusinessBloc(hours: hours);
      emit(state.update(isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.STOP));
    } on ApiException catch (exception) {
      emit(state.update(isSubmitting: false, isFailure: true, errorMessage: exception.error, errorButtonControl: CustomAnimationControl.PLAY_FROM_START));
    }
  }

  void _mapHourAddedToState({required HourAdded event, required Emitter<EditHoursScreenState> emit}) {
    switch (event.day) {
      case 0:
        emit(state.update(sunday: state.sunday..add(event.hour)));
        break;
      case 1:
        emit(state.update(monday: state.monday..add(event.hour)));
        break;
      case 2:
        emit(state.update(tuesday: state.tuesday..add(event.hour)));
        break;
      case 3:
        emit(state.update(wednesday: state.wednesday..add(event.hour)));
        break;
      case 4:
        emit(state.update(thursday: state.thursday..add(event.hour)));
        break;
      case 5:
        emit(state.update(friday: state.friday..add(event.hour)));
        break;
      case 6:
        emit(state.update(saturday: state.saturday..add(event.hour)));
        break;
    }
  }

  void _mapHourRemovedToState({required HourRemoved event, required Emitter<EditHoursScreenState> emit}) {
    switch (event.day) {
      case 0:
        emit(state.update(sunday: state.sunday..removeLast()));
        break;
      case 1:
        emit(state.update(monday: state.monday..removeLast()));
        break;
      case 2:
        emit(state.update(tuesday: state.tuesday..removeLast()));
        break;
      case 3:
        emit(state.update(wednesday: state.wednesday..removeLast()));
        break;
      case 4:
        emit(state.update(thursday: state.thursday..removeLast()));
        break;
      case 5:
        emit(state.update(friday: state.friday..removeLast()));
        break;
      case 6:
        emit(state.update(saturday: state.saturday..removeLast()));
        break;
    }
  }

  void _mapResetToState({required Emitter<EditHoursScreenState> emit}) {
    emit(state.update(isSuccess: false, isFailure: false, errorMessage: "", errorButtonControl: CustomAnimationControl.STOP));
  }

  void _updateBusinessBloc({required Hours hours}) {
    _businessBloc.add(HoursUpdated(hours: hours));
  }
}
