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

  final Duration _debounceTime = const Duration(milliseconds: 300);

  RegisterFormBloc({required AuthenticationRepository authenticationRepository, required AuthenticationBloc authenticationBloc})
    : _authenticationRepository = authenticationRepository,
      _authenticationBloc = authenticationBloc, 
      super(RegisterFormState.empty()) { _eventHandler(); }

  void _eventHandler() {
    on<EmailChanged>((event, emit) => _mapEmailChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<PasswordChanged>((event, emit) => _mapPasswordChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<PasswordConfirmationChanged>((event, emit) => _mapPasswordConfirmationChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<Submitted>((event, emit) async => await _mapSubmittedToState(emit: emit));
    on<Reset>((event, emit) => _mapResetToState(emit: emit));
  }

  void _mapEmailChangedToState({required EmailChanged event, required Emitter<RegisterFormState> emit}) {
    emit(state.update(email: event.email, isEmailValid: Validators.isValidEmail(email: event.email)));
  }

  void _mapPasswordChangedToState({required PasswordChanged event, required Emitter<RegisterFormState> emit}) {
    final bool isPasswordConfirmationValid = state.passwordConfirmation.isNotEmpty
      ? Validators.isPasswordConfirmationValid(password: event.password, passwordConfirmation: state.passwordConfirmation)
      : true;
    emit(state.update(password: event.password, isPasswordValid: Validators.isValidPassword(password: event.password), isPasswordConfirmationValid: isPasswordConfirmationValid));
  }

  void _mapPasswordConfirmationChangedToState({required PasswordConfirmationChanged event, required Emitter<RegisterFormState> emit}) {
    emit(state.update(passwordConfirmation: event.passwordConfirmation, isPasswordConfirmationValid: Validators.isPasswordConfirmationValid(password: state.password, passwordConfirmation: event.passwordConfirmation)));
  }

  Future<void> _mapSubmittedToState({required Emitter<RegisterFormState> emit}) async {
    emit(state.update(isSubmitting: true));

    try {
      final Business business = await _authenticationRepository.register(email: state.email, password: state.password, passwordConfirmation: state.passwordConfirmation);
      _authenticationBloc.add(LoggedIn(business: business));
      emit(state.update(isSubmitting: false, isSuccess: true));
    } on ApiException catch (exception) {
      emit(state.update(isSubmitting: false, errorMessage: exception.error, errorButtonControl: CustomAnimationControl.playFromStart));
    }
  }

  void _mapResetToState({required Emitter<RegisterFormState> emit}) {
    emit(state.update(isSuccess: false, errorMessage: "", errorButtonControl: CustomAnimationControl.stop));
  }
}
