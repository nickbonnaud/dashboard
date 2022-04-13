import 'package:dashboard/models/api_response.dart';
import 'package:dashboard/providers/photos_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Photos Provider Tests", () {
    late PhotosProvider photosProvider;

    setUp(() {
      photosProvider = const PhotosProvider();
    });

    test("Storing a logo returns ApiResponse", () async {
      var response = await photosProvider.storeLogo(identifier: "identifier", body: {});
      expect(response, isA<ApiResponse>());
    });

    test("Storing a banner returns ApiResponse", () async {
      var response = await photosProvider.storeBanner(identifier: "identifier", body: {});
      expect(response, isA<ApiResponse>());
    });
  });
}