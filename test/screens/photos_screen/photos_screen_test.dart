import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/global_widgets/app_bars/default_app_bar.dart';
import 'package:dashboard/global_widgets/cached_avatar.dart';
import 'package:dashboard/global_widgets/cached_image.dart';
import 'package:dashboard/models/business/photos.dart';
import 'package:dashboard/models/photo.dart';
import 'package:dashboard/repositories/photo_picker_repository.dart';
import 'package:dashboard/repositories/photos_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/photos_screen/photos_screen.dart';
import 'package:dashboard/screens/photos_screen/widgets/widgets/photos_form_body.dart';
import 'package:dashboard/screens/photos_screen/widgets/widgets/widgets/banner_form/banner_form.dart';
import 'package:dashboard/screens/photos_screen/widgets/widgets/widgets/logo_form/logo_form.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../helpers/mock_data_generator.dart';
import '../../helpers/screen_builder.dart';

class MockPhotoPickerRepository extends Mock implements PhotoPickerRepository {}
class MockPhotosRepository extends Mock implements PhotosRepository {}
class MockBusinessBloc extends Mock implements BusinessBloc {}
class MockXFile extends Mock implements XFile {}

void main() {
  group("Photos Screen Tests", () {
    late MockDataGenerator mockDataGenerator;
    late NavigatorObserver observer;
    late PhotoPickerRepository photoPickerRepository;
    late PhotosRepository photosRepository;
    late BusinessBloc businessBloc;
    late Photos photos;
    late String profileIdentifier;

    late ScreenBuilder screenBuilderNew;
    late ScreenBuilder screenBuilderEdit;

    setUp(() {
      mockDataGenerator = MockDataGenerator();
      observer = NavigatorObserver();
      photoPickerRepository = MockPhotoPickerRepository();
      photosRepository = MockPhotosRepository();
      businessBloc = MockBusinessBloc();
      photos = mockDataGenerator.createBusinessPhotos();
      profileIdentifier = faker.guid.guid();
      
      screenBuilderNew = ScreenBuilder(
        child: PhotosScreen(
          photoPickerRepository: photoPickerRepository,
          photosRepository: photosRepository,
          businessBloc: businessBloc,
          photos: Photos(
            logo: Photo.empty(), 
            banner: Photo.empty()
          ),
          profileIdentifier: profileIdentifier
        ),
        observer: observer
      );

      screenBuilderEdit = ScreenBuilder(
        child: PhotosScreen(
          photoPickerRepository: photoPickerRepository,
          photosRepository: photosRepository,
          businessBloc: businessBloc,
          photos: photos,
          profileIdentifier: profileIdentifier
        ), 
        observer: observer
      );

      registerFallbackValue(PhotosUpdated(photos: mockDataGenerator.createBusinessPhotos()));
      registerFallbackValue(MockXFile());
      
      when(() => photoPickerRepository.choosePhoto())
        .thenAnswer((_) async => null);
      
      when(() => photosRepository.storeLogo(file: any(named: "file"), profileIdentifier: any(named: "profileIdentifier")))
        .thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 500), () => mockDataGenerator.createBusinessPhotos()));

      when(() => businessBloc.add(any(that: isA<PhotosUpdated>()))).thenReturn(null);
    });

    testWidgets("New Photos Screen creates AppBar", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets("Edit Photos Screen creates DefaultAppBar", (tester) async {
      await mockNetworkImagesFor(() => screenBuilderEdit.createScreen(tester: tester, shouldPump: false));
      await tester.pump();
      expect(find.byType(DefaultAppBar), findsOneWidget);
    });

    testWidgets("PhotosForm creates PhotosFormBody", (tester) async {
      await mockNetworkImagesFor(() => screenBuilderNew.createScreen(tester: tester, shouldPump: false));
      await tester.pump();
      expect(find.byType(PhotosFormBody), findsOneWidget);
    });

    testWidgets("inital page of PhotosFormBody = 0", (tester) async {
      await mockNetworkImagesFor(() => screenBuilderNew.createScreen(tester: tester, shouldPump: false));
      await tester.pump();
      expect(tester.widget<PageView>(find.byKey(const Key("pageViewKey"))).controller.page, 0);
    });

    testWidgets("PhotosFormBody creates leftChevron", (tester) async {
      await mockNetworkImagesFor(() => screenBuilderNew.createScreen(tester: tester, shouldPump: false));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key("leftChevronKey")), findsOneWidget);
    });

    testWidgets("LeftChevron is disabled initially", (tester) async {
      await mockNetworkImagesFor(() => screenBuilderNew.createScreen(tester: tester, shouldPump: false));
      await tester.pumpAndSettle();
      expect(tester.widget<IconButton>(find.byKey(const Key("leftChevronKey"))).onPressed, null);
    });

    testWidgets("PhotosFormBody creates rightChevron", (tester) async {
      await mockNetworkImagesFor(() => screenBuilderNew.createScreen(tester: tester, shouldPump: false));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key("rightChevronKey")), findsOneWidget);
    });

    testWidgets("RightChevron is enabled initially", (tester) async {
      await mockNetworkImagesFor(() => screenBuilderNew.createScreen(tester: tester, shouldPump: false));
      await tester.pumpAndSettle();
      expect(tester.widget<IconButton>(find.byKey(const Key("rightChevronKey"))).onPressed, isA<Function>());
    });

    testWidgets("Tapping rightChevron when page = 0 changes page to page = 1", (tester) async {
      await mockNetworkImagesFor(() => screenBuilderNew.createScreen(tester: tester, shouldPump: false));
      await tester.pumpAndSettle();
      expect(tester.widget<PageView>(find.byKey(const Key("pageViewKey"))).controller.page, 0);
      await tester.tap(find.byKey(const Key("rightChevronKey")));
      await tester.pumpAndSettle(const Duration(milliseconds: 300));
      expect(tester.widget<PageView>(find.byKey(const Key("pageViewKey"))).controller.page, 1);
    });

    testWidgets("Tapping leftChevron when page = 1 changes page to page = 0", (tester) async {
      await mockNetworkImagesFor(() => screenBuilderNew.createScreen(tester: tester, shouldPump: false));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key("rightChevronKey")));
      await tester.pumpAndSettle(const Duration(milliseconds: 300));

      expect(tester.widget<PageView>(find.byKey(const Key("pageViewKey"))).controller.page, 1);

      await tester.tap(find.byKey(const Key("leftChevronKey")));
      await tester.pumpAndSettle(const Duration(milliseconds: 300));

      expect(tester.widget<PageView>(find.byKey(const Key("pageViewKey"))).controller.page, 0);
    });

    testWidgets("Page = 0 shows LogoForm", (tester) async {
      await mockNetworkImagesFor(() => screenBuilderNew.createScreen(tester: tester, shouldPump: false));
      await tester.pumpAndSettle();

      expect(find.byType(LogoForm), findsOneWidget);
      expect(find.byType(BannerForm), findsNothing);
    });

    testWidgets("Page = 1 shows BannerForm", (tester) async {
      await mockNetworkImagesFor(() => screenBuilderNew.createScreen(tester: tester, shouldPump: false));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key("rightChevronKey")));
      await tester.pumpAndSettle(const Duration(milliseconds: 300));

      expect(find.byType(LogoForm), findsNothing);
      expect(find.byType(BannerForm), findsOneWidget);
    });

    testWidgets("New LogoForm creates placeholder", (tester) async {
      await mockNetworkImagesFor(() => screenBuilderNew.createScreen(tester: tester, shouldPump: false));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key("logoPlaceHolderKey")), findsOneWidget);
    });

    testWidgets("Edit LogoForm creates initialLogo", (tester) async {
      await mockNetworkImagesFor(() => screenBuilderEdit.createScreen(tester: tester, shouldPump: false));
      await tester.pump();

      expect(find.byType(CachedAvatar), findsOneWidget);
    });

    testWidgets("Tapping logoPickerButton calls photoPickerRepository.choosePhoto", (tester) async {
      await mockNetworkImagesFor(() => screenBuilderNew.createScreen(tester: tester, shouldPump: false));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key("logoPickerButtonKey")));
      await tester.pump();
      verify(() => photoPickerRepository.choosePhoto()).called(1);
    });

    testWidgets("New BannerForm creates placeholder", (tester) async {
      await mockNetworkImagesFor(() => screenBuilderNew.createScreen(tester: tester, shouldPump: false));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key("rightChevronKey")));
      await tester.pumpAndSettle(const Duration(milliseconds: 300));

      expect(find.byKey(const Key("bannerPlaceHolderKey")), findsOneWidget);
    });

    testWidgets("Edit BannerForm creates initialBanner", (tester) async {
      await mockNetworkImagesFor(() => screenBuilderEdit.createScreen(tester: tester, shouldPump: false));
      await tester.pump();

      await tester.tap(find.byKey(const Key("rightChevronKey")));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(CachedImage), findsOneWidget);
    });

    testWidgets("Tapping BannerPickerButton calls photoPickerRepository.choosePhoto", (tester) async {
      await mockNetworkImagesFor(() => screenBuilderEdit.createScreen(tester: tester, shouldPump: false));
      await tester.pump();

      await tester.tap(find.byKey(const Key("rightChevronKey")));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.drag(find.byKey(const Key("mainScrollKey")), const Offset(0, -500));
      await tester.pump();
      await tester.tap(find.byKey(const Key("bannerPickerButtonKey")));
      await tester.pump();
      verify(() => photoPickerRepository.choosePhoto()).called(1);
    });

    testWidgets("SubmitButton is disabled by default", (tester) async {
      await mockNetworkImagesFor(() => screenBuilderEdit.createScreen(tester: tester, shouldPump: false));
      await tester.pump();

      expect(tester.widget<ElevatedButton>(find.byKey(const Key("submitButtonKey"))).enabled, false);
      await tester.pump(const Duration(milliseconds: 1));
    });

    testWidgets("SubmitButton is enabled if filePicked", (tester) async {
      final XFile pickedFile = MockXFile();
      when(() => pickedFile.path).thenReturn("");
      
      when(() => photoPickerRepository.choosePhoto())
        .thenAnswer((_) async => pickedFile);
        
      await mockNetworkImagesFor(() => screenBuilderEdit.createScreen(tester: tester, shouldPump: false));
      await tester.pump();

      await tester.tap(find.byKey(const Key("logoPickerButtonKey")));
      await tester.pump();
      expect(tester.widget<ElevatedButton>(find.byKey(const Key("submitButtonKey"))).enabled, true);
      await tester.pump(const Duration(milliseconds: 1));
    });

    testWidgets("Tapping Submit button displays CircularProgressIndicator", (tester) async {
      final XFile pickedFile = MockXFile();
      when(() => pickedFile.path).thenReturn("");
      
      when(() => photoPickerRepository.choosePhoto())
        .thenAnswer((_) async => pickedFile);
        
      await mockNetworkImagesFor(() => screenBuilderEdit.createScreen(tester: tester, shouldPump: false));
      await tester.pump();

      await tester.tap(find.byKey(const Key("logoPickerButtonKey")));
      await tester.pump();
      
      expect(find.byType(CircularProgressIndicator), findsNothing);
      await tester.tap(find.byKey(const Key("submitButtonKey")));
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump(const Duration(seconds: 4));
    });

    testWidgets("Tapping Submit displays toast on success", (tester) async {
      final XFile pickedFile = MockXFile();
      when(() => pickedFile.path).thenReturn("");
      
      when(() => photoPickerRepository.choosePhoto())
        .thenAnswer((_) async => pickedFile);
        
      await mockNetworkImagesFor(() => screenBuilderEdit.createScreen(tester: tester, shouldPump: false));
      await tester.pump();

      await tester.tap(find.byKey(const Key("logoPickerButtonKey")));
      await tester.pump();
      
      expect(find.text("Photos Saved!"), findsNothing);
      await tester.tap(find.byKey(const Key("submitButtonKey")));
      await tester.pump(const Duration(seconds: 2));
      expect(find.text("Photos Saved!"), findsOneWidget);
      await tester.pump(const Duration(seconds: 2));
    });

    testWidgets("Tapping Submit displays error on fail", (tester) async {
      final XFile pickedFile = MockXFile();
      when(() => pickedFile.path).thenReturn("");
      
      when(() => photoPickerRepository.choosePhoto())
        .thenAnswer((_) async => pickedFile);

      when(() => photosRepository.storeLogo(file: any(named: "file"), profileIdentifier: any(named: "profileIdentifier")))
        .thenThrow(const ApiException(error: "An error occurred!"));
        
      await mockNetworkImagesFor(() => screenBuilderEdit.createScreen(tester: tester, shouldPump: false));
      await tester.pump();

      await tester.tap(find.byKey(const Key("logoPickerButtonKey")));
      await tester.pump();
      
      expect(find.text("An error occurred!"), findsNothing);
      await tester.tap(find.byKey(const Key("submitButtonKey")));
      await tester.pump();
      expect(find.text("An error occurred!"), findsOneWidget);
      await tester.pump(const Duration(seconds: 2));
      await tester.pump(const Duration(seconds: 1));
      expect(find.text("An error occurred!"), findsNothing);
    });
  });
}