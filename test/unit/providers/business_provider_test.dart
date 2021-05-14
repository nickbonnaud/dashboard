import 'package:dashboard/models/api_response.dart';
import 'package:dashboard/providers/business_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Business Provider Tests", () {
    late BusinessProvider businessProvider;

    setUp(() {
      businessProvider = BusinessProvider();
    });

    test("Fetching a business returns ApiResponse", () async {
      var response = await businessProvider.fetch();
      expect(response, isA<ApiResponse>());
    });

    test("Updating a business returns ApiResponse", () async {
      var response = await businessProvider.update(body: {}, identifier: "identifier");
      expect(response, isA<ApiResponse>());
    });
  });
}