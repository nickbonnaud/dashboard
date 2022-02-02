import 'package:dashboard/models/business/employee.dart';
import 'package:dashboard/resources/http/mock_responses.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Employee Tests", () {

    test("An Employee can deserialize json", () {
      final Map<String, dynamic> json = MockResponses.generateEmployee();
      var employee = Employee.fromJson(json: json);
      expect(employee, isA<Employee>());
    });
  });
}