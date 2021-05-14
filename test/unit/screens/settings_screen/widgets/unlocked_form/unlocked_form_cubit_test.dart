import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/screens/settings_screen/widget/widgets/unlocked_form/cubit/unlocked_form_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Unlocked Form Cubit Tests", () {
    late UnlockedFormCubit unlockedFormCubit;

    setUp(() {
      unlockedFormCubit = UnlockedFormCubit();
    });

    tearDown(() {
      unlockedFormCubit.close();
    });

    test("Initial state of unlockedFormCubit is 0", () {
      expect(unlockedFormCubit.state, 0);
    });

    blocTest<UnlockedFormCubit, int>(
      "Next event changes state to + 1",
      build: () => unlockedFormCubit,
      seed: () => 2,
      act: (cubit) => cubit.next(),
      expect: () => [3]
    );

    blocTest<UnlockedFormCubit, int>(
      "Previous event changes state to - 1",
      build: () => unlockedFormCubit,
      seed: () => 2,
      act: (cubit) => cubit.previous(),
      expect: () => [1]
    );
  });
}