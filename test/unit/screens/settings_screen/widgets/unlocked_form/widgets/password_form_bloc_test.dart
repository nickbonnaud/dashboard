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
      "PasswordChanged event changes state if confirmation empty: [isPasswordValid: false, isPasswordConfirmationValid: true]",
      build: () => passwordFormBloc,
      wait: Duration(milliseconds: 300),
      act: (bloc) => bloc.add(PasswordChanged(password: "pa", passwordConfirmation: "")),
      expect: () => [_baseState.update(isPasswordValid: false, isPasswordConfirmationValid: true)]
    );

    blocTest<PasswordFormBloc, PasswordFormState>(
      "PasswordChanged event changes state if confirmation is not empty: [isPasswordValid: false, isPasswordConfirmationValid: false]",
      build: () => passwordFormBloc,
      wait: Duration(milliseconds: 300),
      act: (bloc) => bloc.add(PasswordChanged(password: "pa", passwordConfirmation: "pass")),
      expect: () => [_baseState.update(isPasswordValid: false, isPasswordConfirmationValid: false)]
    );

    blocTest<PasswordFormBloc, PasswordFormState>(
      "PasswordConfirmationChanged event changes state: [isPasswordConfirmationValid: false]",
      build: () => passwordFormBloc,
      wait: Duration(milliseconds: 300),
      act: (bloc) => bloc.add(PasswordConfirmationChanged(password: "pass", passwordConfirmation: "pa")),
      expect: () => [_baseState.update(isPasswordConfirmationValid: false)]
    );

    blocTest<PasswordFormBloc, PasswordFormState>(
      "Submitted event changes state: [isSubmitting: true], [isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.STOP]",
      build: () {
        when(() => businessRepository.updatePassword(password: any(named: "password"), passwordConfirmation: any(named: "passwordConfirmation"), identifier: any(named: "identifier")))
          .thenAnswer((invocation) async => true);
        return passwordFormBloc;
      },
      act: (bloc) => bloc.add(Submitted(password: "password", passwordConfirmation: "password", identifier: "identifier")),
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.STOP)]
    );

    blocTest<PasswordFormBloc, PasswordFormState>(
      "Submitted event calls businessRepository.updatePassword()",
      build: () {
        when(() => businessRepository.updatePassword(password: any(named: "password"), passwordConfirmation: any(named: "passwordConfirmation"), identifier: any(named: "identifier")))
          .thenAnswer((invocation) async => true);
        return passwordFormBloc;
      },
      act: (bloc) => bloc.add(Submitted(password: "password", passwordConfirmation: "password", identifier: "identifier")),
      verify: (_) {
        verify(() => businessRepository.updatePassword(password: any(named: "password"), passwordConfirmation: any(named: "passwordConfirmation"), identifier: any(named: "identifier"))).called(1);
      }
    );

    blocTest<PasswordFormBloc, PasswordFormState>(
      "Submitted event changes state: [isSubmitting: true], [isSubmitting: false, errorMessage: exception.error, errorButtonControl: CustomAnimationControl.PLAY_FROM_START]",
      build: () {
        when(() => businessRepository.updatePassword(password: any(named: "password"), passwordConfirmation: any(named: "passwordConfirmation"), identifier: any(named: "identifier")))
          .thenThrow(ApiException(error: "error"));
        return passwordFormBloc;
      },
      act: (bloc) => bloc.add(Submitted(password: "password", passwordConfirmation: "password", identifier: "identifier")),
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, errorMessage: "error", errorButtonControl: CustomAnimationControl.PLAY_FROM_START)]
    );

    blocTest<PasswordFormBloc, PasswordFormState>(
      "Reset event changes state: [isSuccess: false, errorMessage: "", errorButtonControl: CustomAnimationControl.STOP]",
      build: () => passwordFormBloc,
      seed: () => _baseState.update(isSuccess: true, errorMessage: "error", errorButtonControl: CustomAnimationControl.PLAY_FROM_START),
      act: (bloc) => bloc.add(Reset()),
      expect: () => [_baseState.update(isSuccess: false, errorMessage: "", errorButtonControl: CustomAnimationControl.STOP)]
    );
  });
}