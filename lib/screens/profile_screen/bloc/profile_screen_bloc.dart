import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/models/business/bank_account.dart';
import 'package:dashboard/models/business/business_account.dart';
import 'package:dashboard/models/business/location.dart' as Business;
import 'package:dashboard/models/business/profile.dart';
import 'package:dashboard/repositories/profile_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/resources/helpers/validators.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:simple_animations/simple_animations.dart';

part 'profile_screen_event.dart';
part 'profile_screen_state.dart';

class ProfileScreenBloc extends Bloc<ProfileScreenEvent, ProfileScreenState> {
  final ProfileRepository _profileRepository;
  final BusinessBloc _businessBloc;
  final GoogleMapsPlaces _places;

  ProfileScreenBloc({
    required ProfileRepository profileRepository, 
    required BusinessBloc businessBloc,
    required GoogleMapsPlaces places
  })
    : _profileRepository = profileRepository,
      _businessBloc = businessBloc,
      _places = places,
      super(ProfileScreenState.empty());

  @override
  Stream<Transition<ProfileScreenEvent, ProfileScreenState>> transformEvents(Stream<ProfileScreenEvent> events, transitionFn) {
    final nonDebounceStream = events.where((event) => 
      event is !NameChanged && 
      event is !WebsiteChanged && 
      event is !DescriptionChanged && 
      event is !PhoneChanged &&
      event is !PlaceQueryChanged
    );
    final debounceStream = events.where((event) => 
      event is NameChanged ||
      event is WebsiteChanged || 
      event is DescriptionChanged || 
      event is PhoneChanged
    ).debounceTime(Duration(milliseconds: 300));
    final extraDebounceStream = events.where((event) => 
      event is PlaceQueryChanged
    ).debounceTime(Duration(seconds: 1));
    return super.transformEvents(nonDebounceStream.mergeWith([debounceStream, extraDebounceStream]), transitionFn);
  }
  
  @override
  Stream<ProfileScreenState> mapEventToState(ProfileScreenEvent event) async* {
    if (event is PlaceQueryChanged) {
      yield* _mapPlaceQueryChangedToState(event: event);
    } else if (event is PredictionSelected) {
      yield* _mapPredictionSelectedToState(event: event);
    } else if (event is NameChanged) {
      yield* _mapNameChangedToState(event: event);
    } else if (event is WebsiteChanged) {
      yield* _mapWebsiteChangedToState(event: event);
    } else if (event is PhoneChanged) {
      yield* _mapPhoneChangedToState(event: event);
    } else if (event is DescriptionChanged) {
      yield* _mapDescriptionChangedToState(event: event);
    } else if (event is Submitted) {
      yield* _mapSubmittedToState(event: event);
    } else if (event is Updated) {
      yield* _mapUpdatedToState(event: event);
    } else if (event is Reset) {
      yield* _mapResetToState();
    }
  }

  Stream<ProfileScreenState> _mapPlaceQueryChangedToState({required PlaceQueryChanged event}) async* {
    if (event.query.length >= 3) {
      yield state.update(isSubmitting: true, errorMessage: "");
      
      final PlacesAutocompleteResponse response = await _places.autocomplete(
        event.query,
        types: ['establishment'],
      );

      if (response.isOkay) {
        yield state.update(isSubmitting: false, predictions: response.predictions);
      } else {
        yield state.update(isSubmitting: false, errorMessage: response.errorMessage);
      }
    }
  }

  Stream<ProfileScreenState> _mapPredictionSelectedToState({required PredictionSelected event}) async* {
    if (event.prediction.placeId != null) {
      yield state.update(isSubmitting: true, predictions: []);
      final PlacesDetailsResponse response = await _places.getDetailsByPlaceId(event.prediction.placeId!);
      yield state.update(isSubmitting: false, selectedPrediction: response.result); 
    }
  }
  
  Stream<ProfileScreenState> _mapNameChangedToState({required NameChanged event}) async* {
    yield state.update(isNameValid: Validators.isValidBusinessName(name: event.name));
  }

  Stream<ProfileScreenState> _mapWebsiteChangedToState({required WebsiteChanged event}) async* {
    yield state.update(isWebsiteValid: Validators.isValidUrl(url: _setWebsite(originalWebsite: event.website)));
  }

  Stream<ProfileScreenState> _mapPhoneChangedToState({required PhoneChanged event}) async* {
    yield state.update(isPhoneValid: Validators.isValidPhone(phone: event.phone));
  }

  Stream<ProfileScreenState> _mapDescriptionChangedToState({required DescriptionChanged event}) async* {
    yield state.update(isDescriptionValid: Validators.isValidBusinessDescription(description: event.description));
  }

  Stream<ProfileScreenState> _mapSubmittedToState({required Submitted event}) async* {
    yield state.update(isSubmitting: true);

    try {
      Profile profile = await _profileRepository.store(
        name: event.name,
        website: event.website,
        description: event.description,
        phone: event.phone,
      );
      _updateBusinessBloc(profile: profile);
      yield state.update(isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.STOP);
    } on ApiException catch (exception) {
      yield state.update(isSubmitting: false, errorMessage: exception.error, errorButtonControl: CustomAnimationControl.PLAY_FROM_START);
    }
  }

  Stream<ProfileScreenState> _mapUpdatedToState({required Updated event}) async* {
    yield state.update(isSubmitting: true);

    try {
      Profile profile = await _profileRepository.update(
        name: event.name,
        website: event.website,
        description: event.description,
        phone: event.phone,
        identifier: event.id
      );
      _updateBusinessBloc(profile: profile);
      yield state.update(isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.STOP);
    } on ApiException catch (exception) {
      yield state.update(isSubmitting: false, errorMessage: exception.error, errorButtonControl: CustomAnimationControl.PLAY_FROM_START);
    }
  }

  Stream<ProfileScreenState> _mapResetToState() async* {
    print('tada');
    yield state.update(isSuccess: false, errorMessage: "", errorButtonControl: CustomAnimationControl.STOP);
  }

  String _setWebsite({required String originalWebsite}) {
    return 'http://www.$originalWebsite';
  }

  void _updateBusinessBloc({required Profile profile}) {
    if (state.selectedPrediction != null && state.selectedPrediction!.geometry != null) {
      _businessBloc.add(ProfileUpdated(profile: profile));
      _businessBloc.add(LocationUpdated(location: Business.Location(
          identifier: "", 
          lat: state.selectedPrediction!.geometry!.location.lat, 
          lng: state.selectedPrediction!.geometry!.location.lng, 
          radius: 50
      )));
      _businessBloc.add(BusinessAccountUpdated(businessAccount: BusinessAccount.fromMaps(details: state.selectedPrediction!)));
      _businessBloc.add(BankAccountUpdated(bankAccount: BankAccount.empty()));
    } else {
      _businessBloc.add(ProfileUpdated(profile: profile));
    }
  }
}
