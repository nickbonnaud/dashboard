import 'package:bloc/bloc.dart';
import 'package:dashboard/repositories/authentication_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/resources/helpers/debouncer.dart';
import 'package:dashboard/resources/helpers/validators.dart';
import 'package:equatable/equatable.dart';
import 'package:simple_animations/simple_animations.dart';

part 'request_reset_password_screen_event.dart';
part 'request_reset_password_screen_state.dart';

class RequestResetPasswordScreenBloc extends Bloc<RequestResetPasswordScreenEvent, RequestResetPasswordScreenState> {
  final AuthenticationRepository _authenticationRepository;
  
  RequestResetPasswordScreenBloc({required AuthenticationRepository authenticationRepository}) 
    : _authenticationRepository = authenticationRepository,
      super(RequestResetPasswordScreenState.initial()) { _eventHandler(); }

  void _eventHandler() {
    on<EmailChanged>((event, emit) => _mapEmailChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: Duration(milliseconds: 300)));
    on<Submitted>((event, emit) async => await _mapSubmittedToState(event: event, emit: emit));
    on<Reset>((event, emit) => _mapResetToState(emit: emit));
  }

  void _mapEmailChangedToState({required EmailChanged event, required Emitter<RequestResetPasswordScreenState> emit}) {
    emit(state.update(isEmailValid: Validators.isValidEmail(email: event.email)));
  }

  Future<void> _mapSubmittedToState({required Submitted event, required Emitter<RequestResetPasswordScreenState> emit}) async {
    emit(state.update(isSubmitting: true, errorMessage: ""));

    try {
      await _authenticationRepository.requestPasswordReset(email: event.email);
      emit(state.update(
        isSubmitting: false, 
        isSuccess: true,
        errorMessage: "",
        errorButtonControl: CustomAnimationControl.stop
      ));
    } on ApiException catch (exception) {
      emit(state.update(
        isSubmitting: false,
        isSuccess: false,
        errorMessage: exception.error,
        errorButtonControl: CustomAnimationControl.playFromStart
      ));
    }
  }

  void _mapResetToState({required Emitter<RequestResetPasswordScreenState> emit}) {
    emit(state.update(isSubmitting: false, isSuccess: false, errorMessage: "", errorButtonControl: CustomAnimationControl.stop));
  }
}
