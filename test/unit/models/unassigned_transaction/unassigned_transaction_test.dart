import 'package:dashboard/models/unassigned_transaction/unassigned_transaction.dart';
import 'package:dashboard/resources/http/mock_responses.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Unassigned Transaction tests", () {

    test("An Unassigned Transaction can deserialize json", () {
      final Map<String, dynamic> json = MockResponses.generateUnassignedTransaction();
      var unassignedTransaction = UnassignedTransaction.fromJson(json: json);
      expect(unassignedTransaction, isA<UnassignedTransaction>());
    });
  });
}