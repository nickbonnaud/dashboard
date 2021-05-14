import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dashboard/blocs/authentication/authentication_bloc.dart';
import 'package:dashboard/models/business/business.dart';
import 'package:dashboard/repositories/authentication_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/resources/helpers/validators.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:simple_animations/simple_animations.dart';

part 'register_form_event.dart';
part 'register_form_state.dart';

class RegisterFormBloc extends Bloc<RegisterFormEvent, RegisterFormState> {
  final AuthenticationRepository _authenticationRepository;
  final AuthenticationBloc _authenticationBloc;

  RegisterFormBloc({required AuthenticationRepository authenticationRepository, required AuthenticationBloc authenticationBloc})
    : _authenticationRepository = authenticationRepository,
      _authenticationBloc = authenticationBloc, 
      super(RegisterFormState.empty());

  @override
  Stream<Transition<RegisterFormEvent, RegisterFormState>> transformEvents(Stream<RegisterFormEvent> events, transitionFn) {
    final nonDebounceStream = events.where((event) => event is !EmailChanged && event is !PasswordChanged && event is !PasswordConfirmationChanged);
    final debounceStream = events.where((event) => event is EmailChanged || event is PasswordChanged || event is PasswordConfirmationChanged)
      .debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), transitionFn);
  }
  
  @override
  Stream<RegisterFormState> mapEventToState(RegisterFormEvent event) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event: event);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event: event);
    } else if (event is PasswordConfirmationChanged) {
      yield* _mapPasswordConfirmationChangedToState(event: event);
    } else if (event is Submitted) {
      yield* _mapSubmittedToState(event: event);
    } else if (event is Reset) {
      yield* _mapResetToState();
    }
  }

  Stream<RegisterFormState> _mapEmailChangedToState({required EmailChanged event}) async* {
    yield state.update(isEmailValid: Validators.isValidEmail(email: event.email));
  }

  Stream<RegisterFormState> _mapPasswordChangedToState({required PasswordChanged event}) async* {
    final bool isPasswordConfirmationValid = event.passwordConfirmation.isNotEmpty
      ? Validators.isPasswordConfirmationValid(password: event.password, passwordConfirmation: event.passwordConfirmation)
      : true;
    yield state.update(isPasswordValid: Validators.isValidPassword(password: event.password), isPasswordConfirmationValid: isPasswordConfirmationValid);
  }

  Stream<RegisterFormState> _mapPasswordConfirmationChangedToState({required PasswordConfirmationChanged event}) async* {
    yield state.update(isPasswordConfirmationValid: Validators.isPasswordConfirmationValid(password: event.password, passwordConfirmation: event.passwordConfirmation));
  }

  Stream<RegisterFormState> _mapSubmittedToState({required Submitted event}) async* {
    yield RegisterFormState.loading();

    try {
      final Business business = await _authenticationRepository.register(email: event.email, password: event.password, passwordConfirmation: event.passwordConfirmation);
      _authenticationBloc.add(LoggedIn(business: business));
      yield RegisterFormState.success();
    } on ApiException catch (exception) {
      yield RegisterFormState.failure(errorMessage: exception.error);
    }
  }

  Stream<RegisterFormState> _mapResetToState() async* {
    yield state.update(isSuccess: false, errorMessage: "", errorButtonControl: CustomAnimationControl.STOP);
  }
}
