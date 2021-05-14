import 'package:dashboard/blocs/authentication/authentication_bloc.dart';
import 'package:dashboard/models/business/business.dart';
import 'package:dashboard/repositories/authentication_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/login_screen/login_screen.dart';
import 'package:dashboard/screens/login_screen/widgets/login_card.dart';
import 'package:dashboard/screens/login_screen/widgets/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/screen_builder.dart';

class MockAuthenticationRepository extends Mock implements AuthenticationRepository {}
class MockAuthenticationBloc extends Mock implements AuthenticationBloc {}
class MockBusiness extends Mock implements Business {}

void main() {
  group("Login Screen Tests", () {
    late AuthenticationRepository authenticationRepository;
    late AuthenticationBloc authenticationBloc;
    late NavigatorObserver observer;
    late ScreenBuilder screenBuilder;
    
    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      authenticationBloc = MockAuthenticationBloc();
      observer = MockNavigatorObserver();
      screenBuilder = ScreenBuilder(
        child: LoginScreen(authenticationRepository: authenticationRepository, authenticationBloc: authenticationBloc),
        observer: observer
      );

      registerFallbackValue<AuthenticationEvent>(LoggedIn(business: MockBusiness()));

      when(() => authenticationRepository.login(email: any(named: "email"), password: any(named: "password")))
        .thenAnswer((_) async => Future.delayed(Duration(milliseconds: 500), () => MockBusiness()));

      when(() => authenticationBloc.add(any(that: isA<AuthenticationEvent>())))
        .thenReturn(null);

      registerFallbackValue<Route>(MockRoute());
    });

    testWidgets("Login Screen creates LoginCard", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byType(LoginCard), findsOneWidget);
    });

    testWidgets("Login Screen creates LoginForm", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byType(LoginForm), findsOneWidget);
    });

    testWidgets("LoginForm creates Email TextField", (tester) async {
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

    testWidgets("Email TextField shows error on invalid error", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      String email = "not_an_!mail.com";
      expect(find.text("Invalid email"), findsNothing);
      await tester.enterText(find.byKey(Key("emailTextFieldKey")), email);
      await tester.pump(Duration(milliseconds: 300));
      expect(find.text("Invalid email"), findsOneWidget);
    });

    testWidgets("LoginForm creates Password TextField", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byKey(Key("passwordTextFieldKey")), findsOneWidget);
    });

    testWidgets("Password TextField can receive input", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      String password = "nfodjPc5!@bnc5M";
      expect(tester.widget<TextFormField>(find.byKey(Key("passwordTextFieldKey"))).controller!.text.isEmpty, true);
      await tester.enterText(find.byKey(Key("passwordTextFieldKey")), password);
      await tester.pump();
      expect(tester.widget<TextFormField>(find.byKey(Key("passwordTextFieldKey"))).controller!.text.isEmpty, false);
    });

    testWidgets("Password TextField shows error on invalid input", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      String password = "1a";
      expect(find.text("Invalid Password"), findsNothing);
      await tester.enterText(find.byKey(Key("passwordTextFieldKey")), password);
      await tester.pump(Duration(milliseconds: 300));
      expect(find.text("Invalid Password"), findsOneWidget);
    });

    testWidgets("LoginForm creates SubmitButton", (tester) async {
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
      await tester.pump(Duration(milliseconds: 400));

      await tester.enterText(find.byKey(Key("passwordTextFieldKey")), "1a");
      await tester.pump(Duration(milliseconds: 400));

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

      expect(tester.widget<ElevatedButton>(find.byKey(Key("submitButtonKey"))).enabled, true);
    });

    testWidgets("Tapping SubmitButton shows CircularProgressIndicator", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      
      await tester.enterText(find.byKey(Key("emailTextFieldKey")), "nick@gmail.com");
      await tester.pump(Duration(milliseconds: 500));

      await tester.enterText(find.byKey(Key("passwordTextFieldKey")), "");
      await tester.pump(Duration(milliseconds: 500));

      await tester.enterText(find.byKey(Key("passwordTextFieldKey")), "nfodjPc5!@bnc5M");
      await tester.pump(Duration(milliseconds: 500));

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

      await tester.tap(find.byKey(Key("submitButtonKey")));
      await tester.pump(Duration(milliseconds: 500));
      verify(() => observer.didPush(any(), any()));
    });

    testWidgets("Tapping SubmitButton on error shows error message", (tester) async {
      when(() => authenticationRepository.login(email: any(named: "email"), password: any(named: "password")))
        .thenThrow(ApiException(error: "An Error Happened!"));

      await screenBuilder.createScreen(tester: tester);
      
      await tester.enterText(find.byKey(Key("emailTextFieldKey")), "nick@gmail.com");
      await tester.pump(Duration(milliseconds: 500));

      await tester.enterText(find.byKey(Key("passwordTextFieldKey")), "");
      await tester.pump(Duration(milliseconds: 500));

      await tester.enterText(find.byKey(Key("passwordTextFieldKey")), "nfodjPc5!@bnc5M");
      await tester.pump(Duration(milliseconds: 500));

      expect(find.text("An Error Happened!"), findsNothing);
      await tester.tap(find.byKey(Key("submitButtonKey")));
      await tester.pumpAndSettle();
      expect(find.text("An Error Happened!"), findsOneWidget);
      await tester.pump(Duration(seconds: 3));
      expect(find.text("An Error Happened!"), findsNothing);
    });

    testWidgets("Tapping GoToRegisterButton pushes nav", (tester) async {
      await screenBuilder.createScreen(tester: tester);

      await tester.drag(find.byKey(Key("scrollKey")), Offset(0, -500));
      await tester.pumpAndSettle();
      
      await tester.tap(find.byKey(Key("goToRegisterButtonKey")));
      await tester.pumpAndSettle();
      verify(() => observer.didPush(any(), any()));
    });

    testWidgets("Tapping ResetPasswordButton pushes nav", (tester) async {
      await screenBuilder.createScreen(tester: tester);

      await tester.drag(find.byKey(Key("scrollKey")), Offset(0, -500));
      await tester.pumpAndSettle();
      
      await tester.tap(find.byKey(Key("resetPasswordButtonKey")));
      await tester.pumpAndSettle();
      verify(() => observer.didPush(any(), any()));
    });
  });
}