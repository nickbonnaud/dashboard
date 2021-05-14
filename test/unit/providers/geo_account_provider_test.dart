import 'package:dashboard/models/api_response.dart';
import 'package:dashboard/providers/geo_account_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Geo Account Provider Tests", () {
    late GeoAccountProvider geoAccountProvider;

    setUp(() {
      geoAccountProvider = GeoAccountProvider();
    });

    test("Storing geo account returns Api Response", () async {
      var response = await geoAccountProvider.store(body: {});
      expect(response, isA<ApiResponse>());
    });

    test("Updating geo account returns Api Response", () async {
      var response = await geoAccountProvider.update(body: {}, identifier: "identifier");
      expect(response, isA<ApiResponse>());
    });
  });
}