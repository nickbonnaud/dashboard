import 'package:dashboard/models/business/business.dart';
import 'package:dashboard/resources/http/mock_responses.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Business Tests", () {

    test('A Business can deserialize json', () {
      final Map<String, dynamic> json = MockResponses.generateBusiness();
      var business = Business.fromJson(json: json);
      expect(business is Business, true);
    });
    
    test("A business can update it's attributes", () {
      var business = Business.fromJson(json: MockResponses.generateBusiness());
      final String oldEmail = business.email;
      final String newEmail = faker.internet.email();

      expect(business.email == oldEmail, true);
      expect(business.email == newEmail, false);

      business = business.update(email: newEmail);
      expect(business.email == oldEmail, false);
      expect(business.email == newEmail, true);
    });
  });
}