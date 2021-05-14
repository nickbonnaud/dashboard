import 'package:dashboard/global_widgets/app_bars/bottom_modal_app_bar.dart';
import 'package:dashboard/global_widgets/purchased_item_widget.dart';
import 'package:dashboard/models/transaction/purchased_item.dart';
import 'package:dashboard/models/transaction/transaction_resource.dart';
import 'package:dashboard/resources/helpers/currency.dart';
import 'package:dashboard/resources/helpers/date_formatter.dart';
import 'package:dashboard/screens/receipt_screen/receipt_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../helpers/mock_data_generator.dart';
import '../../helpers/screen_builder.dart';

void main() {
  group("Receipt Screen Tests", () {
    late MockDataGenerator mockDataGenerator;
    late TransactionResource transactionResource;
    late NavigatorObserver observer;
    late ScreenBuilder screenBuilder;

    setUp(() {
      mockDataGenerator = MockDataGenerator();
      transactionResource = mockDataGenerator.createTransactionResource();
      observer = MockNavigatorObserver();
      screenBuilder = ScreenBuilder(
        child: ReceiptScreen(transactionResource: transactionResource),
        observer: observer
      );
    });

    testWidgets("Receipt screen shows BottomModalAppBar", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.byType(BottomModalAppBar), findsOneWidget);
    });

    testWidgets("Receipt screen shows CircleAvatar", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets("Receipt screen displays customer first and last name", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.text("${transactionResource.customer.firstName} ${transactionResource.customer.lastName}"), findsOneWidget);
    });

    testWidgets("Receipt screen displays when transaction updated at", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.text(DateFormatter.toStringDateTime(date: transactionResource.transaction.updatedAt)), findsOneWidget);
    });

    testWidgets("Receipt screen displays correct number PurchasedItemWidgets", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.byType(PurchasedItemWidget), findsNWidgets(transactionResource.purchasedItems.length));
    });

    testWidgets("Purchased Item Widget displays quantity", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      PurchasedItem item = transactionResource.purchasedItems.first;
      expect(find.text(item.quantity.toString()), findsWidgets);
    });

    testWidgets("Purchased Item Widget displays name", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      PurchasedItem item = transactionResource.purchasedItems.first;
      expect(find.text(item.name), findsOneWidget);
    });

    testWidgets("Purchased Item Widget displays subName", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      PurchasedItem item = transactionResource.purchasedItems.first;
      expect(find.text(item.subName as String), findsOneWidget);
    });

    testWidgets("Purchased Item Widget displays total", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      PurchasedItem item = transactionResource.purchasedItems.first;
      expect(find.text(Currency.create(cents: item.total)), findsOneWidget);
    });




    testWidgets("Receipt screen displays Subtotal amount", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.text(Currency.create(cents: transactionResource.transaction.netSales)), findsOneWidget);
    });

    testWidgets("Receipt screen displays Tax amount", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.text(Currency.create(cents: transactionResource.transaction.tax)), findsOneWidget);
    });

    testWidgets("Receipt screen displays Tip amount", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.text(Currency.create(cents: transactionResource.transaction.tip)), findsOneWidget);
    });

    testWidgets("Receipt screen displays Total amount", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      int total = transactionResource.transaction.total - transactionResource.refunds.fold(0, (total, refund) => total + refund.total);
      expect(find.text(Currency.create(cents: total)), findsOneWidget);
    });

    testWidgets("Receipt screen displays Transaction Id", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.text("Transaction ID: ${transactionResource.transaction.identifier}"), findsOneWidget);
    });

    testWidgets("Receipt screen displays refund row", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.text("(${Currency.create(cents: transactionResource.refunds.fold(0, (total, refund) => total + refund.total))})"), findsOneWidget);
    });
  });
}