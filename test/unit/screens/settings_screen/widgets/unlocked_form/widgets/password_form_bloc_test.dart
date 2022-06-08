import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/repositories/business_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/settings_screen/widget/widgets/unlocked_form/widgets/password_form/bloc/password_form_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simple_animations/simple_animations.dart';

class MockBusinessRepository extends Mock implements BusinessRepository {}

void main() {
  group("Password Form Bloc Tests", () {
    late BusinessRepository businessRepository;
    late PasswordFormBloc passwordFormBloc;
    
    late PasswordFormState _baseState;

    late String password;
    late String passwordConfirmation;

    setUp(() {
      businessRepository = MockBusinessRepository();
      passwordFormBloc = PasswordFormBloc(businessRepository: businessRepository);
      _baseState = passwordFormBloc.state;
    });

    tearDown(() {
      passwordFormBloc.close();
    });

    test("Initial state of PasswordFormBloc is PasswordFormState.initial()", () {
      expect(passwordFormBloc.state, PasswordFormState.initial());
    });

    blocTest<PasswordFormBloc, PasswordFormState>(
      "PasswordChanged event changes state if confirmation empty: [isPasswordValid: true, isPasswordConfirmationValid: true]",
      build: () => passwordFormBloc,
      wait: const Duration(milliseconds: 300),
      act: (bloc) {
        password = "ndcbJSH2#*!!sjs426HH@23";
        bloc.add(PasswordChanged(password: password));
      },
      expect: () => [_baseState.update(password: password, isPasswordValid: true, isPasswordConfirmationValid: true)]
    );

    blocTest<PasswordFormBloc, PasswordFormState>(
      "PasswordChanged event changes state if confirmation is not empty: [isPasswordValid: true, isPasswordConfirmationValid: false]",
      build: () => passwordFormBloc,
      wait: const Duration(milliseconds: 300),
      seed: () {
        passwordConfirmation = "pass";
        _baseState = _baseState.update(passwordConfirmation: "pass");
        return _baseState;
      },
      act: (bloc) {
        password = "ndcbJSH2#*!!sjs426HH@23";
        bloc.add(PasswordChanged(password: password));
      },
      expect: () => [_baseState.update(password: password, isPasswordValid: true, isPasswordConfirmationValid: false)]
    );

    blocTest<PasswordFormBloc, PasswordFormState>(
      "PasswordConfirmationChanged event changes state: [isPasswordConfirmationValid: true]",
      build: () => passwordFormBloc,
      wait: const Duration(milliseconds: 300),
      seed: () {
        password = "ndcbJSH2#*!!sjs426HH@23";
        _baseState = _baseState.update(password: password);
        return _baseState;
      },
      act: (bloc) => bloc.add(PasswordConfirmationChanged(passwordConfirmation: password)),
      expect: () => [_baseState.update(passwordConfirmation: password, isPasswordConfirmationValid: true)]
    );

    blocTest<PasswordFormBloc, PasswordFormState>(
      "Submitted event changes state: [isSubmitting: true], [isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.STOP]",
      build: () {
        when(() => businessRepository.updatePassword(password: any(named: "password"), passwordConfirmation: any(named: "passwordConfirmation"), identifier: any(named: "identifier")))
          .thenAnswer((invocation) async => true);
        return passwordFormBloc;
      },
      seed: () {
        password = "ndcbJSH2#*!!sjs426HH@23";
        passwordConfirmation = password;
        _baseState = _baseState.update(password: password, passwordConfirmation: passwordConfirmation);
        return _baseState;
      },
      act: (bloc) => bloc.add(const Submitted(identifier: "identifier")),
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.stop)]
    );

    blocTest<PasswordFormBloc, PasswordFormState>(
      "Submitted event calls businessRepository.updatePassword()",
      build: () {
        when(() => businessRepository.updatePassword(password: any(named: "password"), passwordConfirmation: any(named: "passwordConfirmation"), identifier: any(named: "identifier")))
          .thenAnswer((invocation) async => true);
        return passwordFormBloc;
      },
      seed: () {
        password = "ndcbJSH2#*!!sjs426HH@23";
        passwordConfirmation = password;
        _baseState = _baseState.update(password: password, passwordConfirmation: passwordConfirmation);
        return _baseState;
      },
      act: (bloc) => bloc.add(const Submitted(identifier: "identifier")),
      verify: (_) {
        verify(() => businessRepository.updatePassword(password: any(named: "password"), passwordConfirmation: any(named: "passwordConfirmation"), identifier: any(named: "identifier"))).called(1);
      }
    );

    blocTest<PasswordFormBloc, PasswordFormState>(
      "Submitted event changes state: [isSubmitting: true], [isSubmitting: false, errorMessage: exception.error, errorButtonControl: CustomAnimationControl.PLAY_FROM_START]",
      build: () {
        when(() => businessRepository.updatePassword(password: any(named: "password"), passwordConfirmation: any(named: "passwordConfirmation"), identifier: any(named: "identifier")))
          .thenThrow(const ApiException(error: "error"));
        return passwordFormBloc;
      },
      seed: () {
        password = "ndcbJSH2#*!!sjs426HH@23";
        passwordConfirmation = password;
        _baseState = _baseState.update(password: password, passwordConfirmation: passwordConfirmation);
        return _baseState;
      },
      act: (bloc) => bloc.add(const Submitted(identifier: "identifier")),
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, errorMessage: "error", errorButtonControl: CustomAnimationControl.playFromStart)]
    );

    blocTest<PasswordFormBloc, PasswordFormState>(
      "Reset event changes state: [isSuccess: false, errorMessage: "", errorButtonControl: CustomAnimationControl.STOP]",
      build: () => passwordFormBloc,
      seed: () {
        password = "ndcbJSH2#*!!sjs426HH@23";
        passwordConfirmation = password;
        _baseState = _baseState.update(password: password, passwordConfirmation: passwordConfirmation, isSuccess: true, errorMessage: "error", errorButtonControl: CustomAnimationControl.playFromStart);
        return _baseState;
      },
      act: (bloc) => bloc.add(Reset()),
      expect: () => [_baseState.update(isSuccess: false, errorMessage: "", errorButtonControl: CustomAnimationControl.stop)]
    );
  });
}