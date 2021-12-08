import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/models/business/photos.dart';
import 'package:dashboard/repositories/photos_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/photos_screen/widgets/widgets/widgets/banner_form/bloc/banner_form_bloc.dart';
import 'package:dashboard/screens/photos_screen/widgets/widgets/widgets/logo_form/bloc/logo_form_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_animations/simple_animations.dart';

part 'photos_form_event.dart';
part 'photos_form_state.dart';

class PhotosFormBloc extends Bloc<PhotosFormEvent, PhotosFormState> {
  final PhotosRepository _photosRepository;
  final LogoFormBloc _logoFormBloc;
  final BannerFormBloc _bannerFormBloc;
  final BusinessBloc _businessBloc;

  late StreamSubscription _logoStream;
  late StreamSubscription _bannerStream;

  PhotosFormBloc({
    required PhotosRepository photosRepository,
    required LogoFormBloc logoFormBloc,
    required BannerFormBloc bannerFormBloc,
    required BusinessBloc businessBloc
  })
    : _photosRepository = photosRepository,
      _logoFormBloc = logoFormBloc,
      _bannerFormBloc = bannerFormBloc,
      _businessBloc = businessBloc,
      super(PhotosFormState.intial()) {
        _eventHandler();
        _logoStream = _logoFormBloc.stream.listen(_onLogoChanged);
        _bannerStream = _bannerFormBloc.stream.listen(_onBannerChanged);
      }

  void _eventHandler() {
    on<LogoFilePicked>((event, emit) => _mapLogoFilePickedToState(event: event, emit: emit));
    on<BannerFilePicked>((event, emit) => _mapBannerFilePickedToState(event: event, emit: emit));
    on<Submitted>((event, emit) async => await _mapSubmittedToState(event: event, emit: emit));
    on<Reset>((event, emit) => _mapResetToState(emit: emit));
  }

  @override
  Future<void> close() {
    _logoStream.cancel();
    _bannerStream.cancel();
    return super.close();
  }

  void _mapLogoFilePickedToState({required LogoFilePicked event, required Emitter<PhotosFormState> emit}) {
    emit(state.update(logoFile: event.logo));
  }

  void _mapBannerFilePickedToState({required BannerFilePicked event, required Emitter<PhotosFormState> emit}) {
    emit(state.update(bannerFile: event.banner));
  }

  Future<void> _mapSubmittedToState({required Submitted event, required Emitter<PhotosFormState> emit}) async {
    emit(state.update(isSubmitting: true));

    try {
      Photos photos;
      if (state.logoFile != null && state.bannerFile != null) {
        photos = await _storeBoth(identifier: event.identifier);
      } else if (state.logoFile != null) {
        photos = await _storeLogo(identifier: event.identifier);
      } else {
        photos = await _storeBanner(identifier: event.identifier);
      }
      _updateBusinessBloc(photos: photos);
      emit(state.update(isSubmitting: false, isSuccess: true));
    } on ApiException catch (exception) {
      emit(state.update(isSubmitting: false, errorMessage: exception.error, errorButtonControl: CustomAnimationControl.playFromStart));
    }
  }

  void _mapResetToState({required Emitter<PhotosFormState> emit}) {
    emit(state.update(isSubmitting: false, isSuccess: false, errorMessage: "", errorButtonControl: CustomAnimationControl.stop));
  }

  void _updateBusinessBloc({required Photos photos}) {
    _businessBloc.add(PhotosUpdated(photos: photos));
  }
  
  void _onLogoChanged(LogoFormState logoFormState) {
    if (logoFormState.logoFile != null) {
      add(LogoFilePicked(logo: logoFormState.logoFile!));
    }
  }

  void _onBannerChanged(BannerFormState bannerFormState) {
    if (bannerFormState.bannerFile != null) {
      add(BannerFilePicked(banner: bannerFormState.bannerFile!));
    }
  }

  Future<Photos> _storeBoth({required String identifier}) async {
    List<Photos> responses = await Future.wait([
      _photosRepository.storeLogo(file: state.logoFile!, profileIdentifier: identifier),
      _photosRepository.storeBanner(file: state.bannerFile!, profileIdentifier: identifier)
    ]);
    return Photos(
      logo: responses[0].logo,
      banner: responses[1].banner
    );
  }

  Future<Photos> _storeLogo({required String identifier}) async {
    return await _photosRepository.storeLogo(file: state.logoFile!, profileIdentifier: identifier);
  }

  Future<Photos> _storeBanner({required String identifier}) async {
    return await _photosRepository.storeBanner(file: state.logoFile!, profileIdentifier: identifier);
  }
}
