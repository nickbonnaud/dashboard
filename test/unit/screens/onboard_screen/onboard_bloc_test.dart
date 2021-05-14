import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/models/status.dart';
import 'package:dashboard/screens/onboard_screen/bloc/onboard_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group("Onboard Bloc Tests", () {
    late Status accountStatus;
    late OnboardBloc onboardBloc;

    setUp(() {
      accountStatus = Status(name: "Test", code: 103);
      onboardBloc = OnboardBloc(accountStatus: accountStatus);
    });

    tearDown(() {
      onboardBloc.close();
    });
    
    test("Initial state of OnboardBloc is _setInitialStep()", () {
      expect(onboardBloc.state, 3);
    });

    blocTest<OnboardBloc, int>(
      "OnboardEvent.next changes state: [4]",
      build: () => onboardBloc,
      act: (bloc) => bloc.add(OnboardEvent.next),
      expect: () => [4]
    );

    blocTest<OnboardBloc, int>(
      "OnboardEvent.prev changes state: [2]",
      build: () => onboardBloc,
      act: (bloc) => bloc.add(OnboardEvent.prev),
      expect: () => [2]
    );
  });
}