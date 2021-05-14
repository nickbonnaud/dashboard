import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dashboard/models/photo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

part 'logo_form_event.dart';
part 'logo_form_state.dart';

class LogoFormBloc extends Bloc<LogoFormEvent, LogoFormState> {
  LogoFormBloc({required Photo logo}) : super(LogoFormState.initial(logo: logo));

  PickedFile? get logoFile => state.logoFile;
  
  @override
  Stream<LogoFormState> mapEventToState(LogoFormEvent event) async* {
    if (event is LogoPicked) {
      yield* _mapLogoPickedToState(event: event);
    }
  }

  Stream<LogoFormState> _mapLogoPickedToState({required LogoPicked event}) async* {
    yield state.update(logoFile: event.logoFile);
  }
}
