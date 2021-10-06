import 'package:bloc/bloc.dart';
import 'package:dashboard/blocs/authentication/authentication_bloc.dart';
import 'package:dashboard/models/business/business.dart';
import 'package:dashboard/repositories/authentication_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/resources/helpers/debouncer.dart';
import 'package:dashboard/resources/helpers/validators.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:simple_animations/simple_animations.dart';

part 'register_form_event.dart';
part 'register_form_state.dart';

class RegisterFormBloc extends Bloc<RegisterFormEvent, RegisterFormState> {
  final AuthenticationRepository _authenticationRepository;
  final AuthenticationBloc _authenticationBloc;

  final Duration _debounceTime = Duration(milliseconds: 300);

  RegisterFormBloc({required AuthenticationRepository authenticationRepository, required AuthenticationBloc authenticationBloc})
    : _authenticationRepository = authenticationRepository,
      _authenticationBloc = authenticationBloc, 
      super(RegisterFormState.empty()) { _eventHandler(); }

  void _eventHandler() {
    on<EmailChanged>((event, emit) => _mapEmailChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<PasswordChanged>((event, emit) => _mapPasswordChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<PasswordConfirmationChanged>((event, emit) => _mapPasswordConfirmationChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<Submitted>((event, emit) => _mapSubmittedToState(event: event, emit: emit));
    on<Reset>((event, emit) => _mapResetToState(emit: emit));
  }

  void _mapEmailChangedToState({required EmailChanged event, required Emitter<RegisterFormState> emit}) async {
    emit(state.update(isEmailValid: Validators.isValidEmail(email: event.email)));
  }

  void _mapPasswordChangedToState({required PasswordChanged event, required Emitter<RegisterFormState> emit}) async {
    final bool isPasswordConfirmationValid = event.passwordConfirmation.isNotEmpty
      ? Validators.isPasswordConfirmationValid(password: event.password, passwordConfirmation: event.passwordConfirmation)
      : true;
    emit(state.update(isPasswordValid: Validators.isValidPassword(password: event.password), isPasswordConfirmationValid: isPasswordConfirmationValid));
  }

  void _mapPasswordConfirmationChangedToState({required PasswordConfirmationChanged event, required Emitter<RegisterFormState> emit}) async {
    emit(state.update(isPasswordConfirmationValid: Validators.isPasswordConfirmationValid(password: event.password, passwordConfirmation: event.passwordConfirmation)));
  }

  void _mapSubmittedToState({required Submitted event, required Emitter<RegisterFormState> emit}) async {
    emit(RegisterFormState.loading());

    try {
      final Business business = await _authenticationRepository.register(email: event.email, password: event.password, passwordConfirmation: event.passwordConfirmation);
      _authenticationBloc.add(LoggedIn(business: business));
      emit(RegisterFormState.success());
    } on ApiException catch (exception) {
      emit(RegisterFormState.failure(errorMessage: exception.error));
    }
  }

  void _mapResetToState({required Emitter<RegisterFormState> emit}) async {
    emit(state.update(isSuccess: false, errorMessage: "", errorButtonControl: CustomAnimationControl.STOP));
  }
}
