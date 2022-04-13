import 'package:dashboard/models/business/pos_account.dart';
import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/models/unassigned_transaction/unassigned_transaction.dart';
import 'package:dashboard/repositories/unassigned_transaction_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/unassigned_transactions_screen/unassigned_transactions_screen.dart';
import 'package:dashboard/screens/unassigned_transactions_screen/widgets/unassigned_transactions_screen_body.dart';
import 'package:dashboard/screens/unassigned_transactions_screen/widgets/widgets/unassigned_transactions_header.dart';
import 'package:dashboard/screens/unassigned_transactions_screen/widgets/widgets/unassigned_transactions_list/unassigned_transactions_list.dart';
import 'package:dashboard/screens/unassigned_transactions_screen/widgets/widgets/unassigned_transactions_list/widgets/unassigned_transaction_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mock_data_generator.dart';
import '../../helpers/screen_builder.dart';

class MockUnassignedTransactionRepository extends Mock implements UnassignedTransactionRepository {}
class MockPosAccount extends Mock implements PosAccount {}

void main() {
  group("Unassigned Transactions Screen Tests", () {
    late MockDataGenerator mockDataGenerator;
    late UnassignedTransactionRepository unassignedTransactionRepository;
    late PosAccount posAccount;
    late NavigatorObserver observer;
    late ScreenBuilder screenBuilder;

    setUp(() {
      mockDataGenerator = MockDataGenerator();
      unassignedTransactionRepository = MockUnassignedTransactionRepository();
      posAccount = MockPosAccount();
      when(() => posAccount.typeToString).thenReturn("type");
      observer = MockNavigatorObserver();

      screenBuilder = ScreenBuilder(
        child: UnassignedTransactionsScreen(unassignedTransactionRepository: unassignedTransactionRepository),
        observer: observer
      );

      when(() => unassignedTransactionRepository.fetchAll())
        .thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 500), () => PaginateDataHolder(data: List<UnassignedTransaction>.generate(15, (_) => mockDataGenerator.createUnassignedTransaction()), next: "next_url")));

      when(() => unassignedTransactionRepository.fetchAll(dateRange: any(named: "dateRange")))
        .thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 500), () => PaginateDataHolder(data: List<UnassignedTransaction>.generate(15, (_) => mockDataGenerator.createUnassignedTransaction()), next: "next_url")));

      when(() => unassignedTransactionRepository.paginate(url: any(named: "url")))
        .thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 500), () => PaginateDataHolder(data: List<UnassignedTransaction>.generate(15, (_) => mockDataGenerator.createUnassignedTransaction()), next: "next_url")));

      registerFallbackValue(MockRoute());
    });

    testWidgets("Unassigned Transactions Screen creates UnassignedTransactionsScreenBody", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byType(UnassignedTransactionsScreenBody), findsOneWidget);
    });

    testWidgets("Unassigned Transactions Screen Body creates UnassignedTransactionsHeader", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byType(UnassignedTransactionsHeader), findsOneWidget);
    });

    testWidgets("Unassigned Transactions Header initially displays noDateRangeHeader", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.text("Unmatched Bills"), findsOneWidget);
    });
    
    testWidgets("Unassigned Transactions Header shows dateRangeHeader when date range selected", (tester) async {
      await screenBuilder.createScreen(tester: tester);

      expect(find.byKey(const Key("dateRangeHeader")), findsNothing);

      await tester.tap(find.byKey(const Key("dateRangePickerButtonKey")));
      await tester.pump();

      await tester.tap(find.text("1"));
      await tester.pump();

      await tester.tap(find.text("1"));
      await tester.pumpAndSettle();

      await tester.tap(find.text("Set"));
      await tester.pumpAndSettle();
      
      expect(find.byKey(const Key("dateRangeHeader")), findsOneWidget);
    });

    testWidgets("Tapping clearDatesButton hides dateRangeHeader", (tester) async {
      await screenBuilder.createScreen(tester: tester);

      await tester.tap(find.byKey(const Key("dateRangePickerButtonKey")));
      await tester.pump();

      await tester.tap(find.text("1"));
      await tester.pump();

      await tester.tap(find.text("1"));
      await tester.pumpAndSettle();

      await tester.tap(find.text("Set"));
      await tester.pumpAndSettle();
      
      expect(find.byKey(const Key("dateRangeHeader")), findsOneWidget);

      await tester.tap(find.byKey(const Key("clearDatesButtonKey")));
      await tester.pump();

      expect(find.byKey(const Key("dateRangeHeader")), findsNothing);
      
      await tester.pump(const Duration(milliseconds: 500));
    });

    testWidgets("Tapping clearDatesButton calls unassignedTransactionsRepository", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      verify(() => unassignedTransactionRepository.fetchAll()).called(1);

      await tester.tap(find.byKey(const Key("dateRangePickerButtonKey")));
      await tester.pump();

      await tester.tap(find.text("1"));
      await tester.pump();

      await tester.tap(find.text("1"));
      await tester.pumpAndSettle();

      await tester.tap(find.text("Set"));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key("clearDatesButtonKey")));
      await tester.pump();
      
      await tester.pump(const Duration(milliseconds: 500));

      verify(() => unassignedTransactionRepository.fetchAll()).called(1);
    });

    testWidgets("Unassigned Transactions Header initially displays showInfoButton", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byKey(const Key("showInfoButtonKey")), findsOneWidget);
    });

    testWidgets("Tapping showInfoButton displays infoDialog", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      
      expect(find.byKey(const Key("infoDialogKey")), findsNothing);

      await tester.tap(find.byKey(const Key("showInfoButtonKey")));
      await tester.pump();

      expect(find.byKey(const Key("infoDialogKey")), findsOneWidget);
    });

    testWidgets("InfoDialog can be dismissed", (tester) async {
      await screenBuilder.createScreen(tester: tester);

      await tester.tap(find.byKey(const Key("showInfoButtonKey")));
      await tester.pump();

      expect(find.byKey(const Key("infoDialogKey")), findsOneWidget);

      await tester.tap(find.byKey(const Key("dismissInfoDialogKey")));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key("infoDialogKey")), findsNothing);
    });

    testWidgets("Unassigned Transactions Screen Body creates UnassignedTransactionsList", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byType(UnassignedTransactionsList), findsOneWidget);
    });

    testWidgets("Unassigned Transactions List displays UnassignedTransactionWidget", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byType(UnassignedTransactionWidget), findsWidgets);
    });

    testWidgets("Tapping unassignedTransactionWidget pushes ReceiptScreenUnassigned", (tester) async {
      await screenBuilder.createScreen(tester: tester);

      await tester.tap(find.byKey(const Key("unassignedTransactionsCard-0")));
      await tester.pump();

      verify(() => observer.didPush(any(), any()));
    });

    testWidgets("Unassigned Transactions List is scrollable", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      
      expect(find.byKey(const Key("unassignedTransactionsCard-0")), findsOneWidget);

      await tester.fling(find.byKey(const Key("unassignedTransactionsListKey")), const Offset(0, -500), 1000);
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      expect(find.byKey(const Key("unassignedTransactionsCard-0")), findsNothing);
    });

    testWidgets("Unassigned Transactions List can paginate data", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      verifyNever(() => unassignedTransactionRepository.paginate(url: any(named: "url")));

      await tester.fling(find.byKey(const Key("unassignedTransactionsListKey")), const Offset(0, -1000), 1000);
      await tester.pump(const Duration(milliseconds: 1000));

      verify(() => unassignedTransactionRepository.paginate(url: any(named: "url"))).called(1);
    });

    testWidgets("Unassigned Transactions List displays error on fetch fail", (tester) async {
      when(() => unassignedTransactionRepository.fetchAll())
        .thenThrow(const ApiException(error: "error happened"));
      
      await screenBuilder.createScreen(tester: tester);

      expect(find.text("Error: error happened"), findsOneWidget);
    });

    testWidgets("Unassigned Transactions List displays noTransactionsFound if fetch returns empty list", (tester) async {
      List<UnassignedTransaction> transactions = [];
      
      when(() => unassignedTransactionRepository.fetchAll())
        .thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 500), () => PaginateDataHolder(data: transactions, next: null)));
      
      await screenBuilder.createScreen(tester: tester);

      expect(find.text("No Transactions Found!"), findsOneWidget);
    });

    testWidgets("Unassigned Transactions Screen Body creates dateRangePickerButton", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byKey(const Key("dateRangePickerButtonKey")), findsOneWidget);
    });

    testWidgets("Tapping dateRangePickerButton shows dateRangePicker", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byKey(const Key("dateRangePickerKey")), findsNothing);

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
      await tester.pumpAndSettle();
      expect(find.byKey(const Key("dateRangePickerKey")), findsNothing);
    });

    testWidgets("Tapping cancel on dateRangePicker does not call unassignedTransactionsRespository", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      verify(() => unassignedTransactionRepository.fetchAll(dateRange: any(named: "dateRange"))).called(1);

      await tester.tap(find.byKey(const Key("dateRangePickerButtonKey")));
      await tester.pump();


      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      
      verifyNever(() => unassignedTransactionRepository.fetchAll(dateRange: any(named: "dateRange")));
    });

    testWidgets("Selecting date range and tapping Set dismisses dateRangePicker", (tester) async {
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

    testWidgets("Selecting date range and tapping Set calls unassignedTransactionRepository", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      verify(() => unassignedTransactionRepository.fetchAll(dateRange: any(named: "dateRange"))).called(1);
      
      await tester.tap(find.byKey(const Key("dateRangePickerButtonKey")));
      await tester.pump();

      await tester.tap(find.text("1"));
      await tester.pump();

      await tester.tap(find.text("1"));
      await tester.pumpAndSettle();

      await tester.tap(find.text("Set"));
      await tester.pumpAndSettle();
      
      verify(() => unassignedTransactionRepository.fetchAll(dateRange: any(named: "dateRange"))).called(1);
    });
  });
}