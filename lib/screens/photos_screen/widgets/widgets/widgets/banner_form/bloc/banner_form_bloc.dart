import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dashboard/models/photo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

part 'banner_form_event.dart';
part 'banner_form_state.dart';

class BannerFormBloc extends Bloc<BannerFormEvent, BannerFormState> {
  BannerFormBloc({required Photo banner}) : super(BannerFormState.initial(banner: banner));

  PickedFile? get bannerFile => state.bannerFile;
  
  @override
  Stream<BannerFormState> mapEventToState(BannerFormEvent event) async* {
    if (event is BannerPicked) {
      yield* _mapBannerPickedToState(event: event);
    }
  }

  Stream<BannerFormState> _mapBannerPickedToState({required BannerPicked event}) async* {
    yield state.update(bannerFile: event.bannerFile);
  }
}
