import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/global_widgets/app_bars/default_app_bar.dart';
import 'package:dashboard/models/business/profile.dart';
import 'package:dashboard/repositories/profile_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/profile_screen/profile_screen.dart';
import 'package:dashboard/screens/profile_screen/widgets/create_profile_screen_body/create_profile_screen_body.dart';
import 'package:dashboard/screens/profile_screen/widgets/create_profile_screen_body/widgets/body_form.dart';
import 'package:dashboard/screens/profile_screen/widgets/edit_profile_screen_body/edit_profile_screen_body.dart';
import 'package:dashboard/screens/profile_screen/widgets/place_form.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mock_data_generator.dart';
import '../../helpers/screen_builder.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}
class MockBusinessBloc extends Mock implements BusinessBloc {}
class MockGoogleMapsPlaces extends Mock implements GoogleMapsPlaces {}

void main() {
  group("Profile Screen Tests", () {
    late MockDataGenerator mockDataGenerator;
    late NavigatorObserver observer;
    late ProfileRepository profileRepository;
    late BusinessBloc businessBloc;
    late GoogleMapsPlaces places;
    late Profile profile;
    late ScreenBuilder screenBuilderNew;
    late ScreenBuilder screenBuilderEdit;

    setUp(() {
      mockDataGenerator = MockDataGenerator();
      observer = MockNavigatorObserver();
      profileRepository = MockProfileRepository();
      businessBloc = MockBusinessBloc();
      places = MockGoogleMapsPlaces();
      profile = mockDataGenerator.createProfile();

      screenBuilderNew = ScreenBuilder(
        child: ProfileScreen(profileRepository: profileRepository, profile: Profile.empty(), businessBloc: businessBloc, places: places),
        observer: observer
      );
      
      screenBuilderEdit = ScreenBuilder(
        child: ProfileScreen(profileRepository: profileRepository, profile: profile, businessBloc: businessBloc, places: places),
        observer: observer
      );

      when(() => places.autocomplete(any(that: isA<String>()), types: any(named: "types")))
        .thenAnswer((_) => Future.delayed(Duration(milliseconds: 500), () {
          return PlacesAutocompleteResponse(
            status: "OK",
            predictions: [Prediction(placeId: faker.guid.guid(), description: "first"), Prediction(placeId: faker.guid.guid(), description: "second")],
          );
        }));

      when(() => places.getDetailsByPlaceId(any(that: isA<String>())))
        .thenAnswer((_) async => Future.delayed(Duration(milliseconds: 500), () {
          return PlacesDetailsResponse(
            status: "OK", 
            result: PlaceDetails(
              adrAddress: "adrAddress",
              name: faker.company.name(),
              placeId: "placeId",
              utcOffset: 1,
              website: "www.${faker.lorem.word()}.com",
              formattedPhoneNumber: "9362963431"
            ), 
            htmlAttributions: []
          );
        }));

      when(() => profileRepository.update(name: any(named: "name"), website: any(named: "website"), description: any(named: "description"), phone: any(named: "phone"), identifier: any(named: "identifier")))
        .thenAnswer((_) => Future.delayed(Duration(milliseconds: 500), () => mockDataGenerator.createProfile()));

      when(() => profileRepository.store(name: any(named: "name"), website: any(named: "website"), description: any(named: "description"), phone: any(named: "phone")))
        .thenAnswer((_) => Future.delayed(Duration(milliseconds: 500), () => mockDataGenerator.createProfile()));

      registerFallbackValue<BusinessEvent>(ProfileUpdated(profile: mockDataGenerator.createProfile()));
      registerFallbackValue<Route>(MockRoute());

      when(() => businessBloc.add(any(that: isA<ProfileUpdated>()))).thenReturn(null);
    });

    testWidgets("New Profile Screen creates AppBar", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets("New Profile Screen creates CreateProfileScreenBody", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      expect(find.byType(CreateProfileScreenBody), findsOneWidget);
    });

    testWidgets("Initial title of CreateProfileScreenBody is First let's get your businesses name.", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      expect(find.text("First let's get your businesses name."), findsOneWidget);
    });

    testWidgets("CreateProfileScreenBody initial shows PlaceForm", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      expect(find.byType(PlaceForm), findsOneWidget);
    });

    testWidgets("PlaceForm creates placeNameField", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      expect(find.byKey(Key("placeNameFieldKey")), findsOneWidget);
    });

    testWidgets("Entering less than 3 characters in placeNameField does nothing", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      String businessName = "aw";
      await tester.enterText(find.byKey(Key("placeNameFieldKey")), businessName);
      await tester.pump(Duration(seconds: 1));
      verifyNever(() => places.autocomplete(any(that: isA<String>()), types: any(named: "types")));
    });

    testWidgets("Entering valid name in placeNameField calls places.autoComplete", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      String businessName = faker.company.name();
      await tester.enterText(find.byKey(Key("placeNameFieldKey")), businessName);
      await tester.pump(Duration(seconds: 1));
      verify(() => places.autocomplete(any(that: isA<String>()), types: any(named: "types"))).called(1);
      await tester.pump(Duration(milliseconds: 500));
    });

    testWidgets("Entering valid name in placeNameField shows CircularProgressIndicator", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      String businessName = faker.company.name();
      expect(find.byType(CircularProgressIndicator), findsNothing);
      await tester.enterText(find.byKey(Key("placeNameFieldKey")), businessName);
      await tester.pump(Duration(seconds: 1));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump(Duration(milliseconds: 500));
    });

    testWidgets("Entering valid name in placeNameField displays predictions", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      String businessName = faker.company.name();
      expect(find.byKey(Key("predictionsListKey")), findsNothing);
      await tester.enterText(find.byKey(Key("placeNameFieldKey")), businessName);
      await tester.pump(Duration(milliseconds: 1500));
      expect(find.byKey(Key("predictionsListKey")), findsOneWidget);
    });

    testWidgets("Selecting prediction calls places.getDetailsByPlaceId", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      String businessName = faker.company.name();
      await tester.enterText(find.byKey(Key("placeNameFieldKey")), businessName);
      await tester.pump(Duration(milliseconds: 1500));
      
      await tester.tap(find.byType(ListTile).first);
      await tester.pump();
      verify(() => places.getDetailsByPlaceId(any(that: isA<String>()))).called(1);
      await tester.pump(Duration(milliseconds: 500));
    });

    testWidgets("Selecting prediction shows CircularProgressIndicator", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      String businessName = faker.company.name();
      await tester.enterText(find.byKey(Key("placeNameFieldKey")), businessName);
      await tester.pump(Duration(milliseconds: 1500));
      
      expect(find.byType(CircularProgressIndicator), findsNothing);
      await tester.tap(find.byType(ListTile).first);
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump(Duration(milliseconds: 500));
    });

    testWidgets("Selecting prediction hides PlaceForm", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      expect(find.byType(PlaceForm), findsOneWidget);
      String businessName = faker.company.name();
      await tester.enterText(find.byKey(Key("placeNameFieldKey")), businessName);
      await tester.pump(Duration(milliseconds: 1500));
      
      await tester.tap(find.byType(ListTile).first);
      await tester.pump(Duration(milliseconds: 500));
      expect(find.byType(PlaceForm), findsNothing);
      expect(find.byType(BodyForm), findsOneWidget);
    });

    testWidgets("Edit Profile Screen creates DefaultAppBar", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      expect(find.byType(DefaultAppBar), findsOneWidget);
    });

    testWidgets("Edit Profile Screen creates EditProfileScreenBody", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      expect(find.byType(EditProfileScreenBody), findsOneWidget);
    });

    testWidgets("EditProfileScreenBody creates title", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      expect(find.text("Profile"), findsOneWidget);
    });

    testWidgets("EditProfileScreenBody creates BodyForm", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      expect(find.byType(BodyForm), findsOneWidget);
    });

    testWidgets("New Profile fills in textfields from google data", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      await tester.enterText(find.byKey(Key("placeNameFieldKey")), faker.company.name());
      await tester.pump(Duration(milliseconds: 1500));
      
      await tester.tap(find.byType(ListTile).first);
      await tester.pump(Duration(milliseconds: 500));
      
      expect(tester.widget<TextFormField>(find.byKey(Key("nameFieldKey"))).controller!.text.isNotEmpty, true);
      expect(tester.widget<TextFormField>(find.byKey(Key("websiteFieldKey"))).controller!.text.isNotEmpty, true);
      expect(tester.widget<TextFormField>(find.byKey(Key("phoneTextFieldKey"))).controller!.text.isNotEmpty, true);
      expect(tester.widget<TextFormField>(find.byKey(Key("descriptionTextKey"))).controller!.text.isNotEmpty, false);
    });

    testWidgets("Edit Profile fills in all textfields", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      
      expect(tester.widget<TextFormField>(find.byKey(Key("nameFieldKey"))).controller!.text.isNotEmpty, true);
      expect(tester.widget<TextFormField>(find.byKey(Key("websiteFieldKey"))).controller!.text.isNotEmpty, true);
      expect(tester.widget<TextFormField>(find.byKey(Key("phoneTextFieldKey"))).controller!.text.isNotEmpty, true);
      expect(tester.widget<TextFormField>(find.byKey(Key("descriptionTextKey"))).controller!.text.isNotEmpty, true);
    });

    testWidgets("NameTextField can receive text input", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      
      String name = faker.company.name();
      await tester.enterText(find.byKey(Key("nameFieldKey")), name);
      await tester.pump();
      expect(find.text(name), findsOneWidget);
    });

    testWidgets("NameTextField shows error on invalid input", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      
      expect(find.text('Invalid Business Name'), findsNothing);
      String name = "n";
      await tester.enterText(find.byKey(Key("nameFieldKey")), name);
      await tester.pump(Duration(milliseconds: 300));
      expect(find.text('Invalid Business Name'), findsOneWidget);
    });

    testWidgets("WebsiteTextField can receive text input", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      
      String website = "${faker.lorem.word()}.com";
      await tester.enterText(find.byKey(Key("websiteFieldKey")), website);
      await tester.pump();
      expect(find.text(website), findsOneWidget);
    });

    testWidgets("WebsiteTextField shows error on invalid input", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      
      expect(find.text('Invalid Website url'), findsNothing);
      String website = "not valid !";
      await tester.enterText(find.byKey(Key("websiteFieldKey")), website);
      await tester.pump(Duration(milliseconds: 300));
      expect(find.text('Invalid Website url'), findsOneWidget);
    });

    testWidgets("PhoneTextField can receive text input", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      
      String phone = "7347419654";
      await tester.enterText(find.byKey(Key("phoneTextFieldKey")), "");
      await tester.pump(Duration(milliseconds: 300));
      await tester.enterText(find.byKey(Key("phoneTextFieldKey")), phone);
      await tester.pump();
      expect(find.text("(734) 741-9654"), findsOneWidget);
    });

    testWidgets("PhoneTextField shows error on invalid input", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      
      expect(find.text("Invalid Phone Number"), findsNothing);
      String phone = "73*654";
      await tester.enterText(find.byKey(Key("phoneTextFieldKey")), phone);
      await tester.pump(Duration(milliseconds: 300));
      expect(find.text("Invalid Phone Number"), findsOneWidget);
    });

    testWidgets("DescriptionTextField can receive text input", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      
      String description = faker.lorem.sentences(4).join();
      await tester.enterText(find.byKey(Key("descriptionTextKey")), description);
      await tester.pump();
      expect(find.text(description), findsOneWidget);
    });

    testWidgets("DescriptionTextField shows error on invalid input", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      
      expect(find.text("Description must be longer"), findsNothing);
      String description = "a";
      await tester.enterText(find.byKey(Key("descriptionTextKey")), description);
      await tester.pump(Duration(milliseconds: 300));
      expect(find.text("Description must be longer"), findsOneWidget);
    });

    testWidgets("SubmitButton is disabled by default new Profile", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      await tester.enterText(find.byKey(Key("placeNameFieldKey")), faker.company.name());
      await tester.pump(Duration(milliseconds: 1500));
      
      await tester.tap(find.byType(ListTile).first);
      await tester.pump(Duration(milliseconds: 500));

      expect(tester.widget<ElevatedButton>(find.byKey(Key("submitButtonKey"))).enabled, false);
    });
    
    testWidgets("SubmitButton is disabled by default Edit Profile", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      
      expect(tester.widget<ElevatedButton>(find.byKey(Key("submitButtonKey"))).enabled, false);
    });

    testWidgets("Tapping submit button when form valid shows CircularProgressIndicator", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      
      expect(find.byType(CircularProgressIndicator), findsNothing);
      String description = faker.lorem.sentences(4).join();
      await tester.enterText(find.byKey(Key("descriptionTextKey")), description);
      await tester.pump(Duration(milliseconds: 300));

      await tester.tap(find.byKey(Key("submitButtonKey")));
      await tester.pump(Duration(milliseconds: 250));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump(Duration(seconds: 4));
    });

    testWidgets("Tapping submit button when Editing Profile calls profileRepository.update", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);

      String description = faker.lorem.sentences(4).join();
      await tester.enterText(find.byKey(Key("descriptionTextKey")), description);
      await tester.pump(Duration(milliseconds: 300));

      await tester.tap(find.byKey(Key("submitButtonKey")));
      await tester.pump(Duration(seconds: 5));
      verify(() => profileRepository.update(name: any(named: "name"), website: any(named: "website"), description: any(named: "description"), phone: any(named: "phone"), identifier: any(named: "identifier"))).called(1);
    });

    testWidgets("Tapping submit button when New Profile calls profileRepository.store", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      await tester.enterText(find.byKey(Key("placeNameFieldKey")), faker.company.name());
      await tester.pump(Duration(milliseconds: 1500));
      
      await tester.tap(find.byType(ListTile).first);
      await tester.pump(Duration(milliseconds: 500));

      String description = faker.lorem.sentences(4).join();
      await tester.enterText(find.byKey(Key("descriptionTextKey")), "");
      await tester.pump(Duration(milliseconds: 300));

      await tester.enterText(find.byKey(Key("descriptionTextKey")), description);
      await tester.pump(Duration(milliseconds: 300));

      await tester.tap(find.byKey(Key("submitButtonKey")));
      await tester.pump(Duration(seconds: 5));

      verify(() => profileRepository.store(name: any(named: "name"), website: any(named: "website"), description: any(named: "description"), phone: any(named: "phone"))).called(1);
    });

    testWidgets("Tapping submit button on Edit success shows success toast", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);

      String description = faker.lorem.sentences(4).join();
      await tester.enterText(find.byKey(Key("descriptionTextKey")), description);
      await tester.pump(Duration(milliseconds: 300));

      expect(find.text("Profile Updated!"), findsNothing);
      await tester.tap(find.byKey(Key("submitButtonKey")));
      await tester.pump(Duration(seconds: 3));
      expect(find.text("Profile Updated!"), findsOneWidget);
      await tester.pump(Duration(seconds: 2));
      expect(find.text("Profile Updated!"), findsNothing);
    });

    testWidgets("Tapping submit button on New success shows success toast", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      await tester.enterText(find.byKey(Key("placeNameFieldKey")), faker.company.name());
      await tester.pump(Duration(milliseconds: 1500));
      
      await tester.tap(find.byType(ListTile).first);
      await tester.pump(Duration(milliseconds: 500));

      String description = faker.lorem.sentences(4).join();
      await tester.enterText(find.byKey(Key("descriptionTextKey")), "");
      await tester.pump(Duration(milliseconds: 300));

      await tester.enterText(find.byKey(Key("descriptionTextKey")), description);
      await tester.pump(Duration(milliseconds: 300));

      expect(find.text("Profile Saved!"), findsNothing);
      await tester.tap(find.byKey(Key("submitButtonKey")));

      await tester.pump(Duration(seconds: 3));
      expect(find.text("Profile Saved!"), findsOneWidget);
      await tester.pump(Duration(seconds: 2));
      expect(find.text("Profile Saved!"), findsNothing);
    });

    testWidgets("Tapping submit button on error shows errorMessage", (tester) async {
      when(() => profileRepository.update(name: any(named: "name"), website: any(named: "website"), description: any(named: "description"), phone: any(named: "phone"), identifier: any(named: "identifier")))
        .thenThrow(ApiException(error: "error Message!"));
      
      await screenBuilderEdit.createScreen(tester: tester);

      String description = faker.lorem.sentences(4).join();
      await tester.enterText(find.byKey(Key("descriptionTextKey")), description);
      await tester.pump(Duration(milliseconds: 300));

      expect(find.text("error Message!"), findsNothing);
      await tester.tap(find.byKey(Key("submitButtonKey")));
      await tester.pumpAndSettle();
      expect(find.text("error Message!"), findsOneWidget);
      await tester.pump(Duration(seconds: 3));
      expect(find.text("error Message!"), findsNothing);
    });

    testWidgets("Tapping submit button on success pops nav", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);

      String description = faker.lorem.sentences(4).join();
      await tester.enterText(find.byKey(Key("descriptionTextKey")), description);
      await tester.pump(Duration(milliseconds: 300));

      expect(find.text("Profile Updated!"), findsNothing);
      await tester.tap(find.byKey(Key("submitButtonKey")));
      await tester.pump(Duration(seconds: 4));
      verify(() => observer.didPop(any(), any()));
    });
  });
}