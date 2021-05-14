import 'package:dashboard/models/refund/refund.dart';
import 'package:dashboard/resources/http/mock_responses.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Refund tests", () {

    test("A Refund can deserialize json", () {
      final Map<String, dynamic> json = MockResponses.generateRefund();
      var refund = Refund.fromJson(json: json);
      expect(refund is Refund, true);
    });
  });
}