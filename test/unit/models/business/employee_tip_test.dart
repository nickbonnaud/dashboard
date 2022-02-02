import 'package:dashboard/models/business/employee_tip.dart';
import 'package:dashboard/resources/http/mock_responses.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Employee Tip Test", () {

    test("An Employee Tip can deserialize json", () {
      final Map<String, dynamic> json = MockResponses.generateEmployeeTip();
      var tip = EmployeeTip.fromJson(json: json);
      expect(tip, isA<EmployeeTip>());
    });
  });
}