import 'package:dashboard/models/customer/transaction.dart';
import 'package:dashboard/resources/http/mock_responses.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Customer Transaction Tests", () {

    test("A Transaction can deserialize json", () {
      final Map<String, dynamic> json = MockResponses.generateCustomerTransaction();
      var transaction = Transaction.fromJson(json: json);
      expect(transaction is Transaction, true);
    });
  });
}