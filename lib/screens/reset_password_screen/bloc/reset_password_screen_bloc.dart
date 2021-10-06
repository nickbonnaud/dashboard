import 'package:bloc/bloc.dart';
import 'package:dashboard/repositories/authentication_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/resources/helpers/debouncer.dart';
import 'package:dashboard/resources/helpers/validators.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

part 'reset_password_screen_event.dart';
part 'reset_password_screen_state.dart';

class ResetPasswordScreenBloc extends Bloc<ResetPasswordScreenEvent, ResetPasswordScreenState> {
  final AuthenticationRepository _authenticationRepository;
  final String? _token;

  final Duration _debounceTime = Duration(milliseconds: 300);
  
  ResetPasswordScreenBloc({required AuthenticationRepository authenticationRepository, required String? token}) 
    : _authenticationRepository = authenticationRepository,
      _token = token,
      super(ResetPasswordScreenState.initial()) { _eventHandler(); }

  void _eventHandler() {
    on<PasswordChanged>((event, emit) => _mapPasswordChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<PasswordConfirmationChanged>((event, emit) => _mapPasswordConfirmationChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<Submitted>((event, emit) => _mapSubmittedToState(event: event, emit: emit));
    on<Reset>((event, emit) => _mapResetToState(emit: emit));
  }
  
  void _mapPasswordChangedToState({required PasswordChanged event, required Emitter<ResetPasswordScreenState> emit}) async {
    final bool isPasswordConfirmationValid = event.passwordConfirmation.isNotEmpty
      ? Validators.isPasswordConfirmationValid(password: event.password, passwordConfirmation: event.passwordConfirmation)
      : true;
    emit(state.update(isPasswordValid: Validators.isValidPassword(password: event.password), isPasswordConfirmationValid: isPasswordConfirmationValid));
  }

  void _mapPasswordConfirmationChangedToState({required PasswordConfirmationChanged event, required Emitter<ResetPasswordScreenState> emit}) async {
    emit(state.update(isPasswordConfirmationValid: Validators.isPasswordConfirmationValid(password: event.password, passwordConfirmation: event.passwordConfirmation)));
  }

  void _mapSubmittedToState({required Submitted event, required Emitter<ResetPasswordScreenState> emit}) async {
    if (_token != null) {
      emit(state.update(isSubmitting: true, errorMessage: ""));

      try {
        await _authenticationRepository.resetPassword(password: event.password, passwordConfirmation: event.passwordConfirmation, token: _token!);
        emit(state.update(
          isSubmitting: false,
          isSuccess: true,
          errorMessage: "",
          errorButtonControl: CustomAnimationControl.STOP
        ));
      } on ApiException catch (exception) {
        emit(state.update(
          isSubmitting: false,
          isSuccess: false,
          errorMessage: exception.error,
          errorButtonControl: CustomAnimationControl.PLAY_FROM_START
        ));
      }
    }
  }

  void _mapResetToState({required Emitter<ResetPasswordScreenState> emit}) async {
    emit(state.update(isSubmitting: false, isSuccess: false, errorMessage: "", errorButtonControl: CustomAnimationControl.STOP));
  }
}
