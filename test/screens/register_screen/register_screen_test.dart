import 'package:dashboard/blocs/authentication/authentication_bloc.dart';
import 'package:dashboard/models/business/business.dart';
import 'package:dashboard/repositories/authentication_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/register_screen/register_screen.dart';
import 'package:dashboard/screens/register_screen/widgets/register_card.dart';
import 'package:dashboard/screens/register_screen/widgets/widgets/register_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/screen_builder.dart';

class MockAuthenticationRepository extends Mock implements AuthenticationRepository {}
class MockAuthenticationBloc extends Mock implements AuthenticationBloc {}
class MockBusiness extends Mock implements Business {}

void main() {
  group("Register Screen Tests", () {
    late AuthenticationRepository authenticationRepository;
    late AuthenticationBloc authenticationBloc;
    late NavigatorObserver observer;
    late ScreenBuilder screenBuilder;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      authenticationBloc = MockAuthenticationBloc();
      observer = MockNavigatorObserver();
      screenBuilder = ScreenBuilder(
        child: RegisterScreen(authenticationRepository: authenticationRepository, authenticationBloc: authenticationBloc),
        observer: observer
      );

      registerFallbackValue<AuthenticationEvent>(LoggedIn(business: MockBusiness()));
      
      when(() => authenticationRepository.register(email: any(named: "email"), password: any(named: "password"), passwordConfirmation: any(named: "passwordConfirmation")))
        .thenAnswer((_) async => Future.delayed(Duration(milliseconds: 500), () => MockBusiness()));

      when(() => authenticationBloc.add(any(that: isA<AuthenticationEvent>())))
        .thenReturn(null);

      registerFallbackValue<Route>(MockRoute());
    });

    testWidgets("Register Screen creates RegisterCard", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byType(RegisterCard), findsOneWidget);
    });

    testWidgets("RegisterCard creates RegisterForm", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byType(RegisterForm), findsOneWidget);
    });

    testWidgets("Register Form creates Email TextField", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byKey(Key("emailTextFieldKey")), findsOneWidget);
    });

    testWidgets("Email TextField can receive input", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      String email = "nick@gmail.com";
      expect(find.text(email), findsNothing);
      await tester.enterText(find.byKey(Key("emailTextFieldKey")), email);
      await tester.pump();
      expect(find.text(email), findsOneWidget);
    });

    testWidgets("Email TextField shows error on invalid input", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      String email = "not_an_!mail.com";
      expect(find.text("Invalid email"), findsNothing);
      await tester.enterText(find.byKey(Key("emailTextFieldKey")), email);
      await tester.pump(Duration(milliseconds: 300));
      expect(find.text("Invalid email"), findsOneWidget);
    });

    testWidgets("Register Form creates Password TextField", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byKey(Key("passwordTextFieldKey")), findsOneWidget);
    });

    testWidgets("Password TextField can receive input", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      String password = "nfodjPc5!@bnc5M";
      expect(find.text(password), findsNothing);
      await tester.enterText(find.byKey(Key("passwordTextFieldKey")), password);
      await tester.pump();
      expect(find.text(password), findsOneWidget);
    });

    testWidgets("Password TextField shows error on invalid input", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      String password = "1a";
      expect(find.text('min: 8 characters, 1 uppercase, 1 lowercase, 1 digit, 1 special character'), findsNothing);
      await tester.enterText(find.byKey(Key("passwordTextFieldKey")), password);
      await tester.pump(Duration(milliseconds: 300));
      expect(find.text('min: 8 characters, 1 uppercase, 1 lowercase, 1 digit, 1 special character'), findsOneWidget);
    });

    testWidgets("Register Form creates PasswordConfirmation TextField", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byKey(Key("passwordConfirmationTextFieldKey")), findsOneWidget);
    });

    testWidgets("PasswordConfirmation TextField can receive input", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      String password = "nfodjPc5!@bnc5M";
      expect(find.text(password), findsNothing);
      await tester.enterText(find.byKey(Key("passwordConfirmationTextFieldKey")), password);
      await tester.pump();
      expect(find.text(password), findsOneWidget);
    });

    testWidgets("Password Confirmation TextField shows error on invalid input", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      String password = "1a";
      expect(find.text("Passwords are not matching"), findsNothing);
      await tester.enterText(find.byKey(Key("passwordConfirmationTextFieldKey")), password);
      await tester.pump(Duration(milliseconds: 300));
      expect(find.text("Passwords are not matching"), findsOneWidget);
    });

    testWidgets("Register Form creates submitButton", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byKey(Key("submitButtonKey")), findsOneWidget);
    });

    testWidgets("SubmitButton is disabled on empty form", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(tester.widget<ElevatedButton>(find.byKey(Key("submitButtonKey"))).enabled, false);
    });

    testWidgets("SubmitButton is disabled on invalid form", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      
      await tester.enterText(find.byKey(Key("emailTextFieldKey")), "not_an_!mail.com");
      await tester.pump(Duration(milliseconds: 500));

      await tester.enterText(find.byKey(Key("passwordTextFieldKey")), "1a");
      await tester.pump(Duration(milliseconds: 500));

      await tester.enterText(find.byKey(Key("passwordConfirmationTextFieldKey")), "k99");
      await tester.pump(Duration(milliseconds: 500));

      expect(tester.widget<ElevatedButton>(find.byKey(Key("submitButtonKey"))).enabled, false);
    });

    testWidgets("SubmitButton is enabled on valid form", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      
      await tester.enterText(find.byKey(Key("emailTextFieldKey")), "nick@gmail.com");
      await tester.pump(Duration(milliseconds: 500));

      await tester.enterText(find.byKey(Key("passwordTextFieldKey")), "");
      await tester.pump(Duration(milliseconds: 500));

      await tester.enterText(find.byKey(Key("passwordTextFieldKey")), "nfodjPc5!@bnc5M");
      await tester.pump(Duration(milliseconds: 500));

      await tester.enterText(find.byKey(Key("passwordConfirmationTextFieldKey")), "");
      await tester.pump(Duration(milliseconds: 500));

      await tester.enterText(find.byKey(Key("passwordConfirmationTextFieldKey")), "nfodjPc5!@bnc5M");
      await tester.pump(Duration(milliseconds: 500));

      expect(tester.widget<ElevatedButton>(find.byKey(Key("submitButtonKey"))).enabled, true);
    });

    testWidgets("Tapping submitButton shows CircularProgressIndicator", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      
      await tester.enterText(find.byKey(Key("emailTextFieldKey")), "nick@gmail.com");
      await tester.pump(Duration(milliseconds: 500));

      await tester.enterText(find.byKey(Key("passwordTextFieldKey")), "");
      await tester.pump(Duration(milliseconds: 500));

      await tester.enterText(find.byKey(Key("passwordTextFieldKey")), "nfodjPc5!@bnc5M");
      await tester.pump(Duration(milliseconds: 500));

      await tester.enterText(find.byKey(Key("passwordConfirmationTextFieldKey")), "");
      await tester.pump(Duration(milliseconds: 500));

      await tester.enterText(find.byKey(Key("passwordConfirmationTextFieldKey")), "nfodjPc5!@bnc5M");
      await tester.pump(Duration(milliseconds: 500));

      await tester.drag(find.byType(SingleChildScrollView), Offset(0, -500));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      await tester.tap(find.byKey(Key("submitButtonKey")));
      await tester.pump(Duration(milliseconds: 250));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump(Duration(milliseconds: 250));
    });

    testWidgets("Tapping SubmitButton pushes nav on success", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      
      await tester.enterText(find.byKey(Key("emailTextFieldKey")), "nick@gmail.com");
      await tester.pump(Duration(milliseconds: 500));

      await tester.enterText(find.byKey(Key("passwordTextFieldKey")), "");
      await tester.pump(Duration(milliseconds: 500));

      await tester.enterText(find.byKey(Key("passwordTextFieldKey")), "nfodjPc5!@bnc5M");
      await tester.pump(Duration(milliseconds: 500));

      await tester.enterText(find.byKey(Key("passwordConfirmationTextFieldKey")), "");
      await tester.pump(Duration(milliseconds: 500));

      await tester.enterText(find.byKey(Key("passwordConfirmationTextFieldKey")), "nfodjPc5!@bnc5M");
      await tester.pump(Duration(milliseconds: 500));

      await tester.drag(find.byType(SingleChildScrollView), Offset(0, -500));
      await tester.pump();

      await tester.tap(find.byKey(Key("submitButtonKey")));
      await tester.pump(Duration(milliseconds: 500));
      verify(() => observer.didPush(any(), any()));
    });

    testWidgets("Tapping SubmitButton on error shows errror message", (tester) async {
      when(() => authenticationRepository.register(email: any(named: "email"), password: any(named: "password"), passwordConfirmation: any(named: "passwordConfirmation")))
        .thenThrow(ApiException(error: "An Error Happened!"));
      
      await screenBuilder.createScreen(tester: tester);
      
      await tester.enterText(find.byKey(Key("emailTextFieldKey")), "nick@gmail.com");
      await tester.pump(Duration(milliseconds: 500));

      await tester.enterText(find.byKey(Key("passwordTextFieldKey")), "");
      await tester.pump(Duration(milliseconds: 500));

      await tester.enterText(find.byKey(Key("passwordTextFieldKey")), "nfodjPc5!@bnc5M");
      await tester.pump(Duration(milliseconds: 500));

      await tester.enterText(find.byKey(Key("passwordConfirmationTextFieldKey")), "");
      await tester.pump(Duration(milliseconds: 500));

      await tester.enterText(find.byKey(Key("passwordConfirmationTextFieldKey")), "nfodjPc5!@bnc5M");
      await tester.pump(Duration(milliseconds: 500));

      await tester.drag(find.byType(SingleChildScrollView), Offset(0, -500));
      await tester.pump();

      expect(find.text("An Error Happened!"), findsNothing);
      await tester.tap(find.byKey(Key("submitButtonKey")));
      await tester.pumpAndSettle();
      expect(find.text("An Error Happened!"), findsOneWidget);
      await tester.pump(Duration(seconds: 3));
      expect(find.text("An Error Happened!"), findsNothing);
    });

    testWidgets("Tapping goToLoginButton pushes nav", (tester) async {
      await screenBuilder.createScreen(tester: tester);

      await tester.drag(find.byType(SingleChildScrollView), Offset(0, -500));
      await tester.pump();

      await tester.tap(find.byKey(Key("goToLoginButtonKey")));
      await tester.pumpAndSettle();
      verify(() => observer.didPush(any(), any()));
    });
  });
}