import 'package:dashboard/models/business/address.dart';
import 'package:dashboard/resources/http/mock_responses.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/mock_response_scrubber.dart';

void main() {
  final MockResponseScrubber _scrubber = MockResponseScrubber();
  group("Business Address Tests", () {

    test("An Address can deserialize json", () {
      final Map<String, dynamic> json = _scrubber.scrub(json: MockResponses.generateAddress());
      var address = Address.fromJson(json: json);
      expect(address is Address, true);
    });
    
    test("An Address can create an empty placeholder", () {
      var address = Address.empty();
      expect(address is Address, true);
    });
  });
}