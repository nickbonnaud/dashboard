import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/global_widgets/app_bars/default_app_bar.dart';
import 'package:dashboard/models/business/business.dart';
import 'package:dashboard/repositories/authentication_repository.dart';
import 'package:dashboard/repositories/business_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/settings_screen/settings_screen.dart';
import 'package:dashboard/screens/settings_screen/widget/settings_screen_body.dart';
import 'package:dashboard/screens/settings_screen/widget/widgets/unlocked_form/unlocked_form.dart';
import 'package:dashboard/screens/settings_screen/widget/widgets/unlocked_form/widgets/email_form/email_form.dart';
import 'package:dashboard/screens/settings_screen/widget/widgets/unlocked_form/widgets/password_form/password_form.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/screen_builder.dart';

class MockAuthenticationRepository extends Mock implements AuthenticationRepository {}
class MockBusinessBloc extends Mock implements BusinessBloc {}
class MockBusinessRepository extends Mock implements BusinessRepository {}
class MockBusiness extends Mock implements Business {}
class MockBusinessEvent extends Mock implements BusinessEvent {}

void main() {
  group("Settings Screen Tests", () {
    late AuthenticationRepository authenticationRepository;
    late BusinessBloc businessBloc;
    late BusinessRepository businessRepository;
    late NavigatorObserver observer;
    late ScreenBuilder screenBuilder;

    late Business business;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      businessBloc = MockBusinessBloc();
      businessRepository = MockBusinessRepository();
      observer = MockNavigatorObserver();

      business = MockBusiness();
      when(() => business.email).thenReturn(faker.internet.email());
      when(() => business.identifier).thenReturn(faker.guid.guid());
      when(() => businessBloc.business).thenReturn(business);

      screenBuilder = ScreenBuilder(
        child: SettingsScreen(
          authenticationRepository: authenticationRepository,
          businessBloc: businessBloc,
          businessRepository: businessRepository,
        ),
        observer: observer
      );

      when(() => authenticationRepository.verifyPassword(password: any(named: "password")))
        .thenAnswer((_) async => Future.delayed(Duration(milliseconds: 500), () => true));

      when(() => businessRepository.updateEmail(email: any(named: "email"), identifier: any(named: "identifier")))
        .thenAnswer((_) async => Future.delayed(Duration(milliseconds: 500), () => faker.internet.email()));

      when(() => businessRepository.updatePassword(password: any(named: "password"), passwordConfirmation: any(named: "passwordConfirmation"), identifier: any(named: "identifier")))
        .thenAnswer((_) async => Future.delayed(Duration(milliseconds: 500), () => true));

      registerFallbackValue(MockBusinessEvent());
      
      when(() => businessBloc.add(any(that: isA<BusinessEvent>())))
        .thenReturn(null);

      registerFallbackValue(MockRoute());
    });

    testWidgets("Settings Screen creates DefaultAppBar", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byType(DefaultAppBar), findsOneWidget);
    });

    testWidgets("Settings Screen creates SettingsScreenBody", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byType(SettingsScreenBody), findsOneWidget);
    });

    testWidgets("Locked Form creates unlockPasswordField", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byKey(Key("unlockPasswordTextFieldKey")), findsOneWidget);
    });

    testWidgets("Unlock Password Field can receive input", (tester) async {
      await screenBuilder.createScreen(tester: tester);

      String password = "hcfJgfhFDH@#3469*bnN";
      expect(find.text(password), findsNothing);

      await tester.enterText(find.byKey(Key("unlockPasswordTextFieldKey")), password);
      await tester.pump();

      expect(find.text(password), findsOneWidget);
    });

    testWidgets("Unlock Password Field displays error on invalid input", (tester) async {
      await screenBuilder.createScreen(tester: tester);

      String password = "notvalid";
      expect(find.text("Invalid Password"), findsNothing);

      await tester.enterText(find.byKey(Key("unlockPasswordTextFieldKey")), password);
      await tester.pump(Duration(milliseconds: 300));

      expect(find.text("Invalid Password"), findsOneWidget);
    });

    testWidgets("Locked Form creates unlockButton", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byKey(Key("unlockButtonKey")), findsOneWidget);
    });

    testWidgets("Unlock Button is disabled on empty form", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(tester.widget<ElevatedButton>(find.byKey(Key("unlockButtonKey"))).enabled, false);
    });

    testWidgets("Unlock Button is disabled on invalid form", (tester) async {
      await screenBuilder.createScreen(tester: tester);

      await tester.enterText(find.byKey(Key("unlockPasswordTextFieldKey")), "notvalid");
      await tester.pump(Duration(milliseconds: 500));

      expect(tester.widget<ElevatedButton>(find.byKey(Key("unlockButtonKey"))).enabled, false);
    });

    testWidgets("Unlock Button is enabled on valid form", (tester) async {
      await screenBuilder.createScreen(tester: tester);

      await tester.enterText(find.byKey(Key("unlockPasswordTextFieldKey")), "hcfJgfhFDH@#3469*bnN");
      await tester.pump(Duration(milliseconds: 500));

      expect(tester.widget<ElevatedButton>(find.byKey(Key("unlockButtonKey"))).enabled, true);
    });

    testWidgets("Tapping unlockButton displays CircularProgressIndicator", (tester) async {
      await screenBuilder.createScreen(tester: tester);

      await tester.enterText(find.byKey(Key("unlockPasswordTextFieldKey")), "hcfJgfhFDH@#3469*bnN");
      await tester.pump(Duration(milliseconds: 500));

      expect(find.byType(CircularProgressIndicator), findsNothing);

      await tester.tap(find.byKey(Key("unlockButtonKey")));
      await tester.pump(Duration(milliseconds: 250));
      
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump(Duration(milliseconds: 250));
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets("Tapping unlockButton on error shows errorMessage", (tester) async {
      when(() => authenticationRepository.verifyPassword(password: any(named: "password")))
        .thenThrow(ApiException(error: "An Error Happened!"));
      
      await screenBuilder.createScreen(tester: tester);

      await tester.enterText(find.byKey(Key("unlockPasswordTextFieldKey")), "hcfJgfhFDH@#3469*bnN");
      await tester.pump(Duration(milliseconds: 500));

      expect(find.text("An Error Happened!"), findsNothing);
      
      await tester.tap(find.byKey(Key("unlockButtonKey")));
      await tester.pumpAndSettle();
      expect(find.text("An Error Happened!"), findsOneWidget);
      
      await tester.pump(Duration(seconds: 3));
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets("Tapping unlockButton on Success hides LockedForm", (tester) async {
      await screenBuilder.createScreen(tester: tester);

      expect(find.byType(UnlockedForm), findsNothing);
      
      await tester.enterText(find.byKey(Key("unlockPasswordTextFieldKey")), "hcfJgfhFDH@#3469*bnN");
      await tester.pump(Duration(milliseconds: 500));

      await tester.tap(find.byKey(Key("unlockButtonKey")));
      await tester.pump(Duration(milliseconds: 500));
      
      expect(find.byType(UnlockedForm), findsOneWidget);
    });

    testWidgets("Email Form creates emailField", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      await tester.enterText(find.byKey(Key("unlockPasswordTextFieldKey")), "hcfJgfhFDH@#3469*bnN");
      await tester.pump(Duration(milliseconds: 500));
      await tester.tap(find.byKey(Key("unlockButtonKey")));
      await tester.pump(Duration(milliseconds: 500));


      expect(find.byKey(Key("emailTextFieldKey")), findsOneWidget);
    });

    testWidgets("Email Field can receive input", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      await tester.enterText(find.byKey(Key("unlockPasswordTextFieldKey")), "hcfJgfhFDH@#3469*bnN");
      await tester.pump(Duration(milliseconds: 500));
      await tester.tap(find.byKey(Key("unlockButtonKey")));
      await tester.pump(Duration(milliseconds: 500));


      String email = faker.internet.email();
      expect(find.text(email), findsNothing);

      await tester.enterText(find.byKey(Key("emailTextFieldKey")), email);
      await tester.pump();

      expect(find.text(email), findsOneWidget);
    });

    testWidgets("Email Field displays error on invalid input", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      await tester.enterText(find.byKey(Key("unlockPasswordTextFieldKey")), "hcfJgfhFDH@#3469*bnN");
      await tester.pump(Duration(milliseconds: 500));
      await tester.tap(find.byKey(Key("unlockButtonKey")));
      await tester.pump(Duration(milliseconds: 500));


      String email = 'bademail';
      expect(find.text("Invalid Email"), findsNothing);

      await tester.enterText(find.byKey(Key("emailTextFieldKey")), email);
      await tester.pump(Duration(milliseconds: 300));

      expect(find.text("Invalid Email"), findsOneWidget);
    });

    testWidgets("Email Form creates emailSubmitButton", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      await tester.enterText(find.byKey(Key("unlockPasswordTextFieldKey")), "hcfJgfhFDH@#3469*bnN");
      await tester.pump(Duration(milliseconds: 500));
      await tester.tap(find.byKey(Key("unlockButtonKey")));
      await tester.pump(Duration(milliseconds: 500));


      expect(find.byKey(Key("emailSubmitButtonKey")), findsOneWidget);
    });

    testWidgets("Email Submit Button is disabled on empty form", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      await tester.enterText(find.byKey(Key("unlockPasswordTextFieldKey")), "hcfJgfhFDH@#3469*bnN");
      await tester.pump(Duration(milliseconds: 500));
      await tester.tap(find.byKey(Key("unlockButtonKey")));
      await tester.pump(Duration(milliseconds: 500));


      expect(tester.widget<ElevatedButton>(find.byKey(Key("emailSubmitButtonKey"))).enabled, false);
    });

    testWidgets("Email Submit Button is disabled on invalid form", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      await tester.enterText(find.byKey(Key("unlockPasswordTextFieldKey")), "hcfJgfhFDH@#3469*bnN");
      await tester.pump(Duration(milliseconds: 500));
      await tester.tap(find.byKey(Key("unlockButtonKey")));
      await tester.pump(Duration(milliseconds: 500));

      String email = 'bademail';
      await tester.enterText(find.byKey(Key("emailTextFieldKey")), email);
      await tester.pump(Duration(milliseconds: 500));


      expect(tester.widget<ElevatedButton>(find.byKey(Key("emailSubmitButtonKey"))).enabled, false);
    });

    testWidgets("Email Submit Button is enabled on valid form", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      await tester.enterText(find.byKey(Key("unlockPasswordTextFieldKey")), "hcfJgfhFDH@#3469*bnN");
      await tester.pump(Duration(milliseconds: 500));
      await tester.tap(find.byKey(Key("unlockButtonKey")));
      await tester.pump(Duration(milliseconds: 500));

      String email = faker.internet.email();
      await tester.enterText(find.byKey(Key("emailTextFieldKey")), email);
      await tester.pump(Duration(milliseconds: 500));


      expect(tester.widget<ElevatedButton>(find.byKey(Key("emailSubmitButtonKey"))).enabled, true);
    });

    testWidgets("Tapping emailSubmitButton displays CircularProgressIndicator", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      await tester.enterText(find.byKey(Key("unlockPasswordTextFieldKey")), "hcfJgfhFDH@#3469*bnN");
      await tester.pump(Duration(milliseconds: 500));
      await tester.tap(find.byKey(Key("unlockButtonKey")));
      await tester.pump(Duration(milliseconds: 500));

      String email = faker.internet.email();
      await tester.enterText(find.byKey(Key("emailTextFieldKey")), email);
      await tester.pump(Duration(milliseconds: 500));

      expect(find.byType(CircularProgressIndicator), findsNothing);

      await tester.tap(find.byKey(Key("emailSubmitButtonKey")));
      await tester.pump(Duration(milliseconds: 250));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump(Duration(milliseconds: 250));
      expect(find.byType(CircularProgressIndicator), findsNothing);

      await tester.pump(Duration(seconds: 4));
    });

    testWidgets("Tapping emailSubmitButton on success shows toast", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      await tester.enterText(find.byKey(Key("unlockPasswordTextFieldKey")), "hcfJgfhFDH@#3469*bnN");
      await tester.pump(Duration(milliseconds: 500));
      await tester.tap(find.byKey(Key("unlockButtonKey")));
      await tester.pump(Duration(milliseconds: 500));

      String email = faker.internet.email();
      await tester.enterText(find.byKey(Key("emailTextFieldKey")), email);
      await tester.pump(Duration(milliseconds: 500));

      expect(find.text("Email Updated!"), findsNothing);

      await tester.tap(find.byKey(Key("emailSubmitButtonKey")));
      await tester.pump(Duration(seconds: 1));
      expect(find.text("Email Updated!"), findsOneWidget);

      await tester.pump(Duration(seconds: 4));
      expect(find.text("Email Updated!"), findsNothing);
    });

    testWidgets("Tapping emailSubmitButton on success pops nav", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      await tester.enterText(find.byKey(Key("unlockPasswordTextFieldKey")), "hcfJgfhFDH@#3469*bnN");
      await tester.pump(Duration(milliseconds: 500));
      await tester.tap(find.byKey(Key("unlockButtonKey")));
      await tester.pump(Duration(milliseconds: 500));

      String email = faker.internet.email();
      await tester.enterText(find.byKey(Key("emailTextFieldKey")), email);
      await tester.pump(Duration(milliseconds: 500));

      await tester.tap(find.byKey(Key("emailSubmitButtonKey")));
      await tester.pump(Duration(seconds: 5));

      verify(() => observer.didPop(any(), any())).called(1);
    });

    testWidgets("Tapping emailSubmitButton on error displays error message", (tester) async {
      when(() => businessRepository.updateEmail(email: any(named: "email"), identifier: any(named: "identifier")))
        .thenThrow(ApiException(error: "Warning error!"));
      
      await screenBuilder.createScreen(tester: tester);
      await tester.enterText(find.byKey(Key("unlockPasswordTextFieldKey")), "hcfJgfhFDH@#3469*bnN");
      await tester.pump(Duration(milliseconds: 500));
      await tester.tap(find.byKey(Key("unlockButtonKey")));
      await tester.pump(Duration(milliseconds: 500));

      String email = faker.internet.email();
      await tester.enterText(find.byKey(Key("emailTextFieldKey")), email);
      await tester.pump(Duration(milliseconds: 500));

      expect(find.text("Warning error!"), findsNothing);

      await tester.tap(find.byKey(Key("emailSubmitButtonKey")));
      await tester.pumpAndSettle();

      expect(find.text("Warning error!"), findsOneWidget);

      await tester.pump(Duration(seconds: 5));
      expect(find.text("Warning error!"), findsNothing);
    });

    testWidgets("Unlocked Form displays EmailForm initially", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      await tester.enterText(find.byKey(Key("unlockPasswordTextFieldKey")), "hcfJgfhFDH@#3469*bnN");
      await tester.pump(Duration(milliseconds: 500));
      await tester.tap(find.byKey(Key("unlockButtonKey")));
      await tester.pump(Duration(milliseconds: 500));

      expect(find.byType(EmailForm), findsOneWidget);
      expect(find.byType(PasswordForm), findsNothing);
    });

    testWidgets("Unlocked displays left and right chevrons", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      await tester.enterText(find.byKey(Key("unlockPasswordTextFieldKey")), "hcfJgfhFDH@#3469*bnN");
      await tester.pump(Duration(milliseconds: 500));
      await tester.tap(find.byKey(Key("unlockButtonKey")));
      await tester.pump(Duration(milliseconds: 500));

      expect(find.byIcon(Icons.chevron_left), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets("Tapping on right chevron hides EmailForm and shows PasswordForm", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      await tester.enterText(find.byKey(Key("unlockPasswordTextFieldKey")), "hcfJgfhFDH@#3469*bnN");
      await tester.pump(Duration(milliseconds: 500));
      await tester.tap(find.byKey(Key("unlockButtonKey")));
      await tester.pump(Duration(milliseconds: 500));

      expect(find.byType(EmailForm), findsOneWidget);
      expect(find.byType(PasswordForm), findsNothing);
      
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pumpAndSettle(Duration(milliseconds: 300));

      expect(find.byType(EmailForm), findsNothing);
      expect(find.byType(PasswordForm), findsOneWidget);
    });

    testWidgets("Tapping on left chevron hides PasswordForm and shows EmailForm", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      await tester.enterText(find.byKey(Key("unlockPasswordTextFieldKey")), "hcfJgfhFDH@#3469*bnN");
      await tester.pump(Duration(milliseconds: 500));
      await tester.tap(find.byKey(Key("unlockButtonKey")));
      await tester.pump(Duration(milliseconds: 500));
      
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pumpAndSettle(Duration(milliseconds: 300));

      expect(find.byType(EmailForm), findsNothing);
      expect(find.byType(PasswordForm), findsOneWidget);

      await tester.tap(find.byIcon(Icons.chevron_left));
      await tester.pumpAndSettle(Duration(milliseconds: 300));

      expect(find.byType(EmailForm), findsOneWidget);
      expect(find.byType(PasswordForm), findsNothing);
    });

    testWidgets("Password Form creates passwordField", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      await tester.enterText(find.byKey(Key("unlockPasswordTextFieldKey")), "hcfJgfhFDH@#3469*bnN");
      await tester.pump(Duration(milliseconds: 500));
      await tester.tap(find.byKey(Key("unlockButtonKey")));
      await tester.pump(Duration(milliseconds: 500));
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pumpAndSettle(Duration(milliseconds: 300));

      expect(find.byKey(Key("passwordTextFieldKey")), findsOneWidget);
    });

    testWidgets("Password Field can receive input", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      await tester.enterText(find.byKey(Key("unlockPasswordTextFieldKey")), "hcfJgfhFDH@#3469*bnN");
      await tester.pump(Duration(milliseconds: 500));
      await tester.tap(find.byKey(Key("unlockButtonKey")));
      await tester.pump(Duration(milliseconds: 500));
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pumpAndSettle(Duration(milliseconds: 300));

      String password = "ndfbdGJKG12!@kld*nnHFS";
      expect(find.text(password), findsNothing);
      await tester.enterText(find.byKey(Key("passwordTextFieldKey")), password);
      await tester.pump();
      expect(find.text(password), findsOneWidget);
    });

    testWidgets("Password Field displays error on invalid input", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      await tester.enterText(find.byKey(Key("unlockPasswordTextFieldKey")), "hcfJgfhFDH@#3469*bnN");
      await tester.pump(Duration(milliseconds: 500));
      await tester.tap(find.byKey(Key("unlockButtonKey")));
      await tester.pump(Duration(milliseconds: 500));
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pumpAndSettle(Duration(milliseconds: 300));

      String password = "n";
      expect(find.text("Invalid Password"), findsNothing);
      await tester.enterText(find.byKey(Key("passwordTextFieldKey")), password);
      await tester.pump(Duration(milliseconds: 300));
      expect(find.text("Invalid Password"), findsOneWidget);
    });

    testWidgets("Password Form creates passwordConfirmationField", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      await tester.enterText(find.byKey(Key("unlockPasswordTextFieldKey")), "hcfJgfhFDH@#3469*bnN");
      await tester.pump(Duration(milliseconds: 500));
      await tester.tap(find.byKey(Key("unlockButtonKey")));
      await tester.pump(Duration(milliseconds: 500));
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pumpAndSettle(Duration(milliseconds: 300));

      expect(find.byKey(Key("passwordConfirmationTextFieldKey")), findsOneWidget);
    });

    testWidgets("Password Confirmation Field can receive input", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      await tester.enterText(find.byKey(Key("unlockPasswordTextFieldKey")), "hcfJgfhFDH@#3469*bnN");
      await tester.pump(Duration(milliseconds: 500));
      await tester.tap(find.byKey(Key("unlockButtonKey")));
      await tester.pump(Duration(milliseconds: 500));
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pumpAndSettle(Duration(milliseconds: 300));

      String password = "ndfbdGJKG12!@kld*nnHFS";
      expect(find.text(password), findsNothing);
      await tester.enterText(find.byKey(Key("passwordConfirmationTextFieldKey")), password);
      await tester.pump();
      expect(find.text(password), findsOneWidget);
    });

    testWidgets("Password Confirmation Field displays error on invalid input", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      await tester.enterText(find.byKey(Key("unlockPasswordTextFieldKey")), "hcfJgfhFDH@#3469*bnN");
      await tester.pump(Duration(milliseconds: 500));
      await tester.tap(find.byKey(Key("unlockButtonKey")));
      await tester.pump(Duration(milliseconds: 500));
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pumpAndSettle(Duration(milliseconds: 300));

      String password = "n";
      expect(find.text("Confirmation does not match"), findsNothing);
      await tester.enterText(find.byKey(Key("passwordConfirmationTextFieldKey")), password);
      await tester.pump(Duration(milliseconds: 300));
      expect(find.text("Confirmation does not match"), findsOneWidget);
    });

    testWidgets("Password Form creates submitPasswordButton", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      await tester.enterText(find.byKey(Key("unlockPasswordTextFieldKey")), "hcfJgfhFDH@#3469*bnN");
      await tester.pump(Duration(milliseconds: 500));
      await tester.tap(find.byKey(Key("unlockButtonKey")));
      await tester.pump(Duration(milliseconds: 500));
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pumpAndSettle(Duration(milliseconds: 300));

      expect(find.byKey(Key("submitPasswordButtonKey")), findsOneWidget);
    });

    testWidgets("Submit Password Button is disabled on empty form", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      await tester.enterText(find.byKey(Key("unlockPasswordTextFieldKey")), "hcfJgfhFDH@#3469*bnN");
      await tester.pump(Duration(milliseconds: 500));
      await tester.tap(find.byKey(Key("unlockButtonKey")));
      await tester.pump(Duration(milliseconds: 500));
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pumpAndSettle(Duration(milliseconds: 300));

      expect(tester.widget<ElevatedButton>(find.byKey(Key("submitPasswordButtonKey"))).enabled, false);
    });

    testWidgets("Submit Password Button is disabled on invalid form", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      await tester.enterText(find.byKey(Key("unlockPasswordTextFieldKey")), "hcfJgfhFDH@#3469*bnN");
      await tester.pump(Duration(milliseconds: 500));
      await tester.tap(find.byKey(Key("unlockButtonKey")));
      await tester.pump(Duration(milliseconds: 500));
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pumpAndSettle(Duration(milliseconds: 300));

      await tester.enterText(find.byKey(Key("passwordTextFieldKey")), "hssss");
      await tester.pump(Duration(milliseconds: 500));

      await tester.enterText(find.byKey(Key("passwordConfirmationTextFieldKey")), "");
      await tester.pump(Duration(milliseconds: 500));

      await tester.enterText(find.byKey(Key("passwordConfirmationTextFieldKey")), "ts");
      await tester.pump(Duration(milliseconds: 500));

      expect(tester.widget<ElevatedButton>(find.byKey(Key("submitPasswordButtonKey"))).enabled, false);
    });

    testWidgets("Submit Password Button is enabled on valid form", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      await tester.enterText(find.byKey(Key("unlockPasswordTextFieldKey")), "hcfJgfhFDH@#3469*bnN");
      await tester.pump(Duration(milliseconds: 500));
      await tester.tap(find.byKey(Key("unlockButtonKey")));
      await tester.pump(Duration(milliseconds: 500));
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pumpAndSettle(Duration(milliseconds: 300));

      await tester.enterText(find.byKey(Key("passwordTextFieldKey")), "jcdbdsHJSG!@#219872HHHDVDcds");
      await tester.pump(Duration(milliseconds: 500));

      await tester.enterText(find.byKey(Key("passwordConfirmationTextFieldKey")), "");
      await tester.pump(Duration(milliseconds: 500));

      await tester.enterText(find.byKey(Key("passwordConfirmationTextFieldKey")), "jcdbdsHJSG!@#219872HHHDVDcds");
      await tester.pump(Duration(milliseconds: 500));

      expect(tester.widget<ElevatedButton>(find.byKey(Key("submitPasswordButtonKey"))).enabled, true);
    });

    testWidgets("Tapping submitButton on valid form displays CircularProgressIndicator", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      await tester.enterText(find.byKey(Key("unlockPasswordTextFieldKey")), "hcfJgfhFDH@#3469*bnN");
      await tester.pump(Duration(milliseconds: 500));
      await tester.tap(find.byKey(Key("unlockButtonKey")));
      await tester.pump(Duration(milliseconds: 500));
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pumpAndSettle(Duration(milliseconds: 300));
      await tester.enterText(find.byKey(Key("passwordTextFieldKey")), "jcdbdsHJSG!@#219872HHHDVDcds");
      await tester.pump(Duration(milliseconds: 500));
      await tester.enterText(find.byKey(Key("passwordConfirmationTextFieldKey")), "");
      await tester.pump(Duration(milliseconds: 500));
      await tester.enterText(find.byKey(Key("passwordConfirmationTextFieldKey")), "jcdbdsHJSG!@#219872HHHDVDcds");
      await tester.pump(Duration(milliseconds: 500));

      expect(find.byType(CircularProgressIndicator), findsNothing);
      
      await tester.tap(find.byKey(Key("submitPasswordButtonKey")));
      await tester.pump(Duration(milliseconds: 250));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump(Duration(milliseconds: 250));
      expect(find.byType(CircularProgressIndicator), findsNothing);

      await tester.pump(Duration(seconds: 4));
    });

    testWidgets("Tapping submitButton on success displays toast", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      await tester.enterText(find.byKey(Key("unlockPasswordTextFieldKey")), "hcfJgfhFDH@#3469*bnN");
      await tester.pump(Duration(milliseconds: 500));
      await tester.tap(find.byKey(Key("unlockButtonKey")));
      await tester.pump(Duration(milliseconds: 500));
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pumpAndSettle(Duration(milliseconds: 300));
      await tester.enterText(find.byKey(Key("passwordTextFieldKey")), "jcdbdsHJSG!@#219872HHHDVDcds");
      await tester.pump(Duration(milliseconds: 500));
      await tester.enterText(find.byKey(Key("passwordConfirmationTextFieldKey")), "");
      await tester.pump(Duration(milliseconds: 500));
      await tester.enterText(find.byKey(Key("passwordConfirmationTextFieldKey")), "jcdbdsHJSG!@#219872HHHDVDcds");
      await tester.pump(Duration(milliseconds: 500));

      expect(find.text("Password Changed!"), findsNothing);
      
      await tester.tap(find.byKey(Key("submitPasswordButtonKey")));
      await tester.pump(Duration(milliseconds: 500));

      expect(find.text("Password Changed!"), findsOneWidget);

      await tester.pump(Duration(seconds: 4));
      expect(find.text("Password Changed!"), findsNothing);
    });

    testWidgets("Tapping submitButton on success pops nav", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      await tester.enterText(find.byKey(Key("unlockPasswordTextFieldKey")), "hcfJgfhFDH@#3469*bnN");
      await tester.pump(Duration(milliseconds: 500));
      await tester.tap(find.byKey(Key("unlockButtonKey")));
      await tester.pump(Duration(milliseconds: 500));
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pumpAndSettle(Duration(milliseconds: 300));
      await tester.enterText(find.byKey(Key("passwordTextFieldKey")), "jcdbdsHJSG!@#219872HHHDVDcds");
      await tester.pump(Duration(milliseconds: 500));
      await tester.enterText(find.byKey(Key("passwordConfirmationTextFieldKey")), "");
      await tester.pump(Duration(milliseconds: 500));
      await tester.enterText(find.byKey(Key("passwordConfirmationTextFieldKey")), "jcdbdsHJSG!@#219872HHHDVDcds");
      await tester.pump(Duration(milliseconds: 500));
      
      await tester.tap(find.byKey(Key("submitPasswordButtonKey")));

      await tester.pump(Duration(seconds: 5));
      verify(() => observer.didPop(any(), any())).called(1);
    });

    testWidgets("Tapping submitButton on error displays errorMessage", (tester) async {
      when(() => businessRepository.updatePassword(password: any(named: "password"), passwordConfirmation: any(named: "passwordConfirmation"), identifier: any(named: "identifier")))
        .thenThrow(ApiException(error: "An Error Happened!"));
      
      await screenBuilder.createScreen(tester: tester);
      await tester.enterText(find.byKey(Key("unlockPasswordTextFieldKey")), "hcfJgfhFDH@#3469*bnN");
      await tester.pump(Duration(milliseconds: 500));
      await tester.tap(find.byKey(Key("unlockButtonKey")));
      await tester.pump(Duration(milliseconds: 500));
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pumpAndSettle(Duration(milliseconds: 300));
      await tester.enterText(find.byKey(Key("passwordTextFieldKey")), "jcdbdsHJSG!@#219872HHHDVDcds");
      await tester.pump(Duration(milliseconds: 500));
      await tester.enterText(find.byKey(Key("passwordConfirmationTextFieldKey")), "");
      await tester.pump(Duration(milliseconds: 500));
      await tester.enterText(find.byKey(Key("passwordConfirmationTextFieldKey")), "jcdbdsHJSG!@#219872HHHDVDcds");
      await tester.pump(Duration(milliseconds: 500));
      
      expect(find.text("An Error Happened!"), findsNothing);
      await tester.tap(find.byKey(Key("submitPasswordButtonKey")));
      await tester.pumpAndSettle();

      expect(find.text("An Error Happened!"), findsOneWidget);

      await tester.pump(Duration(seconds: 5));
      expect(find.text("An Error Happened!"), findsNothing);
    });
  });
}