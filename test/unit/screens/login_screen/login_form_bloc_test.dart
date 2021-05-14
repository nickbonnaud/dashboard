import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/blocs/authentication/authentication_bloc.dart';
import 'package:dashboard/models/business/business.dart';
import 'package:dashboard/repositories/authentication_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/login_screen/widgets/widgets/bloc/login_form_bloc.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simple_animations/simple_animations.dart';

class MockAuthenticationRepository extends Mock implements AuthenticationRepository {}
class MockAuthenticationBloc extends Mock implements AuthenticationBloc {}
class MockBusiness extends Mock implements Business {}

void main() {
  group("Login Form Bloc Tests", () {
    late AuthenticationRepository authenticationRepository;
    late AuthenticationBloc authenticationBloc;
    late LoginFormBloc loginFormBloc;

    late LoginFormState baseState;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      authenticationBloc = MockAuthenticationBloc();
      loginFormBloc = LoginFormBloc(authenticationRepository: authenticationRepository, authenticationBloc: authenticationBloc);

      baseState = loginFormBloc.state;

      registerFallbackValue<AuthenticationEvent>(LoggedIn(business: MockBusiness()));
    });

    tearDown(() {
      loginFormBloc.close();
    });

    test("Initial State of LoginFormBloc is LoginFormState.empty()", () {
      expect(loginFormBloc.state, LoginFormState.empty());
    });

    blocTest<LoginFormBloc, LoginFormState>(
      "EmailChanged event changes state: [isEmailValid: false]",
      build: () => loginFormBloc,
      wait: Duration(milliseconds: 300),
      act: (bloc) => bloc.add(EmailChanged(email: "not@email!s")),
      expect: () => [baseState.update(isEmailValid: false)]
    );

    blocTest<LoginFormBloc, LoginFormState>(
      "PasswordChanged event changes state: [isPasswordValid: false]",
      build: () => loginFormBloc,
      wait: Duration(milliseconds: 300),
      act: (bloc) => bloc.add(PasswordChanged(password: "badpass")),
      expect: () => [baseState.update(isPasswordValid: false)]
    );

    blocTest<LoginFormBloc, LoginFormState>(
      "Submitted event changes state: [LoginFormState.loading()], [LoginFormState.success()]",
      build: () => loginFormBloc,
      act: (bloc) {
        when(() => authenticationRepository.login(email: any(named: "email"), password: any(named: "password")))
          .thenAnswer((_) async => MockBusiness());
        when(() => authenticationBloc.add(any(that: isA<AuthenticationEvent>())))
          .thenReturn(null);
        bloc.add(Submitted(email: faker.internet.email(), password: faker.internet.password()));
      },
      expect: () => [LoginFormState.loading(), LoginFormState.success()]
    );

    blocTest<LoginFormBloc, LoginFormState>(
      "Submitted event calls authenticationRepository.login()",
      build: () => loginFormBloc,
      act: (bloc) {
        when(() => authenticationRepository.login(email: any(named: "email"), password: any(named: "password")))
          .thenAnswer((_) async => MockBusiness());
        when(() => authenticationBloc.add(any(that: isA<AuthenticationEvent>())))
          .thenReturn(null);
        bloc.add(Submitted(email: faker.internet.email(), password: faker.internet.password()));
      },
      verify: (_) {
        verify(() => authenticationRepository.login(email: any(named: "email"), password: any(named: "password"))).called(1);
      }
    );

    blocTest<LoginFormBloc, LoginFormState>(
      "Submitted event calls authenticationBloc.add()",
      build: () => loginFormBloc,
      act: (bloc) {
        when(() => authenticationRepository.login(email: any(named: "email"), password: any(named: "password")))
          .thenAnswer((_) async => MockBusiness());
        when(() => authenticationBloc.add(any(that: isA<AuthenticationEvent>())))
          .thenReturn(null);
        bloc.add(Submitted(email: faker.internet.email(), password: faker.internet.password()));
      },
      verify: (_) {
        verify(() => authenticationBloc.add(any(that: isA<AuthenticationEvent>()))).called(1);
      }
    );

    blocTest<LoginFormBloc, LoginFormState>(
      "Submitted event on error changes state: [LoginFormState.loading()], [LoginFormState.failure()]",
      build: () => loginFormBloc,
      act: (bloc) {
        when(() => authenticationRepository.login(email: any(named: "email"), password: any(named: "password")))
          ..thenThrow(ApiException(error: "error"));
        bloc.add(Submitted(email: faker.internet.email(), password: faker.internet.password()));
      },
      expect: () => [LoginFormState.loading(), LoginFormState.failure(errorMessage: "error")]
    );

    blocTest<LoginFormBloc, LoginFormState>(
      "Reset event changes state: [isSuccess: false, errorMessage: "", errorButtonControl: CustomAnimationControl.STOP]",
      build: () => loginFormBloc,
      act: (bloc) => bloc.add(Reset()),
      expect: () => [baseState.update(isSuccess: false, errorMessage: "", errorButtonControl: CustomAnimationControl.STOP)]
    );
  });
}