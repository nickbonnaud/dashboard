import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/repositories/authentication_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/settings_screen/cubit/settings_screen_cubit.dart';
import 'package:dashboard/screens/settings_screen/widget/widgets/locked_form/bloc/locked_form_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simple_animations/simple_animations.dart';

class MockAuthenticationRepository extends Mock implements AuthenticationRepository {}
class MockSettingsScreenCubit extends Mock implements SettingsScreenCubit {}

void main() {
  group("Locked Form Bloc Tests", () {
    late AuthenticationRepository authenticationRepository;
    late SettingsScreenCubit settingsScreenCubit;
    late LockedFormBloc lockedFormBloc;

    late LockedFormState _baseState;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      settingsScreenCubit = MockSettingsScreenCubit();
      lockedFormBloc = LockedFormBloc(authenticationRepository: authenticationRepository, settingsScreenCubit: settingsScreenCubit);
      _baseState = lockedFormBloc.state;
    });

    tearDown(() {
      lockedFormBloc.close();
    });

    test("Initial state of LockedFormBloc is LockedFormState.initial()", () {
      expect(lockedFormBloc.state, LockedFormState.initial());
    });

    blocTest<LockedFormBloc, LockedFormState>(
      "PasswordChanged event changes state: [isPasswordValid: false]",
      build: () => lockedFormBloc,
      wait: Duration(milliseconds: 300),
      act: (bloc) => bloc.add(PasswordChanged(password: "p")),
      expect: () => [_baseState.update(isPasswordValid: false)]
    );

    blocTest<LockedFormBloc, LockedFormState>(
      "Submitted event changes state: [isSubmitting: true], [isSubmitting: false, errorButtonControl: CustomAnimationControl.STOP]",
      build: () {
        when(() => authenticationRepository.verifyPassword(password: any(named: "password"))).thenAnswer((_) async => true);
        when(() => settingsScreenCubit.unlock()).thenReturn(null);
        return lockedFormBloc;
      },
      act: (bloc) => bloc.add(Submitted(password: "password")),
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, errorButtonControl: CustomAnimationControl.STOP)]
    );

    blocTest<LockedFormBloc, LockedFormState>(
      "Submitted event calls authenticationRepository.verifyPassword()",
      build: () {
        when(() => authenticationRepository.verifyPassword(password: any(named: "password"))).thenAnswer((_) async => true);
        when(() => settingsScreenCubit.unlock()).thenReturn(null);
        return lockedFormBloc;
      },
      act: (bloc) => bloc.add(Submitted(password: "password")),
      verify: (_) {
        verify(() => authenticationRepository.verifyPassword(password: any(named: "password"))).called(1);
      }
    );

    blocTest<LockedFormBloc, LockedFormState>(
      "Submitted event calls settingsScreenCubit.unlock()",
      build: () {
        when(() => authenticationRepository.verifyPassword(password: any(named: "password"))).thenAnswer((_) async => true);
        when(() => settingsScreenCubit.unlock()).thenReturn(null);
        return lockedFormBloc;
      },
      act: (bloc) => bloc.add(Submitted(password: "password")),
      verify: (_) {
        verify(() => settingsScreenCubit.unlock()).called(1);
      }
    );

    blocTest<LockedFormBloc, LockedFormState>(
      "Submitted event on error changes state: [isSubmitting: true], [isSubmitting: false, errorMessage: error, errorButtonControl: CustomAnimationControl.PLAY_FROM_START]",
      build: () {
        when(() => authenticationRepository.verifyPassword(password: any(named: "password"))).thenThrow(ApiException(error: "error"));
        when(() => settingsScreenCubit.unlock()).thenReturn(null);
        return lockedFormBloc;
      },
      act: (bloc) => bloc.add(Submitted(password: "password")),
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, errorMessage: "error", errorButtonControl: CustomAnimationControl.PLAY_FROM_START)]
    );

    blocTest<LockedFormBloc, LockedFormState>(
      "Reset event changes state: [isPasswordValid: false]",
      build: () => lockedFormBloc,
      seed: () => _baseState.update(errorMessage: "error", errorButtonControl: CustomAnimationControl.PLAY_FROM_START),
      act: (bloc) => bloc.add(Reset()),
      expect: () => [_baseState.update(errorMessage: "", errorButtonControl: CustomAnimationControl.STOP)]
    );
  });
}