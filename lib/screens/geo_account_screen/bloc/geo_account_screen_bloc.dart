import 'package:bloc/bloc.dart';
import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/models/business/location.dart';
import 'package:dashboard/repositories/geo_account_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'package:simple_animations/simple_animations.dart';

part 'geo_account_screen_event.dart';
part 'geo_account_screen_state.dart';

class GeoAccountScreenBloc extends Bloc<GeoAccountScreenEvent, GeoAccountScreenState> {
  final GeoAccountRepository _accountRepository;
  final BusinessBloc _businessBloc;
  
  GeoAccountScreenBloc({required GeoAccountRepository accountRepository, required BusinessBloc businessBloc, required Location location}) 
    : _accountRepository = accountRepository,
      _businessBloc = businessBloc,
      super(GeoAccountScreenState.initial(location: location)) { _eventHandler(); }

  void _eventHandler() {
    on<LocationChanged>((event, emit) => _mapLocationChangedToState(event: event, emit: emit));
    on<RadiusChanged>((event, emit) => _mapRadiusChangedToState(event: event, emit: emit));
    on<Submitted>((event, emit) async => await _mapSubmittedToState(emit: emit));
    on<Updated>((event, emit) async => await _mapUpdatedToState(event: event, emit: emit));
    on<Reset>((event, emit) => _mapResetToState(emit: emit));
  }

  void _mapLocationChangedToState({required LocationChanged event, required Emitter<GeoAccountScreenState> emit}) {
    emit(state.update(currentLocation: event.location));
  }

  void _mapRadiusChangedToState({required RadiusChanged event, required Emitter<GeoAccountScreenState> emit}) {
    emit(state.update(radius: event.radius));
  }

  Future<void> _mapSubmittedToState({required Emitter<GeoAccountScreenState> emit}) async {
    emit(state.update(isSubmitting: true));

    try {
      Location location = await _accountRepository.store(
        lat: state.currentLocation.latitude,
        lng: state.currentLocation.longitude,
        radius: _roundRadius(originalRadius: state.radius)
      );
      _updateBusinessBloc(location: location);
      emit(state.update(isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.stop));
    } on ApiException catch (exception) {
      emit(state.update(isSubmitting: false, isFailure: true, errorMessage: exception.error, errorButtonControl: CustomAnimationControl.playFromStart));
    }
  }

  Future<void> _mapUpdatedToState({required Updated event, required Emitter<GeoAccountScreenState> emit}) async {
    emit(state.update(isSubmitting: true));

    try {
      Location location = await _accountRepository.update(
        identifier: event.identifier, 
        lat: state.currentLocation.latitude,
        lng: state.currentLocation.longitude,
        radius: _roundRadius(originalRadius: state.radius)
      );
      _updateBusinessBloc(location: location);
      emit(state.update(isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.stop));
    } on ApiException catch (exception) {
      emit(state.update(isSubmitting: false, isFailure: true, errorMessage: exception.error, errorButtonControl: CustomAnimationControl.playFromStart));
    }
  }

  void _mapResetToState({required Emitter<GeoAccountScreenState> emit}) {
    emit(state.update(isSuccess: false, isFailure: false, errorMessage: "", errorButtonControl: CustomAnimationControl.stop));
  }

  int _roundRadius({required double originalRadius}) {
    return ((originalRadius / 5.0).round() * 5).toInt();
  }

  void _updateBusinessBloc({required Location location}) {
    _businessBloc.add(LocationUpdated(location: location));
  }
}
