import 'package:dashboard/models/customer/customer.dart';
import 'package:dashboard/resources/http/mock_responses.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Customer tests", () {

    test("A Customer can deserialize json", () {
      final Map<String, dynamic> json = MockResponses.generateCustomer();
      var customer = Customer.fromJson(json: json);
      expect(customer, isA<Customer>());
    });
  });
}