import 'package:dashboard/global_widgets/purchased_item_widget.dart';
import 'package:dashboard/models/customer/customer_resource.dart';
import 'package:dashboard/resources/helpers/currency.dart';
import 'package:dashboard/resources/helpers/date_formatter.dart';
import 'package:dashboard/screens/customers_screen/widgets/widgets/widgets/widgets/receipt_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:dashboard/extensions/string_extensions.dart';

import '../../helpers/mock_data_generator.dart';
import '../../helpers/screen_builder.dart';

void main() {
  group("Customer Screen -> Receipt Screen tests", () {
    late MockDataGenerator mockDataGenerator;
    late NavigatorObserver observer;
    late CustomerResource customerResource;
    late ScreenBuilder screenBuilder;

    setUpAll(() {
      mockDataGenerator = MockDataGenerator();
      observer = MockNavigatorObserver();
      customerResource = mockDataGenerator.createCustomerResource(requiresTransaction: true, requiresRefund: true);
      screenBuilder = ScreenBuilder(child: ReceiptScreen(customerResource: customerResource), observer: observer);
      registerFallbackValue<Route>(MockRoute());
    });

    testWidgets("Receipt Screen shows relevant customer data", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));

      expect(find.text("${customerResource.customer.firstName} ${customerResource.customer.lastName}"), findsOneWidget);
      expect(find.text(DateFormatter.toStringDateTime(date: customerResource.transaction!.updatedAt)), findsOneWidget);
      expect(find.text("${customerResource.transaction!.status.name.capitalizeFirstEach}"), findsOneWidget);
      expect(find.byType(PurchasedItemWidget), findsWidgets);
      expect(find.text(Currency.create(cents: customerResource.transaction!.netSales)), findsOneWidget);
      expect(find.text(Currency.create(cents: customerResource.transaction!.tax)), findsOneWidget);
      expect(find.text(Currency.create(cents: customerResource.transaction!.tip)), findsOneWidget);
      expect(find.text("(${Currency.create(cents: customerResource.transaction!.refunds.fold(0, (previousValue, element) => previousValue + element.total))})"), findsOneWidget);
      expect(find.text(Currency.create(cents: customerResource.transaction!.total - customerResource.transaction!.refunds.fold(0, (previousValue, element) => previousValue + element.total))), findsOneWidget);
      expect(find.text("Transaction ID: ${customerResource.transaction!.identifier}"), findsOneWidget);
      if (customerResource.notification != null) {
        expect(find.text("Last Notification: ${customerResource.notification!.lastNotification} at ${DateFormatter.toStringDateTime(date: customerResource.notification!.updatedAt)}"), findsOneWidget);
      }
    });

    testWidgets("Pressing close icon dismisses Receipt Screen", (tester) async {
      await mockNetworkImagesFor(() => screenBuilder.createScreen(tester: tester));
      await tester.tap(find.byIcon(Icons.arrow_downward));
      await tester.pump();
      verify(() => observer.didPush(any(), any()));
    });
  });
}