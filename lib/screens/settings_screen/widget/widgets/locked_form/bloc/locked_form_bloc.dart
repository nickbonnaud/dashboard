import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dashboard/repositories/authentication_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/resources/helpers/validators.dart';
import 'package:dashboard/screens/settings_screen/cubit/settings_screen_cubit.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:rxdart/rxdart.dart';

part 'locked_form_event.dart';
part 'locked_form_state.dart';

class LockedFormBloc extends Bloc<LockedFormEvent, LockedFormState> {
  final AuthenticationRepository _authenticationRepository;
  final SettingsScreenCubit _settingsScreenCubit;
  
  LockedFormBloc({required AuthenticationRepository authenticationRepository, required SettingsScreenCubit settingsScreenCubit})
    : _authenticationRepository = authenticationRepository,
      _settingsScreenCubit = settingsScreenCubit,
      super(LockedFormState.initial());

  @override
    Stream<Transition<LockedFormEvent, LockedFormState>> transformEvents(Stream<LockedFormEvent> events, transitionFn) {
      final nonDebounceStream = events.where((event) => event is !PasswordChanged);
      final debounceStream = events.where((event) => event is PasswordChanged).debounceTime(Duration(milliseconds: 300));

      return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), transitionFn);
    }
  
  @override
  Stream<LockedFormState> mapEventToState(LockedFormEvent event) async* {
    if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event: event);
    } else if (event is Submitted) {
      yield* _mapSubmittedToState(event: event);
    } else if (event is Reset) {
      yield* _mapResetToState();
    }
  }

  Stream<LockedFormState> _mapPasswordChangedToState({required PasswordChanged event}) async* {
    yield state.update(isPasswordValid: Validators.isValidPassword(password: event.password));
  }

  Stream<LockedFormState> _mapSubmittedToState({required Submitted event}) async* {
    yield state.update(isSubmitting: true);

    try {
      await _authenticationRepository.verifyPassword(password: event.password);
      yield state.update(isSubmitting: false, errorButtonControl: CustomAnimationControl.STOP);
      _settingsScreenCubit.unlock();
    } on ApiException catch (exception) {
      yield state.update(isSubmitting: false, errorMessage: exception.error, errorButtonControl: CustomAnimationControl.PLAY_FROM_START);
    }
  }
  
  Stream<LockedFormState> _mapResetToState() async* {
    yield state.update(errorMessage: "", errorButtonControl: CustomAnimationControl.STOP);
  }
}
