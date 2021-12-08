import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/models/photo.dart';
import 'package:dashboard/screens/photos_screen/widgets/widgets/widgets/logo_form/bloc/logo_form_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';

class MockPhoto extends Mock implements Photo {}
class MockXFile extends Mock implements XFile {}

void main() {
  group("Logo Form Bloc Tests", () {
    late Photo logo;
    late LogoFormBloc logoFormBloc;
    late LogoFormState baseState;

    late XFile pickedLogo;

    setUp(() {
      logo = MockPhoto();
      logoFormBloc = LogoFormBloc(logo: logo);
      baseState = LogoFormState.initial(logo: logo);
    });

    tearDown(() {
      logoFormBloc.close();
    });

    test("Initial state of LogoFormBloc is LogoFormState.initial", () {
      expect(logoFormBloc.state, LogoFormState.initial(logo: logo));
    });

    blocTest<LogoFormBloc, LogoFormState>(
      "LogoPicked event changes state: [logoFile: logo]",
      build: () => logoFormBloc,
      act: (bloc) {
        pickedLogo = MockXFile();
        bloc.add(LogoPicked(logoFile: pickedLogo));
      },
      expect: () => [baseState.update(logoFile: pickedLogo)]
    );
  });
}