import 'package:dashboard/global_widgets/app_bars/bottom_modal_app_bar.dart';
import 'package:dashboard/global_widgets/purchased_item_widget.dart';
import 'package:dashboard/models/unassigned_transaction/unassigned_transaction.dart';
import 'package:dashboard/resources/helpers/currency.dart';
import 'package:dashboard/resources/helpers/date_formatter.dart';
import 'package:dashboard/screens/receipt_screen_unassigned/receipt_screen_unassigned.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../helpers/mock_data_generator.dart';
import '../../helpers/screen_builder.dart';

void main() {
  group("Receipt Screen Unassigned Tests", () {
    late MockDataGenerator mockDataGenerator;
    late UnassignedTransaction unassignedTransaction;
    late NavigatorObserver observer;
    late ScreenBuilder screenBuilder;

    setUp(() {
      mockDataGenerator = MockDataGenerator();
      unassignedTransaction = mockDataGenerator.createUnassignedTransaction();
      observer = MockNavigatorObserver();
      screenBuilder = ScreenBuilder(
        child: ReceiptScreenUnassigned(unassignedTransaction: unassignedTransaction),
        observer: observer
      );
    });

    testWidgets("Receipt Screen Unassigned shows BottomModalAppBar", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.byType(BottomModalAppBar), findsOneWidget);
    });

    testWidgets("Receipt Screen Unassigned creates CircleAvatar", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets("Receipt Screen Unassigned displays createdAt date", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.text(DateFormatter.toStringDateTime(date: unassignedTransaction.transaction.createdAt)), findsOneWidget);
    });

    testWidgets("Receipt Screen Unassigned displays correct number of PurchasedItemWidgets", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.byType(PurchasedItemWidget), findsNWidgets(unassignedTransaction.transaction.purchasedItems.length));
    });

    testWidgets("Receipt Screen Unassigned displays Subtotal", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.text(Currency.create(cents: unassignedTransaction.transaction.netSales)), findsOneWidget);
    });

    testWidgets("Receipt Screen Unassigned displays Tax", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.text(Currency.create(cents: unassignedTransaction.transaction.tax)), findsOneWidget);
    });

    testWidgets("Receipt Screen Unassigned displays Total", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.text(Currency.create(cents: unassignedTransaction.transaction.total)), findsOneWidget);
    });

    testWidgets("Receipt Screen Unassigned displays employee name", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      expect(find.text("Employee: ${unassignedTransaction.employee!.firstName} ${unassignedTransaction.employee!.lastName}"), findsOneWidget);
    });
  });
}