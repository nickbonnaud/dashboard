import 'package:dashboard/models/api_response.dart';
import 'package:dashboard/providers/owner_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Owner Provider Tests", () {
    late OwnerProvider ownerProvider;

    setUp(() {
      ownerProvider = OwnerProvider();
    });

    test("Storing owner returns ApiResponse", () async {
      var response = await ownerProvider.store(body: {});
      expect(response, isA<ApiResponse>());
    });

    test("Updating owner returns ApiResponse", () async {
      var response = await ownerProvider.update(body: {}, identifier: "identifier");
      expect(response, isA<ApiResponse>());
    });

    test("Removing owner returns ApiResponse", () async {
      var response = await ownerProvider.remove(identifier: "identifier");
      expect(response, isA<ApiResponse>());
    });
  });
}