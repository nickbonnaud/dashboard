import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/screens/photos_screen/cubit/photos_screen_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Photos Screen Cubit Tests", () {
    late PhotosScreenCubit photosScreenCubit;

    setUp(() {
      photosScreenCubit = PhotosScreenCubit();
    });

    tearDown(() {
      photosScreenCubit.close();
    });

    test("Initial state of PhotosScreenCubit is 0", () {
      expect(photosScreenCubit.state, 0);
    });

    blocTest<PhotosScreenCubit, int>(
      "Next event changes state to 1",
      build: () => photosScreenCubit,
      act: (cubit) => cubit.next(),
      expect: () => [1]
    );

    blocTest<PhotosScreenCubit, int>(
      "Previous event changes state to 2",
      build: () => photosScreenCubit,
      seed: () => 3,
      act: (cubit) => cubit.previous(),
      expect: () => [2]
    );
  });
}