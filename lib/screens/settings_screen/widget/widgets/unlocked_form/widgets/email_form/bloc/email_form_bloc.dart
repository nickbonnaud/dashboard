import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/repositories/business_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/resources/helpers/validators.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:rxdart/rxdart.dart';

part 'email_form_event.dart';
part 'email_form_state.dart';

class EmailFormBloc extends Bloc<EmailFormEvent, EmailFormState> {
  final BusinessRepository _businessRepository;
  final BusinessBloc _businessBloc; 
  
  EmailFormBloc({required BusinessRepository businessRepository, required BusinessBloc businessBloc})
    : _businessRepository = businessRepository,
      _businessBloc = businessBloc,
      super(EmailFormState.initial());
  
  @override
    Stream<Transition<EmailFormEvent, EmailFormState>> transformEvents(Stream<EmailFormEvent> events, transitionFn) {
      final nonDebounceStream = events.where((event) => event is !EmailChanged);
      final debounceStream = events.where((event) => event is EmailChanged).debounceTime(Duration(milliseconds: 300));

      return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), transitionFn);
    }
  
  @override
  Stream<EmailFormState> mapEventToState(EmailFormEvent event) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event: event);
    } else if (event is Submitted) {
      yield* _mapSubmittedToState(event: event);
    } else if (event is Reset) {
      yield* _mapResetToState();
    }
  }

  Stream<EmailFormState> _mapEmailChangedToState({required EmailChanged event}) async* {
    yield state.update(isEmailValid: Validators.isValidEmail(email: event.email));
  }

  Stream<EmailFormState> _mapSubmittedToState({required Submitted event}) async* {
    yield state.update(isSubmitting: true);

    try {
      final String email = await _businessRepository.updateEmail(
        email: event.email, 
        identifier: event.identifier
      );
      _businessBloc.add(EmailUpdated(email: email));
      yield state.update(isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.STOP);
    } on ApiException catch (exception) {
      yield state.update(isSubmitting: false, errorMessage: exception.error, errorButtonControl: CustomAnimationControl.PLAY_FROM_START);
    }
  }

  Stream<EmailFormState> _mapResetToState() async* {
    yield state.update(isSuccess: false, errorMessage: "", errorButtonControl: CustomAnimationControl.STOP);
  }
}
