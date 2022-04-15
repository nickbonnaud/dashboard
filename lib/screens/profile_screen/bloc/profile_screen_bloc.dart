import 'package:bloc/bloc.dart';
import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/models/business/bank_account.dart';
import 'package:dashboard/models/business/business_account.dart';
import 'package:dashboard/models/business/location.dart' as business;
import 'package:dashboard/models/business/profile.dart';
import 'package:dashboard/repositories/profile_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/resources/helpers/debouncer.dart';
import 'package:dashboard/resources/helpers/validators.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:meta/meta.dart';
import 'package:simple_animations/simple_animations.dart';

part 'profile_screen_event.dart';
part 'profile_screen_state.dart';

class ProfileScreenBloc extends Bloc<ProfileScreenEvent, ProfileScreenState> {
  final ProfileRepository _profileRepository;
  final BusinessBloc _businessBloc;
  final GoogleMapsPlaces _places;

  final Duration _debounceTime = const Duration(milliseconds: 300);

  ProfileScreenBloc({
    required ProfileRepository profileRepository, 
    required BusinessBloc businessBloc,
    required GoogleMapsPlaces places
  })
    : _profileRepository = profileRepository,
      _businessBloc = businessBloc,
      _places = places,
      super(ProfileScreenState.empty(profile: businessBloc.business.profile)) { _eventHandler(); }

  void _eventHandler() {
    on<PlaceQueryChanged>((event, emit) async => await _mapPlaceQueryChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: const Duration(seconds: 1)));
    on<PredictionSelected>((event, emit) async => await _mapPredictionSelectedToState(event: event, emit: emit));
    on<NameChanged>((event, emit) => _mapNameChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<WebsiteChanged>((event, emit) => _mapWebsiteChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<PhoneChanged>((event, emit) => _mapPhoneChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<DescriptionChanged>((event, emit) => _mapDescriptionChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<Submitted>((event, emit) async => await _mapSubmittedToState(event: event, emit: emit));
    on<Updated>((event, emit) async => await _mapUpdatedToState(event: event, emit: emit));
    on<Reset>((event, emit) => _mapResetToState(emit: emit));
  }

  Future<void> _mapPlaceQueryChangedToState({required PlaceQueryChanged event, required Emitter<ProfileScreenState> emit}) async {
    if (event.query.length >= 3) {
      emit(state.update(isSubmitting: true, errorMessage: ""));
      
      final PlacesAutocompleteResponse response = await _places.autocomplete(
        event.query,
        types: ['establishment'],
      );

      if (response.isOkay) {
        emit(state.update(isSubmitting: false, predictions: response.predictions));
      } else {
        emit(state.update(isSubmitting: false, errorMessage: response.errorMessage));
      }
    }
  }

  Future<void> _mapPredictionSelectedToState({required PredictionSelected event, required Emitter<ProfileScreenState> emit}) async {
    if (event.prediction.placeId != null) {
      emit(state.update(isSubmitting: true, predictions: []));
      final PlacesDetailsResponse response = await _places.getDetailsByPlaceId(event.prediction.placeId!);
      emit(state.update(
        isSubmitting: false,
        selectedPrediction: response.result,
        name: response.result.name,
        website: response.result.website ?? "",
        phone: response.result.formattedPhoneNumber ?? ""
      )); 
    }
  }
  
  void _mapNameChangedToState({required NameChanged event, required Emitter<ProfileScreenState> emit}) {
    emit(state.update(name: event.name, isNameValid: Validators.isValidBusinessName(name: event.name)));
  }

  void _mapWebsiteChangedToState({required WebsiteChanged event, required Emitter<ProfileScreenState> emit}) {
    emit(state.update(website: event.website, isWebsiteValid: Validators.isValidUrl(url: _setWebsite(originalWebsite: event.website))));
  }

  void _mapPhoneChangedToState({required PhoneChanged event, required Emitter<ProfileScreenState> emit}) {
    emit(state.update(phone: event.phone, isPhoneValid: Validators.isValidPhone(phone: event.phone)));
  }

  void _mapDescriptionChangedToState({required DescriptionChanged event, required Emitter<ProfileScreenState> emit}) {
    emit(state.update(description: event.description, isDescriptionValid: Validators.isValidBusinessDescription(description: event.description)));
  }

  Future<void> _mapSubmittedToState({required Submitted event, required Emitter<ProfileScreenState> emit}) async {
    emit(state.update(isSubmitting: true));

    try {
      Profile profile = await _profileRepository.store(
        name: state.name,
        website: state.website,
        description: state.description,
        phone: state.phone,
      );
      _updateBusinessBloc(profile: profile);
      emit(state.update(isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.stop));
    } on ApiException catch (exception) {
      emit(state.update(isSubmitting: false, errorMessage: exception.error, errorButtonControl: CustomAnimationControl.playFromStart));
    }
  }

  Future<void> _mapUpdatedToState({required Updated event, required Emitter<ProfileScreenState> emit}) async {
    emit(state.update(isSubmitting: true));

    try {
      Profile profile = await _profileRepository.update(
        name: state.name,
        website: state.website,
        description: state.description,
        phone: state.phone,
        identifier: _businessBloc.business.profile.identifier
      );
      _updateBusinessBloc(profile: profile);
      emit(state.update(isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.stop));
    } on ApiException catch (exception) {
      emit(state.update(isSubmitting: false, errorMessage: exception.error, errorButtonControl: CustomAnimationControl.playFromStart));
    }
  }

  void _mapResetToState({required Emitter<ProfileScreenState> emit}) {
    emit(state.update(isSuccess: false, errorMessage: "", errorButtonControl: CustomAnimationControl.stop));
  }

  String _setWebsite({required String originalWebsite}) {
    return 'http://www.$originalWebsite';
  }

  void _updateBusinessBloc({required Profile profile}) {
    if (state.selectedPrediction != null && state.selectedPrediction!.geometry != null) {
      _businessBloc.add(ProfileUpdated(profile: profile));
      _businessBloc.add(LocationUpdated(location: business.Location(
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
