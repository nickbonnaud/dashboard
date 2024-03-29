import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/models/business/business.dart';
import 'package:dashboard/models/business/profile.dart';
import 'package:dashboard/repositories/google_places_repository.dart';
import 'package:dashboard/repositories/profile_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/profile_screen/bloc/profile_screen_bloc.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simple_animations/simple_animations.dart';

import '../../../helpers/mock_data_generator.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}
class MockBusinessBloc extends Mock implements BusinessBloc {}
class MockGooglePlacesRepository extends Mock implements GooglePlacesRepository {}
class MockPrediction extends Mock implements Prediction {}
class MockProfile extends Mock implements Profile {}
class MockBusinessEvent extends Mock implements BusinessEvent {}

void main() {
  group("Profile Screen Bloc Tests", () {
    late ProfileRepository profileRepository;
    late BusinessBloc businessBloc;
    late GooglePlacesRepository places;
    late ProfileScreenBloc profileScreenBloc;
    late Business business;
    late Profile profile;

    late ProfileScreenState _baseState;
    late List<Prediction> _predictions;
    late PlaceDetails _selectedPrediction;

    setUp(() {
      business = MockDataGenerator().createBusiness();
      profile = business.profile;

      profileRepository = MockProfileRepository();
      businessBloc = MockBusinessBloc();
      when(() => businessBloc.business).thenReturn(business);
      places = MockGooglePlacesRepository();
      profileScreenBloc = ProfileScreenBloc(
        profileRepository: profileRepository,
        businessBloc: businessBloc,
        places: places
      );
      
      
      _baseState = profileScreenBloc.state;

      registerFallbackValue(MockBusinessEvent());
    });

    tearDown(() {
      profileScreenBloc.close();
    });

    test("Initial state of ProfileScreenBloc is ProfileScreenState.empty()", () {
      expect(profileScreenBloc.state, ProfileScreenState.empty(profile: profile));
    });

    blocTest<ProfileScreenBloc, ProfileScreenState>(
      "PlaceQueryChanged event changes state: [isSubmitting: true], [isSubmitting: false, predictions: response.predictions]",
      build: () => profileScreenBloc,
      wait: const Duration(seconds: 1),
      act: (bloc) {

        when(() => places.autoComplete(query: any(named: 'query'))).thenAnswer((_) async {
          _predictions = [Prediction(), Prediction()];
          return PlacesAutocompleteResponse(
            status: "OK",
            predictions: _predictions,
          );
        });
        bloc.add(const PlaceQueryChanged(query: "query"));
      },
      expect: () => [_baseState.update(placeQuery: "query", isSubmitting: true), _baseState.update(placeQuery: "query", isSubmitting: false, predictions: _predictions)]
    );

    blocTest<ProfileScreenBloc, ProfileScreenState>(
      "PlaceQueryChanged event calls _places.autocomplete()",
      build: () => profileScreenBloc,
      wait: const Duration(seconds: 1),
      act: (bloc) {
        when(() => places.autoComplete(query: any(named: 'query'))).thenAnswer((_) async {
          _predictions = [Prediction(), Prediction()];
          return PlacesAutocompleteResponse(
            status: "OK",
            predictions: _predictions
          );
        });
        bloc.add(const PlaceQueryChanged(query: "query"));
      },
      verify: (_) {
        verify(() => places.autoComplete(query: any(named: 'query'))).called(1);
      }
    );
    
    blocTest<ProfileScreenBloc, ProfileScreenState>(
      "PlaceQueryChanged event on error changes state: [isSubmitting: true], [isSubmitting: false, selectedPrediction is empty]",
      build: () => profileScreenBloc,
      wait: const Duration(seconds: 1),
      act: (bloc) {
        when(() => places.autoComplete(query: any(named: 'query'))).thenAnswer((_) async {
          return PlacesAutocompleteResponse(
            status: "REQUEST_DENIED",
            predictions: [],
            errorMessage: "error"
          );
        });
        bloc.add(const PlaceQueryChanged(query: "query"));
      },
      expect: () => [isA<ProfileScreenState>(), isA<ProfileScreenState>()],
      verify: (_) {
        profileScreenBloc.state.selectedPrediction != null && profileScreenBloc.state.selectedPrediction!.name.isEmpty && profileScreenBloc.state.selectedPrediction!.placeId.isEmpty;
      }
    );

    blocTest<ProfileScreenBloc, ProfileScreenState>(
      "PredictionSelected event changes state: [isSubmitting: true, predictions: []], [isSubmitting: false, selectedPrediction: response.result]",
      build: () => profileScreenBloc,
      act: (bloc) {
        Prediction selectedPrediction = MockPrediction();
        when(() => selectedPrediction.placeId).thenReturn(faker.guid.guid());
        when(() => places.details(placeId: any(named: 'placeId'))).thenAnswer((_) async {
          _selectedPrediction = PlaceDetails(adrAddress: "adrAddress", name: "fake name", website: 'fake.com', formattedPhoneNumber: "111-222-3333", placeId: "placeId", utcOffset: 1);
          return PlacesDetailsResponse(
            htmlAttributions: [],
            result: _selectedPrediction,
            status: "OK"
          );
        });
        bloc.add(PredictionSelected(prediction: selectedPrediction));
      },
      expect: () => [
        _baseState.update(isSubmitting: true, predictions: []),
        _baseState.update(isSubmitting: false, selectedPrediction: _selectedPrediction, name: _selectedPrediction.name, website: _selectedPrediction.website, phone: _selectedPrediction.formattedPhoneNumber)
      ]
    );

    blocTest<ProfileScreenBloc, ProfileScreenState>(
      "PredictionSelected event calls places.getDetailsByPlaceId()",
      build: () => profileScreenBloc,
      act: (bloc) {
        Prediction selectedPrediction = MockPrediction();
        when(() => selectedPrediction.placeId).thenReturn(faker.guid.guid());
        when(() => places.details(placeId: any(named: 'placeId'))).thenAnswer((_) async {
          _selectedPrediction = PlaceDetails(adrAddress: "adrAddress", name: "name", placeId: "placeId", utcOffset: 1);
          return PlacesDetailsResponse(
            htmlAttributions: [],
            result: _selectedPrediction,
            status: "OK"
          );
        });
        bloc.add(PredictionSelected(prediction: selectedPrediction));
      },
      verify: (_) {
        verify(() => places.details(placeId: any(named: 'placeId'))).called(1);
      }
    );

    blocTest<ProfileScreenBloc, ProfileScreenState>(
      "NameChanged event changes state: [isNameValid: false]", 
      build: () => profileScreenBloc,
      wait: const Duration(milliseconds: 300),
      act: (bloc) => bloc.add(const NameChanged(name: "a")),
      expect: () => [_baseState.update(isNameValid: false, name: "a")]
    );

    blocTest<ProfileScreenBloc, ProfileScreenState>(
      "WebsiteChanged event changes state: [isWebsiteValid: false]", 
      build: () => profileScreenBloc,
      wait: const Duration(milliseconds: 300),
      act: (bloc) => bloc.add(const WebsiteChanged(website: "not&!wbe/")),
      expect: () => [_baseState.update(isWebsiteValid: false, website: "not&!wbe/")]
    );

    blocTest<ProfileScreenBloc, ProfileScreenState>(
      "PhoneChanged event changes state: [isPhoneValid: false]", 
      build: () => profileScreenBloc,
      wait: const Duration(milliseconds: 300),
      act: (bloc) => bloc.add(const PhoneChanged(phone: "wrong&222-s")),
      expect: () => [_baseState.update(isPhoneValid: false, phone: "wrong&222-s")]
    );

    blocTest<ProfileScreenBloc, ProfileScreenState>(
      "DescriptionChanged event changes state: [isDescriptionValid: false]", 
      build: () => profileScreenBloc,
      wait: const Duration(milliseconds: 300),
      act: (bloc) => bloc.add(const DescriptionChanged(description: "not long enough")),
      expect: () => [_baseState.update(isDescriptionValid: false, description: "not long enough")]
    );

    blocTest<ProfileScreenBloc, ProfileScreenState>(
      "Submitted event changes state: [isSubmitting: true], [isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.STOP]",
      build: () => profileScreenBloc,
      act: (bloc) {
        when(() => profileRepository.store(name: any(named: "name"), website: any(named: "website"), description: any(named: "description"), phone: any(named: "phone")))
          .thenAnswer((_) async => MockProfile());
        when(() => businessBloc.add(any(that: isA<BusinessEvent>()))).thenReturn(null);
        bloc.add(Submitted());
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.stop)]
    );

    blocTest<ProfileScreenBloc, ProfileScreenState>(
      "Submitted event calls profileRepository.store()",
      build: () => profileScreenBloc,
      act: (bloc) {
        when(() => profileRepository.store(name: any(named: "name"), website: any(named: "website"), description: any(named: "description"), phone: any(named: "phone")))
          .thenAnswer((_) async => MockProfile());
        when(() => businessBloc.add(any(that: isA<BusinessEvent>()))).thenReturn(null);
        bloc.add(Submitted());
      },
      verify: (_) {
        verify(() => profileRepository.store(name: any(named: "name"), website: any(named: "website"), description: any(named: "description"), phone: any(named: "phone"))).called(1);
      }
    );

    blocTest<ProfileScreenBloc, ProfileScreenState>(
      "Submitted event calls businessBloc.add() 4 times if state.selectedPrediction != null && state.selectedPrediction!.geometry != null",
      build: () => profileScreenBloc,
      seed: () => _baseState.update(selectedPrediction: PlaceDetails(
        adrAddress: "adrAddress",
        name: "name",
        placeId: "placeId",
        utcOffset: 1,
        geometry: Geometry(location: Location(lat: 1.0, lng: 1.0))
      )),
      act: (bloc) {
        when(() => profileRepository.store(name: any(named: "name"), website: any(named: "website"), description: any(named: "description"), phone: any(named: "phone")))
          .thenAnswer((_) async => MockProfile());
        when(() => businessBloc.add(any(that: isA<BusinessEvent>()))).thenReturn(null);
        bloc.add(Submitted());
      },
      verify: (_) {
        verify(() => businessBloc.add(any(that: isA<BusinessEvent>()))).called(4);
      }
    );

    blocTest<ProfileScreenBloc, ProfileScreenState>(
      "Submitted event calls businessBloc.add() 1 time if state.selectedPrediction == null",
      build: () => profileScreenBloc,
      act: (bloc) {
        when(() => profileRepository.store(name: any(named: "name"), website: any(named: "website"), description: any(named: "description"), phone: any(named: "phone")))
          .thenAnswer((_) async => MockProfile());
        when(() => businessBloc.add(any(that: isA<BusinessEvent>()))).thenReturn(null);
        bloc.add(Submitted());
      },
      verify: (_) {
        verify(() => businessBloc.add(any(that: isA<BusinessEvent>()))).called(1);
      }
    );

    blocTest<ProfileScreenBloc, ProfileScreenState>(
      "Submitted event on error changes state: [isSubmitting: true], [isSubmitting: false, errorMessage: exception.error, errorButtonControl: CustomAnimationControl.PLAY_FROM_START]",
      build: () => profileScreenBloc,
      act: (bloc) {
        when(() => profileRepository.store(name: any(named: "name"), website: any(named: "website"), description: any(named: "description"), phone: any(named: "phone")))
          .thenThrow(const ApiException(error: "error"));
        bloc.add(Submitted());
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, errorMessage: "error", errorButtonControl: CustomAnimationControl.playFromStart)]
    );

    blocTest<ProfileScreenBloc, ProfileScreenState>(
      "Updated event changes state: [isSubmitting: true], [isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.STOP]",
      build: () => profileScreenBloc,
      act: (bloc) {
        when(() => profileRepository.update(identifier: any(named: "identifier"), name: any(named: "name"), website: any(named: "website"), description: any(named: "description"), phone: any(named: "phone")))
          .thenAnswer((_) async => MockProfile());
        when(() => businessBloc.add(any(that: isA<BusinessEvent>()))).thenReturn(null);
        bloc.add(Updated());
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.stop)]
    );

    blocTest<ProfileScreenBloc, ProfileScreenState>(
      "Updated event calls profileRepository.update()",
      build: () => profileScreenBloc,
      act: (bloc) {
        when(() => profileRepository.update(identifier: any(named: "identifier"), name: any(named: "name"), website: any(named: "website"), description: any(named: "description"), phone: any(named: "phone")))
          .thenAnswer((_) async => MockProfile());
        when(() => businessBloc.add(any(that: isA<BusinessEvent>()))).thenReturn(null);
        bloc.add(Updated());
      },
      verify: (_) {
        verify(() => profileRepository.update(identifier: any(named: "identifier"), name: any(named: "name"), website: any(named: "website"), description: any(named: "description"), phone: any(named: "phone"))).called(1);
      }
    );

    blocTest<ProfileScreenBloc, ProfileScreenState>(
      "Updated event calls businessBloc.add() 4 times if state.selectedPrediction != null && state.selectedPrediction!.geometry != null",
      build: () => profileScreenBloc,
      seed: () => _baseState.update(selectedPrediction: PlaceDetails(
        adrAddress: "adrAddress",
        name: "name",
        placeId: "placeId",
        utcOffset: 1,
        geometry: Geometry(location: Location(lat: 1.0, lng: 1.0))
      )),
      act: (bloc) {
        when(() => profileRepository.update(identifier: any(named: "identifier"), name: any(named: "name"), website: any(named: "website"), description: any(named: "description"), phone: any(named: "phone")))
          .thenAnswer((_) async => MockProfile());
        when(() => businessBloc.add(any(that: isA<BusinessEvent>()))).thenReturn(null);
        bloc.add(Updated());
      },
      verify: (_) {
        verify(() => businessBloc.add(any(that: isA<BusinessEvent>()))).called(4);
      }
    );

    blocTest<ProfileScreenBloc, ProfileScreenState>(
      "Updated event calls businessBloc.add() 1 time if state.selectedPrediction != null && state.selectedPrediction!.geometry != null",
      build: () => profileScreenBloc,
      act: (bloc) {
        when(() => profileRepository.update(identifier: any(named: "identifier"), name: any(named: "name"), website: any(named: "website"), description: any(named: "description"), phone: any(named: "phone")))
          .thenAnswer((_) async => MockProfile());
        when(() => businessBloc.add(any(that: isA<BusinessEvent>()))).thenReturn(null);
        bloc.add(Updated());
      },
      verify: (_) {
        verify(() => businessBloc.add(any(that: isA<BusinessEvent>()))).called(1);
      }
    );

    blocTest<ProfileScreenBloc, ProfileScreenState>(
      "Updated event on error changes state: [isSubmitting: true], [isSubmitting: false, errorMessage: exception.error, errorButtonControl: CustomAnimationControl.PLAY_FROM_START]",
      build: () => profileScreenBloc,
      act: (bloc) {
        when(() => profileRepository.update(identifier: any(named: "identifier"), name: any(named: "name"), website: any(named: "website"), description: any(named: "description"), phone: any(named: "phone")))
          .thenThrow(const ApiException(error: "error"));
        when(() => businessBloc.add(any(that: isA<BusinessEvent>()))).thenReturn(null);
        bloc.add(Updated());
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, errorMessage: "error", errorButtonControl: CustomAnimationControl.playFromStart)]
    );

    blocTest<ProfileScreenBloc, ProfileScreenState>(
      "Reset event changes state: [isSuccess: false, errorMessage: "", errorButtonControl: CustomAnimationControl.STOP]",
      build: () => profileScreenBloc,
      seed: () => _baseState.update(isSuccess: true, errorMessage: "error", errorButtonControl: CustomAnimationControl.playFromStart),
      act: (bloc) => bloc.add(Reset()),
      expect: () => [_baseState.update(isSuccess: false, errorMessage: "", errorButtonControl: CustomAnimationControl.stop)]
    );
  });
}