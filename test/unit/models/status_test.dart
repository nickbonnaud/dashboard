import 'package:dashboard/models/status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Status tests", () {

    test("A Status can deserialize json", () {
      final Map<String, dynamic> json = { 'name': 'open', 'code': 100 };
      var status = Status.fromJson(json: json);
      expect(status is Status, true);
    });

    test("A Status can create an unknown Status", () {
      var status = Status.unknown();
      expect(status is Status, true);
    });
  });
}