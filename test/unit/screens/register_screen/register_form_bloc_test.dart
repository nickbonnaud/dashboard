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

    late String email;
    late String password;
    late String passwordConfirmation;

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
      act: (bloc) {
        email = 'notAnEmail';
        bloc.add(EmailChanged(email: email));
      },
      expect: () => [_baseState.update(email: email, isEmailValid: false)]
    );

    blocTest<RegisterFormBloc, RegisterFormState>(
      "PasswordChanged event changes state with empty passwordConfirmation: [isPasswordValid: false]",
      wait: const Duration(milliseconds: 300),
      build: () => registerFormBloc,
      act: (bloc) {
        password = "no";
        bloc.add(PasswordChanged(password: password));
      },
      expect: () => [_baseState.update(password: password, isPasswordValid: false)]
    );

    blocTest<RegisterFormBloc, RegisterFormState>(
      "PasswordChanged event changes state with non empty passwordConfirmation: [isPasswordValid: false, isPasswordConfirmationValid: false]",
      wait: const Duration(milliseconds: 300),
      build: () => registerFormBloc,
      seed: () {
        passwordConfirmation = "notSame";
        _baseState = _baseState.update(passwordConfirmation: passwordConfirmation);
        return _baseState;
      },
      act: (bloc) {
        password = "no";
        bloc.add(PasswordChanged(password: password));
      },
      expect: () => [_baseState.update(password: password, isPasswordValid: false, isPasswordConfirmationValid: false)]
    );

    blocTest<RegisterFormBloc, RegisterFormState>(
      "PasswordConfirmationChanged event changes state: [isPasswordConfirmationValid: false]",
      wait: const Duration(milliseconds: 300),
      build: () => registerFormBloc,
      seed: () {
        password = "Password";
        _baseState = _baseState.update(password: password);
        return _baseState;
      },
      act: (bloc) {
        passwordConfirmation = "12";
        bloc.add(PasswordConfirmationChanged(passwordConfirmation: passwordConfirmation));
      },
      expect: () => [_baseState.update(passwordConfirmation: passwordConfirmation, isPasswordConfirmationValid: false)]
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
      seed: () {
        email = faker.internet.email();
        password = faker.internet.password();
        passwordConfirmation = password;
        _baseState = _baseState.update(email: email, password: password, passwordConfirmation: passwordConfirmation);
        return _baseState;
      },
      act: (bloc) => bloc.add(Submitted()),
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
      seed: () {
        email = faker.internet.email();
        password = faker.internet.password();
        passwordConfirmation = password;
        _baseState = _baseState.update(email: email, password: password, passwordConfirmation: passwordConfirmation);
        return _baseState;
      },
      act: (bloc) => bloc.add(Submitted()),
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
      seed: () {
        email = faker.internet.email();
        password = faker.internet.password();
        passwordConfirmation = password;
        _baseState = _baseState.update(email: email, password: password, passwordConfirmation: passwordConfirmation);
        return _baseState;
      },
      act: (bloc) => bloc.add(Submitted()),
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
      seed: () {
        email = faker.internet.email();
        password = faker.internet.password();
        passwordConfirmation = password;
        _baseState = _baseState.update(email: email, password: password, passwordConfirmation: passwordConfirmation);
        return _baseState;
      },
      act: (bloc) => bloc.add(Submitted()),
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