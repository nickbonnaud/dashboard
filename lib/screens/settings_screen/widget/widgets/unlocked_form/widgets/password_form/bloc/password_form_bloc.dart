import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dashboard/repositories/business_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/resources/helpers/validators.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:rxdart/rxdart.dart';

part 'password_form_event.dart';
part 'password_form_state.dart';

class PasswordFormBloc extends Bloc<PasswordFormEvent, PasswordFormState> {
  final BusinessRepository _businessRepository;

  PasswordFormBloc({required BusinessRepository businessRepository}) 
    : _businessRepository = businessRepository,
      super(PasswordFormState.initial());

  @override
  Stream<Transition<PasswordFormEvent, PasswordFormState>> transformEvents(Stream<PasswordFormEvent> events, transitionFn) {
    final nonDebounceStream = events.where((event) => event is Submitted || event is Reset);
    final debounceStream = events.where((event) => event is !Submitted && event is !Reset)
        .debounceTime(Duration(milliseconds: 300));

    return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), transitionFn);
  }
  
  @override
  Stream<PasswordFormState> mapEventToState(PasswordFormEvent event) async* {
    if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event: event);
    } else if (event is PasswordConfirmationChanged) {
      yield* _mapPasswordConfirmationChangedToState(event: event);
    } else if (event is Submitted) {
      yield*  _mapSubmittedToState(event: event);
    } else if (event is Reset) {
      yield* _mapResetToState();
    }
  }

  Stream<PasswordFormState> _mapPasswordChangedToState({required PasswordChanged event}) async* {
    final bool isPasswordConfirmationValid = event.passwordConfirmation.isNotEmpty
      ? Validators.isPasswordConfirmationValid(password: event.password, passwordConfirmation: event.passwordConfirmation)
      : true;
    yield state.update(isPasswordValid: Validators.isValidPassword(password: event.password), isPasswordConfirmationValid: isPasswordConfirmationValid);
  }

  Stream<PasswordFormState> _mapPasswordConfirmationChangedToState({required PasswordConfirmationChanged event}) async* {
    yield state.update(isPasswordConfirmationValid: Validators.isPasswordConfirmationValid(password: event.password, passwordConfirmation: event.passwordConfirmation));
  }

  Stream<PasswordFormState> _mapSubmittedToState({required Submitted event}) async* {
    yield state.update(isSubmitting: true);

    try {
      await _businessRepository.updatePassword(
        password: event.password, 
        passwordConfirmation: event.passwordConfirmation, 
        identifier: event.identifier
      );
      yield state.update(isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.STOP);
    } on ApiException catch (exception) {
      yield state.update(isSubmitting: false, errorMessage: exception.error, errorButtonControl: CustomAnimationControl.PLAY_FROM_START);
    }
  }

  Stream<PasswordFormState> _mapResetToState() async* {
    yield state.update(isSuccess: false, errorMessage: "", errorButtonControl: CustomAnimationControl.STOP);
  }
}
