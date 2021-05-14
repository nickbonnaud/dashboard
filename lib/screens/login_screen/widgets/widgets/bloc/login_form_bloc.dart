import 'dart:async';
import 'package:dashboard/blocs/authentication/authentication_bloc.dart';
import 'package:dashboard/models/business/business.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/resources/helpers/validators.dart';
import 'package:rxdart/rxdart.dart';

import 'package:bloc/bloc.dart';
import 'package:dashboard/repositories/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:simple_animations/simple_animations.dart';

part 'login_form_event.dart';
part 'login_form_state.dart';

class LoginFormBloc extends Bloc<LoginFormEvent, LoginFormState> {
  final AuthenticationRepository _authenticationRepository;
  final AuthenticationBloc _authenticationBloc;

  LoginFormBloc({required AuthenticationRepository authenticationRepository, required AuthenticationBloc authenticationBloc})
    : _authenticationRepository = authenticationRepository,
      _authenticationBloc = authenticationBloc,
      super(LoginFormState.empty());

  @override
  Stream<Transition<LoginFormEvent, LoginFormState>> transformEvents(Stream<LoginFormEvent> events, transitionFn) {
    final nonDebounceStream = events.where((event) => event is !EmailChanged && event is !PasswordChanged);
    final debounceStream = (events.where((event) => event is EmailChanged || event is PasswordChanged))
      .debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), transitionFn);
  }

  @override
  Stream<LoginFormState> mapEventToState(LoginFormEvent event) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event: event);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event: event);
    } else if (event is Submitted) {
      yield* _mapSubmittedToState(event: event);
    } else if (event is Reset) {
      yield* _mapResetToState();
    }
  }

  Stream<LoginFormState> _mapEmailChangedToState({required EmailChanged event}) async* {
    yield state.update(isEmailValid: Validators.isValidEmail(email: event.email));
  }

  Stream<LoginFormState> _mapPasswordChangedToState({required PasswordChanged event}) async* {
    yield state.update(isPasswordValid: Validators.isValidPassword(password: event.password));
  }

  Stream<LoginFormState> _mapSubmittedToState({required Submitted event}) async* {
    yield LoginFormState.loading();
    try {
      final Business business = await _authenticationRepository.login(email: event.email, password: event.password);
      _authenticationBloc.add(LoggedIn(business: business));
      yield LoginFormState.success();
    } on ApiException catch (exception) {
      yield LoginFormState.failure(errorMessage: exception.error);
    }
  }

  Stream<LoginFormState> _mapResetToState() async* {
    yield state.update(isSuccess: false, errorMessage: "", errorButtonControl: CustomAnimationControl.STOP);
  }
}
