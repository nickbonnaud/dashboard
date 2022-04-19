import 'package:dashboard/global_widgets/transaction_widget.dart';
import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/models/transaction/transaction_resource.dart';
import 'package:dashboard/repositories/refund_repository.dart';
import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/resources/helpers/currency.dart' as app_currency;
import 'package:dashboard/screens/quick_dashboard_screen/quick_dashboard_screen.dart';
import 'package:dashboard/screens/quick_dashboard_screen/widgets/quick_dashboard_body.dart';
import 'package:dashboard/screens/quick_dashboard_screen/widgets/widgets/last_month/last_month.dart';
import 'package:dashboard/screens/quick_dashboard_screen/widgets/widgets/recent_transactions/recent_transactions.dart';
import 'package:dashboard/screens/quick_dashboard_screen/widgets/widgets/today/today.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../helpers/mock_data_generator.dart';
import '../../helpers/screen_builder.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}
class MockRefundRepository extends Mock implements RefundRepository {}

void main() {
  group("Quick Dashboard Screen Tests", () {
    late MockDataGenerator mockDataGenerator;
    late TransactionRepository transactionRepository;
    late RefundRepository refundRepository;
    late ScreenBuilder screenBuilder;

    setUp(() {
      mockDataGenerator = MockDataGenerator();
      transactionRepository = MockTransactionRepository();
      refundRepository = MockRefundRepository();
      screenBuilder = ScreenBuilder(
        child: MultiRepositoryProvider(
          providers: [
            RepositoryProvider(
              create: (_) => transactionRepository
            ),

            RepositoryProvider(
              create: (_) => refundRepository
            )
          ],
          child: const QuickDashboardScreen()
        ),
        observer: MockNavigatorObserver(),
        business: mockDataGenerator.createBusiness()
      );

      when(() => transactionRepository.fetchNetSalesToday())
        .thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 500), () => faker.randomGenerator.integer(10000)));

      when(() => refundRepository.fetchTotalRefundsToday())
        .thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 500), () => faker.randomGenerator.integer(10000)));

      when(() => transactionRepository.fetchTotalTipsToday())
        .thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 500), () => faker.randomGenerator.integer(10000)));
      
      when(() => transactionRepository.fetchTotalSalesToday())
        .thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 500), () => faker.randomGenerator.integer(10000)));

      when(() => transactionRepository.fetchNetSalesMonth())
        .thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 500), () => faker.randomGenerator.integer(10000)));

      when(() => transactionRepository.fetchTotalTaxesMonth())
        .thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 500), () => faker.randomGenerator.integer(10000)));

      when(() => transactionRepository.fetchTotalTipsMonth())
        .thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 500), () => faker.randomGenerator.integer(10000)));

      when(() => transactionRepository.fetchTotalSalesMonth())
        .thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 500), () => faker.randomGenerator.integer(10000)));

      when(() => refundRepository.fetchTotalRefundsMonth())
        .thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 500), () => faker.randomGenerator.integer(10000)));

      when(() => transactionRepository.fetchTotalUniqueCustomersMonth())
        .thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 500), () => faker.randomGenerator.integer(100)));

      when(() => transactionRepository.fetchTotalTransactionsMonth())
        .thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 500), () => faker.randomGenerator.integer(100)));

      when(() => transactionRepository.fetchAll())
        .thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 500), () => PaginateDataHolder(data: List<TransactionResource>.generate(10, (index) => mockDataGenerator.createTransactionResource()))));
    });

    testWidgets("QuickDashboardScreen creates QuickDashboardBody", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.byType(QuickDashboardBody), findsOneWidget);
    });

    testWidgets("QuickDashboardBody creates Today widget", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.byType(Today), findsOneWidget);
    });

    testWidgets("NetSalesToday widget displays net sales today on success", (tester) async {
      int amount = faker.randomGenerator.integer(10000);
      when(() => transactionRepository.fetchNetSalesToday())
        .thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 500), () => amount));
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));

      expect(find.text(app_currency.Currency.create(cents: amount)), findsOneWidget);
    });

    testWidgets("NetSalesToday widget displays error on fail", (tester) async {
      when(() => transactionRepository.fetchNetSalesToday())
        .thenThrow(const ApiException(error: "Error Loading!"));
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));

      expect(find.text("Error Loading!"), findsOneWidget);
    });
    
    testWidgets("TotalRefundsToday widget displays total refunds today on success", (tester) async {
      int amount = faker.randomGenerator.integer(10000);
      when(() => refundRepository.fetchTotalRefundsToday())
        .thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 500), () => amount));
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));

      expect(find.text(app_currency.Currency.create(cents: amount)), findsOneWidget);
    });
    
    testWidgets("TotalRefundsToday widget displays error on fail", (tester) async {
      when(() => refundRepository.fetchTotalRefundsToday())
        .thenThrow(const ApiException(error: "Error Loading!"));
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));

      expect(find.text("Error Loading!"), findsOneWidget);
    });

    testWidgets("TotalSalesToday widget displays total sales today on success", (tester) async {
      int amount = faker.randomGenerator.integer(10000);
      when(() => transactionRepository.fetchTotalSalesToday())
        .thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 500), () => amount));
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));

      expect(find.text(app_currency.Currency.create(cents: amount)), findsOneWidget);
    });

    testWidgets("TotalSalesToday widget displays error on fail", (tester) async {
      when(() => transactionRepository.fetchTotalSalesToday())
        .thenThrow(const ApiException(error: "Error Loading!"));
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));

      expect(find.text("Error Loading!"), findsOneWidget);
    });

    testWidgets("TotalTipsToday widget displays total tips today on success", (tester) async {
      int amount = faker.randomGenerator.integer(10000);
      when(() => transactionRepository.fetchTotalTipsToday())
        .thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 500), () => amount));
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));

      expect(find.text(app_currency.Currency.create(cents: amount)), findsOneWidget);
    });
    
    testWidgets("TotalTipsToday widget displays error on fail", (tester) async {
      when(() => transactionRepository.fetchTotalTipsToday())
        .thenThrow(const ApiException(error: "Error Loading!"));
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));

      expect(find.text("Error Loading!"), findsOneWidget);
    });
    
    testWidgets("QuickDashboardBody creates RecentTransactions widget", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.byType(RecentTransactions), findsOneWidget);
    });

    testWidgets("RecentTransactions widget shows max 5 transactionWidgets", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.byType(TransactionWidget), findsNWidgets(5));
    });

    testWidgets("RecentTransactions widget shows not transactions text if no transactions fetched", (tester) async {
      List<TransactionResource> empty = [];
      when(() => transactionRepository.fetchAll())
        .thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 500), () => PaginateDataHolder(data: empty)));
      
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.text("No recent transactions."), findsOneWidget);
    });

    testWidgets("RecentTransactions widget shows error message on fetch fail", (tester) async {
      when(() => transactionRepository.fetchAll())
        .thenThrow(const ApiException(error: "An Error Happened!"));
      
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.text("Error: An Error Happened!"), findsOneWidget);
    });

    testWidgets("QuickDashboardBody creates Last 30 Days widget", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.byType(LastMonth), findsOneWidget);
    });

    testWidgets("Net Sales Month widget displays net sales month on success", (tester) async {
      int amount = faker.randomGenerator.integer(10000);
      when(() => transactionRepository.fetchNetSalesMonth())
        .thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 500), () => amount));
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));

      expect(find.text(app_currency.Currency.create(cents: amount)), findsOneWidget);
    });

    testWidgets("Net Sales Month widget displays error on fail", (tester) async {
      when(() => transactionRepository.fetchNetSalesMonth())
        .thenThrow(const ApiException(error: "Error Loading!"));
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));

      expect(find.byIcon(Icons.warning), findsOneWidget);
    });

    testWidgets("Total Refunds Month widget displays total refunds month on success", (tester) async {
      int amount = faker.randomGenerator.integer(10000);
      when(() => refundRepository.fetchTotalRefundsMonth())
        .thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 500), () => amount));
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));

      expect(find.text(app_currency.Currency.create(cents: amount)), findsOneWidget);
    });

    testWidgets("Total Refunds Month widget displays error on fail", (tester) async {
      when(() => refundRepository.fetchTotalRefundsMonth())
        .thenThrow(const ApiException(error: "Error Loading!"));
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));

      expect(find.byIcon(Icons.warning), findsOneWidget);
    });

    testWidgets("Total Sales Month widget displays total sales month on success", (tester) async {
      int amount = faker.randomGenerator.integer(10000);
      when(() => transactionRepository.fetchTotalSalesMonth())
        .thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 500), () => amount));
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));

      expect(find.text(app_currency.Currency.create(cents: amount)), findsOneWidget);
    });

    testWidgets("Total Sales Month widget displays error on fail", (tester) async {
      when(() => transactionRepository.fetchTotalSalesMonth())
        .thenThrow(const ApiException(error: "Error Loading!"));
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));

      expect(find.byIcon(Icons.warning), findsOneWidget);
    });

    testWidgets("Total Taxes Month widget displays total taxes month on success", (tester) async {
      int amount = faker.randomGenerator.integer(10000);
      when(() => transactionRepository.fetchTotalTaxesMonth())
        .thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 500), () => amount));
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));

      expect(find.text(app_currency.Currency.create(cents: amount)), findsOneWidget);
    });

    testWidgets("Total Taxes Month widget displays error on fail", (tester) async {
      when(() => transactionRepository.fetchTotalTaxesMonth())
        .thenThrow(const ApiException(error: "Error Loading!"));
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));

      expect(find.byIcon(Icons.warning), findsOneWidget);
    });

    testWidgets("Total Tips Month widget displays total tips month on success", (tester) async {
      int amount = faker.randomGenerator.integer(10000);
      when(() => transactionRepository.fetchTotalTipsMonth())
        .thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 500), () => amount));
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));

      expect(find.text(app_currency.Currency.create(cents: amount)), findsOneWidget);
    });

    testWidgets("Total Tips Month widget displays error on fail", (tester) async {
      when(() => transactionRepository.fetchTotalTipsMonth())
        .thenThrow(const ApiException(error: "Error Loading!"));
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));

      expect(find.byIcon(Icons.warning), findsOneWidget);
    });

    testWidgets("Total Transactions Month widget displays total transactions month on success", (tester) async {
      int amount = faker.randomGenerator.integer(10000);
      when(() => transactionRepository.fetchTotalTransactionsMonth())
        .thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 500), () => amount));
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));

      expect(find.text("$amount"), findsOneWidget);
    });

    testWidgets("Total Transactions Month widget displays error on fail", (tester) async {
      when(() => transactionRepository.fetchTotalTransactionsMonth())
        .thenThrow(const ApiException(error: "Error Loading!"));
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));

      expect(find.byIcon(Icons.warning), findsOneWidget);
    });

    testWidgets("Total Unique Customers Month widget displays total unique customers month on success", (tester) async {
      int amount = faker.randomGenerator.integer(10000);
      when(() => transactionRepository.fetchTotalUniqueCustomersMonth())
        .thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 500), () => amount));
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));

      expect(find.text("$amount"), findsOneWidget);
    });

    testWidgets("Total Unique Customers Month widget displays error on fail", (tester) async {
      when(() => transactionRepository.fetchTotalUniqueCustomersMonth())
        .thenThrow(const ApiException(error: "Error Loading!"));
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));

      expect(find.byIcon(Icons.warning), findsOneWidget);
    });
  });
}