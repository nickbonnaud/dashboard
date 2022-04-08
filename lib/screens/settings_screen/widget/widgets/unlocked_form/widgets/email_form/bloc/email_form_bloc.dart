import 'package:bloc/bloc.dart';
import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/repositories/business_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/resources/helpers/debouncer.dart';
import 'package:dashboard/resources/helpers/validators.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:simple_animations/simple_animations.dart';

part 'email_form_event.dart';
part 'email_form_state.dart';

class EmailFormBloc extends Bloc<EmailFormEvent, EmailFormState> {
  final BusinessRepository _businessRepository;
  final BusinessBloc _businessBloc; 
  
  EmailFormBloc({required BusinessRepository businessRepository, required BusinessBloc businessBloc})
    : _businessRepository = businessRepository,
      _businessBloc = businessBloc,
      super(EmailFormState.initial()) { _eventHandler(); }
  
  void _eventHandler() {
    on<EmailChanged>((event, emit) => _mapEmailChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: const Duration(milliseconds: 300)));
    on<Submitted>((event, emit) async => await _mapSubmittedToState(event: event, emit: emit));
    on<Reset>((event, emit) => _mapResetToState(emit: emit));
  }

  void _mapEmailChangedToState({required EmailChanged event, required Emitter<EmailFormState> emit}) {
    emit(state.update(isEmailValid: Validators.isValidEmail(email: event.email)));
  }

  Future<void> _mapSubmittedToState({required Submitted event, required Emitter<EmailFormState> emit}) async {
    emit(state.update(isSubmitting: true));

    try {
      final String email = await _businessRepository.updateEmail(
        email: event.email, 
        identifier: event.identifier
      );
      _businessBloc.add(EmailUpdated(email: email));
      emit(state.update(isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.stop));
    } on ApiException catch (exception) {
      emit(state.update(isSubmitting: false, errorMessage: exception.error, errorButtonControl: CustomAnimationControl.playFromStart));
    }
  }

  void _mapResetToState({required Emitter<EmailFormState> emit}) {
    emit(state.update(isSuccess: false, errorMessage: "", errorButtonControl: CustomAnimationControl.stop));
  }
}
