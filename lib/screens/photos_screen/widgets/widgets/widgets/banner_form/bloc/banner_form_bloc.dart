import 'package:bloc/bloc.dart';
import 'package:dashboard/models/photo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

part 'banner_form_event.dart';
part 'banner_form_state.dart';

class BannerFormBloc extends Bloc<BannerFormEvent, BannerFormState> {
  BannerFormBloc({required Photo banner})
    : super(BannerFormState.initial(banner: banner)) { _eventHandler(); }

  PickedFile? get bannerFile => state.bannerFile;
  
  void _eventHandler() {
    on<BannerPicked>((event, emit) => _mapBannerPickedToState(event: event, emit: emit));
  }

  void _mapBannerPickedToState({required BannerPicked event, required Emitter<BannerFormState> emit}) {
    emit(state.update(bannerFile: event.bannerFile));
  }
}
