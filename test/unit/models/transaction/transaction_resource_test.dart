import 'package:dashboard/models/transaction/transaction_resource.dart';
import 'package:dashboard/resources/http/mock_responses.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Transaction Resource ", () {

    test("A Transaction Resource can deserialize json", () {
      final Map<String, dynamic> json = MockResponses.generateTransactionResource();
      var transactionResource = TransactionResource.fromJson(json: json);
      expect(transactionResource is TransactionResource, true);
    });
  });
}