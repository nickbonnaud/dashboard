import 'package:dashboard/models/unassigned_transaction/transaction.dart';
import 'package:dashboard/resources/http/mock_responses.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Transaction Tests", () {
    
    test("A Transaction can deserialize json", () {
      final Map<String, dynamic> json = MockResponses.generateUnAssignedTransactionTransaction();
      var transaction = Transaction.fromJson(json: json);
      expect(transaction, isA<Transaction>());
    });
  });
}