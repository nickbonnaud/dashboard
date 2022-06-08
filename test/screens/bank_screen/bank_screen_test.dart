import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/global_widgets/app_bars/default_app_bar.dart';
import 'package:dashboard/models/business/accounts.dart';
import 'package:dashboard/models/business/address.dart' as business_address;
import 'package:dashboard/models/business/bank_account.dart';
import 'package:dashboard/models/business/business.dart';
import 'package:dashboard/models/status.dart';
import 'package:dashboard/repositories/bank_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/bank_screen/bank_screen.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mock_data_generator.dart';
import '../../helpers/screen_builder.dart';

class MockBankRepository extends Mock implements BankRepository {}
class MockBankAccount extends Mock implements BankAccount {}

void main() {
  
  group("Bank Screen Tests", () {
    late ScreenBuilder screenBuilderNew;
    late ScreenBuilder screenBuilderEdit;
    late ScreenBuilder screenBuilderNewFilled;
    late NavigatorObserver observer;
    late BankRepository bankRepository;

    setUpAll(() {
      observer = MockNavigatorObserver();
      bankRepository = MockBankRepository();

      MockDataGenerator mockDataGenerator = MockDataGenerator();
      
      screenBuilderNew = ScreenBuilder(
        child: RepositoryProvider(
          create: (_) => bankRepository,
          child: const BankScreen(),
        ),
        observer: observer
      );

      screenBuilderNewFilled = ScreenBuilder(
        child: RepositoryProvider(
          create: (_) => bankRepository,
          child: const BankScreen(),
        ),
        business: Business(
          identifier: 'identifier',
          email: 'email',
          profile: mockDataGenerator.createProfile(),
          photos: mockDataGenerator.createBusinessPhotos(),
          accounts: Accounts(
            businessAccount: mockDataGenerator.createBusinessAccount(),
            ownerAccounts: const [],
            bankAccount: const BankAccount(
              identifier: "",
              firstName: "firstName",
              lastName: "lastName",
              routingNumber: "123456789",
              accountNumber: "1234567890",
              accountType: AccountType.checking,
              address: business_address.Address(
                address: "123 Main",
                addressSecondary: "F33",
                city: "City",
                state: "NC",
                zip: "74925"
              )
            ),
            accountStatus: const Status(name: 'name', code: 100)
          ),
          location: mockDataGenerator.createLocation(),
          posAccount: mockDataGenerator.createPosAccount()
        ),
        observer: observer
      );

      screenBuilderEdit = ScreenBuilder(
        child: RepositoryProvider(
          create: (_) => bankRepository,
          child: const BankScreen(),
        ),
        observer: observer,
        business: mockDataGenerator.createBusiness()
      );

      
      when(() => bankRepository.update(
        identifier: any(named: "identifier"), 
        firstName: any(named: "firstName"), 
        lastName: any(named: "lastName"), 
        routingNumber: any(named: "routingNumber"), 
        accountNumber: any(named: "accountNumber"), 
        accountType: any(named: "accountType"), 
        address: any(named: "address"), 
        addressSecondary: any(named: "addressSecondary"), 
        city: any(named: "city"), 
        state: any(named: "state"), 
        zip: any(named: "zip")
      )).thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 500), () => MockBankAccount()));

      when(() => bankRepository.store(
        firstName: any(named: "firstName"), 
        lastName: any(named: "lastName"), 
        routingNumber: any(named: "routingNumber"), 
        accountNumber: any(named: "accountNumber"), 
        accountType: any(named: "accountType"), 
        address: any(named: "address"), 
        addressSecondary: any(named: "addressSecondary"), 
        city: any(named: "city"), 
        state: any(named: "state"), 
        zip: any(named: "zip")
      )).thenThrow(const ApiException(error: "An error occurred!"));
      
      registerFallbackValue(BankAccountUpdated(bankAccount: MockBankAccount()));
      registerFallbackValue(MockRoute());
      
    });
    
    testWidgets("New BankAccount creates AppBar", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets("Edit BankAccount creates DefaultAppBar", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      expect(find.byType(DefaultAppBar), findsOneWidget);
    });

    testWidgets("New BankAccount creates Form", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      expect(find.byType(Form), findsOneWidget);
    });

    testWidgets("New BankAccount creates Empty title", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      expect(find.text("Banking Details"), findsOneWidget);
      expect(find.text("Please select your Bank Account type."), findsOneWidget);
    });

    testWidgets("New BankAccount Checking Account Button and Savings Account Buttons", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      expect(find.byKey(Key(AccountType.checking.toString())), findsOneWidget);
      expect(find.byKey(Key(AccountType.saving.toString())), findsOneWidget);
    });

    testWidgets("Selecting AccountType checking button changes form to Data", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      expect(find.byKey(const Key("accountTypeKey")), findsOneWidget);
      expect(find.byKey(const Key("AccountDataKey")), findsNothing);
      await tester.tap(find.byKey(Key(AccountType.checking.toString())));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key("accountTypeKey")), findsNothing);
      expect(find.byKey(const Key("AccountDataKey")), findsOneWidget);
    });

    testWidgets("Selecting AccountType savings button changes form to Data", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      expect(find.byKey(const Key("accountTypeKey")), findsOneWidget);
      expect(find.byKey(const Key("AccountDataKey")), findsNothing);
      await tester.tap(find.byKey(Key(AccountType.saving.toString())));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key("accountTypeKey")), findsNothing);
      expect(find.byKey(const Key("AccountDataKey")), findsOneWidget);
    });

    testWidgets("New Bank Data form contains all correct fields", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      await tester.tap(find.byKey(Key(AccountType.saving.toString())));
      await tester.pumpAndSettle();
      
      expect(find.byKey(const Key("firstNameKey")), findsOneWidget);
      expect(find.byKey(const Key("lastNameKey")), findsOneWidget);
      expect(find.byKey(const Key("routingKey")), findsOneWidget);
      expect(find.byKey(const Key("accountKey")), findsOneWidget);
      expect(find.byKey(const Key("addressKey")), findsOneWidget);
      expect(find.byKey(const Key("addressSecondaryKey")), findsOneWidget);
      expect(find.byKey(const Key("cityKey")), findsOneWidget);
      expect(find.byKey(const Key("stateKey")), findsOneWidget);
      expect(find.byKey(const Key("zipKey")), findsOneWidget);
    });

    testWidgets("First Name field can take text", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      await tester.tap(find.byKey(Key(AccountType.saving.toString())));
      await tester.pumpAndSettle();

      String firstName = faker.person.firstName();
      await tester.enterText(find.byKey(const Key("firstNameKey")), firstName);
      expect(find.text(firstName), findsOneWidget);
    });

    testWidgets("Invalid first name shows error", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      await tester.tap(find.byKey(Key(AccountType.saving.toString())));
      await tester.pumpAndSettle();

      expect(find.text("Invalid First Name"), findsNothing);
      await tester.enterText(find.byKey(const Key("firstNameKey")), "a");
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text("Invalid First Name"), findsOneWidget);
    });

    testWidgets("Last Name field can take text", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      await tester.tap(find.byKey(Key(AccountType.saving.toString())));
      await tester.pumpAndSettle();

      String lastName = faker.person.lastName();
      await tester.enterText(find.byKey(const Key("lastNameKey")), lastName);
      expect(find.text(lastName), findsOneWidget);
    });

    testWidgets("Invalid Last Name field shows error", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      await tester.tap(find.byKey(Key(AccountType.saving.toString())));
      await tester.pumpAndSettle();

      expect(find.text("Invalid Last Name"), findsNothing);
      await tester.enterText(find.byKey(const Key("lastNameKey")), "a");
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text("Invalid Last Name"), findsOneWidget);
    });

    testWidgets("Routing field can take text", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      await tester.tap(find.byKey(Key(AccountType.saving.toString())));
      await tester.pumpAndSettle();

      String routing = "123456789";
      await tester.enterText(find.byKey(const Key("routingKey")), routing);
      expect(find.text(routing), findsOneWidget);
    });

    testWidgets("Invalid Routing field shows error", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      await tester.tap(find.byKey(Key(AccountType.saving.toString())));
      await tester.pumpAndSettle();

      expect(find.text("Invalid Routing Number"), findsNothing);
      String routing = "1234";
      await tester.enterText(find.byKey(const Key("routingKey")), routing);
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text("Invalid Routing Number"), findsOneWidget);
    });

    testWidgets("Account field can take text", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      await tester.tap(find.byKey(Key(AccountType.saving.toString())));
      await tester.pumpAndSettle();

      String account = "1234567890123";
      await tester.enterText(find.byKey(const Key("accountKey")), account);
      expect(find.text(account), findsOneWidget);
    });

    testWidgets("Invalid Account field shows error", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      await tester.tap(find.byKey(Key(AccountType.saving.toString())));
      await tester.pumpAndSettle();

      expect(find.text("Invalid Account Number"), findsNothing);
      String account = "123";
      await tester.enterText(find.byKey(const Key("accountKey")), account);
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text("Invalid Account Number"), findsOneWidget);
    });

    testWidgets("Address field can take text", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      await tester.tap(find.byKey(Key(AccountType.saving.toString())));
      await tester.pumpAndSettle();

      String address = "12 Main St";
      await tester.enterText(find.byKey(const Key("addressKey")), address);
      expect(find.text(address), findsOneWidget);
    });

    testWidgets("Invalid Address field shows error", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      await tester.tap(find.byKey(Key(AccountType.saving.toString())));
      await tester.pumpAndSettle();

      expect(find.text("Invalid Address"), findsNothing);
      String address = "D";
      await tester.enterText(find.byKey(const Key("addressKey")), address);
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text("Invalid Address"), findsOneWidget);
    });

    testWidgets("Address Secondary field can take text", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      await tester.tap(find.byKey(Key(AccountType.saving.toString())));
      await tester.pumpAndSettle();

      String addressSecondary = "D13";
      await tester.enterText(find.byKey(const Key("addressSecondaryKey")), addressSecondary);
      expect(find.text(addressSecondary), findsOneWidget);
    });

    testWidgets("Invalid Address Secondary shows error", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      await tester.tap(find.byKey(Key(AccountType.saving.toString())));
      await tester.pumpAndSettle();

      expect(find.text("Invalid Address"), findsNothing);
      String addressSecondary = "1";
      await tester.enterText(find.byKey(const Key("addressSecondaryKey")), addressSecondary);
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text("Invalid Address"), findsOneWidget);
    });

    testWidgets("City field can take text", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      await tester.tap(find.byKey(Key(AccountType.saving.toString())));
      await tester.pumpAndSettle();

      String city = faker.address.city();
      await tester.enterText(find.byKey(const Key("cityKey")), city);
      expect(find.text(city), findsOneWidget);
    });

    testWidgets("Invalid City field shows error", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      await tester.tap(find.byKey(Key(AccountType.saving.toString())));
      await tester.pumpAndSettle();

      expect(find.text("Invalid City"), findsNothing);
      String city = "n";
      await tester.enterText(find.byKey(const Key("cityKey")), city);
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text("Invalid City"), findsOneWidget);
    });

    testWidgets("State field can take text", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      await tester.tap(find.byKey(Key(AccountType.saving.toString())));
      await tester.pumpAndSettle();

      String state = "NC";
      await tester.enterText(find.byKey(const Key("stateKey")), state);
      expect(find.text(state), findsOneWidget);
    });

    testWidgets("Invalid State field shows error", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      await tester.tap(find.byKey(Key(AccountType.saving.toString())));
      await tester.pumpAndSettle();

      expect(find.text("Invalid State"), findsNothing);
      String state = "N";
      await tester.enterText(find.byKey(const Key("stateKey")), state);
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text("Invalid State"), findsOneWidget);
    });

    testWidgets("Zip field can take text", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      await tester.tap(find.byKey(Key(AccountType.saving.toString())));
      await tester.pumpAndSettle();

      String zip = "73527";
      await tester.enterText(find.byKey(const Key("zipKey")), zip);
      expect(find.text(zip), findsOneWidget);
    });

    testWidgets("Invalid Zip field shows error", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      await tester.tap(find.byKey(Key(AccountType.saving.toString())));
      await tester.pumpAndSettle();

      expect(find.text("Invalid Zip"), findsNothing);
      String zip = "77";
      await tester.enterText(find.byKey(const Key("zipKey")), zip);
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text("Invalid Zip"), findsOneWidget);
    });

    testWidgets("Bank Account Data form creates Change Account Type Button", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      await tester.tap(find.byKey(Key(AccountType.saving.toString())));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key("changeAccountTypeKey")), findsOneWidget);
    });

    testWidgets("Tapping Change Account Type Button changes Account Type", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      await tester.tap(find.byKey(Key(AccountType.saving.toString())));
      await tester.pumpAndSettle();

      expect(find.text("Change To Savings"), findsNothing);
      expect(find.text("Change To Checking"), findsOneWidget);

      await tester.drag(find.byKey(const Key("scrollKey")), const Offset(0.0, -500));
      await tester.pump();
      await tester.tap(find.byKey(const Key("changeAccountTypeKey")));
      await tester.pump();

      expect(find.text("Change To Savings"), findsOneWidget);
      expect(find.text("Change To Checking"), findsNothing);
    });

    testWidgets("Bank Account Data form creates Submit Button", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      await tester.tap(find.byKey(Key(AccountType.saving.toString())));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key("submitButtonKey")), findsOneWidget);
    });

    testWidgets("Bank Account Data Submit Button is disabled on empty form", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      await tester.tap(find.byKey(Key(AccountType.saving.toString())));
      await tester.pumpAndSettle();

      expect(tester.widget<ElevatedButton>(find.byKey(const Key("submitButtonKey"))).enabled, false);
    });

    testWidgets("Bank Account Data Submit Button is enabled on valid form", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);

      expect(tester.widget<ElevatedButton>(find.byKey(const Key("submitButtonKey"))).enabled, false);
      
      String firstName = faker.person.firstName();
      await tester.enterText(find.byKey(const Key("firstNameKey")), firstName);
      await tester.pump(const Duration(milliseconds: 300));

      expect(tester.widget<ElevatedButton>(find.byKey(const Key("submitButtonKey"))).enabled, true);
    });

    testWidgets("Bank Account Data Submit Button is disabled if data not changed", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);

      expect(tester.widget<ElevatedButton>(find.byKey(const Key("submitButtonKey"))).enabled, false);
      
      String firstName = faker.person.firstName();
      await tester.enterText(find.byKey(const Key("firstNameKey")), firstName);
      await tester.pump(const Duration(milliseconds: 300));

      expect(tester.widget<ElevatedButton>(find.byKey(const Key("submitButtonKey"))).enabled, true);

      await tester.enterText(find.byKey(const Key("firstNameKey")), screenBuilderEdit.business!.accounts.bankAccount.firstName);
      await tester.pump(const Duration(milliseconds: 300));

       expect(tester.widget<ElevatedButton>(find.byKey(const Key("submitButtonKey"))).enabled, false);
    });

    testWidgets("Submit Button tap shows CircularProgressIndicator", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      
      String firstName = faker.person.firstName();
      await tester.enterText(find.byKey(const Key("firstNameKey")), firstName);
      await tester.pump();
      
      await tester.drag(find.byKey(const Key("scrollKey")), const Offset(0.0, -500));
      await tester.pumpAndSettle();
      
      await tester.tap(find.byKey(const Key("submitButtonKey")));
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump(const Duration(seconds: 4));
    });
    
    testWidgets("Submit Button tap shows Toast on Success", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      expect(find.text("Banking Saved!"), findsNothing);
      
      String firstName = faker.person.firstName();
      await tester.enterText(find.byKey(const Key("firstNameKey")), firstName);
      await tester.pump();
      
      await tester.drag(find.byKey(const Key("scrollKey")), const Offset(0.0, -500));
      await tester.pumpAndSettle();
      
      await tester.tap(find.byKey(const Key("submitButtonKey")));
      await tester.pump(const Duration(seconds: 2));
      expect(find.text("Banking Saved!"), findsOneWidget);
      await tester.pump(const Duration(seconds: 2));
    });

    testWidgets("Submit Button tap on Success pops Nav", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      
      String firstName = faker.person.firstName();
      await tester.enterText(find.byKey(const Key("firstNameKey")), firstName);
      await tester.pump();
      
      await tester.drag(find.byKey(const Key("scrollKey")), const Offset(0.0, -500));
      await tester.pumpAndSettle();
      
      await tester.tap(find.byKey(const Key("submitButtonKey")));
      await tester.pump(const Duration(seconds: 4));
      verify(() => observer.didPop(any(), any()));
    });

    testWidgets("Submit Button tap on error shows error message for one second", (tester) async {
      await screenBuilderNewFilled.createScreen(tester: tester);

      await tester.drag(find.byKey(const Key("scrollKey")), const Offset(0.0, -500));
      await tester.pumpAndSettle();
      
      expect(find.text("An error occurred!"), findsNothing);
      await tester.tap(find.byKey(const Key("submitButtonKey")));
      await tester.pumpAndSettle();
      expect(find.text("An error occurred!"), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));
      expect(find.text("An error occurred!"), findsNothing);
    });
  });
}