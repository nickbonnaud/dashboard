import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/models/business/business.dart';
import 'package:dashboard/repositories/business_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/settings_screen/widget/widgets/unlocked_form/widgets/email_form/bloc/email_form_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simple_animations/simple_animations.dart';

class MockBusinessRepository extends Mock implements BusinessRepository {}
class MockBusinessBloc extends Mock implements BusinessBloc {}
class MockBusiness extends Mock implements Business {}
class MockEmailUpdated extends Mock implements EmailUpdated {}

void main() {
  group("Email Form Bloc Tests", () {
    late BusinessRepository businessRepository;
    late BusinessBloc businessBloc;
    late EmailFormBloc emailFormBloc;

    late EmailFormState _baseState;

    setUp(() {
      businessRepository = MockBusinessRepository();
      businessBloc = MockBusinessBloc();
      emailFormBloc = EmailFormBloc(businessRepository: businessRepository, businessBloc: businessBloc);

      _baseState = emailFormBloc.state;

      registerFallbackValue<BusinessEvent>(MockEmailUpdated());
    });

    tearDown(() {
      emailFormBloc.close();
    });

    test("Initial state of EmailFormBloc is EmailFormState.initial()", () {
      expect(emailFormBloc.state, EmailFormState.initial());
    });

    blocTest<EmailFormBloc, EmailFormState>(
      "EmailChanged event changes state: [isEmailValid: false]",
      build: () => emailFormBloc,
      wait: Duration(milliseconds: 300),
      act: (bloc) => bloc.add(EmailChanged(email: "notEmail")),
      expect: () => [_baseState.update(isEmailValid: false)]
    );

    blocTest<EmailFormBloc, EmailFormState>(
      "Submitted event changes state: [isSubmitting: true], [isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.STOP]",
      build: () {
        when(() => businessRepository.updateEmail(email: any(named: "email"), identifier: any(named: "identifier")))
          .thenAnswer((_) async => "new.email@gmail.com");
        when(() => businessBloc.add(any(that: isA<EmailUpdated>()))).thenReturn(null);
        return emailFormBloc;
      },
      act: (bloc) => bloc.add(Submitted(email: "email", identifier: "identifier")),
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.STOP)]
    );

    blocTest<EmailFormBloc, EmailFormState>(
      "Submitted event calls businessRepository.updateEmail()",
      build: () {
        when(() => businessRepository.updateEmail(email: any(named: "email"), identifier: any(named: "identifier")))
          .thenAnswer((_) async => "new.email@gmail.com");
        when(() => businessBloc.add(any(that: isA<EmailUpdated>()))).thenReturn(null);
        return emailFormBloc;
      },
      act: (bloc) => bloc.add(Submitted(email: "email", identifier: "identifier")),
      verify: (_) {
        verify(() => businessRepository.updateEmail(email: any(named: "email"), identifier: any(named: "identifier"))).called(1);
      }
    );

    blocTest<EmailFormBloc, EmailFormState>(
      "Submitted event calls businessBloc.add()",
      build: () {
        when(() => businessRepository.updateEmail(email: any(named: "email"), identifier: any(named: "identifier")))
          .thenAnswer((_) async => "new.email@gmail.com");
        when(() => businessBloc.add(any(that: isA<EmailUpdated>()))).thenReturn(null);
        return emailFormBloc;
      },
      act: (bloc) => bloc.add(Submitted(email: "email", identifier: "identifier")),
      verify: (_) {
        verify(() => businessBloc.add(any(that: isA<EmailUpdated>()))).called(1);
      }
    );

    blocTest<EmailFormBloc, EmailFormState>(
      "Submitted event on error changes state: [isSubmitting: true], [isSubmitting: false, errorMessage: exception.error, errorButtonControl: CustomAnimationControl.PLAY_FROM_START]",
      build: () {
        when(() => businessRepository.updateEmail(email: any(named: "email"), identifier: any(named: "identifier")))
          .thenThrow(ApiException(error: "error"));
        return emailFormBloc;
      },
      act: (bloc) => bloc.add(Submitted(email: "email", identifier: "identifier")),
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, errorMessage: "error", errorButtonControl: CustomAnimationControl.PLAY_FROM_START)]
    );

    blocTest<EmailFormBloc, EmailFormState>(
      "Reset event changes state: [isSuccess: false, errorMessage: "", errorButtonControl: CustomAnimationControl.STOP]",
      build: () => emailFormBloc,
      act: (bloc) => bloc.add(Reset()),
      expect: () => [_baseState.update(isSuccess: false, errorMessage: "", errorButtonControl: CustomAnimationControl.STOP)]
    );
  });
}