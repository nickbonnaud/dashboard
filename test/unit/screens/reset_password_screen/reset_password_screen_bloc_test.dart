import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/repositories/authentication_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/reset_password_screen/bloc/reset_password_screen_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simple_animations/simple_animations.dart';

class MockAuthenticationRepository extends Mock implements AuthenticationRepository {}

void main() {
  group("Reset Password Screen Bloc Tests", () {
    late AuthenticationRepository authenticationRepository;
    late ResetPasswordScreenBloc resetPasswordScreenBloc;

    late ResetPasswordScreenState _baseState;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      resetPasswordScreenBloc = ResetPasswordScreenBloc(authenticationRepository: authenticationRepository, token: "token");

      _baseState = resetPasswordScreenBloc.state;
    });

    tearDown(() {
      resetPasswordScreenBloc.close();
    });

    test("Initial state of ResetPasswordScreenBloc is ResetPasswordScreenState.initial()", () {
      expect(resetPasswordScreenBloc.state, ResetPasswordScreenState.initial());
    });

    blocTest<ResetPasswordScreenBloc, ResetPasswordScreenState>(
      "PasswordChanged event changes state when confirmation is empty: [isPasswordValid: false]",
      build: () => resetPasswordScreenBloc,
      wait: Duration(milliseconds: 300),
      act: (bloc) => bloc.add(PasswordChanged(password: "pass", passwordConfirmation: "")),
      expect: () => [_baseState.update(isPasswordValid: false)]
    );

    blocTest<ResetPasswordScreenBloc, ResetPasswordScreenState>(
      "PasswordChanged event changes state when confirmation is not empty: [isPasswordValid: false, isPasswordConfirmationValid: false]",
      build: () => resetPasswordScreenBloc,
      wait: Duration(milliseconds: 300),
      act: (bloc) => bloc.add(PasswordChanged(password: "pass", passwordConfirmation: "p")),
      expect: () => [_baseState.update(isPasswordValid: false, isPasswordConfirmationValid: false)]
    );

    blocTest<ResetPasswordScreenBloc, ResetPasswordScreenState>(
      "PasswordConfirmationChanged event changes state: [isPasswordConfirmationValid: false]",
      build: () => resetPasswordScreenBloc,
      wait: Duration(milliseconds: 300),
      act: (bloc) => bloc.add(PasswordConfirmationChanged(password: "pass", passwordConfirmation: "p")),
      expect: () => [_baseState.update(isPasswordConfirmationValid: false)]
    );

    blocTest<ResetPasswordScreenBloc, ResetPasswordScreenState>(
      "Submitted event changes state: [isSubmitting: true, errorMessage: ""], [isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.STOP]",
      build: () {
        when(() => authenticationRepository.resetPassword(password: any(named: "password"), passwordConfirmation: any(named: "passwordConfirmation"), token: any(named: "token")))
          .thenAnswer((_) async => true);
        return resetPasswordScreenBloc;
      },
      act: (bloc) => bloc.add(Submitted(password: "password", passwordConfirmation: "password")),
      expect: () => [_baseState.update(isSubmitting: true, errorMessage: ""), _baseState.update(isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.STOP)]
    );

    blocTest<ResetPasswordScreenBloc, ResetPasswordScreenState>(
      "Submitted event calls authenticationRepository.resetPassword()",
      build: () {
        when(() => authenticationRepository.resetPassword(password: any(named: "password"), passwordConfirmation: any(named: "passwordConfirmation"), token: any(named: "token")))
          .thenAnswer((_) async => true);
        return resetPasswordScreenBloc;
      },
      act: (bloc) => bloc.add(Submitted(password: "password", passwordConfirmation: "password")),
      verify: (_) {
        verify(() => authenticationRepository.resetPassword(password: any(named: "password"), passwordConfirmation: any(named: "passwordConfirmation"), token: any(named: "token"))).called(1);
      }
    );

    blocTest<ResetPasswordScreenBloc, ResetPasswordScreenState>(
      "Submitted event on error changes state: [isSubmitting: true, errorMessage: ""], [isSubmitting: false, isSuccess: false, errorMessage: 'error', errorButtonControl: CustomAnimationControl.PLAY_FROM_START]",
      build: () {
        when(() => authenticationRepository.resetPassword(password: any(named: "password"), passwordConfirmation: any(named: "passwordConfirmation"), token: any(named: "token")))
          .thenThrow(ApiException(error: "error"));
        return resetPasswordScreenBloc;
      },
      act: (bloc) => bloc.add(Submitted(password: "password", passwordConfirmation: "password")),
      expect: () => [_baseState.update(isSubmitting: true, errorMessage: ""), _baseState.update(isSubmitting: false, isSuccess: false, errorMessage: 'error', errorButtonControl: CustomAnimationControl.PLAY_FROM_START)]
    );

    blocTest<ResetPasswordScreenBloc, ResetPasswordScreenState>(
      "Reset event changes state: [isSubmitting: false, isSuccess: false, errorMessage: "", errorButtonControl: CustomAnimationControl.STOP]",
      build: () => resetPasswordScreenBloc,
      act: (bloc) => bloc.add(Reset()),
      expect: () => [_baseState.update(isSubmitting: false, isSuccess: false, errorMessage: "", errorButtonControl: CustomAnimationControl.STOP)]
    );
  });
}