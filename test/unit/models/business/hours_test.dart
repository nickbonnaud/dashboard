import 'package:dashboard/models/business/hours.dart';
import 'package:dashboard/resources/http/mock_responses.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  
  group("Hours Tests", () {

    test("Hours can deserialize json", () {
      final Map<String, dynamic> json = MockResponses.generateHours();
      var hours = Hours.fromJson(json: json);
      expect(hours, isA<Hours>());
    });

    test("Hours can generate Empty", () {
      var hours = Hours.empty();
      expect(hours, isA<Hours>());
    });

    test("Hours can get earliest opening", () {
      final String earliest = "6:00 AM";
      final Map<String, dynamic> json = MockResponses.generateHours(earliest: earliest);
      var hours = Hours.fromJson(json: json);
      expect(hours.earliest, earliest);
    });

    test("Hours can get latest closing", () {
      final String latest = "2:00 AM";
      final Map<String, dynamic> json = MockResponses.generateHours(latest: latest);
      var hours = Hours.fromJson(json: json);
      expect(hours.latest, latest);
    });

    test("Hours can get each days hours in list", () {
      final Map<String, dynamic> json = MockResponses.generateHours();
      var hours = Hours.fromJson(json: json);
      expect(hours.days.length, 7);
    });
  });
}