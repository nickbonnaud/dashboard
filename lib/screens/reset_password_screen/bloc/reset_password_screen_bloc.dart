import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dashboard/repositories/authentication_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/resources/helpers/validators.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:rxdart/rxdart.dart';

part 'reset_password_screen_event.dart';
part 'reset_password_screen_state.dart';

class ResetPasswordScreenBloc extends Bloc<ResetPasswordScreenEvent, ResetPasswordScreenState> {
  final AuthenticationRepository _authenticationRepository;
  final String? _token;
  
  ResetPasswordScreenBloc({required AuthenticationRepository authenticationRepository, required String? token}) 
    : _authenticationRepository = authenticationRepository,
      _token = token,
      super(ResetPasswordScreenState.initial());

  @override
  Stream<Transition<ResetPasswordScreenEvent, ResetPasswordScreenState>> transformEvents(Stream<ResetPasswordScreenEvent> events, transitionFn) {
    final nonDebounceStream = events.where((event) => event is !PasswordChanged && event is !PasswordConfirmationChanged);
    final debounceStream = events.where((event) => event is PasswordChanged || event is PasswordConfirmationChanged)
      .debounceTime(Duration(milliseconds: 300));
    
    return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), transitionFn);
  }
  
  @override
  Stream<ResetPasswordScreenState> mapEventToState(ResetPasswordScreenEvent event) async* {
    if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event: event);
    } else if (event is PasswordConfirmationChanged) {
      yield* _mapPasswordConfirmationChangedToState(event: event);
    } else if (event is Submitted) {
      yield* _mapSubmittedToState(event: event);
    } else if (event is Reset) {
      yield* _mapResetToState();
    }
  }

  Stream<ResetPasswordScreenState> _mapPasswordChangedToState({required PasswordChanged event}) async* {
    final bool isPasswordConfirmationValid = event.passwordConfirmation.isNotEmpty
      ? Validators.isPasswordConfirmationValid(password: event.password, passwordConfirmation: event.passwordConfirmation)
      : true;
    yield state.update(isPasswordValid: Validators.isValidPassword(password: event.password), isPasswordConfirmationValid: isPasswordConfirmationValid);
  }

  Stream<ResetPasswordScreenState> _mapPasswordConfirmationChangedToState({required PasswordConfirmationChanged event}) async* {
    yield state.update(isPasswordConfirmationValid: Validators.isPasswordConfirmationValid(password: event.password, passwordConfirmation: event.passwordConfirmation));
  }

  Stream<ResetPasswordScreenState> _mapSubmittedToState({required Submitted event}) async* {
    if (_token != null) {
      yield state.update(isSubmitting: true, errorMessage: "");

      try {
        await _authenticationRepository.resetPassword(password: event.password, passwordConfirmation: event.passwordConfirmation, token: _token!);
        yield state.update(
          isSubmitting: false,
          isSuccess: true,
          errorMessage: "",
          errorButtonControl: CustomAnimationControl.STOP
        );
      } on ApiException catch (exception) {
        yield state.update(
          isSubmitting: false,
          isSuccess: false,
          errorMessage: exception.error,
          errorButtonControl: CustomAnimationControl.PLAY_FROM_START
        );
      }
    }
  }

  Stream<ResetPasswordScreenState> _mapResetToState() async* {
    yield state.update(isSubmitting: false, isSuccess: false, errorMessage: "", errorButtonControl: CustomAnimationControl.STOP);
  }
}
