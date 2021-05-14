import 'package:dashboard/models/token.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Hour tests", () {

    test("A Token can deserialize json", () {
      final Map<String, dynamic> json = { 'value': faker.guid.guid(), 'expiry': DateTime.now().toIso8601String() };
      var token = Token.fromJson(json: json);
      expect(token is Token, true);
    });

    test("A token can be serialized to json", () {
      final Map<String, dynamic> json = { 'value': faker.guid.guid(), 'expiry': DateTime.now().toIso8601String() };
      var token = Token.fromJson(json: json);
      expect(token is Token, true);
      var jsonToken = token.toJson();
      expect(jsonToken is Token, false);
      expect(jsonToken is Map<String, dynamic>, true);
    });
  });
}