import 'package:dashboard/models/api_response.dart';
import 'package:dashboard/providers/hours_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Hours Provider Tests", () {
    late HoursProvider hoursProvider;

    setUp(() {
      hoursProvider = HoursProvider();
    });

    test("Storing Hours returns ApiResponse", () async {
      var response = await hoursProvider.store(body: {});
      expect(response, isA<ApiResponse>());
    });

    test("Updating Hours returns ApiResponse", () async {
      var response = await hoursProvider.update(body: {}, identifier: "identifier");
      expect(response, isA<ApiResponse>());
    });
  });
}