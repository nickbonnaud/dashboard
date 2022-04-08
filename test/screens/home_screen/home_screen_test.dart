import 'package:dashboard/global_widgets/app_bars/default_app_bar.dart';
import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/models/transaction/transaction_resource.dart';
import 'package:dashboard/repositories/customer_repository.dart';
import 'package:dashboard/repositories/refund_repository.dart';
import 'package:dashboard/repositories/tips_repository.dart';
import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:dashboard/repositories/unassigned_transaction_repository.dart';
import 'package:dashboard/screens/historic_transactions_screen/historic_transactions_screen.dart';
import 'package:dashboard/screens/home_screen/home_screen.dart';
import 'package:dashboard/screens/home_screen/widgets/home_screen_body.dart';
import 'package:dashboard/screens/quick_dashboard_screen/quick_dashboard_screen.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../helpers/mock_data_generator.dart';
import '../../helpers/screen_builder.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}
class MockRefundRepository extends Mock implements RefundRepository {}
class MockTipsRepository extends Mock implements TipsRepository {}
class MockUnassignedTransactionRepository extends Mock implements UnassignedTransactionRepository {}
class MockCustomerRepository extends Mock implements CustomerRepository {}

void main() {
  group("Home Screen Tests", () {
    late MockDataGenerator mockDataGenerator;
    late NavigatorObserver observer;
    late TransactionRepository transactionRepository;
    late RefundRepository refundRepository;
    late TipsRepository tipsRepository;
    late UnassignedTransactionRepository unassignedTransactionRepository;
    late CustomerRepository customerRepository;
    late ScreenBuilder screenBuilder;

    setUp(() {
      mockDataGenerator = MockDataGenerator();
      observer = MockNavigatorObserver();
      transactionRepository = MockTransactionRepository();
      refundRepository = MockRefundRepository();
      tipsRepository = MockTipsRepository();
      unassignedTransactionRepository = MockUnassignedTransactionRepository();
      customerRepository = MockCustomerRepository();

      screenBuilder = ScreenBuilder(
        child: HomeScreen(
          transactionRepository: transactionRepository,
          refundRepository: refundRepository,
          tipsRepository: tipsRepository,
          unassignedTransactionRepository: unassignedTransactionRepository,
          customerRepository: customerRepository,
          posAccount: mockDataGenerator.createPosAccount()
        ), 
        observer: observer
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

    testWidgets("Home Screen creates HomeScreenBody", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.byType(HomeScreenBody), findsOneWidget);
    });

    testWidgets("Home Screen Body creates DefaultAppBar", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.byType(DefaultAppBar), findsOneWidget);
    });

    testWidgets("Home Screen Body can show drawer menu", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.byKey(const Key("menuDrawerKey")), findsNothing);

      expect(find.byIcon(Icons.menu), findsOneWidget);

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key("menuDrawerKey")), findsOneWidget);
    });

    testWidgets("Home Screen Body contains TabBarView", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.byType(TabBarView), findsOneWidget);
    });

    testWidgets("Initial tab of TabBarView is QuickDashboardScreen", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.byType(QuickDashboardScreen), findsOneWidget);
    });

    testWidgets("Tapping on another tab hides current tab and shows tapped tab", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.byType(QuickDashboardScreen), findsOneWidget);
      expect(find.byType(HistoricTransactionsScreen), findsNothing);

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      
      await tester.tap(find.text("Transactions"));
      await tester.pumpAndSettle();

      expect(find.byType(QuickDashboardScreen), findsNothing);
      expect(find.byType(HistoricTransactionsScreen), findsOneWidget);
    });
  });
}