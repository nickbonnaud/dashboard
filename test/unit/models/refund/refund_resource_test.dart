import 'package:dashboard/models/refund/refund_resource.dart';
import 'package:dashboard/resources/http/mock_responses.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Refund Resource Test", () {

    test("A Refund Resource can deserialize json", () {
      final Map<String, dynamic> json = MockResponses.generateRefundResource();
      var refundResource = RefundResource.fromJson(json: json);
      expect(refundResource, isA<RefundResource>());
    });
  });
}