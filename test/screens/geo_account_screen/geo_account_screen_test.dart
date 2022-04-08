import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/global_widgets/app_bars/default_app_bar.dart';
import 'package:dashboard/models/business/location.dart';
import 'package:dashboard/repositories/geo_account_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/geo_account_screen/geo_account_screen.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/screen_builder.dart';

class MockGeoAccountRepository extends Mock implements GeoAccountRepository {}
class MockBusinessBloc extends Mock implements BusinessBloc {}

void main() {
  group("Geo Account Screen Tests", () {
    late NavigatorObserver observer;
    late GeoAccountRepository geoAccountRepository;
    late BusinessBloc businessBloc;
    late Location location;
    late ScreenBuilder screenBuilderNew;
    late ScreenBuilder screenBuilderEdit;

    setUpAll(() {
      observer = MockNavigatorObserver();
      geoAccountRepository = MockGeoAccountRepository();
      businessBloc = MockBusinessBloc();
      location = Location(
        identifier: faker.guid.guid(),
        lat: 35.9132,
        lng: 79.0558,
        radius: 50
      );

      screenBuilderNew = ScreenBuilder(
        child: GeoAccountScreen(
          geoAccountRepository: geoAccountRepository,
          businessBloc: businessBloc,
          location: location,
          isEdit: false,
        ), 
        observer: observer
      );

      screenBuilderEdit = ScreenBuilder(
        child: GeoAccountScreen(
          geoAccountRepository: geoAccountRepository,
          businessBloc: businessBloc,
          location: location,
          isEdit: true,
        ), 
        observer: observer
      );

      when(() => geoAccountRepository.store(lat: any(named: "lat"), lng: any(named: "lng"), radius: any(named: "radius")))
        .thenAnswer((_) async=> Future.delayed(const Duration(milliseconds: 500), () => location));

      when(() => geoAccountRepository.update(identifier: any(named: "identifier"), lat: any(named: "lat"), lng: any(named: "lng"), radius: any(named: "radius")))
        .thenAnswer((_) async=> Future.delayed(const Duration(milliseconds: 500), () => location));

      registerFallbackValue(MockRoute());
    });
    
    testWidgets("New Geo Account Screen displays AppBar", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets("Edit Geo Account Screen displays AppBar", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      expect(find.byType(DefaultAppBar), findsOneWidget);
    });

    testWidgets("Geo Account Screen displays correct title", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      expect(find.text("Business Location & Geofence"), findsOneWidget);

      await screenBuilderNew.createScreen(tester: tester);
      expect(find.text("Please ensure location is correct and geofence encircles business."), findsOneWidget);
    });

    testWidgets("Geo Account Screen displays GoogleMap", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      expect(find.byType(GoogleMap), findsOneWidget);
    });

    testWidgets("Geo Account Screen creates a slider", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      expect(find.text("Geofence Size"), findsOneWidget);
      expect(find.byType(Slider), findsOneWidget);
    });

    testWidgets("Geo Account Screen slider can slide", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      expect(tester.widget<ElevatedButton>(find.byKey(const Key("submitButtonKey"))).enabled, false);
      await tester.drag(find.byKey(const Key("titleKey")), const Offset(0.0, -500));
      await tester.pump();
      await tester.drag(find.byType(Slider), const Offset(100, 0));
      await tester.pump();
      expect(tester.widget<ElevatedButton>(find.byKey(const Key("submitButtonKey"))).enabled, true);
    });

    testWidgets("Tapping submit button shows CircularProgressIndicator", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      await tester.drag(find.byKey(const Key("titleKey")), const Offset(0.0, -500));
      await tester.pump();
      
      await tester.tap(find.byKey(const Key("submitButtonKey")));
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump(const Duration(seconds: 4));
    });

    testWidgets("Tapping submit button shows toast on success", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      expect(find.text("Location Saved!"), findsNothing);
      await tester.drag(find.byKey(const Key("titleKey")), const Offset(0.0, -500));
      await tester.pump();
      
      await tester.tap(find.byKey(const Key("submitButtonKey")));
      await tester.pump(const Duration(seconds: 2));
      expect(find.text("Location Saved!"), findsOneWidget);
      await tester.pump(const Duration(seconds: 2));
    });

    testWidgets("Tapping submit button on success pops nav", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      await tester.drag(find.byKey(const Key("titleKey")), const Offset(0.0, -500));
      await tester.pump();
      
      await tester.tap(find.byKey(const Key("submitButtonKey")));
      await tester.pump(const Duration(seconds: 4));
      verify(() => observer.didPop(any(), any()));
    });

    testWidgets("Tapping submit button on error shows error message", (tester) async {
      when(() => geoAccountRepository.store(lat: any(named: "lat"), lng: any(named: "lng"), radius: any(named: "radius")))
        .thenThrow(const ApiException(error: "An Error Occurred!"));
      
      await screenBuilderNew.createScreen(tester: tester);
      expect(find.text("An Error Occurred!"), findsNothing);
      await tester.drag(find.byKey(const Key("titleKey")), const Offset(0.0, -500));
      await tester.pump();
      
      await tester.tap(find.byKey(const Key("submitButtonKey")));
      await tester.pumpAndSettle();
      expect(find.text("An Error Occurred!"), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));
      expect(find.text("An Error Occurred!"), findsNothing);
    });
  });
}