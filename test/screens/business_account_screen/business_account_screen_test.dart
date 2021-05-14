import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/global_widgets/app_bars/default_app_bar.dart';
import 'package:dashboard/models/business/address.dart';
import 'package:dashboard/models/business/business_account.dart';
import 'package:dashboard/repositories/business_account_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/business_account_screen/business_account_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/screen_builder.dart';

class MockBusinessAccountRepository extends Mock implements BusinessAccountRepository {}
class MockBusinessBloc extends Mock implements BusinessBloc {}
class MockBusinessAccount extends Mock implements BusinessAccount {}

void main() {
  
  BusinessAccount _createAccount({bool isNew = false}) {
    return BusinessAccount(
      identifier: isNew ? "" : "identifier",
      businessName: "Acme Inc.",
      address: Address(
        address: "123 Main",
        addressSecondary: "F33",
        city: "City",
        state: "NC",
        zip: "74925"
      ), 
      entityType: EntityType.llc,
      ein: "12-3456789"
    );
  }
  
  group("Business Account Screen Tests", () {
    late ScreenBuilder screenBuilderNew;
    late ScreenBuilder screenBuilderNewFilled;
    late ScreenBuilder screenBuilderEdit;
    late NavigatorObserver observer;
    late BusinessAccountRepository accountRepository;
    late BusinessBloc businessBloc;

    setUpAll(() {
      observer = MockNavigatorObserver();
      accountRepository = MockBusinessAccountRepository();
      businessBloc = MockBusinessBloc();

      screenBuilderNew = ScreenBuilder(
        child: BusinessAccountScreen(
          businessAccount: BusinessAccount.empty(), 
          accountRepository: accountRepository, 
          businessBloc: businessBloc
        ), 
        observer: observer
      );

      screenBuilderNewFilled = ScreenBuilder(
        child: BusinessAccountScreen(
          businessAccount: _createAccount(isNew: true), 
          accountRepository: accountRepository, 
          businessBloc: businessBloc
        ), 
        observer: observer
      );

      screenBuilderEdit = ScreenBuilder(
        child: BusinessAccountScreen(
          businessAccount: _createAccount(), 
          accountRepository: accountRepository, 
          businessBloc: businessBloc
        ), 
        observer: observer
      );

      when(() => accountRepository.update(
        name: any(named: "name"),
        address: any(named: "address"), 
        addressSecondary: any(named: "addressSecondary"), 
        city: any(named: "city"), 
        state: any(named: "state"), 
        zip: any(named: "zip"),
        entityType: any(named: "entityType"), 
        identifier: any(named: "identifier"), 
        ein: any(named: "ein")
      )).thenAnswer((_) async => Future.delayed(Duration(milliseconds: 500), () => MockBusinessAccount()));

      when(() => accountRepository.store(
        name: any(named: "name"),
        address: any(named: "address"), 
        addressSecondary: any(named: "addressSecondary"), 
        city: any(named: "city"), 
        state: any(named: "state"), 
        zip: any(named: "zip"),
        entityType: any(named: "entityType"), 
        ein: any(named: "ein")
      )).thenThrow(ApiException(error: "An error occurred!"));

      registerFallbackValue<BusinessEvent>(BusinessAccountUpdated(businessAccount: MockBusinessAccount()));
      registerFallbackValue<Route>(MockRoute());

      when(() => businessBloc.add(any(that: isA<BusinessEvent>())))
        .thenReturn(null);
    });

    testWidgets("New BusinessAccount creates AppBar", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets("Edit BusinessAccount creates DefaultAppBar", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      expect(find.byType(DefaultAppBar), findsOneWidget);
    });

    testWidgets("Business Account Screen has SingleChildScrollView", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      expect(find.byKey(Key("scrollKey")), findsOneWidget);
    });

    testWidgets("Business Account Screen has Form", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      expect(find.byKey(Key("formKey")), findsOneWidget);
    });

    testWidgets("New Business Account Screen title has distinct title", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      expect(find.text("Please select your Business Entity type."), findsOneWidget);
    });

    testWidgets("Edit Business Account Screen title has distinct title", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      expect(find.text("Great! Next let's get some details."), findsOneWidget);
    });

    testWidgets("New Business Account Screen initially displays Entity Type Body", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      expect(find.byKey(Key("entityTypeBody")), findsOneWidget);
    });

    testWidgets("New Business Account Screen Entity Type Body contains all EntityTypeButtons", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      EntityType.values.forEach((entityType) {
        if (entityType != EntityType.unknown) {
          expect(find.byKey(Key(entityType.toString())), findsOneWidget); 
        }
      });
    });

    testWidgets("Tapping EntityTypeButton hides entityTypeBody and shows BusinessDataBody", (tester) async {
      final List<EntityType> types = [EntityType.corporation, EntityType.llc, EntityType.partnership, EntityType.soleProprietorship];
      await screenBuilderNew.createScreen(tester: tester);
      expect(find.byKey(Key("entityTypeBody")), findsOneWidget);
      expect(find.byKey(Key("businessDataBody")), findsNothing);
      await tester.tap(find.byKey(Key((types..shuffle()).first.toString())));
      await tester.pump();
      expect(find.byKey(Key("entityTypeBody")), findsNothing);
      expect(find.byKey(Key("businessDataBody")), findsOneWidget);
    });

    testWidgets("Business Data body has correct TextFields", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
     
      expect(find.byKey(Key("nameKey")), findsOneWidget);
      expect(find.byKey(Key("addressKey")), findsOneWidget);
      expect(find.byKey(Key("addressSecondaryKey")), findsOneWidget);
      expect(find.byKey(Key("cityKey")), findsOneWidget);
      expect(find.byKey(Key("stateKey")), findsOneWidget);
      expect(find.byKey(Key("zipKey")), findsOneWidget);
      expect(find.byKey(Key("einKey")), findsOneWidget);
    });

    testWidgets("Ein field is hidden if Sole Prop", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      await tester.tap(find.byKey(Key(EntityType.soleProprietorship.toString())));
      await tester.pump();
      expect(find.byKey(Key("einKey")), findsNothing);
    });

    testWidgets("Name field can take text", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      String name = "Test Co.";
      expect(find.text(name), findsNothing);
      await tester.enterText(find.byKey(Key("nameKey")), name);
      expect(find.text(name), findsOneWidget);
    });

    testWidgets("Invalid name shows error", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      String name = "?";
      expect(find.text("Invalid Business Name"), findsNothing);
      await tester.enterText(find.byKey(Key("nameKey")), name);
      await tester.pump(Duration(milliseconds: 300));
      expect(find.text("Invalid Business Name"), findsOneWidget);
    });

    testWidgets("Address field can take text", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      String address = "12 Main Ave";
      expect(find.text(address), findsNothing);
      await tester.enterText(find.byKey(Key("addressKey")), address);
      expect(find.text(address), findsOneWidget);
    });

    testWidgets("Invalid Address field shows error", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      String address = "*";
      expect(find.text("Invalid Address"), findsNothing);
      await tester.enterText(find.byKey(Key("addressKey")), address);
      await tester.pump(Duration(milliseconds: 300));
      expect(find.text("Invalid Address"), findsOneWidget);
    });

    testWidgets("Address Secondary field can take text", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      String addressSecondary = "D13";
      expect(find.text(addressSecondary), findsNothing);
      await tester.enterText(find.byKey(Key("addressSecondaryKey")), addressSecondary);
      expect(find.text(addressSecondary), findsOneWidget);
    });

    testWidgets("Invalid Address Secondary shows error", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      String addressSecondary = "1";
      expect(find.text("Invalid Address"), findsNothing);
      await tester.enterText(find.byKey(Key("addressSecondaryKey")), addressSecondary);
      await tester.pump(Duration(milliseconds: 300));
      expect(find.text("Invalid Address"), findsOneWidget);
    });

    testWidgets("City field can take text", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      String city = "Chapel Hill";
      expect(find.text(city), findsNothing);
      await tester.enterText(find.byKey(Key("cityKey")), city);
      expect(find.text(city), findsOneWidget);
    });

    testWidgets("Invalid City field shows error", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      String city = "n";
      expect(find.text("Invalid City"), findsNothing);
      await tester.enterText(find.byKey(Key("cityKey")), city);
      await tester.pump(Duration(milliseconds: 300));
      expect(find.text("Invalid City"), findsOneWidget);
    });

    testWidgets("State field can take text", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      String state = "NY";
      expect(find.text(state), findsNothing);
      await tester.enterText(find.byKey(Key("stateKey")), "");
      await tester.enterText(find.byKey(Key("stateKey")), state);
      expect(find.text(state), findsOneWidget);
    });

    testWidgets("Invalid State field shows error", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      String state = "a";
      expect(find.text("Invalid State"), findsNothing);
      await tester.enterText(find.byKey(Key("stateKey")), "");
      await tester.enterText(find.byKey(Key("stateKey")), state);
      await tester.pump(Duration(milliseconds: 300));
      expect(find.text("Invalid State"), findsOneWidget);
    });

    testWidgets("Zip field can take text", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      String zip = "13507";
      expect(find.text(zip), findsNothing);
      await tester.enterText(find.byKey(Key("zipKey")), "");
      await tester.enterText(find.byKey(Key("zipKey")), zip);
      expect(find.text(zip), findsOneWidget);
    });

    testWidgets("Invalid Zip field shows error", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);

      String zip = "12";
      expect(find.text("Invalid Zip"), findsNothing);
      await tester.enterText(find.byKey(Key("zipKey")), "");
      await tester.enterText(find.byKey(Key("zipKey")), zip);
      await tester.pump(Duration(milliseconds: 300));
      expect(find.text("Invalid Zip"), findsOneWidget);
    });

    testWidgets("Ein field can take text", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      String ein = "99-3456489";
      expect(find.text(ein), findsNothing);
      await tester.enterText(find.byKey(Key("einKey")), "");
      await tester.enterText(find.byKey(Key("einKey")), ein);
      expect(find.text(ein), findsOneWidget);
    });

    testWidgets("Invalid ein shows error", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      String ein = "56";
      expect(find.text("Invalid EIN"), findsNothing);
      await tester.enterText(find.byKey(Key("einKey")), "");
      await tester.enterText(find.byKey(Key("einKey")), ein);
      await tester.pump(Duration(milliseconds: 300));
      expect(find.text("Invalid EIN"), findsOneWidget);
    });

    testWidgets("Business Data Form creates ChangeEntityButton", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      expect(find.byKey(Key("changeEntityKey")), findsOneWidget);
    });

    testWidgets("Tapping ChangeEntityButton hide Business Data Form and shows Entity Type Body", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      expect(find.byKey(Key("businessDataBody")), findsOneWidget);
      expect(find.byKey(Key("entityTypeBody")), findsNothing);

      await tester.drag(find.byKey(Key("scrollKey")), Offset(0.0, -500));
      await tester.pump();
      await tester.tap(find.byKey(Key("changeEntityKey")));
      await tester.pump();
      expect(find.byKey(Key("businessDataBody")), findsNothing);
      expect(find.byKey(Key("entityTypeBody")), findsOneWidget);
    });

    testWidgets("Business Data Form creates SubmitButton", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      expect(find.byKey(Key("submitButtonKey")), findsOneWidget);
    });

    testWidgets("Submit Button is disabled on empty form", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      await tester.tap(find.byKey(Key(EntityType.llc.toString())));
      await tester.pump();

      expect(tester.widget<ElevatedButton>(find.byKey(Key("submitButtonKey"))).enabled, false);
    });

    testWidgets("Submit Button is disabled on invalid form", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);

      String name = "?";
      await tester.enterText(find.byKey(Key("nameKey")), name);
      await tester.pump(Duration(milliseconds: 300));

      expect(tester.widget<ElevatedButton>(find.byKey(Key("submitButtonKey"))).enabled, false);
    });

    testWidgets("Submit Button is enabled on valid form", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);

      String name = "Test LLC";
      await tester.enterText(find.byKey(Key("nameKey")), name);
      await tester.pump(Duration(milliseconds: 300));

      expect(tester.widget<ElevatedButton>(find.byKey(Key("submitButtonKey"))).enabled, true);
    });

    testWidgets("Tapping Submit Button shows CircularProgressIndicator", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);

      String name = "Test LLC";
      await tester.enterText(find.byKey(Key("nameKey")), name);
      await tester.pump(Duration(milliseconds: 300));
      await tester.drag(find.byKey(Key("scrollKey")), Offset(0.0, -500));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      await tester.tap(find.byKey(Key("submitButtonKey")));
      await tester.pump(Duration(milliseconds: 250));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump(Duration(seconds: 4));
    });

    testWidgets("Tapping Submit Button shows Toast on Success", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);

      String name = "Test LLC";
      await tester.enterText(find.byKey(Key("nameKey")), name);
      await tester.pump(Duration(milliseconds: 300));
      await tester.drag(find.byKey(Key("scrollKey")), Offset(0.0, -500));
      await tester.pump();

      expect(find.text("Details Saved!"), findsNothing);
      await tester.tap(find.byKey(Key("submitButtonKey")));
      await tester.pump(Duration(seconds: 2));
      expect(find.text("Details Saved!"), findsOneWidget);
      await tester.pump(Duration(seconds: 2));
    });

    testWidgets("Tapping Submit Button on success pops nav", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);

      String name = "Test LLC";
      await tester.enterText(find.byKey(Key("nameKey")), name);
      await tester.pump(Duration(milliseconds: 300));
      await tester.drag(find.byKey(Key("scrollKey")), Offset(0.0, -500));
      await tester.pump();

      expect(find.text("Details Saved!"), findsNothing);
      await tester.tap(find.byKey(Key("submitButtonKey")));
      await tester.pump(Duration(seconds: 4));
      verify(() => observer.didPop(any(), any()));
    });

    testWidgets("Tapping Submit Button on error shows error message", (tester) async {
      await screenBuilderNewFilled.createScreen(tester: tester);

      await tester.drag(find.byKey(Key("scrollKey")), Offset(0.0, -500));
      await tester.pump();

      expect(find.text("An error occurred!"), findsNothing);
      await tester.tap(find.byKey(Key("submitButtonKey")));
      await tester.pumpAndSettle();
      expect(find.text("An error occurred!"), findsOneWidget);
      await tester.pump(Duration(seconds: 1));
      expect(find.text("An error occurred!"), findsNothing);
    });
  });
}