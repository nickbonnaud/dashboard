import 'package:dashboard/models/transaction/purchased_item.dart';
import 'package:dashboard/resources/http/mock_responses.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Purchased Items Test", () {

    test("A Purchased Item can deserialize json", () {
      final Map<String, dynamic> json = MockResponses.generatePurchasedItem();
      var purchasedItem = PurchasedItem.fromJson(json: json);
      expect(purchasedItem is PurchasedItem, true);
    });
  });
}