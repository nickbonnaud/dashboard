import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/screens/settings_screen/cubit/settings_screen_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Settings Screen Cubit Tests", () {
    late SettingsScreenCubit settingsScreenCubit;

    setUp(() {
      settingsScreenCubit = SettingsScreenCubit();
    });

    tearDown(() {
      settingsScreenCubit.close();
    });

    test("Initial state of SettingsScreenCubit is true", () {
      expect(settingsScreenCubit.state, true);
    });

    blocTest<SettingsScreenCubit, bool>(
      "Unlock() event changes state to false",
      build: () => settingsScreenCubit,
      act: (cubit) => cubit.unlock(),
      expect: () => [false]
    );

    blocTest<SettingsScreenCubit, bool>(
      "lock() event changes state to false",
      build: () => settingsScreenCubit,
      act: (cubit) => cubit.lock(),
      expect: () => [true]
    );
  });
}