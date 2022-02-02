import 'package:dashboard/models/business/profile.dart';
import 'package:dashboard/resources/http/mock_responses.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Profile tests", () {

    test("A Profile can deserialize json", () {
      final Map<String, dynamic> json = MockResponses.generateProfile();
      var profile = Profile.fromJson(json: json);
      expect(profile, isA<Profile>());
    });

    test("A Profile can create an empty placeholder", () {
      var profile = Profile.empty();
      expect(profile, isA<Profile>());
    });

    test("A Profile can update it's attributes", () {
      final Map<String, dynamic> json = MockResponses.generateProfile();
      var profile = Profile.fromJson(json: json);
      final String name = faker.company.name();
      expect(profile.name == name, false);
      profile = profile.update(name: name);
      expect(profile.name == name, true);
    });
  });
}