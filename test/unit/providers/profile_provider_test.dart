import 'package:dashboard/models/api_response.dart';
import 'package:dashboard/providers/profile_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Profile Provider Tests", () {
    late ProfileProvider profileProvider;

    setUp(() {
      profileProvider = const ProfileProvider();
    });

    test("Storing a profile returns ApiResponse", () async {
      var response = await profileProvider.store(body: {});
      expect(response, isA<ApiResponse>());
    });

    test("Updating a profile returns ApiResponse", () async {
      var response = await profileProvider.update(body: {}, identifier: "identifier");
      expect(response, isA<ApiResponse>());
    });
  });
}