import 'package:bloc/bloc.dart';
import 'package:dashboard/models/photo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

part 'logo_form_event.dart';
part 'logo_form_state.dart';

class LogoFormBloc extends Bloc<LogoFormEvent, LogoFormState> {
  LogoFormBloc({required Photo logo})
    : super(LogoFormState.initial(logo: logo)) { _eventHandler(); }

  XFile? get logoFile => state.logoFile;
  
  void _eventHandler() {
    on<LogoPicked>((event, emit) => _mapLogoPickedToState(event: event, emit: emit));
  }
  
  void _mapLogoPickedToState({required LogoPicked event, required Emitter<LogoFormState> emit}) {
    emit(state.update(logoFile: event.logoFile));
  }
}
