import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/repositories/authentication_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/request_reset_password_screen/bloc/request_reset_password_screen_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simple_animations/simple_animations.dart';

class MockAuthenticationRepository extends Mock implements AuthenticationRepository {}

void main() {
  group("Request Reset Password Screen Bloc Tests", () {
    late AuthenticationRepository authenticationRepository;
    late RequestResetPasswordScreenBloc requestResetPasswordScreenBloc;

    late RequestResetPasswordScreenState _baseState;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      requestResetPasswordScreenBloc = RequestResetPasswordScreenBloc(authenticationRepository: authenticationRepository);
      _baseState = requestResetPasswordScreenBloc.state;
    });

    tearDown(() {
      requestResetPasswordScreenBloc.close();
    });

    test("Initial state of RequestResetPasswordScreenBloc is RequestResetPasswordScreenState.initial()", () {
      expect(requestResetPasswordScreenBloc.state, RequestResetPasswordScreenState.initial());
    });

    blocTest<RequestResetPasswordScreenBloc, RequestResetPasswordScreenState>(
      'EmailChanged event changes state: [isEmailValid: false]',
      build: () => requestResetPasswordScreenBloc,
      wait: Duration(milliseconds: 300),
      act: (bloc) => bloc.add(EmailChanged(email: "notEmail")),
      expect: () => [_baseState.update(isEmailValid: false)]
    );

    blocTest<RequestResetPasswordScreenBloc, RequestResetPasswordScreenState>(
      'Submitted event changes state: [isSubmitting: true, errorMessage: ""], [isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.STOP]',
      build: () {
        when(() => authenticationRepository.requestPasswordReset(email: any(named: "email")))
          .thenAnswer((_) async => true);
        return requestResetPasswordScreenBloc;
      },
      act: (bloc) => bloc.add(Submitted(email: "email")),
      expect: () => [_baseState.update(isSubmitting: true, errorMessage: ""), _baseState.update(isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.stop)]
    );

    blocTest<RequestResetPasswordScreenBloc, RequestResetPasswordScreenState>(
      'Submitted event calls _authenticationRepository.requestPasswordReset()',
      build: () {
        when(() => authenticationRepository.requestPasswordReset(email: any(named: "email")))
          .thenAnswer((_) async => true);
        return requestResetPasswordScreenBloc;
      },
      act: (bloc) => bloc.add(Submitted(email: "email")),
      verify: (_) {
        verify(() => authenticationRepository.requestPasswordReset(email: any(named: "email"))).called(1);
      }
    );
    
    blocTest<RequestResetPasswordScreenBloc, RequestResetPasswordScreenState>(
      'Submitted event on error changes state: [isSubmitting: true, errorMessage: ""], [isSubmitting: false, isSuccess: false, errorMessage: error, errorButtonControl: CustomAnimationControl.PLAY_FROM_START]',
      build: () {
        when(() => authenticationRepository.requestPasswordReset(email: any(named: "email")))
          .thenThrow(ApiException(error: "error"));
        return requestResetPasswordScreenBloc;
      },
      act: (bloc) => bloc.add(Submitted(email: "email")),
      expect: () => [_baseState.update(isSubmitting: true, errorMessage: ""), _baseState.update(isSubmitting: false, isSuccess: false, errorMessage: "error", errorButtonControl: CustomAnimationControl.playFromStart)]
    );

    blocTest<RequestResetPasswordScreenBloc, RequestResetPasswordScreenState>(
      'Reset event changes state: [isSubmitting: false, isSuccess: false, errorMessage: ""]',
      build: () => requestResetPasswordScreenBloc,
      seed: () {
        _baseState = _baseState.update(isSubmitting: true, isSuccess: true, errorMessage: "error");
        return _baseState;
      },
      act: (bloc) => bloc.add(Reset()),
      expect: () => [_baseState.update(isSubmitting: false, isSuccess: false, errorMessage: "")]
    );
  });
}