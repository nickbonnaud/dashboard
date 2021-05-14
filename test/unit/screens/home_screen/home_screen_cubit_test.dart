import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/screens/home_screen/cubit/home_screen_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Home Screen Cubit Tests", () {
    late HomeScreenCubit homeScreenCubit;

    setUp(() {
      homeScreenCubit = HomeScreenCubit();
    });

    tearDown(() {
      homeScreenCubit.close();
    });

    test("Initial state of HomeScreenCubit is 0", () {
      expect(homeScreenCubit.state, 0);
    });

    blocTest<HomeScreenCubit, int>(
      "TabChanged event emits new tab index",
      build: () => homeScreenCubit,
      act: (cubit) => cubit.tabChanged(currentTab: 3),
      expect: () => [3]
    );
  });
}