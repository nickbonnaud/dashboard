import 'package:dashboard/repositories/authentication_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/request_reset_password_screen/request_reset_password_screen.dart';
import 'package:dashboard/screens/request_reset_password_screen/widgets/request_reset_password_screen_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/screen_builder.dart';

class MockAuthenticationRepository extends Mock implements AuthenticationRepository {}

void main() {
  group("Request Reset Password Screen Tests", () {
    late AuthenticationRepository authenticationRepository;
    late NavigatorObserver observer;
    late ScreenBuilder screenBuilder;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      observer = MockNavigatorObserver();
      screenBuilder = ScreenBuilder(
        child: RepositoryProvider(
          create: (_) => authenticationRepository,
          child: const RequestResetPasswordScreen(),
        ),
        observer: observer
      );
      
      when(() => authenticationRepository.requestPasswordReset(email: any(named: "email")))
        .thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 500), () => true));

      registerFallbackValue(MockRoute());
    });

    testWidgets("Request Reset Password Screen creates Appbar", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets("Request Reset Password Screen creates RequestResetPasswordScreenBody", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byType(RequestResetPasswordScreenBody), findsOneWidget);
    });

    testWidgets("Request Reset Password Screen creates Email TextField", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byKey(const Key("emailTextFieldKey")), findsOneWidget);
    });

    testWidgets("Email TextField can receive input", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      String email = "nick@gmail.com";
      expect(find.text(email), findsNothing);
      
      await tester.enterText(find.byKey(const Key("emailTextFieldKey")), email);
      await tester.pump();
      expect(find.text(email), findsOneWidget);
    });

    testWidgets("Email TextField shows error on invalid input", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      String email = "not_an_!mail.com";
      expect(find.text('Invalid Email'), findsNothing);
      await tester.enterText(find.byKey(const Key("emailTextFieldKey")), email);
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Invalid Email'), findsOneWidget);
    });

    testWidgets("Request Reset Password Screen creates submitButton", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byKey(const Key("submitButtonKey")), findsOneWidget);
    });

    testWidgets("SubmitButton is disabled on empty form", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(tester.widget<ElevatedButton>(find.byKey(const Key("submitButtonKey"))).enabled, false);
    });

    testWidgets("SubmitButton is disabled on invalid form", (tester) async {
      await screenBuilder.createScreen(tester: tester);

      await tester.enterText(find.byKey(const Key("emailTextFieldKey")), "not_an_!mail.com");
      await tester.pump(const Duration(milliseconds: 500));

      expect(tester.widget<ElevatedButton>(find.byKey(const Key("submitButtonKey"))).enabled, false);
    });

    testWidgets("SubmitButton is enabled on valid form", (tester) async {
      await screenBuilder.createScreen(tester: tester);

      await tester.enterText(find.byKey(const Key("emailTextFieldKey")), "nick@gmail.com");
      await tester.pump(const Duration(milliseconds: 500));

      expect(tester.widget<ElevatedButton>(find.byKey(const Key("submitButtonKey"))).enabled, true);
    });

    testWidgets("Tapping submitButton shows CircularProgressIndicator", (tester) async {
      await screenBuilder.createScreen(tester: tester);

      await tester.enterText(find.byKey(const Key("emailTextFieldKey")), "nick@gmail.com");
      await tester.pump(const Duration(milliseconds: 500));

      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -500));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);

      await tester.tap(find.byKey(const Key("submitButtonKey")));
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.byType(CircularProgressIndicator), findsNothing);
      await tester.pump(const Duration(seconds: 4));
    });

    testWidgets("Tapping submitButton shows Toast on success", (tester) async {
      await screenBuilder.createScreen(tester: tester);

      await tester.enterText(find.byKey(const Key("emailTextFieldKey")), "nick@gmail.com");
      await tester.pump(const Duration(milliseconds: 500));

      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -500));
      await tester.pump();

      expect(find.text("Reset Password Email Sent."), findsNothing);

      await tester.tap(find.byKey(const Key("submitButtonKey")));
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text("Reset Password Email Sent."), findsOneWidget);
      await tester.pump(const Duration(seconds: 4));
      expect(find.text("Reset Password Email Sent."), findsNothing);
    });

    testWidgets("Tapping submitButton pops nav on success", (tester) async {
      await screenBuilder.createScreen(tester: tester);

      await tester.enterText(find.byKey(const Key("emailTextFieldKey")), "nick@gmail.com");
      await tester.pump(const Duration(milliseconds: 500));

      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -500));
      await tester.pump();

      await tester.tap(find.byKey(const Key("submitButtonKey")));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(seconds: 4));
      verify(() => observer.didPush(any(), any()));
    });

    testWidgets("Tapping submitButton on error shows error message", (tester) async {
      when(() => authenticationRepository.requestPasswordReset(email: any(named: "email")))
        .thenThrow(const ApiException(error: "An error Happened!"));
      
      await screenBuilder.createScreen(tester: tester);

      await tester.enterText(find.byKey(const Key("emailTextFieldKey")), "nick@gmail.com");
      await tester.pump(const Duration(milliseconds: 500));

      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -500));
      await tester.pump();

      expect(find.text("An error Happened!"), findsNothing);
      
      await tester.tap(find.byKey(const Key("submitButtonKey")));
      await tester.pumpAndSettle();
      expect(find.text("An error Happened!"), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));
      expect(find.text("An error Happened!"), findsNothing);
    });

    testWidgets("Tapping goToLoginButton pushes nav", (tester) async {
      await screenBuilder.createScreen(tester: tester);

      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -500));
      await tester.pump();

      await tester.tap(find.byKey(const Key("goToLoginButtonKey")));
      await tester.pumpAndSettle();
      verify(() => observer.didPush(any(), any()));
    });
  });
}