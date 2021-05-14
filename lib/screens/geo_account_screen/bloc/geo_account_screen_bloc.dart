import 'dart:async';

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
      super(GeoAccountScreenState.initial(location: location));

  @override
  Stream<GeoAccountScreenState> mapEventToState(GeoAccountScreenEvent event) async* {
    if (event is LocationChanged) {
      yield* _mapLocationChangedToState(event: event);
    } else if (event is RadiusChanged) {
      yield* _mapRadiusChangedToState(event: event);
    } else if (event is Submitted) {
      yield* _mapSubmittedToState();
    } else if (event is Updated) {
      yield* _mapUpdatedToState(event: event);
    } else if (event is Reset) {
      yield* _mapResetToState();
    }
  }

  Stream<GeoAccountScreenState> _mapLocationChangedToState({required LocationChanged event}) async* {
    yield state.update(currentLocation: event.location);
  }

  Stream<GeoAccountScreenState> _mapRadiusChangedToState({required RadiusChanged event}) async* {
    yield state.update(radius: event.radius);
  }

  Stream<GeoAccountScreenState> _mapSubmittedToState() async* {
    yield state.update(isSubmitting: true);

    try {
      Location location = await _accountRepository.store(
        lat: state.currentLocation.latitude,
        lng: state.currentLocation.longitude,
        radius: _roundRadius(originalRadius: state.radius)
      );
      _updateBusinessBloc(location: location);
      yield state.update(isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.STOP);
    } on ApiException catch (exception) {
      yield state.update(isSubmitting: false, isFailure: true, errorMessage: exception.error, errorButtonControl: CustomAnimationControl.PLAY_FROM_START);
    }
  }

  Stream<GeoAccountScreenState> _mapUpdatedToState({required Updated event}) async* {
    yield state.update(isSubmitting: true);

    try {
      Location location = await _accountRepository.update(
        identifier: event.identifier, 
        lat: state.currentLocation.latitude,
        lng: state.currentLocation.longitude,
        radius: _roundRadius(originalRadius: state.radius)
      );
      _updateBusinessBloc(location: location);
      yield state.update(isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.STOP);
    } on ApiException catch (exception) {
      yield state.update(isSubmitting: false, isFailure: true, errorMessage: exception.error, errorButtonControl: CustomAnimationControl.PLAY_FROM_START);
    }
  }

  Stream<GeoAccountScreenState> _mapResetToState() async* {
    yield state.update(isSuccess: false, isFailure: false, errorMessage: "", errorButtonControl: CustomAnimationControl.STOP);
  }

  int _roundRadius({required double originalRadius}) {
    return ((originalRadius / 5.0).round() * 5).toInt();
  }

  void _updateBusinessBloc({required Location location}) {
    _businessBloc.add(LocationUpdated(location: location));
  }
}
