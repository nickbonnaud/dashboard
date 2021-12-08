import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/models/photo.dart';
import 'package:dashboard/screens/photos_screen/widgets/widgets/widgets/banner_form/bloc/banner_form_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';

class MockPhoto extends Mock implements Photo {}
class MockXFile extends Mock implements XFile {}

void main() {
  group("Banner Form Bloc Tests", () {
    late Photo banner;
    late BannerFormBloc bannerFormBloc;
    late BannerFormState baseState;

    late XFile pickedBanner;

    setUp(() {
      banner = MockPhoto();
      bannerFormBloc = BannerFormBloc(banner: banner);
      baseState = BannerFormState.initial(banner: banner);
    });

    tearDown(() {
      bannerFormBloc.close();
    });

    test("Initial state of BannerFormBloc is BannerFormState.initial", () {
      expect(bannerFormBloc.state, BannerFormState.initial(banner: banner));
    });

    blocTest<BannerFormBloc, BannerFormState>(
      "BannerPicked event changes state: [bannerFile: banner]",
      build: () => bannerFormBloc,
      act: (bloc) {
        pickedBanner = MockXFile();
        bloc.add(BannerPicked(bannerFile: pickedBanner));
      },
      expect: () => [baseState.update(bannerFile: pickedBanner)]
    );
  });
}