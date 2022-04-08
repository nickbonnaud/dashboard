import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/models/business/photos.dart';
import 'package:dashboard/models/photo.dart';
import 'package:dashboard/repositories/photos_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/photos_screen/widgets/bloc/photos_form_bloc.dart';
import 'package:dashboard/screens/photos_screen/widgets/widgets/widgets/banner_form/bloc/banner_form_bloc.dart';
import 'package:dashboard/screens/photos_screen/widgets/widgets/widgets/logo_form/bloc/logo_form_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simple_animations/simple_animations.dart';

class MockPhotosRepository extends Mock implements PhotosRepository {}
class MockBusinessBloc extends Mock implements BusinessBloc {}
class MockPhoto extends Mock implements Photo {}
class MockXFile extends Mock implements XFile {}

void main() {
  group("Photos Form Bloc Tests", () {
    late PhotosRepository photosRepository;
    late BusinessBloc businessBloc;
    late LogoFormBloc logoFormBloc;
    late BannerFormBloc bannerFormBloc;
    late PhotosFormBloc photosFormBloc;

    late PhotosFormState baseState;
    late XFile logoFile;
    late XFile bannerFile;

    setUp(() {
      photosRepository = MockPhotosRepository();
      businessBloc = MockBusinessBloc();
      logoFormBloc = LogoFormBloc(logo: MockPhoto());
      bannerFormBloc = BannerFormBloc(banner: MockPhoto());

      photosFormBloc = PhotosFormBloc(
        photosRepository: photosRepository,
        businessBloc: businessBloc,
        logoFormBloc: logoFormBloc,
        bannerFormBloc: bannerFormBloc
      );

      baseState = PhotosFormState.intial();
      registerFallbackValue(PhotosUpdated(photos: Photos(logo: MockPhoto(), banner: MockPhoto())));
      registerFallbackValue(MockXFile());

      when(() => photosRepository.storeLogo(file: any(named: "file"), profileIdentifier: any(named: "profileIdentifier")))
        .thenAnswer((_) async => Photos(logo: MockPhoto(), banner: MockPhoto()));

      when(() => photosRepository.storeBanner(file: any(named: "file"), profileIdentifier: any(named: "profileIdentifier")))
        .thenAnswer((_) async => Photos(logo: MockPhoto(), banner: MockPhoto()));

      when(() => businessBloc.add(any(that: isA<PhotosUpdated>()))).thenReturn(null);
    });

    tearDown(() {
      logoFormBloc.close();
      bannerFormBloc.close();
      photosFormBloc.close();
    });

    test("Initial state of PhotosFormBloc is PhotosFormState.intial()", () {
      expect(photosFormBloc.state, PhotosFormState.intial());
    });

    blocTest<PhotosFormBloc, PhotosFormState>(
      "LogoFilePicked event changes state: [logoFile: logo]",
      build: () => photosFormBloc,
      act: (bloc) {
        logoFile = MockXFile();
        bloc.add(LogoFilePicked(logo: logoFile));
      },
      expect: () => [baseState.update(logoFile: logoFile)]
    );

    blocTest<PhotosFormBloc, PhotosFormState>(
      "BannerFilePicked event changes state: [bannerFile: banner]",
      build: () => photosFormBloc,
      act: (bloc) {
        bannerFile = MockXFile();
        bloc.add(BannerFilePicked(banner: bannerFile));
      },
      expect: () => [baseState.update(bannerFile: bannerFile)]
    );

    blocTest<PhotosFormBloc, PhotosFormState>(
      "bannerFile and logoFile != null sets PhotosValid = true",
      build: () => photosFormBloc,
      act: (bloc) {
        logoFile = MockXFile();
        bannerFile = MockXFile();
        bloc.add(BannerFilePicked(banner: bannerFile));
        bloc.add(LogoFilePicked(logo: logoFile));
      },
      verify: (_) {
        expect(photosFormBloc.state.photosValid, true);
      }
    );

    blocTest<PhotosFormBloc, PhotosFormState>(
      "Submitted event changes state: [isSubmitting: true], [isSubmitting: false, isSuccess: true]",
      build: () => photosFormBloc,
      seed: () {
        baseState = baseState.update(logoFile: MockXFile(), bannerFile: MockXFile());
        return baseState;
      },
      act: (bloc) {
        bloc.add(const Submitted(identifier: "identifier"));
      },
      expect: () => [baseState.update(isSubmitting: true), baseState.update(isSubmitting: false, isSuccess: true)]
    );

    blocTest<PhotosFormBloc, PhotosFormState>(
      "Submitted event calls photosRepository.storeLogo && photosRepository.storeBanner",
      build: () => photosFormBloc,
      seed: () {
        baseState = baseState.update(logoFile: MockXFile(), bannerFile: MockXFile());
        return baseState;
      },
      act: (bloc) {
        bloc.add(const Submitted(identifier: "identifier"));
      },
      verify: (_) {
        verify(() => photosRepository.storeLogo(file: any(named: "file"), profileIdentifier: any(named: "profileIdentifier"))).called(1);
        verify(() => photosRepository.storeBanner(file: any(named: "file"), profileIdentifier: any(named: "profileIdentifier"))).called(1);
      }
    );

    blocTest<PhotosFormBloc, PhotosFormState>(
      "Submitted event calls businessBloc.add",
      build: () => photosFormBloc,
      seed: () {
        baseState = baseState.update(logoFile: MockXFile(), bannerFile: MockXFile());
        return baseState;
      },
      act: (bloc) {
        bloc.add(const Submitted(identifier: "identifier"));
      },
      verify: (_) {
        verify(() => businessBloc.add(any(that: isA<PhotosUpdated>()))).called(1);
      }
    );

    blocTest<PhotosFormBloc, PhotosFormState>(
      "Submitted event on storeLogo error changes state: [isSubmitting: true], [isSubmitting: false, errorMessage: exception.error, errorButtonControl: CustomAnimationControl.PLAY_FROM_START]",
      build: () => photosFormBloc,
      seed: () {
        baseState = baseState.update(logoFile: MockXFile(), bannerFile: MockXFile());
        return baseState;
      },
      act: (bloc) {
        when(() => photosRepository.storeLogo(file: any(named: "file"), profileIdentifier: any(named: "profileIdentifier")))
          .thenThrow(const ApiException(error: "error"));
        bloc.add(const Submitted(identifier: "identifier"));
      },
      expect: () => [baseState.update(isSubmitting: true), baseState.update(isSubmitting: false, errorMessage: "error", errorButtonControl: CustomAnimationControl.playFromStart)]
    );

    blocTest<PhotosFormBloc, PhotosFormState>(
      "Submitted event on storeBanner error changes state: [isSubmitting: true], [isSubmitting: false, errorMessage: exception.error, errorButtonControl: CustomAnimationControl.PLAY_FROM_START]",
      build: () => photosFormBloc,
      seed: () {
        baseState = baseState.update(logoFile: MockXFile(), bannerFile: MockXFile());
        return baseState;
      },
      act: (bloc) {
        when(() => photosRepository.storeBanner(file: any(named: "file"), profileIdentifier: any(named: "profileIdentifier")))
          .thenThrow(const ApiException(error: "error"));
        bloc.add(const Submitted(identifier: "identifier"));
      },
      expect: () => [baseState.update(isSubmitting: true), baseState.update(isSubmitting: false, errorMessage: "error", errorButtonControl: CustomAnimationControl.playFromStart)]
    );

    blocTest<PhotosFormBloc, PhotosFormState>(
      "Reset event changes state: [isSuccess: false, isSubmitting: false, errorMessage: "", errorButtonControl: CustomAnimationControl.STOP]",
      build: () => photosFormBloc,
      seed: () {
        baseState = baseState.update(
          logoFile: MockXFile(),
          bannerFile: MockXFile(),
          isSuccess: true,
          isSubmitting: true,
          errorMessage: "error",
          errorButtonControl: CustomAnimationControl.playFromStart
        );
        return baseState;
      },
      act: (bloc) => bloc.add(Reset()),
      expect: () => [baseState.update(isSuccess: false, isSubmitting: false, errorMessage: "", errorButtonControl: CustomAnimationControl.stop)]
    );
  });
}