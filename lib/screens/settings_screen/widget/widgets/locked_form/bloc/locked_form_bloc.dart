import 'package:bloc/bloc.dart';
import 'package:dashboard/repositories/authentication_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/resources/helpers/debouncer.dart';
import 'package:dashboard/resources/helpers/validators.dart';
import 'package:dashboard/screens/settings_screen/cubit/settings_screen_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

part 'locked_form_event.dart';
part 'locked_form_state.dart';

class LockedFormBloc extends Bloc<LockedFormEvent, LockedFormState> {
  final AuthenticationRepository _authenticationRepository;
  final SettingsScreenCubit _settingsScreenCubit;
  
  LockedFormBloc({required AuthenticationRepository authenticationRepository, required SettingsScreenCubit settingsScreenCubit})
    : _authenticationRepository = authenticationRepository,
      _settingsScreenCubit = settingsScreenCubit,
      super(LockedFormState.initial()) { _eventHandler(); }

  void _eventHandler() {
    on<PasswordChanged>((event, emit) => _mapPasswordChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: Duration(milliseconds: 300)));
    on<Submitted>((event, emit) async => await _mapSubmittedToState(event: event, emit: emit));
    on<Reset>((event, emit) => _mapResetToState(emit: emit));
  }

  void _mapPasswordChangedToState({required PasswordChanged event, required Emitter<LockedFormState> emit}) {
    emit(state.update(isPasswordValid: Validators.isValidPassword(password: event.password)));
  }

  Future<void> _mapSubmittedToState({required Submitted event, required Emitter<LockedFormState> emit}) async {
    emit(state.update(isSubmitting: true));

    try {
      await _authenticationRepository.verifyPassword(password: event.password);
      emit(state.update(isSubmitting: false, errorButtonControl: CustomAnimationControl.stop));
      _settingsScreenCubit.unlock();
    } on ApiException catch (exception) {
      emit(state.update(isSubmitting: false, errorMessage: exception.error, errorButtonControl: CustomAnimationControl.playFromStart));
    }
  }
  
  void _mapResetToState({required Emitter<LockedFormState> emit}) {
    emit(state.update(errorMessage: "", errorButtonControl: CustomAnimationControl.stop));
  }
}
