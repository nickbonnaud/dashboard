import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/resources/helpers/currency.dart' as app_currency;
import 'package:dashboard/screens/sales_screen/sales_screen.dart';
import 'package:dashboard/screens/sales_screen/widgets/sales_screen_body.dart';
import 'package:dashboard/screens/sales_screen/widgets/widgets/net_sales/net_sales.dart';
import 'package:dashboard/screens/sales_screen/widgets/widgets/total_sales/total_sales.dart';
import 'package:dashboard/screens/sales_screen/widgets/widgets/total_taxes/total_taxes.dart';
import 'package:dashboard/screens/sales_screen/widgets/widgets/total_tips/total_tips.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/screen_builder.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  group("Sales Screen Tests", () {
    late TransactionRepository transactionRepository;
    late NavigatorObserver observer;
    late ScreenBuilder screenBuilder;

    setUp(() {
      transactionRepository = MockTransactionRepository();
      observer = MockNavigatorObserver();
      screenBuilder = ScreenBuilder(
        child: RepositoryProvider(
          create: (_) => transactionRepository,
          child: const SalesScreen(),
        ),
        observer: observer
      );

      when(() => transactionRepository.fetchNetSalesToday())
        .thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 500), () => faker.randomGenerator.integer(10000, min: 100)));
      when(() => transactionRepository.fetchNetSalesDateRange(dateRange: any(named: "dateRange")))
        .thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 500), () => faker.randomGenerator.integer(10000, min: 100)));

      when(() => transactionRepository.fetchTotalSalesToday())
        .thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 500), () => faker.randomGenerator.integer(10000, min: 100)));
      when(() => transactionRepository.fetchTotalSalesDateRange(dateRange: any(named: "dateRange")))
        .thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 500), () => faker.randomGenerator.integer(10000, min: 100)));

      when(() => transactionRepository.fetchTotalTaxesToday())
        .thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 500), () => faker.randomGenerator.integer(10000, min: 100)));
      when(() => transactionRepository.fetchTotalTaxesDateRange(dateRange: any(named: "dateRange")))
        .thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 500), () => faker.randomGenerator.integer(10000, min: 100)));

      when(() => transactionRepository.fetchTotalTipsToday())
        .thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 500), () => faker.randomGenerator.integer(10000, min: 100)));
      when(() => transactionRepository.fetchTotalTipsDateRange(dateRange: any(named: "dateRange")))
        .thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 500), () => faker.randomGenerator.integer(10000, min: 100)));
    });

    testWidgets("Sales Screen creates SalesScreenBody", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byType(SalesScreenBody), findsOneWidget);
    });

    testWidgets("SalesScreenBody creates NetSales widget", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byType(NetSales), findsOneWidget);
    });

    testWidgets("NetSales widget displays correct net sales amount", (tester) async {
      int netSales = faker.randomGenerator.integer(10000, min: 100);
      when(() => transactionRepository.fetchNetSalesToday())
        .thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 500), () => netSales));
      
      await screenBuilder.createScreen(tester: tester);
      expect(find.text(app_currency.Currency.create(cents: netSales)), findsOneWidget);
    });

    testWidgets("NetSales widget displays error on fetch fail", (tester) async {
      when(() => transactionRepository.fetchNetSalesToday())
        .thenThrow(const ApiException(error: "error"));
      
      await screenBuilder.createScreen(tester: tester);
      expect(find.text("Error Loading!"), findsOneWidget);
    });

    testWidgets("SalesScreenBody creates TotalSales widget", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byType(TotalSales), findsOneWidget);
    });

    testWidgets("TotalSales widget displays correct total sales amount", (tester) async {
      int totalSales = faker.randomGenerator.integer(10000, min: 100);
      when(() => transactionRepository.fetchTotalSalesToday())
        .thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 500), () => totalSales));
      
      await screenBuilder.createScreen(tester: tester);
      expect(find.text(app_currency.Currency.create(cents: totalSales)), findsOneWidget);
    });

    testWidgets("TotalSales widget displays error on fetch fail", (tester) async {
      when(() => transactionRepository.fetchTotalSalesToday())
        .thenThrow(const ApiException(error: "error"));
      
      await screenBuilder.createScreen(tester: tester);
      expect(find.text("Error Loading!"), findsOneWidget);
    });

    testWidgets("SalesScreenBody creates TotalTaxes widget", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byType(TotalTaxes), findsOneWidget);
    });

    testWidgets("TotalTaxes widget displays correct total taxes amount", (tester) async {
      int totalTaxes = faker.randomGenerator.integer(10000, min: 100);
      when(() => transactionRepository.fetchTotalTaxesToday())
        .thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 500), () => totalTaxes));
      
      await screenBuilder.createScreen(tester: tester);
      expect(find.text(app_currency.Currency.create(cents: totalTaxes)), findsOneWidget);
    });

    testWidgets("TotalTaxes widget displays error on fetch fail", (tester) async {
      when(() => transactionRepository.fetchTotalTaxesToday())
        .thenThrow(const ApiException(error: "error"));
      
      await screenBuilder.createScreen(tester: tester);
      expect(find.text("Error Loading!"), findsOneWidget);
    });

    testWidgets("SalesScreenBody creates TotalTips widget", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byType(TotalTips), findsOneWidget);
    });

    testWidgets("TotalTips widget displays correct total tips amount", (tester) async {
      int totalTips = faker.randomGenerator.integer(10000, min: 100);
      when(() => transactionRepository.fetchTotalTipsToday())
        .thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 500), () => totalTips));
      
      await screenBuilder.createScreen(tester: tester);
      expect(find.text(app_currency.Currency.create(cents: totalTips)), findsOneWidget);
    });

    testWidgets("TotalTips widget displays error on fetch fail", (tester) async {
      when(() => transactionRepository.fetchTotalTipsToday())
        .thenThrow(const ApiException(error: "error"));
      
      await screenBuilder.createScreen(tester: tester);
      expect(find.text("Error Loading!"), findsOneWidget);
    });

    testWidgets("SalesScreenBody creates dateRangePickerButton", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byKey(const Key("dateRangePickerButtonKey")), findsOneWidget);
    });

    testWidgets("Tapping dateRangePickerButton shows dateRangePicker", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      
      await tester.tap(find.byKey(const Key("dateRangePickerButtonKey")));
      await tester.pump();

      expect(find.byKey(const Key("dateRangePickerKey")), findsOneWidget);
    });

    testWidgets("Tapping cancel on dateRangePicker dismisses picker", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      
      await tester.tap(find.byKey(const Key("dateRangePickerButtonKey")));
      await tester.pump();
      expect(find.byKey(const Key("dateRangePickerKey")), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();
      expect(find.byKey(const Key("dateRangePickerKey")), findsNothing);

    });

    testWidgets("Tapping cancel on dateRangePicker does not call transactionRepository", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      
      await tester.tap(find.byKey(const Key("dateRangePickerButtonKey")));
      await tester.pump();

      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();

      verifyNever(() => transactionRepository.fetchNetSalesDateRange(dateRange: any(named: "dateRange")));
      verifyNever(() => transactionRepository.fetchTotalSalesDateRange(dateRange: any(named: "dateRange")));
      verifyNever(() => transactionRepository.fetchTotalTaxesDateRange(dateRange: any(named: "dateRange")));
      verifyNever(() => transactionRepository.fetchTotalTipsDateRange(dateRange: any(named: "dateRange")));
    });

    testWidgets("Changing dates on dateRangePicker dismisses picker", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      
      await tester.tap(find.byKey(const Key("dateRangePickerButtonKey")));
      await tester.pump();

      expect(find.byKey(const Key("dateRangePickerKey")), findsOneWidget);

      await tester.tap(find.text("1"));
      await tester.pump();

      await tester.tap(find.text("1"));
      await tester.pumpAndSettle();

      await tester.tap(find.text("Set"));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key("dateRangePickerKey")), findsNothing);
    });

    testWidgets("Selecting dates on dateRangePicker shows dateRangeHeader", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      
      expect(find.byKey(const Key("dateRangeHeaderKey")), findsNothing);
      
      await tester.tap(find.byKey(const Key("dateRangePickerButtonKey")));
      await tester.pump();

      await tester.tap(find.text("1"));
      await tester.pump();

      await tester.tap(find.text("1"));
      await tester.pumpAndSettle();

      await tester.tap(find.text("Set"));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key("dateRangeHeaderKey")), findsOneWidget);
    });

    testWidgets("Selecting dates on dateRangePicker calls transactionRepository", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      
      await tester.tap(find.byKey(const Key("dateRangePickerButtonKey")));
      await tester.pump();

      await tester.tap(find.text("1"));
      await tester.pump();

      await tester.tap(find.text("1"));
      await tester.pumpAndSettle();

      await tester.tap(find.text("Set"));
      await tester.pumpAndSettle();

      verify(() => transactionRepository.fetchNetSalesDateRange(dateRange: any(named: "dateRange"))).called(1);
      verify(() => transactionRepository.fetchTotalSalesDateRange(dateRange: any(named: "dateRange"))).called(1);
      verify(() => transactionRepository.fetchTotalTaxesDateRange(dateRange: any(named: "dateRange"))).called(1);
      verify(() => transactionRepository.fetchTotalTipsDateRange(dateRange: any(named: "dateRange"))).called(1);
    });

    testWidgets("Tapping clear dates button hides headers", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      
      await tester.tap(find.byKey(const Key("dateRangePickerButtonKey")));
      await tester.pump();

      await tester.tap(find.text("1"));
      await tester.pump();

      await tester.tap(find.text("1"));
      await tester.pumpAndSettle();

      await tester.tap(find.text("Set"));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key("dateRangeHeaderKey")), findsOneWidget);

      await tester.tap(find.byKey(const Key("clearDatesButtonKey")));
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byKey(const Key("dateRangeHeaderKey")), findsNothing);
    });

    testWidgets("Tapping clear dates button calls transactionRepository", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      
      await tester.tap(find.byKey(const Key("dateRangePickerButtonKey")));
      await tester.pump();

      await tester.tap(find.text("1"));
      await tester.pump();

      await tester.tap(find.text("1"));
      await tester.pumpAndSettle();

      await tester.tap(find.text("Set"));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key("dateRangeHeaderKey")), findsOneWidget);

      await tester.tap(find.byKey(const Key("clearDatesButtonKey")));
      await tester.pump(const Duration(milliseconds: 500));

      verify(() => transactionRepository.fetchNetSalesToday()).called(1);
      verify(() => transactionRepository.fetchTotalSalesToday()).called(1);
      verify(() => transactionRepository.fetchTotalTaxesToday()).called(1);
      verify(() => transactionRepository.fetchTotalTipsToday()).called(1);
    });
  });
}