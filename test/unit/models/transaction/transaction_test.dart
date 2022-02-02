import 'package:dashboard/models/transaction/transaction.dart';
import 'package:dashboard/resources/http/mock_responses.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Transaction Tests", () {

    test("A transaction can deserialize json", () {
      final Map<String, dynamic> json = MockResponses.generateTransaction();
      var transaction = Transaction.fromJson(json: json);
      expect(transaction, isA<Transaction>());
    }); 
  });
}