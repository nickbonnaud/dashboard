import 'package:dashboard/models/customer/customer_resource.dart';
import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/repositories/customer_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/customers_screen/customers_screen.dart';
import 'package:dashboard/screens/customers_screen/widgets/widgets/widgets/widgets/customer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../helpers/mock_data_generator.dart';
import '../../helpers/screen_builder.dart';

class MockCustomerRepository extends Mock implements CustomerRepository {}

void main() {
  
  group("Customers Screen Tests", () {
    late MockDataGenerator mockDataGenerator;
    late NavigatorObserver observer;
    late CustomerRepository customerRepository;
    late ScreenBuilder screenBuilder;

    setUp(() {
      mockDataGenerator = MockDataGenerator();
      observer = MockNavigatorObserver();
      customerRepository = MockCustomerRepository();
      screenBuilder = ScreenBuilder(
        child: CustomersScreen(customerRepository: customerRepository), 
        observer: observer
      );

      when(() => customerRepository.fetchAll(searchHistoric: any(named: "searchHistoric"), withTransactions: any(named: "withTransactions"), dateRange: any(named: "dateRange")))
        .thenAnswer((_) async => Future.delayed(Duration(milliseconds: 500), () => PaginateDataHolder(
          data: List<CustomerResource>.generate(15, (index) => mockDataGenerator.createCustomerResource()),
          next: "next_url"
        )));

      when(() => customerRepository.paginate(url: any(named: "url")))
        .thenAnswer((_) async => Future.delayed(Duration(milliseconds: 500), () => PaginateDataHolder(
          data: List<CustomerResource>.generate(15, (index) => mockDataGenerator.createCustomerResource()),
          next: "next_url"
        )));

      registerFallbackValue(MockRoute());
    });

    testWidgets("Customers Screen creates changeDateButton", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.byKey(Key("datePickerButtonKey")), findsOneWidget);
    });

    testWidgets("Tapping changeDateButton shows dateRangePicker", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.byKey(Key("dateRangePickerKey")), findsNothing);
      await tester.tap(find.byKey(Key("datePickerButtonKey")));
      await tester.pump();
      expect(find.byKey(Key("dateRangePickerKey")), findsOneWidget);
    });

    testWidgets("Tapping cancel on dateRangePicker hides dateRangePicker", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      await tester.tap(find.byKey(Key("datePickerButtonKey")));
      await tester.pump();
      expect(find.byKey(Key("dateRangePickerKey")), findsOneWidget);
      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();
      expect(find.byKey(Key("dateRangePickerKey")), findsNothing);
    });

    testWidgets("Selecting dates on picker displays hides date picker", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      await tester.tap(find.byKey(Key("datePickerButtonKey")));
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

    testWidgets("Selecting dates on picker redos search", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      await tester.tap(find.byKey(Key("datePickerButtonKey")));
      await tester.pump();

      await tester.tap(find.text("1"));
      await tester.pump();
      await tester.tap(find.text("1"));
      await tester.pumpAndSettle();

      await tester.tap(find.text("Set"));
      await tester.pump(Duration(milliseconds: 400));
      expect(find.byType(CustomerWidget), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump(Duration(milliseconds: 100));
      expect(find.byType(CustomerWidget), findsWidgets);
    });

    testWidgets("Search Display initial text is Previous Customers & With Transactions", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.text("Previous Customers"), findsOneWidget);
      expect(find.text("With Transactions"), findsOneWidget);
    });


    testWidgets("Search Display can change to Active Customers", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      await tester.tap(find.byKey(Key("filterButtonKey")));
      await tester.pumpAndSettle();
      expect(find.text("Active Customers"), findsNothing);
      await tester.tap(find.byKey(Key("historic")));
      await tester.pump();
      expect(find.text("Active Customers"), findsOneWidget);
      await tester.pump(Duration(milliseconds: 500));
    });

    testWidgets("Changing to Active Customers redos search", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      await tester.tap(find.byKey(Key("filterButtonKey")));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key("historic")));
      
      await tester.pump(Duration(milliseconds: 400));
      expect(find.byType(CustomerWidget), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump(Duration(milliseconds: 100));
      expect(find.byType(CustomerWidget), findsWidgets);
    });

    testWidgets("Search Display can change to Transactions", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      await tester.tap(find.byKey(Key("filterButtonKey")));
      await tester.pumpAndSettle();
      expect(find.text("Without Transactions"), findsNothing);
      await tester.tap(find.byKey(Key("withTransaction")));
      await tester.pump();
      expect(find.text("Without Transactions"), findsOneWidget);
      await tester.pump(Duration(milliseconds: 500));
    });

    testWidgets("Change to Transactions redos search", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      await tester.tap(find.byKey(Key("filterButtonKey")));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key("withTransaction")));
      
      await tester.pump(Duration(milliseconds: 400));
      expect(find.byType(CustomerWidget), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump(Duration(milliseconds: 100));
      expect(find.byType(CustomerWidget), findsWidgets);
    });

    testWidgets("Date display is empty initially", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      await tester.pump();
      expect(find.byKey(Key("datesRowKey")), findsNothing);
    });

    testWidgets("Selecting dates shows Date Display", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      await tester.tap(find.byKey(Key("datePickerButtonKey")));
      await tester.pump();
      expect(find.byKey(Key("dateRangePickerKey")), findsOneWidget);

      await tester.tap(find.text("1"));
      await tester.pump();
      await tester.tap(find.text("1"));
      await tester.pumpAndSettle();

      await tester.tap(find.text("Set"));
      await tester.pumpAndSettle();
      expect(find.byKey(Key("datesRowKey")), findsOneWidget);
    });

    testWidgets("Tapping clear dates button removes Date Display", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      await tester.tap(find.byKey(Key("datePickerButtonKey")));
      await tester.pump();
      expect(find.byKey(Key("dateRangePickerKey")), findsOneWidget);

      await tester.tap(find.text("1"));
      await tester.pump();
      await tester.tap(find.text("1"));
      await tester.pumpAndSettle();

      await tester.tap(find.text("Set"));
      await tester.pumpAndSettle();
      
      await tester.tap(find.byKey(Key("clearDatesButtonKey")));
      await tester.pump();
      expect(find.byKey(Key("datesRowKey")), findsNothing);
      await tester.pump(Duration(milliseconds: 500));
    });

    testWidgets("Tapping clear dates redos search", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      await tester.tap(find.byKey(Key("datePickerButtonKey")));
      await tester.pump();
      expect(find.byKey(Key("dateRangePickerKey")), findsOneWidget);

      await tester.tap(find.text("1"));
      await tester.pump();
      await tester.tap(find.text("1"));
      await tester.pumpAndSettle();

      await tester.tap(find.text("Set"));
      await tester.pumpAndSettle();
      
      await tester.tap(find.byKey(Key("clearDatesButtonKey")));
      await tester.pump(Duration(milliseconds: 400));
      expect(find.byType(CustomerWidget), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump(Duration(milliseconds: 100));
      expect(find.byType(CustomerWidget), findsWidgets);
    });

    testWidgets("Customers List is scrollable", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      await tester.pump();
      expect(find.byKey(Key("customer-0")), findsOneWidget);
      await tester.fling(find.byType(CustomScrollView), Offset(0, -200), 3000);
      await tester.pumpAndSettle();
      expect(find.byKey(Key("customer-0")), findsNothing);
      await tester.pump(Duration(milliseconds: 500));
    });

    testWidgets("Customers List fetches more data when threshold reached", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      await tester.pump();
      verifyNever(() => customerRepository.paginate(url: any(named: "url")));
      await tester.fling(find.byType(CustomScrollView), Offset(0, -1000), 1000);
      await tester.pump(Duration(milliseconds: 1000));
      verify(() => customerRepository.paginate(url: any(named: "url"))).called(1);
      await tester.pump(Duration(milliseconds: 500));
    });

    testWidgets("Tapping on Customer Widget navigates to Receipt Screen", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      await tester.pump();
      await tester.tap(find.byKey(Key("customer-0")));
      await tester.pump();
      verify(() => observer.didPush(any(), any()));
    });

    testWidgets("Fetching data on error shows error message", (tester) async {
      when(() => customerRepository.fetchAll(searchHistoric: any(named: "searchHistoric"), withTransactions: any(named: "withTransactions"), dateRange: any(named: "dateRange")))
        .thenThrow(ApiException(error: "error"));

      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      await tester.pump();
      expect(find.text("Error: error"), findsOneWidget);
      expect(find.text("Please try again"), findsOneWidget);
    });

    testWidgets("Fetching data no customers shows no customers message", (tester) async {
      List<CustomerResource> emptyList = [];
      when(() => customerRepository.fetchAll(searchHistoric: any(named: "searchHistoric"), withTransactions: any(named: "withTransactions"), dateRange: any(named: "dateRange")))
        .thenAnswer((_) async => PaginateDataHolder(
          data: emptyList,
          next: "next_url"
        ));

      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      await tester.pump();
      expect(find.text("No Customers Found!"), findsOneWidget);
    });
  });
}