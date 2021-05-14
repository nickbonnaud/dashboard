import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/models/business/location.dart';
import 'package:dashboard/repositories/geo_account_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/geo_account_screen/bloc/geo_account_screen_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simple_animations/simple_animations.dart';

class MockGeoAccountRepository extends Mock implements GeoAccountRepository {}
class MockBusinessBloc extends Mock implements BusinessBloc {}
class MockLocation extends Mock implements Location {}

void main() {
  group("Geo Account Screen Bloc Tests", () {
    late GeoAccountRepository geoAccountRepository;
    late BusinessBloc businessBloc;
    late GeoAccountScreenBloc geoAccountScreenBloc;
    late Location location;

    late GeoAccountScreenState baseState;

    setUp(() {
      geoAccountRepository = MockGeoAccountRepository();
      businessBloc = MockBusinessBloc();
      location = Location(identifier: "identifier", lat: 35.927560, lng: -79.035534, radius: 50);
      geoAccountScreenBloc = GeoAccountScreenBloc(
        accountRepository: geoAccountRepository,
        businessBloc: businessBloc,
        location: location
      );

      baseState = GeoAccountScreenState.initial(location: location);
      registerFallbackValue<BusinessEvent>(LocationUpdated(location: location));
    });

    tearDown(() {
      geoAccountScreenBloc.close();
    });

    test("Initial state of GeoAccountScreenBloc is GeoAccountScreenState.initial()", () {
      expect(geoAccountScreenBloc.state, GeoAccountScreenState.initial(location: location));
    });

    blocTest<GeoAccountScreenBloc, GeoAccountScreenState>(
      "LocationChanged event changes state: [currentLocation]",
      build: () => geoAccountScreenBloc,
      act: (bloc) => bloc.add(LocationChanged(location: LatLng(40.0, -70.0))),
      expect: () => [baseState.update(currentLocation: LatLng(40.0, -70.0))]
    );

    blocTest<GeoAccountScreenBloc, GeoAccountScreenState>(
      "RadiusChanged event changes state: [radius]",
      build: () => geoAccountScreenBloc,
      act: (bloc) => bloc.add(RadiusChanged(radius: 25)),
      expect: () => [baseState.update(radius: 25)]
    );

    blocTest<GeoAccountScreenBloc, GeoAccountScreenState>(
      "Submitted event changes state: [isSubmitting: true], [isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.STOP]",
      build: () => geoAccountScreenBloc,
      act: (bloc) {
        when(() => geoAccountRepository.store(lat: location.lat, lng: location.lng, radius: location.radius))
          .thenAnswer((_) async =>  MockLocation());
        when(() => businessBloc.add(any(that: isA<BusinessEvent>()))).thenReturn(null);
        bloc.add(Submitted());
      },
      expect: () => [baseState.update(isSubmitting: true), baseState.update(isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.STOP)]
    );

    blocTest<GeoAccountScreenBloc, GeoAccountScreenState>(
      "Bloc transforms radius to int and nearest 5",
      build: () => geoAccountScreenBloc,
      seed: () => baseState.update(radius: 42.4),
      act: (bloc) {
        when(() => geoAccountRepository.store(lat: location.lat, lng: location.lng, radius: 40))
          .thenAnswer((_) async =>  MockLocation());
        when(() => businessBloc.add(any(that: isA<BusinessEvent>()))).thenReturn(null);
        bloc.add(Submitted());
      },
      verify: (_) {
        verify(() => geoAccountRepository.store(lat: location.lat, lng: location.lng, radius: 40)).called(1);
      }
    );

    blocTest<GeoAccountScreenBloc, GeoAccountScreenState>(
      "Submitted event calls GeoAccountRepository.store()",
      build: () => geoAccountScreenBloc,
      act: (bloc) {
        when(() => geoAccountRepository.store(lat: location.lat, lng: location.lng, radius: location.radius))
          .thenAnswer((_) async =>  MockLocation());
        when(() => businessBloc.add(any(that: isA<BusinessEvent>()))).thenReturn(null);
        bloc.add(Submitted());
      },
      verify: (_) {
        verify(() => geoAccountRepository.store(lat: location.lat, lng: location.lng, radius: location.radius)).called(1);
      }
    );

    blocTest<GeoAccountScreenBloc, GeoAccountScreenState>(
      "Submitted event calls BusinessBloc.add()",
      build: () => geoAccountScreenBloc,
      act: (bloc) {
        when(() => geoAccountRepository.store(lat: location.lat, lng: location.lng, radius: location.radius))
          .thenAnswer((_) async =>  MockLocation());
        when(() => businessBloc.add(any(that: isA<BusinessEvent>()))).thenReturn(null);
        bloc.add(Submitted());
      },
      verify: (_) {
        verify(() => businessBloc.add(any(that: isA<LocationUpdated>()))).called(1);
      }
    );

    blocTest<GeoAccountScreenBloc, GeoAccountScreenState>(
      "Submitted event on error changes state: [isSubmitting: true], [isSubmitting: false, isFailure: true, errorMessage: exception.error, errorButtonControl: CustomAnimationControl.PLAY_FROM_START]",
      build: () => geoAccountScreenBloc,
      act: (bloc) {
        when(() => geoAccountRepository.store(lat: location.lat, lng: location.lng, radius: location.radius))
          .thenThrow(ApiException(error: "error"));
        when(() => businessBloc.add(any(that: isA<BusinessEvent>()))).thenReturn(null);
        bloc.add(Submitted());
      },
      expect: () => [baseState.update(isSubmitting: true), baseState.update(isSubmitting: false, isFailure: true, errorMessage: 'error', errorButtonControl: CustomAnimationControl.PLAY_FROM_START)]
    );

    blocTest<GeoAccountScreenBloc, GeoAccountScreenState>(
      "Updated event changes state: [isSubmitting: true], [isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.STOP]",
      build: () => geoAccountScreenBloc,
      act: (bloc) {
        when(() => geoAccountRepository.update(identifier: 'identifier', lat: location.lat, lng: location.lng, radius: location.radius))
          .thenAnswer((_) async =>  MockLocation());
        when(() => businessBloc.add(any(that: isA<BusinessEvent>()))).thenReturn(null);
        bloc.add(Updated(identifier: 'identifier'));
      },
      expect: () => [baseState.update(isSubmitting: true), baseState.update(isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.STOP)]
    );
    
    blocTest<GeoAccountScreenBloc, GeoAccountScreenState>(
      "Updated event calls geoAccountRepository.update()",
      build: () => geoAccountScreenBloc,
      act: (bloc) {
        when(() => geoAccountRepository.update(identifier: 'identifier', lat: location.lat, lng: location.lng, radius: location.radius))
          .thenAnswer((_) async =>  MockLocation());
        when(() => businessBloc.add(any(that: isA<BusinessEvent>()))).thenReturn(null);
        bloc.add(Updated(identifier: 'identifier'));
      },
      verify: (_) {
        verify(() => geoAccountRepository.update(identifier: 'identifier', lat: location.lat, lng: location.lng, radius: location.radius)).called(1);
      }
    );

    blocTest<GeoAccountScreenBloc, GeoAccountScreenState>(
      "Updated event calls BusinessBloc.add()",
      build: () => geoAccountScreenBloc,
      act: (bloc) {
        when(() => geoAccountRepository.update(identifier: 'identifier', lat: location.lat, lng: location.lng, radius: location.radius))
          .thenAnswer((_) async =>  MockLocation());
        when(() => businessBloc.add(any(that: isA<BusinessEvent>()))).thenReturn(null);
        bloc.add(Updated(identifier: 'identifier'));
      },
      verify: (_) {
        verify(() => businessBloc.add(any(that: isA<LocationUpdated>()))).called(1);
      }
    );
    
    blocTest<GeoAccountScreenBloc, GeoAccountScreenState>(
      "Updated event on error changes state: [isSubmitting: true], [isSubmitting: false, isFailure: true, errorMessage: exception.error, errorButtonControl: CustomAnimationControl.PLAY_FROM_START]",
      build: () => geoAccountScreenBloc,
      act: (bloc) {
        when(() => geoAccountRepository.update(identifier: 'identifier', lat: location.lat, lng: location.lng, radius: location.radius))
          .thenThrow(ApiException(error: "error"));
        when(() => businessBloc.add(any(that: isA<BusinessEvent>()))).thenReturn(null);
        bloc.add(Updated(identifier: 'identifier'));
      },
      expect: () => [baseState.update(isSubmitting: true), baseState.update(isSubmitting: false, isFailure: true, errorMessage: "error", errorButtonControl: CustomAnimationControl.PLAY_FROM_START)]
    );

    blocTest<GeoAccountScreenBloc, GeoAccountScreenState>(
      "Reset event changes state: [isSuccess: false, isFailure: false, errorMessage: "", errorButtonControl: CustomAnimationControl.STOP]",
      build: () => geoAccountScreenBloc,
      act: (bloc) => bloc.add(Reset()),
      expect: () => [baseState.update(isSuccess: false, isFailure: false, errorMessage: "", errorButtonControl: CustomAnimationControl.STOP)]
    );
  });
}