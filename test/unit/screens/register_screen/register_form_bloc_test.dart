import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/blocs/authentication/authentication_bloc.dart';
import 'package:dashboard/models/business/business.dart';
import 'package:dashboard/repositories/authentication_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/register_screen/widgets/widgets/bloc/register_form_bloc.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simple_animations/simple_animations.dart';

class MockAuthenticationRepository extends Mock implements AuthenticationRepository {}
class MockAuthenticationBloc extends Mock implements AuthenticationBloc {}
class MockBusiness extends Mock implements Business {}

void main() {
  group("Register Form Bloc Tests", () {
    late AuthenticationRepository authenticationRepository;
    late AuthenticationBloc authenticationBloc;
    late RegisterFormBloc registerFormBloc;

    late RegisterFormState _baseState;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      authenticationBloc = MockAuthenticationBloc();
      registerFormBloc = RegisterFormBloc(authenticationRepository: authenticationRepository, authenticationBloc: authenticationBloc);

      _baseState = registerFormBloc.state;

      registerFallbackValue(LoggedIn(business: MockBusiness()));
    });

    tearDown(() {
      registerFormBloc.close();
    });

    test("Initial state of RegisterFormState is RegisterFormState.empty()", () {
      expect(registerFormBloc.state, RegisterFormState.empty());
    });

    blocTest<RegisterFormBloc, RegisterFormState>(
      "EmailChanged event changes state: [isEmailValid: false]",
      wait: const Duration(milliseconds: 300),
      build: () => registerFormBloc,
      act: (bloc) => bloc.add(const EmailChanged(email: 'notAnEmail')),
      expect: () => [_baseState.update(isEmailValid: false)]
    );

    blocTest<RegisterFormBloc, RegisterFormState>(
      "PasswordChanged event changes state with empty passwordConfirmation: [isPasswordValid: false]",
      wait: const Duration(milliseconds: 300),
      build: () => registerFormBloc,
      act: (bloc) => bloc.add(const PasswordChanged(password: "no", passwordConfirmation: "")),
      expect: () => [_baseState.update(isPasswordValid: false)]
    );

    blocTest<RegisterFormBloc, RegisterFormState>(
      "PasswordChanged event changes state with non empty passwordConfirmation: [isPasswordValid: false, isPasswordConfirmationValid: false]",
      wait: const Duration(milliseconds: 300),
      build: () => registerFormBloc,
      act: (bloc) => bloc.add(const PasswordChanged(password: "no", passwordConfirmation: "notSame")),
      expect: () => [_baseState.update(isPasswordValid: false, isPasswordConfirmationValid: false)]
    );

    blocTest<RegisterFormBloc, RegisterFormState>(
      "PasswordConfirmationChanged event changes state: [isPasswordConfirmationValid: false]",
      wait: const Duration(milliseconds: 300),
      build: () => registerFormBloc,
      act: (bloc) => bloc.add(const PasswordConfirmationChanged(password: "Password", passwordConfirmation: "12")),
      expect: () => [_baseState.update(isPasswordConfirmationValid: false)]
    );

    blocTest<RegisterFormBloc, RegisterFormState>(
      "Submitted event changes state: [isSubmitting: true], [isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.STOP]",
      build: () {
        when(() => authenticationRepository.register(email: any(named: "email"), password: any(named: "password"), passwordConfirmation: any(named: "passwordConfirmation")))
          .thenAnswer((_) async => MockBusiness());
        when(() => authenticationBloc.add(any(that: isA<AuthenticationEvent>())))
          .thenReturn(null);
        return registerFormBloc;
      },
      act: (bloc) => bloc.add(Submitted(email: faker.internet.password(), password: "password", passwordConfirmation: "password")),
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.stop)]
    );

    blocTest<RegisterFormBloc, RegisterFormState>(
      "Submitted event calls authenticationRepository.register()",
      build: () {
        when(() => authenticationRepository.register(email: any(named: "email"), password: any(named: "password"), passwordConfirmation: any(named: "passwordConfirmation")))
          .thenAnswer((_) async => MockBusiness());
        when(() => authenticationBloc.add(any(that: isA<AuthenticationEvent>())))
          .thenReturn(null);
        return registerFormBloc;
      },
      act: (bloc) => bloc.add(Submitted(email: faker.internet.password(), password: "password", passwordConfirmation: "password")),
      verify: (_) {
        verify(() => authenticationRepository.register(email: any(named: "email"), password: any(named: "password"), passwordConfirmation: any(named: "passwordConfirmation"))).called(1);
      }
    );

    blocTest<RegisterFormBloc, RegisterFormState>(
      "Submitted event calls authenticationBloc.add()",
      build: () {
        when(() => authenticationRepository.register(email: any(named: "email"), password: any(named: "password"), passwordConfirmation: any(named: "passwordConfirmation")))
          .thenAnswer((_) async => MockBusiness());
        when(() => authenticationBloc.add(any(that: isA<AuthenticationEvent>())))
          .thenReturn(null);
        return registerFormBloc;
      },
      act: (bloc) => bloc.add(Submitted(email: faker.internet.password(), password: "password", passwordConfirmation: "password")),
      verify: (_) {
        verify(() => authenticationBloc.add(any(that: isA<AuthenticationEvent>()))).called(1);
      }
    );

    blocTest<RegisterFormBloc, RegisterFormState>(
      "Submitted event on error changes state: [isSubmitting: true], [isSubmitting: false, isSuccess: false, errorMessage: error, errorButtonControl: CustomAnimationControl.PLAY_FROM_START]",
      build: () {
        when(() => authenticationRepository.register(email: any(named: "email"), password: any(named: "password"), passwordConfirmation: any(named: "passwordConfirmation")))
          .thenThrow(const ApiException(error: "error"));
        when(() => authenticationBloc.add(any(that: isA<AuthenticationEvent>())))
          .thenReturn(null);
        return registerFormBloc;
      },
      act: (bloc) => bloc.add(Submitted(email: faker.internet.password(), password: "password", passwordConfirmation: "password")),
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, isSuccess: false, errorMessage: "error", errorButtonControl: CustomAnimationControl.playFromStart)]
    );

    blocTest<RegisterFormBloc, RegisterFormState>(
      "Reset event changes state: [isSuccess: false, errorButtonControl: CustomAnimationControl.STOP]",
      build: () => registerFormBloc,
      act: (bloc) => bloc.add(Reset()),
      expect: () => [_baseState.update(isSuccess: false, errorButtonControl: CustomAnimationControl.stop)]
    );
  });
}