import 'package:dashboard/models/business/location.dart';
import 'package:dashboard/resources/http/mock_responses.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  
  group("Location Tests", () {

    test("Location can deserialize json", () {
      final Map<String, dynamic> json = MockResponses.generateLocation();
      var location = Location.fromJson(json: json);
      expect(location, isA<Location>());
    });

    test("Location can create an Empty placeholder", () {
      var location = Location.empty();
      expect(location, isA<Location>());
    });
  });
}