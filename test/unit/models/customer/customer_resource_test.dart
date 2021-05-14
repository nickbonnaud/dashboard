import 'package:dashboard/models/customer/customer_resource.dart';
import 'package:dashboard/resources/http/mock_responses.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Customer Resource Tests", () {

    test("A Customer Resource can deserialize json", () {
      final Map<String, dynamic> json = MockResponses.generateCustomerResource();
      var customerResource = CustomerResource.fromJson(json: json);
      expect(customerResource is CustomerResource, true);
    });
  });
}