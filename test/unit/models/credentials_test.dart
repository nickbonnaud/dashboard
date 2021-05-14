import 'package:dashboard/models/credentials.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Credentials tests", () {

    test("Credentials can deserialize json", () {
      final Map<String, dynamic> json = { 'google_key': faker.guid.guid() };
      var credentials = Credentials.fromJson(json: json);
      expect(credentials is Credentials, true);
    });
  });
}