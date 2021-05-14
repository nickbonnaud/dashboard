import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dashboard/repositories/authentication_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/resources/helpers/validators.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:simple_animations/simple_animations.dart';

part 'request_reset_password_screen_event.dart';
part 'request_reset_password_screen_state.dart';

class RequestResetPasswordScreenBloc extends Bloc<RequestResetPasswordScreenEvent, RequestResetPasswordScreenState> {
  final AuthenticationRepository _authenticationRepository;
  
  RequestResetPasswordScreenBloc({required AuthenticationRepository authenticationRepository}) 
    : _authenticationRepository = authenticationRepository,
      super(RequestResetPasswordScreenState.initial());

  @override
  Stream<Transition<RequestResetPasswordScreenEvent, RequestResetPasswordScreenState>> transformEvents(Stream<RequestResetPasswordScreenEvent> events, transitionFn) {
    final nonDebounceStream = events.where((event) => event is !EmailChanged);
    final debounceStream = events.where((event) => event is EmailChanged)
      .debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), transitionFn);
  }
  
  @override
  Stream<RequestResetPasswordScreenState> mapEventToState(RequestResetPasswordScreenEvent event) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event: event);
    } else if (event is Submitted) {
      yield* _mapSubmittedToState(event: event);
    } else if (event is Reset) {
      yield* _mapResetToState();
    }
  }

  Stream<RequestResetPasswordScreenState> _mapEmailChangedToState({required EmailChanged event}) async* {
    yield state.update(isEmailValid: Validators.isValidEmail(email: event.email));
  }

  Stream<RequestResetPasswordScreenState> _mapSubmittedToState({required Submitted event}) async* {
    yield state.update(isSubmitting: true, errorMessage: "");

    try {
      await _authenticationRepository.requestPasswordReset(email: event.email);
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

  Stream<RequestResetPasswordScreenState> _mapResetToState() async* {
    yield state.update(isSubmitting: false, isSuccess: false, errorMessage: "", errorButtonControl: CustomAnimationControl.STOP);
  }
}
