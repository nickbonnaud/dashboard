import 'package:dashboard/models/business/employee_tip.dart';
import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/repositories/tips_repository.dart';
import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/resources/helpers/currency.dart' as appCurrency;
import 'package:dashboard/screens/tips_screen/tips_screen.dart';
import 'package:dashboard/screens/tips_screen/widgets/tips_screen_body.dart';
import 'package:dashboard/screens/tips_screen/widgets/widgets/employee_tip_finder/employee_tip_finder.dart';
import 'package:dashboard/screens/tips_screen/widgets/widgets/employee_tip_finder/widgets/name_field/name_field.dart';
import 'package:dashboard/screens/tips_screen/widgets/widgets/employee_tip_finder/widgets/tip_finder_list.dart';
import 'package:dashboard/screens/tips_screen/widgets/widgets/employee_tips_header.dart';
import 'package:dashboard/screens/tips_screen/widgets/widgets/employee_tips_list/employee_tips_list.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mock_data_generator.dart';
import '../../helpers/screen_builder.dart';

class MockTipsRepository extends Mock implements TipsRepository {}
class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  group("Tips Screen Tests", () {
    late MockDataGenerator mockDataGenerator;
    late TipsRepository tipsRepository;
    late TransactionRepository transactionRepository;
    late NavigatorObserver observer;
    late ScreenBuilder screenBuilder;

    setUp(() {
      mockDataGenerator = MockDataGenerator();
      tipsRepository = MockTipsRepository();
      transactionRepository = MockTransactionRepository();
      observer = MockNavigatorObserver();

      screenBuilder = ScreenBuilder(
        child: TipsScreen(tipsRepository: tipsRepository, transactionRepository: transactionRepository),
        observer: observer
      );

      when(() => transactionRepository.fetchTotalTipsToday())
        .thenAnswer((_) async => Future.delayed(Duration(milliseconds: 500), () => faker.randomGenerator.integer(10000, min: 100)));

      when(() => transactionRepository.fetchTotalTipsDateRange(dateRange: any(named: "dateRange")))
        .thenAnswer((_) async => Future.delayed(Duration(milliseconds: 500), () => faker.randomGenerator.integer(10000, min: 100)));

      when(() => tipsRepository.fetchAll())
        .thenAnswer((_) async => Future.delayed(Duration(milliseconds: 500), () => PaginateDataHolder(data: List<EmployeeTip>.generate(15, (_) => mockDataGenerator.createEmployeeTip()), next: "next_url")));

      when(() => tipsRepository.fetchAll(dateRange: any(named: "dateRange")))
        .thenAnswer((_) async => Future.delayed(Duration(milliseconds: 500), () => PaginateDataHolder(data: List<EmployeeTip>.generate(15, (_) => mockDataGenerator.createEmployeeTip()), next: "next_url")));

      when(() => tipsRepository.paginate(url: any(named: "url")))
        .thenAnswer((_) async => Future.delayed(Duration(milliseconds: 500), () => PaginateDataHolder(data: List<EmployeeTip>.generate(15, (_) => mockDataGenerator.createEmployeeTip()), next: null)));

      when(() => tipsRepository.fetchByCustomerName(firstName: any(named: "firstName"), lastName: any(named: "lastName"), dateRange: any(named: "dateRange")))
        .thenAnswer((_) async => Future.delayed(Duration(milliseconds: 500), () => List<EmployeeTip>.generate(15, (_) => mockDataGenerator.createEmployeeTip())));
    });

    testWidgets("Tips Screen creates TipsScreenBody", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byType(TipsScreenBody), findsOneWidget);
    });

    testWidgets("Tips Screen Body creates EmployeeTipsHeader", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byType(EmployeeTipsHeader), findsOneWidget);
    });

    testWidgets("Tips Screen Body creates TotalTips", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byKey(Key("totalTipsCardKey")), findsOneWidget);
    });

    testWidgets("Total Tips displays correct amount", (tester) async {
      int totalTips = faker.randomGenerator.integer(10000, min: 100);
      when(() => transactionRepository.fetchTotalTipsToday())
        .thenAnswer((_) async => Future.delayed(Duration(milliseconds: 500), () => totalTips));
      
      await screenBuilder.createScreen(tester: tester);

      expect(find.text(appCurrency.Currency.create(cents: totalTips)), findsOneWidget);
    });

    testWidgets("Total Tips displays error message on fail", (tester) async {
      when(() => transactionRepository.fetchTotalTipsToday())
        .thenThrow(ApiException(error: "error"));
      
      await screenBuilder.createScreen(tester: tester);

      expect(find.text("Error Loading!"), findsOneWidget);
    });

    testWidgets("Tips Screen Body creates EmployeeTipFinder", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byType(EmployeeTipFinder), findsOneWidget);
    });

    testWidgets("Tips Screen Body hides EmployeeTipFinder on screen < TABLET", (tester) async {
      tester.binding.window.physicalSizeTestValue = Size(900, 900);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
      
      await screenBuilder.createScreen(tester: tester);
      expect(find.byType(EmployeeTipFinder), findsNothing);
    });
    
    testWidgets("Employee Tip Finder creates NameField", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byType(NameField), findsOneWidget);
    });
    
    testWidgets("Name Field creates first and last name textfields on screen > TABLET", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byKey(Key("firstNameTextFieldKey")), findsOneWidget);
      expect(find.byKey(Key("lastNameTextFieldKey")), findsOneWidget);
    });

    testWidgets("First Name Text Field can receive input", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      
      String firstName = faker.person.firstName();
      await tester.enterText(find.byKey(Key("firstNameTextFieldKey")), firstName);
      await tester.pump();

      expect(find.text(firstName), findsOneWidget);
    });

    testWidgets("Changing firstNameTextField calls transactionRepository", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      
      String firstName = faker.person.firstName();
      await tester.enterText(find.byKey(Key("firstNameTextFieldKey")), firstName);
      await tester.pump(Duration(seconds: 2));

      verify(() => tipsRepository.fetchByCustomerName(firstName: firstName)).called(1);
    });

    testWidgets("Changing lastNameTextField calls transactionRepository", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      
      String lastName = faker.person.lastName();
      await tester.enterText(find.byKey(Key("lastNameTextFieldKey")), lastName);
      await tester.pump(Duration(seconds: 2));

      verify(() => tipsRepository.fetchByCustomerName(lastName: lastName)).called(1);
    });

    testWidgets("Last Name Text Field can receive input", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      
      String lastName = faker.person.lastName();
      await tester.enterText(find.byKey(Key("lastNameTextFieldKey")), lastName);
      await tester.pump();

      expect(find.text(lastName), findsOneWidget);
    });

    testWidgets("Employee Tip Finder creates TipFinderList", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byType(TipFinderList), findsOneWidget);
    });

    testWidgets("Tip Finder List is initially empty", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byKey(Key("emptyTipFinderListKey")), findsOneWidget);
    });

    testWidgets("Tip Finder List shows CircularProgressIndicator on name changed", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      
      expect(find.byType(CircularProgressIndicator), findsNothing);

      String lastName = faker.person.lastName();
      await tester.enterText(find.byKey(Key("lastNameTextFieldKey")), lastName);
      await tester.pump(Duration(seconds: 1));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump(Duration(milliseconds: 500));

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets("Tip Finder List shows TipsList on success", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      
      expect(find.byKey(Key("employeeTipsListKey")), findsNothing);

      String lastName = faker.person.lastName();
      await tester.enterText(find.byKey(Key("lastNameTextFieldKey")), lastName);
      await tester.pump(Duration(seconds: 2));

      expect(find.byKey(Key("employeeTipsListKey")), findsOneWidget);
    });

    testWidgets("Tip Finder List shows error on fail", (tester) async {
      when(() => tipsRepository.fetchByCustomerName(firstName: any(named: "firstName"), lastName: any(named: "lastName"), dateRange: any(named: "dateRange")))
        .thenThrow(ApiException(error: "Something went very wrong"));
      
      await screenBuilder.createScreen(tester: tester);
      
      expect(find.text("Error: Something went very wrong"), findsNothing);

      String lastName = faker.person.lastName();
      await tester.enterText(find.byKey(Key("lastNameTextFieldKey")), lastName);
      await tester.pump(Duration(seconds: 1));

      expect(find.text("Error: Something went very wrong"), findsOneWidget);
    });

    testWidgets("Tip Finder List shows not tips found widget on empty list", (tester) async {
      when(() => tipsRepository.fetchByCustomerName(firstName: any(named: "firstName"), lastName: any(named: "lastName"), dateRange: any(named: "dateRange")))
        .thenAnswer((_) async => Future.delayed(Duration(milliseconds: 500), () => []));
      
      await screenBuilder.createScreen(tester: tester);
      
      expect(find.text("No Tips Found!"), findsNothing);

      String lastName = faker.person.lastName();
      await tester.enterText(find.byKey(Key("lastNameTextFieldKey")), lastName);
      await tester.pump(Duration(seconds: 2));

      expect(find.text("No Tips Found!"), findsOneWidget);
    });

    testWidgets("Tips Screen Body creates EmployeeTipsList", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byType(EmployeeTipsList), findsOneWidget);
    });

    testWidgets("Employee Tips List displays tipsList on success", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byKey(Key("tipsListKey")), findsOneWidget);
    });

    testWidgets("Employee Tips List displays error message on fail", (tester) async {
      when(() => tipsRepository.fetchAll())
        .thenThrow(ApiException(error: "An Error Occurred!"));
      
      await screenBuilder.createScreen(tester: tester);
      expect(find.text("Error: An Error Occurred!"), findsOneWidget);
    });

    testWidgets("Employee Tips List displays no tips found widget on empty list", (tester) async {
      final List<EmployeeTip> tips = [];
      when(() => tipsRepository.fetchAll())
        .thenAnswer((_) async => Future.delayed(Duration(milliseconds: 500), () => PaginateDataHolder(data: tips, next: null)));
      
      await screenBuilder.createScreen(tester: tester);
      expect(find.text("No Tips Found!"), findsOneWidget);
    });

    testWidgets("Tips Screen Body creates changeDateButton", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byKey(Key("changeDateButtonKey")), findsOneWidget);
    });

    testWidgets("Tips Screen Body creates toggleSearchButton if screen width <= TABLET", (tester) async {
      tester.binding.window.physicalSizeTestValue = Size(900, 900);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      await screenBuilder.createScreen(tester: tester);

      expect(find.byKey(Key("toggleSearchButtonKey")), findsOneWidget);
    });

    testWidgets("Screen width <= TABLET shows EmployeeTipsList hides EmployeeTipFinder", (tester) async {
      tester.binding.window.physicalSizeTestValue = Size(900, 900);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
      await screenBuilder.createScreen(tester: tester);

      expect(find.byType(EmployeeTipsList), findsOneWidget);
      expect(find.byType(EmployeeTipFinder), findsNothing);
    });

    testWidgets("Tapping toggleSearchButton hides EmployeeTipsList and shows EmployeeTipFinder", (tester) async {
      tester.binding.window.physicalSizeTestValue = Size(900, 900);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
      await screenBuilder.createScreen(tester: tester);

      expect(find.byType(EmployeeTipsList), findsOneWidget);
      expect(find.byType(EmployeeTipFinder), findsNothing);

      await tester.tap(find.byKey(Key("toggleSearchButtonKey")));
      await tester.pump();

      expect(find.byType(EmployeeTipsList), findsNothing);
      expect(find.byType(EmployeeTipFinder), findsOneWidget);
    });

    testWidgets("Employee Tip Finder only shows last name if screen size < MOBILE", (tester) async {
      tester.binding.window.physicalSizeTestValue = Size(450, 450);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
      await screenBuilder.createScreen(tester: tester);

      await tester.tap(find.byKey(Key("toggleSearchButtonKey")));
      await tester.pump();

      expect(find.byKey(Key("firstNameTextFieldKey")), findsNothing);
      expect(find.byKey(Key("lastNameTextFieldKey")), findsOneWidget);
    });

    testWidgets("Tips Screen Body hides toggleSearchButton if screen width > TABLET", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byKey(Key("toggleSearchButtonKey")), findsNothing);
    });

    testWidgets("Tapping dateRangePickerButton shows dateRangePicker", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byKey(Key("dateRangePickerKey")), findsNothing);

      await tester.tap(find.byKey(Key("changeDateButtonKey")));
      await tester.pump();
      expect(find.byKey(Key("dateRangePickerKey")), findsOneWidget);
    });

    testWidgets("Tapping cancel on dateRangepicker dismisses dateRangePicker", (tester) async {
      await screenBuilder.createScreen(tester: tester);

      await tester.tap(find.byKey(Key("changeDateButtonKey")));
      await tester.pump();
      expect(find.byKey(Key("dateRangePickerKey")), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      expect(find.byKey(Key("dateRangePickerKey")), findsNothing);
    });

    testWidgets("Tapping cancel on dateRangepicker does not call tipsRepository or transactionRepository", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      verify(() => tipsRepository.fetchAll(dateRange: any(named: "dateRange"))).called(1);

      await tester.tap(find.byKey(Key("changeDateButtonKey")));
      await tester.pump();

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      verifyNever(() => transactionRepository.fetchTotalTipsDateRange(dateRange: any(named: "dateRange")));
      verifyNever(() => tipsRepository.fetchAll(dateRange: any(named: "dateRange")));
    });

    testWidgets("Selecting date range dismisses dateRangePicker", (tester) async {
      await screenBuilder.createScreen(tester: tester);

      await tester.tap(find.byKey(Key("changeDateButtonKey")));
      await tester.pump();

      expect(find.byKey(Key("dateRangePickerKey")), findsOneWidget);

      await tester.tap(find.text("1"));
      await tester.pump();

      await tester.tap(find.text("1"));
      await tester.pumpAndSettle();

      await tester.tap(find.text("Set"));
      await tester.pumpAndSettle();

      expect(find.byKey(Key("dateRangePickerKey")), findsNothing);
    });

    testWidgets("Employee Tips Header displays default text with no dateRange", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.text("Recent Tip Totals"), findsOneWidget);
    });

    testWidgets("Selecting dateRange on picker shows dateRangeHeader", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byKey(Key("dateRangeHeaderKey")), findsNothing);

      await tester.tap(find.byKey(Key("changeDateButtonKey")));
      await tester.pump();

      await tester.tap(find.text("1"));
      await tester.pump();

      await tester.tap(find.text("1"));
      await tester.pumpAndSettle();

      await tester.tap(find.text("Set"));
      await tester.pumpAndSettle();

      expect(find.byKey(Key("dateRangeHeaderKey")), findsOneWidget);
    });

    testWidgets("Selecting dateRange on picker calls tipsRepository && transactionRepository", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      verify(() => tipsRepository.fetchAll(dateRange: any(named: "dateRange"))).called(1);

      await tester.tap(find.byKey(Key("changeDateButtonKey")));
      await tester.pump();

      await tester.tap(find.text("1"));
      await tester.pump();

      await tester.tap(find.text("1"));
      await tester.pumpAndSettle();

      await tester.tap(find.text("Set"));
      await tester.pumpAndSettle();

      verify(() => transactionRepository.fetchTotalTipsDateRange(dateRange: any(named: "dateRange"))).called(1);
      verify(() => tipsRepository.fetchAll(dateRange: any(named: "dateRange"))).called(1);
    });

    testWidgets("Tapping clearDatesButtonKey hides header", (tester) async {
      await screenBuilder.createScreen(tester: tester);

      await tester.tap(find.byKey(Key("changeDateButtonKey")));
      await tester.pump();

      await tester.tap(find.text("1"));
      await tester.pump();

      await tester.tap(find.text("1"));
      await tester.pumpAndSettle();

      await tester.tap(find.text("Set"));
      await tester.pumpAndSettle();

      expect(find.byKey(Key("dateRangeHeaderKey")), findsOneWidget);
      
      await tester.tap(find.byKey(Key("clearDatesButtonKey")));
      await tester.pump(Duration(milliseconds: 500));

      expect(find.byKey(Key("dateRangeHeaderKey")), findsNothing);
    });

    testWidgets("Tapping clearDatesButtonKey calls tipsRepository && transactionRepository", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      verify(() => tipsRepository.fetchAll(dateRange: any(named: "dateRange"))).called(1);

      await tester.tap(find.byKey(Key("changeDateButtonKey")));
      await tester.pump();

      await tester.tap(find.text("1"));
      await tester.pump();

      await tester.tap(find.text("1"));
      await tester.pumpAndSettle();

      await tester.tap(find.text("Set"));
      await tester.pumpAndSettle();
      
      await tester.tap(find.byKey(Key("clearDatesButtonKey")));
      await tester.pump(Duration(milliseconds: 500));

      verify(() => transactionRepository.fetchTotalTipsToday()).called(1);
      verify(() => tipsRepository.fetchAll()).called(1);
    });
  });
}