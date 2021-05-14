import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/models/business/hours.dart';
import 'package:dashboard/models/hour.dart';
import 'package:dashboard/repositories/hours_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/hours_screen/widgets/hours_selection_form/bloc/hours_selection_form_bloc.dart';
import 'package:dashboard/screens/hours_screen/widgets/hours_selection_form/model/hours_grid.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

part 'hours_confirmation_form_event.dart';
part 'hours_confirmation_form_state.dart';

class HoursConfirmationFormBloc extends Bloc<HoursConfirmationFormEvent, HoursConfirmationFormState> {
  final HoursRepository _hoursRepository;
  final BusinessBloc _businessBloc;
  
  HoursConfirmationFormBloc({
    required HoursRepository hoursRepository,
    required BusinessBloc businessBloc,
    required HoursGrid hoursGrid,
    required List<TimeOfDay> hoursList
  }) 
    : _hoursRepository = hoursRepository,
      _businessBloc = businessBloc,
      super(HoursConfirmationFormState.initial(
        hoursGrid: hoursGrid,
        hoursList: hoursList
      ));

  @override
  Stream<HoursConfirmationFormState> mapEventToState(HoursConfirmationFormEvent event) async* {
    if (event is HoursChanged) {
      yield* _mapHoursChangedToState(event: event);
    } else if (event is Submitted) {
      yield* _mapSubmittedToState(event: event);
    } else if (event is Reset) {
      yield* _mapResetToState();
    }
  }

  Stream<HoursConfirmationFormState> _mapHoursChangedToState({required HoursChanged event}) async* {
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

  Stream<HoursConfirmationFormState> _mapSubmittedToState({required Submitted event}) async* {
    yield state.update(isSubmitting: true);

    try {
      Hours hours = await _hoursRepository.store(
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
      yield state.update(isSubmitting: false, errorMessage: exception.error, errorButtonControl: CustomAnimationControl.PLAY_FROM_START);
    }
  }

  Stream<HoursConfirmationFormState> _mapResetToState() async* {
    yield state.update(isSuccess: false, errorMessage: "", errorButtonControl: CustomAnimationControl.STOP);
  }

  void _updateBusinessBloc({required Hours hours}) {
    _businessBloc.add(HoursUpdated(hours: hours));
  }
}
