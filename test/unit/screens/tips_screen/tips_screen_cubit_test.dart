import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/screens/tips_screen/cubits/tips_screen_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Tips Screen Cubit Tests", () {
    late TipsScreenCubit tipsScreenCubit;

    setUp(() {
      tipsScreenCubit = TipsScreenCubit();
    });

    tearDown(() {
      tipsScreenCubit.close();
    });

    test("Initial state of TipsScreenCubit is true", () {
      expect(tipsScreenCubit.state, true);
    });

    blocTest<TipsScreenCubit, bool>(
      "toggle event changes state to false",
      build: () => tipsScreenCubit,
      act: (cubit) => cubit.toggle(),
      expect: () => [false]
    );
  });
}