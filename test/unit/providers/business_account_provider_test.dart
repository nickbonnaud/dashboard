import 'package:dashboard/models/api_response.dart';
import 'package:dashboard/providers/business_account_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Business Account Provider Tests", () {
    late BusinessAccountProvider businessAccountProvider;

    setUp(() {
      businessAccountProvider = const BusinessAccountProvider();
    });

    test("Storing BusinessAccount data returns ApiResponse", () async {
      var response = await businessAccountProvider.store(body: {});
      expect(response, isA<ApiResponse>());
    });

    test("Updating BusinessAccount data returns ApiResponse", () async {
      var response = await businessAccountProvider.update(body: {}, identifier: "identifier");
      expect(response, isA<ApiResponse>());
    });
  });
}