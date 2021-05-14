import 'package:dashboard/global_widgets/transaction_widget.dart';
import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/models/transaction/transaction_resource.dart';
import 'package:dashboard/models/transaction_filter.dart';
import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/historic_transactions_screen/historic_transactions_screen.dart';
import 'package:dashboard/screens/historic_transactions_screen/widgets/widgets/widgets/search_bar/search_bar.dart';
import 'package:dashboard/screens/historic_transactions_screen/widgets/widgets/widgets/search_bar/widgets/date_range_picker.dart';
import 'package:dashboard/screens/historic_transactions_screen/widgets/widgets/widgets/search_bar/widgets/filter_button.dart';
import 'package:dashboard/screens/historic_transactions_screen/widgets/widgets/widgets/search_bar/widgets/search_field/search_field.dart';
import 'package:dashboard/screens/historic_transactions_screen/widgets/widgets/widgets/search_display.dart';
import 'package:dashboard/screens/historic_transactions_screen/widgets/widgets/widgets/transactions_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../helpers/mock_data_generator.dart';
import '../../helpers/screen_builder.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  group("Historic Transactions Screen Tests", () {
    late MockDataGenerator mockDataGenerator;
    late NavigatorObserver observer;
    late TransactionRepository transactionRepository;
    late ScreenBuilder screenBuilder;

    setUp(() {
      mockDataGenerator = MockDataGenerator();
      observer = MockNavigatorObserver();
      transactionRepository = MockTransactionRepository();
      screenBuilder = ScreenBuilder(
        child: HistoricTransactionsScreen(transactionRepository: transactionRepository),
        observer: observer
      );

      when(() => transactionRepository.fetchAll())
        .thenAnswer((_) async => Future.delayed(Duration(milliseconds: 500), () => PaginateDataHolder(
          data: List<TransactionResource>.generate(15, (index) => mockDataGenerator.createTransactionResource()),
          next: "next_url"
      )));

      when(() => transactionRepository.fetchAll(dateRange: any(named: "dateRange")))
        .thenAnswer((_) async => Future.delayed(Duration(milliseconds: 500), () => PaginateDataHolder(
          data: List<TransactionResource>.generate(15, (index) => mockDataGenerator.createTransactionResource()),
          next: "next_url"
      )));

      when(() => transactionRepository.fetchByTransactionId(transactionId: any(named: "transactionId")))
        .thenAnswer((_) async => Future.delayed(Duration(milliseconds: 500), () => PaginateDataHolder(
          data: List<TransactionResource>.generate(15, (index) => mockDataGenerator.createTransactionResource()),
          next: "next_url"
      )));

      when(() => transactionRepository.fetchByEmployeeName(firstName: any(named: "firstName"), lastName: any(named: "lastName")))
        .thenAnswer((_) async => Future.delayed(Duration(milliseconds: 500), () => PaginateDataHolder(
          data: List<TransactionResource>.generate(15, (index) => mockDataGenerator.createTransactionResource()),
          next: "next_url"
      )));

      when(() => transactionRepository.fetchByCode(code: any(named: "code")))
        .thenAnswer((_) async => Future.delayed(Duration(milliseconds: 500), () => PaginateDataHolder(
          data: List<TransactionResource>.generate(15, (index) => mockDataGenerator.createTransactionResource()),
          next: "next_url"
      )));

      when(() => transactionRepository.paginate(url: any(named: "url")))
        .thenAnswer((_) async => Future.delayed(Duration(milliseconds: 500), () => PaginateDataHolder(
          data: List<TransactionResource>.generate(15, (index) => mockDataGenerator.createTransactionResource()),
          next: "next_url"
      )));

      registerFallbackValue<Route>(MockRoute());
    });

    testWidgets("Historic Transactions Screen creates SearchDisplay", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.byType(SearchDisplay), findsOneWidget);
    });

    testWidgets("Historic Transactions Screen creates SearchBar", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.byType(SearchBar), findsOneWidget);
    });

    testWidgets("Historic Transactions Screen creates TransactionsList", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.byType(TransactionsList), findsOneWidget);
    });

    testWidgets("Historic Transactions Screen creates header", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.text("Recent"), findsOneWidget);
    });

    testWidgets("SearchBar creates DateRangePicker", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.byType(DateRangePicker), findsOneWidget);
    });

    testWidgets("SearchBar creates SearchField", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.byType(SearchField), findsOneWidget);
    });

    testWidgets("SearchBar creates FilterButton", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.byType(FilterButton), findsOneWidget);
    });

    testWidgets("Tapping dateRangePicker button shows DateRangePicker", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.byKey(Key("dateRangePickerKey")), findsNothing);
      await tester.tap(find.byIcon(Icons.date_range));
      await tester.pump();

      expect(find.byKey(Key("dateRangePickerKey")), findsOneWidget);
    });

    testWidgets("Tapping cancel on DateRangePicker dismisses DateRangePicker", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      await tester.tap(find.byIcon(Icons.date_range));
      await tester.pump();
      expect(find.byKey(Key("dateRangePickerKey")), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();
      expect(find.byKey(Key("dateRangePickerKey")), findsNothing);
    });

    testWidgets("Selecting dates on DateRangePicker hides DateRangePicker", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      await tester.tap(find.byIcon(Icons.date_range));
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

    testWidgets("Selecting dates on DateRangePicker shows SearchDisplay date display", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.byKey(Key("dateDisplayKey")), findsNothing);
      await tester.tap(find.byIcon(Icons.date_range));
      await tester.pump();

      await tester.tap(find.text("1"));
      await tester.pump();
      await tester.tap(find.text("1"));
      await tester.pumpAndSettle();
      await tester.tap(find.text("Set"));
      await tester.pumpAndSettle();
      expect(find.byKey(Key("dateDisplayKey")), findsOneWidget);
    });

    testWidgets("Selecting dates on DateRangePicker redos search", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      await tester.tap(find.byIcon(Icons.date_range));
      await tester.pump();

      await tester.tap(find.text("1"));
      await tester.pump();
      await tester.tap(find.text("1"));
      await tester.pumpAndSettle();

      await tester.tap(find.text("Set"));
      await tester.pump(Duration(milliseconds: 400));
      expect(find.byType(TransactionWidget), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump(Duration(milliseconds: 100));
      expect(find.byType(TransactionWidget), findsWidgets);
    });

    testWidgets("Clearing SearchDisplay dates redos search", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      await tester.tap(find.byIcon(Icons.date_range));
      await tester.pump();

      await tester.tap(find.text("1"));
      await tester.pump();
      await tester.tap(find.text("1"));
      await tester.pumpAndSettle();

      await tester.tap(find.text("Set"));
      await tester.pump(Duration(milliseconds: 500));
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pump(Duration(milliseconds: 400));
      expect(find.byType(TransactionWidget), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump(Duration(milliseconds: 100));
      expect(find.byType(TransactionWidget), findsWidgets);
    });

    testWidgets("Selecting new Filter displays filter in Search Display", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.text("Transaction ID"), findsNothing);
      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key(FilterType.transactionId.toString())));
      await tester.pumpAndSettle();
      expect(find.text("Transaction ID"), findsNWidgets(2));
    });

    testWidgets("Selecting new ID Filter displays Id Search Field", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.byKey(Key("idSearchFieldKey")), findsNothing);
      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key(FilterType.transactionId.toString())));
      await tester.pumpAndSettle();
      expect(find.byKey(Key("idSearchFieldKey")), findsOneWidget);
    });

    testWidgets("Entering correct identifier in ID Search field redos search", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key(FilterType.transactionId.toString())));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(Key("idSearchFieldKey")), "5b58ccc1-32d2-45bf-8b7e-204a3a651d84");
      await tester.pump(Duration(seconds: 1));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(TransactionWidget), findsNothing);
      await tester.pump(Duration(milliseconds: 500));
      expect(find.byType(TransactionWidget), findsWidgets);
    });

    testWidgets("Entering incorrect identifier in ID Search field does nothing", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key(FilterType.transactionId.toString())));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(Key("idSearchFieldKey")), "5b5_ccc1-32d-8b7e-204!a651d84");
      await tester.pump(Duration(seconds: 1));

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(TransactionWidget), findsWidgets);
    });

    testWidgets("Selecting new Name Filter displays Name Search Fields", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.byKey(Key("lastNameSearchFieldKey")), findsNothing);
      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key(FilterType.employeeName.toString())));
      await tester.pumpAndSettle();
      expect(find.byKey(Key("lastNameSearchFieldKey")), findsOneWidget);
    });

    testWidgets("Entering valid name in last name search field redos search", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key(FilterType.employeeName.toString())));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(Key("lastNameSearchFieldKey")), "last");
      await tester.pump(Duration(seconds: 1));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(TransactionWidget), findsNothing);
      await tester.pump(Duration(milliseconds: 500));
      expect(find.byType(TransactionWidget), findsWidgets);
    });

    testWidgets("Entering invalid name in last name search field does nothing", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key(FilterType.employeeName.toString())));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(Key("lastNameSearchFieldKey")), "l");
      await tester.pump(Duration(seconds: 1));

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(TransactionWidget), findsWidgets);
    });

    testWidgets("Selecting new Status Filter displays Status Search picker", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.byKey(Key("statusPickerKey")), findsNothing);
      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key(FilterType.status.toString())));
      await tester.pumpAndSettle();
      expect(find.byKey(Key("statusPickerKey")), findsOneWidget);
    });

    testWidgets("Selecting status to filter by redos search", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.byKey(Key("statusPickerKey")), findsNothing);
      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key(FilterType.status.toString())));
      await tester.pump();
      await tester.tap(find.byKey(Key("statusPickerKey")));
      await tester.pump();
      await tester.tap(find.text("Paid").last);
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(TransactionWidget), findsNothing);
      await tester.pump(Duration(milliseconds: 500));
      expect(find.byType(TransactionWidget), findsWidgets);
    });

    testWidgets("Selecting reset filter option redos search", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key(FilterType.all.toString())));
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      await tester.pump(Duration(milliseconds: 500));
      expect(find.byType(TransactionWidget), findsWidgets);
    });

    testWidgets("Api Exception displays message", (tester) async {
      when(() => transactionRepository.fetchAll())
        .thenThrow(ApiException(error: "An error occurred!"));
      
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.text("Error: An error occurred!"), findsOneWidget);
    });

    testWidgets("Empty response displays empty response text", (tester) async {
      List<TransactionResource> emptyResponse = [];
      when(() => transactionRepository.fetchAll())
        .thenAnswer((_) async => Future.delayed(Duration(milliseconds: 500), () => PaginateDataHolder(
          data: emptyResponse,
          next: "next_url"
        )));
      
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.text("No Transactions Found!"), findsOneWidget);
    });

    testWidgets("TransactionsList List is scrollable", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.byKey(Key("transaction-0")), findsOneWidget);
      await tester.fling(find.byType(CustomScrollView), Offset(0, -200), 3000);
      await tester.pumpAndSettle();
      expect(find.byKey(Key("transaction-0")), findsNothing);
      await tester.pump(Duration(milliseconds: 500));
    });

    testWidgets("TransactionsList fetches more data when threshold reached", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      verifyNever(() => transactionRepository.paginate(url: any(named: "url")));
      await tester.fling(find.byType(CustomScrollView), Offset(0, -1000), 1000);
      await tester.pump(Duration(milliseconds: 1000));
      verify(() => transactionRepository.paginate(url: any(named: "url"))).called(1);
      await tester.pump(Duration(milliseconds: 500));
    });

    testWidgets("Tapping on Transaction Widget navigates to Receipt Screen", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      await tester.tap(find.byKey(Key("transaction-0")));
      await tester.pumpAndSettle();
      verify(() => observer.didPush(any(), any()));
    });
  });
}