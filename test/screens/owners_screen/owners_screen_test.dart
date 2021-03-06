import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/global_widgets/app_bars/default_app_bar.dart';
import 'package:dashboard/models/business/owner_account.dart';
import 'package:dashboard/repositories/owner_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/owners_screen/owners_screen.dart';
import 'package:dashboard/screens/owners_screen/widgets/owner_form/owner_form.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mock_data_generator.dart';
import '../../helpers/screen_builder.dart';

class MockOwnerRepository extends Mock implements OwnerRepository {}
class MockBusinessBloc extends Mock implements BusinessBloc {}

void main() {
  group("Owners Screen Tests", () {
    late MockDataGenerator mockDataGenerator;
    late NavigatorObserver observer;
    late OwnerRepository ownerRepository;
    late BusinessBloc businessBloc;
    late List<OwnerAccount> ownerAccounts;
    late ScreenBuilder screenBuilderNew;
    late ScreenBuilder screenBuilderEdit;


    setUp(() {
      mockDataGenerator = MockDataGenerator();
      observer = MockNavigatorObserver();
      ownerRepository = MockOwnerRepository();
      businessBloc = MockBusinessBloc();
      ownerAccounts = List.generate(3, (index) => mockDataGenerator.createOwner(index: index));
      screenBuilderNew = ScreenBuilder(
        child: OwnersScreen(ownerRepository: ownerRepository, businessBloc: businessBloc, ownerAccounts: []),
        observer: observer
      );
      screenBuilderEdit = ScreenBuilder(
        child: OwnersScreen(ownerRepository: ownerRepository, businessBloc: businessBloc, ownerAccounts: ownerAccounts),
        observer: observer
      );

      when(() => ownerRepository.remove(identifier: any(named: "identifier")))
        .thenAnswer((_) async => Future.delayed(Duration(milliseconds: 500), () => true));

      when(() => ownerRepository.update(identifier: any(named: "identifier"), firstName: any(named: "firstName"), lastName: any(named: "lastName"), title: any(named: "title"), phone: any(named: "phone"), email: any(named: "email"), primary: any(named: "primary"), percentOwnership: any(named: "percentOwnership"), dob: any(named: "dob"), ssn: any(named: "ssn"), address: any(named: "address"), addressSecondary: any(named: "addressSecondary"), city: any(named: "city"), state: any(named: "state"), zip: any(named: "zip")))
        .thenAnswer((_) async => Future.delayed(Duration(milliseconds: 500), () => mockDataGenerator.createOwner(index: 0)));
    });

    testWidgets("New Owners Screen creates AppBar", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets("Edit Owners Screen creates DefaultAppBar", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      expect(find.byType(DefaultAppBar), findsOneWidget);
    });

    testWidgets("New Owners Screen initially shows OwnerForm", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      expect(find.byType(OwnerForm), findsOneWidget);
    });

    testWidgets("OwnerForm creates title", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      expect(find.text("Owner Details"), findsOneWidget);
      expect(find.text("Only persons owning 25% or more of business."), findsOneWidget);
    });
    
    testWidgets("OwnerForm contains all required TextFormField", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      expect(find.byKey(Key("firstNameFieldKey")), findsOneWidget);
      expect(find.byKey(Key("lastNameFieldKey")), findsOneWidget);
      expect(find.byKey(Key("titleFieldKey")), findsOneWidget);
      expect(find.byKey(Key("emailFieldKey")), findsOneWidget);
      expect(find.byKey(Key("dobFieldKey")), findsOneWidget);
      expect(find.byKey(Key("percentOwnershipFieldKey")), findsOneWidget);
      expect(find.byKey(Key("phoneFieldKey")), findsOneWidget);
      expect(find.byKey(Key("ssnKey")), findsOneWidget);
      expect(find.byKey(Key("primaryCheckBoxKey")), findsOneWidget);
      expect(find.byKey(Key("addressFieldKey")), findsOneWidget);
      expect(find.byKey(Key("addressSecondaryFieldKey")), findsOneWidget);
      expect(find.byKey(Key("cityFieldKey")), findsOneWidget);
      expect(find.byKey(Key("stateFieldKey")), findsOneWidget);
      expect(find.byKey(Key("zipFieldKey")), findsOneWidget);
    });

    testWidgets("FirstNameField can receive text input", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      String firstName = faker.person.firstName();
      await tester.enterText(find.byKey(Key("firstNameFieldKey")), firstName);
      await tester.pump();
      expect(find.text(firstName), findsOneWidget);
    });

    testWidgets("FirstNameField displays error on invalid input", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      String firstName = "!";
      await tester.enterText(find.byKey(Key("firstNameFieldKey")), firstName);
      await tester.pump(Duration(milliseconds: 300));
      expect(find.text("Invalid First Name"), findsOneWidget);
    });

    testWidgets("lastNameFieldKey can receive text input", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      String lastName = faker.person.lastName();
      await tester.enterText(find.byKey(Key("lastNameFieldKey")), lastName);
      await tester.pump();
      expect(find.text(lastName), findsOneWidget);
    });

    testWidgets("lastNameFieldKey displays error on invalid input", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      String lastName = "^";
      await tester.enterText(find.byKey(Key("lastNameFieldKey")), lastName);
      await tester.pump(Duration(milliseconds: 300));
      expect(find.text('Invalid Last Name'), findsOneWidget);
    });

    testWidgets("TitleField can receive text input", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      String title = faker.job.title();
      await tester.enterText(find.byKey(Key("titleFieldKey")), title);
      await tester.pump();
      expect(find.text(title), findsOneWidget);
    });

    testWidgets("TitleField displays error on invalid input", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      String title = "&";
      await tester.enterText(find.byKey(Key("titleFieldKey")), title);
      await tester.pump(Duration(milliseconds: 300));
      expect(find.text('Invalid Title'), findsOneWidget);
    });

    testWidgets("EmailField can receive text input", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      String email = faker.internet.email();
      await tester.enterText(find.byKey(Key("emailFieldKey")), email);
      await tester.pump();
      expect(find.text(email), findsOneWidget);
    });

    testWidgets("EmailField displays error on invalid input", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      String email = "not_an_email!";
      await tester.enterText(find.byKey(Key("emailFieldKey")), email);
      await tester.pump(Duration(milliseconds: 300));
      expect(find.text('Invalid Email'), findsOneWidget);
    });

    testWidgets("DobField can receive text input", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      String dob = "10/12/1987";
      await tester.enterText(find.byKey(Key("dobFieldKey")), dob);
      await tester.pump();
      expect(find.text(dob), findsOneWidget);
    });

    testWidgets("Tapping dobField displays datePicker", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      expect(find.byKey(Key("datePickerKey")), findsNothing);
      await tester.drag(find.byType(SingleChildScrollView), Offset(0, -300));
      await tester.pump();
      await tester.tap(find.byKey(Key("dobFieldKey")));
      await tester.pump();
      expect(find.byKey(Key("datePickerKey")), findsOneWidget);
    });

    testWidgets("Selecting Cancel on datepicker dismisses datePicker", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      await tester.drag(find.byType(SingleChildScrollView), Offset(0, -300));
      await tester.pump();
      await tester.tap(find.byKey(Key("dobFieldKey")));
      await tester.pump();
      await tester.tap(find.text("Cancel"));
      await tester.pump();
      expect(tester.widget<TextFormField>(find.byKey(Key("dobFieldKey"))).controller?.text.isEmpty, true);
    });

    testWidgets("Selecting Set on datepicker selects date", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      await tester.drag(find.byType(SingleChildScrollView), Offset(0, -300));
      await tester.pump();
      await tester.tap(find.byKey(Key("dobFieldKey")));
      await tester.pump();
      await tester.tap(find.text("Set"));
      await tester.pump();
      expect(tester.widget<TextFormField>(find.byKey(Key("dobFieldKey"))).controller?.text.isEmpty, false);
    });

    testWidgets("DobField displays error on invalid input", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      String dob = "?2019";
      await tester.enterText(find.byKey(Key("dobFieldKey")), dob);
      await tester.pump(Duration(milliseconds: 300));
      expect(find.text('Invalid Date of Birth'), findsOneWidget);
    });

    testWidgets("PercentOwnershipField can receive text input", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      String percentOwnership = "25";
      await tester.enterText(find.byKey(Key("percentOwnershipFieldKey")), percentOwnership);
      await tester.pump();
      expect(find.text(percentOwnership), findsOneWidget);
    });

    testWidgets("PercentOwnershipField shows error on invalid input", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      String percentOwnership = "200";
      await tester.enterText(find.byKey(Key("percentOwnershipFieldKey")), percentOwnership);
      await tester.pump(Duration(milliseconds: 300));
      expect(find.text('Ownership by ALL owners must be less than 100%'), findsOneWidget);
    });

    testWidgets("PhoneField can receive text input", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      String phone = "8358125976";
      await tester.enterText(find.byKey(Key("phoneFieldKey")), phone);
      await tester.pump();
      expect(find.text("(835) 812-5976"), findsOneWidget);
    });

    testWidgets("PhoneField displays error on invalid input", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      String phone = "@#93md";
      await tester.enterText(find.byKey(Key("phoneFieldKey")), phone);
      await tester.pump(Duration(milliseconds: 300));
      expect(find.text("Invalid Phone Number"), findsOneWidget);
    });

    testWidgets("ssnField can receive text input", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      String ssn = "123456789";
      await tester.enterText(find.byKey(Key("ssnKey")), ssn);
      await tester.pump();
      expect(find.text("123-45-6789"), findsOneWidget);
    });

    testWidgets("ssnField displays error on invalid input", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      String ssn = "afdh%(sf3";
      await tester.enterText(find.byKey(Key("ssnKey")), ssn);
      await tester.pump(Duration(milliseconds: 300));
      expect(find.text("Invalid SSN"), findsOneWidget);
    });

    testWidgets("PrimaryCheckBox can receive taps", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      expect(tester.widget<CheckboxListTile>(find.byKey(Key("primaryCheckBoxKey"))).value, false);
      await tester.drag(find.byType(SingleChildScrollView), Offset(0, -300));
      await tester.pump();
      await tester.tap(find.byKey(Key("primaryCheckBoxKey")));
      await tester.pump();
      expect(tester.widget<CheckboxListTile>(find.byKey(Key("primaryCheckBoxKey"))).value, true);
    });

    testWidgets("AddressField can receive text input", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      String address = faker.address.streetAddress();
      await tester.enterText(find.byKey(Key("addressFieldKey")), address);
      await tester.pump();
      expect(find.text(address), findsOneWidget);
    });

    testWidgets("AddressField shows error on invalid input", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      String address = "<";
      await tester.enterText(find.byKey(Key("addressFieldKey")), address);
      await tester.pump(Duration(milliseconds: 300));
      expect(find.text('Invalid Address'), findsOneWidget);
    });

    testWidgets("AddressSecondaryField can receive text input", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      String address = faker.address.buildingNumber();
      await tester.enterText(find.byKey(Key("addressSecondaryFieldKey")), address);
      await tester.pump();
      expect(find.text(address), findsOneWidget);
    });

    testWidgets("AddressSecondaryField displays error on invalid input", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      String address = "*";
      await tester.enterText(find.byKey(Key("addressSecondaryFieldKey")), address);
      await tester.pump(Duration(milliseconds: 300));
      expect(find.text('Invalid Address'), findsOneWidget);
    });

    testWidgets("CityField can receive text input", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      String city = faker.address.city();
      await tester.enterText(find.byKey(Key("cityFieldKey")), city);
      await tester.pump();
      expect(find.text(city), findsOneWidget);
    });

    testWidgets("CityField displays error on invalid input", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      String city = "3#";
      await tester.enterText(find.byKey(Key("cityFieldKey")), city);
      await tester.pump(Duration(milliseconds: 300));
      expect(find.text('Invalid City'), findsOneWidget);
    });

    testWidgets("StateField can receive text input", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      String state = "NC";
      await tester.enterText(find.byKey(Key("stateFieldKey")), state);
      await tester.pump();
      expect(find.text(state), findsOneWidget);
    });

    testWidgets("StateField displays error on invalid input", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      String state = "F5";
      await tester.enterText(find.byKey(Key("stateFieldKey")), state);
      await tester.pump(Duration(milliseconds: 300));
      expect(find.text('Invalid State'), findsOneWidget);
    });

    testWidgets("ZipField can receive text input", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      String zip = "36517";
      await tester.enterText(find.byKey(Key("zipFieldKey")), zip);
      await tester.pump();
      expect(find.text(zip), findsOneWidget);
    });

    testWidgets("ZipField displays error on invalid input", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      String zip = "&gd522";
      await tester.enterText(find.byKey(Key("zipFieldKey")), zip);
      await tester.pump(Duration(milliseconds: 300));
      expect(find.text('Invalid Zip'), findsOneWidget);
    });

    testWidgets("Submit button is disabled on empty form", (tester) async {
      await screenBuilderNew.createScreen(tester: tester);
      expect(tester.widget<ElevatedButton>(find.byKey(Key("submitButtonKey"))).enabled, false);
    });

    testWidgets("Tapping submitButton on valid form shows CircularProgressIndicator", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      await tester.tap(find.byKey(Key("editOwnerButton-0")));
      await tester.pump();
      await tester.drag(find.byType(SingleChildScrollView), Offset(0, -1000));
      await tester.pump();
      await tester.tap(find.byKey(Key("submitButtonKey")));
      await tester.pump(Duration(milliseconds: 250));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump(Duration(milliseconds: 250));
    });

    testWidgets("Tapping submitButton on success hides OwnerForm", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      await tester.tap(find.byKey(Key("editOwnerButton-0")));
      await tester.pump();
      expect(find.byType(OwnerForm), findsOneWidget);
      await tester.drag(find.byType(SingleChildScrollView), Offset(0, -1000));
      await tester.pump();
      await tester.tap(find.byKey(Key("submitButtonKey")));
      await tester.pump(Duration(milliseconds: 500));
      expect(find.byType(OwnerForm), findsNothing);
    });

    testWidgets("Tapping submitButton on error shows error message", (tester) async {
      when(() => ownerRepository.update(identifier: any(named: "identifier"), firstName: any(named: "firstName"), lastName: any(named: "lastName"), title: any(named: "title"), phone: any(named: "phone"), email: any(named: "email"), primary: any(named: "primary"), percentOwnership: any(named: "percentOwnership"), dob: any(named: "dob"), ssn: any(named: "ssn"), address: any(named: "address"), addressSecondary: any(named: "addressSecondary"), city: any(named: "city"), state: any(named: "state"), zip: any(named: "zip")))
        .thenThrow(ApiException(error: "An Error Happened!"));
      
      await screenBuilderEdit.createScreen(tester: tester);
      await tester.tap(find.byKey(Key("editOwnerButton-0")));
      await tester.pump();
      expect(find.text("An Error Happened!"), findsNothing);
      await tester.drag(find.byType(SingleChildScrollView), Offset(0, -1000));
      await tester.pump();
      await tester.tap(find.byKey(Key("submitButtonKey")));
      await tester.pumpAndSettle();
      expect(find.text("An Error Happened!"), findsOneWidget);
      await tester.pump(Duration(seconds: 1));
      expect(find.text("An Error Happened!"), findsNothing);
    });

    testWidgets("Tapping cancel button hides OwnerForm", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      await tester.tap(find.byKey(Key("editOwnerButton-0")));
      await tester.pump();
      expect(find.byType(OwnerForm), findsOneWidget);
      await tester.drag(find.byType(SingleChildScrollView), Offset(0, -1000));
      await tester.pump();
      await tester.tap(find.byKey(Key("cancelButtonKey")));
      await tester.pumpAndSettle();
      expect(find.byType(OwnerForm), findsNothing);
    });

    testWidgets("Tapping Primary checkbox when already assigned shows changePrimaryDialog", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      await tester.tap(find.byKey(Key("editOwnerButton-1")));
      await tester.pump();
      expect(find.byKey(Key("changePrimaryDialogKey")), findsNothing);
      await tester.drag(find.byType(SingleChildScrollView), Offset(0, -300));
      await tester.pump();
      await tester.tap(find.byKey(Key("primaryCheckBoxKey")));
      await tester.pumpAndSettle();
      expect(find.byKey(Key("changePrimaryDialogKey")), findsOneWidget);
    });

    testWidgets("ChangePrimaryDialog is dismissed if confirm button pressed", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      await tester.tap(find.byKey(Key("editOwnerButton-1")));
      await tester.pump();
      await tester.drag(find.byType(SingleChildScrollView), Offset(0, -300));
      await tester.pump();
      await tester.tap(find.byKey(Key("primaryCheckBoxKey")));
      await tester.pumpAndSettle();
      expect(find.byKey(Key("changePrimaryDialogKey")), findsOneWidget);
      await tester.tap(find.byKey(Key("confirmDialogButtonKey")));
      await tester.pumpAndSettle();
      expect(find.byKey(Key("changePrimaryDialogKey")), findsNothing);
      await tester.pump(Duration(milliseconds: 500));
    });

    testWidgets("Tapping delete button shows DeleteOwnerDialog", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      expect(find.byKey(Key("deleteOwnerDialogKey")), findsNothing);
      await tester.tap(find.byKey(Key("deleteOwnerButton-1")));
      await tester.pumpAndSettle();
      expect(find.byKey(Key("deleteOwnerDialogKey")), findsOneWidget);
    });

    testWidgets("DeleteOwnerDialog is dismissed if confirmDeleteOwnerButtonKey", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      await tester.tap(find.byKey(Key("deleteOwnerButton-1")));
      await tester.pump();
      expect(find.byKey(Key("deleteOwnerDialogKey")), findsOneWidget);
      await tester.tap(find.byKey(Key("confirmDeleteOwnerButtonKey")));
      await tester.pump();
      expect(find.byKey(Key("deleteOwnerDialogKey")), findsNothing);
      await tester.pump(Duration(milliseconds: 500));
    });

    testWidgets("Deleting owners shows CircularProgressIndicator", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      await tester.tap(find.byKey(Key("deleteOwnerButton-1")));
      await tester.pump();
      await tester.tap(find.byKey(Key("confirmDeleteOwnerButtonKey")));
      await tester.pump(Duration(milliseconds: 250));
      expect(find.byType(CircularProgressIndicator), findsWidgets);
      await tester.pump(Duration(milliseconds: 250));
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets("Tapping newOwnerButton shows OwnerForm", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      expect(find.byType(OwnerForm), findsNothing);
      await tester.tap(find.byKey(Key("newOwnerButtonKey")));
      await tester.pump();
      expect(find.byType(OwnerForm), findsOneWidget);
    });

    testWidgets("SaveButton is disabled by default", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      expect(tester.widget<ElevatedButton>(find.byKey(Key("saveButtonKey"))).enabled, false);
    });

    testWidgets("SaveButton is enabled if an owner is edited", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      await tester.tap(find.byKey(Key("editOwnerButton-0")));
      await tester.pump();
      await tester.enterText(find.byKey(Key("firstNameFieldKey")), "firstName");
      await tester.pump(Duration(milliseconds: 300));
      await tester.drag(find.byType(SingleChildScrollView), Offset(0, -1000));
      await tester.pump();
      await tester.tap(find.byKey(Key("submitButtonKey")));
      await tester.pump(Duration(milliseconds: 500));
      expect(tester.widget<ElevatedButton>(find.byKey(Key("saveButtonKey"))).enabled, true);
    });

    testWidgets("Tapping enabled save button shows toast", (tester) async {
      await screenBuilderEdit.createScreen(tester: tester);
      await tester.tap(find.byKey(Key("editOwnerButton-0")));
      await tester.pump();
      await tester.enterText(find.byKey(Key("firstNameFieldKey")), "firstName");
      await tester.pump(Duration(milliseconds: 300));
      await tester.drag(find.byType(SingleChildScrollView), Offset(0, -1000));
      await tester.pump();
      await tester.tap(find.byKey(Key("submitButtonKey")));
      await tester.pump(Duration(milliseconds: 500));
      expect(find.text("Owners Saved!"), findsNothing);
      await tester.drag(find.byType(SingleChildScrollView), Offset(0, 1000));
      await tester.pump();
      await tester.tap(find.byKey(Key("saveButtonKey")));
      await tester.pumpAndSettle();
      expect(find.text("Owners Saved!"), findsOneWidget);
      await tester.pump(Duration(seconds: 3));
      expect(find.text("Owners Saved!"), findsNothing);
    });
  });
}