import 'dart:async';

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
      super(EditHoursScreenState.initial(hours: hours));

  @override
  Stream<EditHoursScreenState> mapEventToState(EditHoursScreenEvent event) async* {
    if (event is HoursChanged) {
      yield* _mapHoursChangedToState(event: event);
    } else if (event is Updated) {
      yield* _mapUpdatedToState(event: event);
    } else if (event is HourAdded) {
      yield* _mapHourAddedToState(event: event);
    } else if (event is HourRemoved) {
      yield* _mapHourRemovedToState(event: event);
    } else if (event is Reset) {
      yield* _mapResetToState();
    }
  }

  Stream<EditHoursScreenState> _mapHoursChangedToState({required HoursChanged event}) async* {
    switch (event.day) {
      case 0:
        yield state.update(sunday: event.hours);
        break;
      case 1:
        yield state.update(monday: event.hours);
        break;
      case 2:
        yield state.update(tuesday: event.hours);
        break;
      case 3:
        yield state.update(wednesday: event.hours);
        break;
      case 4:
        yield state.update(thursday: event.hours);
        break;
      case 5:
        yield state.update(friday: event.hours);
        break;
      case 6:
        yield state.update(saturday: event.hours);
        break;
    }
  }

  Stream<EditHoursScreenState> _mapUpdatedToState({required Updated event}) async* {
    yield state.update(isSubmitting: true);

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
      yield state.update(isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.STOP);
    } on ApiException catch (exception) {
      yield state.update(isSubmitting: false, isFailure: true, errorMessage: exception.error, errorButtonControl: CustomAnimationControl.PLAY_FROM_START);
    }
  }

  Stream<EditHoursScreenState> _mapHourAddedToState({required HourAdded event}) async* {
    switch (event.day) {
      case 0:
        yield state.update(sunday: state.sunday..add(event.hour));
        break;
      case 1:
        yield state.update(monday: state.monday..add(event.hour));
        break;
      case 2:
        yield state.update(tuesday: state.tuesday..add(event.hour));
        break;
      case 3:
        yield state.update(wednesday: state.wednesday..add(event.hour));
        break;
      case 4:
        yield state.update(thursday: state.thursday..add(event.hour));
        break;
      case 5:
        yield state.update(friday: state.friday..add(event.hour));
        break;
      case 6:
        yield state.update(saturday: state.saturday..add(event.hour));
        break;
    }
  }

  Stream<EditHoursScreenState> _mapHourRemovedToState({required HourRemoved event}) async* {
    switch (event.day) {
      case 0:
        yield state.update(sunday: state.sunday..removeLast());
        break;
      case 1:
        yield state.update(monday: state.monday..removeLast());
        break;
      case 2:
        yield state.update(tuesday: state.tuesday..removeLast());
        break;
      case 3:
        yield state.update(wednesday: state.wednesday..removeLast());
        break;
      case 4:
        yield state.update(thursday: state.thursday..removeLast());
        break;
      case 5:
        yield state.update(friday: state.friday..removeLast());
        break;
      case 6:
        yield state.update(saturday: state.saturday..removeLast());
        break;
    }
  }

  Stream<EditHoursScreenState> _mapResetToState() async* {
    yield state.update(isSuccess: false, isFailure: false, errorMessage: "", errorButtonControl: CustomAnimationControl.STOP);
  }

  void _updateBusinessBloc({required Hours hours}) {
    _businessBloc.add(HoursUpdated(hours: hours));
  }
}
