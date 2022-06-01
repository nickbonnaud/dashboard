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

part 'login_form_event.dart';
part 'login_form_state.dart';

class LoginFormBloc extends Bloc<LoginFormEvent, LoginFormState> {
  final AuthenticationRepository _authenticationRepository;
  final AuthenticationBloc _authenticationBloc;

  final Duration _debounceTime = const Duration(milliseconds: 300); 

  LoginFormBloc({required AuthenticationRepository authenticationRepository, required AuthenticationBloc authenticationBloc})
    : _authenticationRepository = authenticationRepository,
      _authenticationBloc = authenticationBloc,
      super(LoginFormState.empty()) { _eventHandler(); }

  void _eventHandler() {
    on<EmailChanged>((event, emit) => _mapEmailChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<PasswordChanged>((event, emit) => _mapPasswordChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<Submitted>((event, emit) async => await _mapSubmittedToState(emit: emit));
    on<Reset>((event, emit) => _mapResetToState(emit: emit));
  }
  
  void _mapEmailChangedToState({required EmailChanged event, required Emitter<LoginFormState> emit}) {
    emit(state.update(email: event.email, isEmailValid: Validators.isValidEmail(email: event.email)));
  }

  void _mapPasswordChangedToState({required PasswordChanged event, required Emitter<LoginFormState> emit}) {
    emit(state.update(password: event.password, isPasswordValid: Validators.isValidPassword(password: event.password)));
  }

  Future<void> _mapSubmittedToState({required Emitter<LoginFormState> emit}) async {
    emit(state.update(isSubmitting: true));
    try {
      final Business business = await _authenticationRepository.login(email: state.email, password: state.password);
      _authenticationBloc.add(LoggedIn(business: business));
      emit(state.update(isSubmitting: false, isSuccess: true));
    } on ApiException catch (exception) {
      emit(state.update(isSubmitting: false, errorMessage: exception.error, errorButtonControl: CustomAnimationControl.playFromStart));
    }
  }

  void _mapResetToState({required Emitter<LoginFormState> emit}) {
    emit(state.update(isSuccess: false, errorMessage: "", errorButtonControl: CustomAnimationControl.stop));
  }
}
