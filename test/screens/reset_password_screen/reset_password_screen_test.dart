import 'package:dashboard/repositories/authentication_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/reset_password_screen/reset_password_screen.dart';
import 'package:dashboard/screens/reset_password_screen/widget/reset_password_screen_body.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/screen_builder.dart';

class MockAuthenticationRepository extends Mock implements AuthenticationRepository {}

void main() {
  group("Reset Password Screen Tests", () {
    late AuthenticationRepository authenticationRepository;
    late String token;
    late NavigatorObserver observer;
    late ScreenBuilder screenBuilder;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      token = faker.guid.guid();
      observer = MockNavigatorObserver();
      screenBuilder = ScreenBuilder(
        child: ResetPasswordScreen(
          authenticationRepository: authenticationRepository,
          token: token,
        ),
        observer: observer
      );

      when(() => authenticationRepository.resetPassword(password: any(named: "password"), passwordConfirmation: any(named: "passwordConfirmation"), token: any(named: "token")))
        .thenAnswer((_) async => Future.delayed(Duration(milliseconds: 500), () => true));

      registerFallbackValue(MockRoute());
    });

    testWidgets("Reset Password Screen creates ResetPasswordScreenBody", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byType(ResetPasswordScreenBody), findsOneWidget);
    });

    testWidgets("ResetPasswordScreenBody displays noTokenPresent if token is null", (tester) async {
      screenBuilder = ScreenBuilder(
        child: ResetPasswordScreen(
          authenticationRepository: authenticationRepository,
          token: null,
        ),
        observer: observer
      );
      await screenBuilder.createScreen(tester: tester);

      expect(find.text("Reset Password Token is Invalid."), findsOneWidget);
    });

    testWidgets("ResetPasswordScreenBody displays passwordResetForm if token present", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byKey(Key("passwordResetFormKey")), findsOneWidget);
    });

    testWidgets("ResetPasswordScreenBody creates passwordTextField", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byKey(Key("passwordTextFieldKey")), findsOneWidget);
    });

    testWidgets("PasswordTextField can receive input", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      String password = "jdbGY#mc8352Ljd7&2!md";
      expect(find.text(password), findsNothing);

      await tester.enterText(find.byKey(Key("passwordTextFieldKey")), password);
      await tester.pump();
      expect(find.text(password), findsOneWidget);
    });

    testWidgets("PasswordTextField shows error on invalid input", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      String password = "notvalid";
      expect(find.text("min: 8 characters, 1 uppercase, 1 lowercase, 1 digit, 1 special character"), findsNothing);

      await tester.enterText(find.byKey(Key("passwordTextFieldKey")), password);
      await tester.pump(Duration(milliseconds: 300));
      expect(find.text("min: 8 characters, 1 uppercase, 1 lowercase, 1 digit, 1 special character"), findsOneWidget);
    });

    testWidgets("ResetPasswordScreenBody creates passwordConfirmationTextField", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byKey(Key("passwordConfirmationTextFieldKey")), findsOneWidget);
    });

    testWidgets("passwordConfirmationTextField can receive input", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      String password = "jdbGY#mc8352Ljd7&2!md";
      expect(find.text(password), findsNothing);

      await tester.enterText(find.byKey(Key("passwordConfirmationTextFieldKey")), password);
      await tester.pump();
      expect(find.text(password), findsOneWidget);
    });

    testWidgets("PasswordConfirmationTextField shows error on invalid input", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      String passwordConfirmationTextField = "notValid";
      expect(find.text("Passwords are not matching"), findsNothing);

      await tester.enterText(find.byKey(Key("passwordConfirmationTextFieldKey")), passwordConfirmationTextField);
      await tester.pump(Duration(milliseconds: 300));

      expect(find.text("Passwords are not matching"), findsOneWidget);
    });

    testWidgets("ResetPasswordScreenBody creates submitButton", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byKey(Key("submitButtonKey")), findsOneWidget);
    });

    testWidgets("SubmitButton is disabled on empty form", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(tester.widget<ElevatedButton>(find.byKey(Key("submitButtonKey"))).enabled, false);
    });

    testWidgets("SubmitButton is disabled on invalid form", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      String password = "notvalid";
      
      await tester.enterText(find.byKey(Key("passwordTextFieldKey")), password);
      await tester.pump(Duration(milliseconds: 500));

      await tester.enterText(find.byKey(Key("passwordConfirmationTextFieldKey")), "");
      await tester.pump(Duration(milliseconds: 500));
      await tester.enterText(find.byKey(Key("passwordConfirmationTextFieldKey")), password);
      await tester.pump(Duration(milliseconds: 500));

      expect(tester.widget<ElevatedButton>(find.byKey(Key("submitButtonKey"))).enabled, false);
    });

    testWidgets("SubmitButton is enabled on valid form", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      String password = "jdbGY#mc8352Ljd7&2!md";
      
      await tester.enterText(find.byKey(Key("passwordTextFieldKey")), password);
      await tester.pump(Duration(milliseconds: 500));

      await tester.enterText(find.byKey(Key("passwordConfirmationTextFieldKey")), "");
      await tester.pump(Duration(milliseconds: 500));
      await tester.enterText(find.byKey(Key("passwordConfirmationTextFieldKey")), password);
      await tester.pump(Duration(milliseconds: 500));

      expect(tester.widget<ElevatedButton>(find.byKey(Key("submitButtonKey"))).enabled, true);
    });

    testWidgets("Tapping submitButton shows CircularProgressIndicator", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      String password = "jdbGY#mc8352Ljd7&2!md";
      
      await tester.enterText(find.byKey(Key("passwordTextFieldKey")), password);
      await tester.pump(Duration(milliseconds: 500));

      await tester.enterText(find.byKey(Key("passwordConfirmationTextFieldKey")), "");
      await tester.pump(Duration(milliseconds: 500));
      await tester.enterText(find.byKey(Key("passwordConfirmationTextFieldKey")), password);
      await tester.pump(Duration(milliseconds: 500));

      await tester.drag(find.byType(SingleChildScrollView), Offset(0, -500));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      await tester.tap(find.byKey(Key("submitButtonKey")));
      await tester.pump(Duration(milliseconds: 250));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump(Duration(seconds: 4));
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets("Tapping submitButton shows toast on success", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      String password = "jdbGY#mc8352Ljd7&2!md";
      
      await tester.enterText(find.byKey(Key("passwordTextFieldKey")), password);
      await tester.pump(Duration(milliseconds: 500));

      await tester.enterText(find.byKey(Key("passwordConfirmationTextFieldKey")), "");
      await tester.pump(Duration(milliseconds: 500));
      await tester.enterText(find.byKey(Key("passwordConfirmationTextFieldKey")), password);
      await tester.pump(Duration(milliseconds: 500));

      await tester.drag(find.byType(SingleChildScrollView), Offset(0, -500));
      await tester.pump();

      expect(find.text("Password Successfully Changed!"), findsNothing);
      await tester.tap(find.byKey(Key("submitButtonKey")));
      await tester.pump(Duration(milliseconds: 500));

      expect(find.text("Password Successfully Changed!"), findsOneWidget);

      await tester.pump(Duration(seconds: 4));
      expect(find.text("Password Successfully Changed!"), findsNothing);
    });

    testWidgets("Tapping submitButton pops nav on success", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      String password = "jdbGY#mc8352Ljd7&2!md";
      
      await tester.enterText(find.byKey(Key("passwordTextFieldKey")), password);
      await tester.pump(Duration(milliseconds: 500));

      await tester.enterText(find.byKey(Key("passwordConfirmationTextFieldKey")), "");
      await tester.pump(Duration(milliseconds: 500));
      await tester.enterText(find.byKey(Key("passwordConfirmationTextFieldKey")), password);
      await tester.pump(Duration(milliseconds: 500));

      await tester.drag(find.byType(SingleChildScrollView), Offset(0, -500));
      await tester.pump();

      await tester.tap(find.byKey(Key("submitButtonKey")));
      await tester.pump(Duration(milliseconds: 500));
      
      await tester.pump(Duration(seconds: 4));
      verify(() => observer.didPush(any(), any()));
    });

    testWidgets("Tapping submitButton on error shows error message", (tester) async {
      when(() => authenticationRepository.resetPassword(password: any(named: "password"), passwordConfirmation: any(named: "passwordConfirmation"), token: any(named: "token")))
        .thenThrow(ApiException(error: "An error Occurred!"));
      
      await screenBuilder.createScreen(tester: tester);
      String password = "jdbGY#mc8352Ljd7&2!md";
      
      await tester.enterText(find.byKey(Key("passwordTextFieldKey")), password);
      await tester.pump(Duration(milliseconds: 500));

      await tester.enterText(find.byKey(Key("passwordConfirmationTextFieldKey")), "");
      await tester.pump(Duration(milliseconds: 500));
      await tester.enterText(find.byKey(Key("passwordConfirmationTextFieldKey")), password);
      await tester.pump(Duration(milliseconds: 500));

      await tester.drag(find.byType(SingleChildScrollView), Offset(0, -500));
      await tester.pump();

      expect(find.text("An error Occurred!"), findsNothing);
      
      await tester.tap(find.byKey(Key("submitButtonKey")));
      await tester.pumpAndSettle();
      expect(find.text("An error Occurred!"), findsOneWidget);
      
      await tester.pump(Duration(seconds: 3));
      expect(find.text("An error Occurred!"), findsNothing);
    });
  });
}