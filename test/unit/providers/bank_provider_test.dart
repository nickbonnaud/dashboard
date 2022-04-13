import 'package:dashboard/models/api_response.dart';
import 'package:dashboard/providers/bank_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Bank Provider Tests", () {
    late BankProvider bankProvider;

    setUp(() {
      bankProvider = const BankProvider();
    });

    test("Storing bank data returns ApiResponse", () async {
      var response = await bankProvider.store(body: {});
      expect(response, isA<ApiResponse>());
    });

    test("Updating bank data returns ApiResponse", () async {
      var response = await bankProvider.update(body: {}, identifier: "identifier");
      expect(response, isA<ApiResponse>());
    });
  });
}