import 'package:dashboard/models/api_response.dart';
import 'package:dashboard/models/business/location.dart';
import 'package:dashboard/providers/geo_account_provider.dart';
import 'package:dashboard/repositories/geo_account_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGeoAccountProvider extends Mock implements GeoAccountProvider {}

void main() {
  group("Geo Account Repository Tests", () {
    late GeoAccountRepository _geoAccountRepository;
    late GeoAccountProvider _mockGeoAccountProvider;
    late GeoAccountRepository _geoAccountRepositoryWithMock;

    setUp(() {
      _geoAccountRepository = const GeoAccountRepository();
      _mockGeoAccountProvider = MockGeoAccountProvider();
      _geoAccountRepositoryWithMock = GeoAccountRepository(geoAccountProvider: _mockGeoAccountProvider);
      registerFallbackValue({});
    });
    
    test("Geo Account Repository can Store a geo account", () async {
      double lat = 35.910259;
      double lng = -79.055473;
      int radius = 50;

      var location = await _geoAccountRepository.store(lat: lat, lng: lng, radius: radius);
      expect(location, isA<Location>());
    });

    test("Geo Account Repository throws error on Store geo account fail", () async {
      double lat = 35.910259;
      double lng = -79.055473;
      int radius = 50;
      when(() => _mockGeoAccountProvider.store(body: any(named: "body"))).thenAnswer((_) async => const ApiResponse(body: {}, error: "error", isOK: false));

      expect(
        _geoAccountRepositoryWithMock.store(lat: lat, lng: lng, radius: radius), 
        throwsA(isA<ApiException>())
      );
    });

    test("Geo Account Repository can Update Geo Account", () async {
      String identifier = faker.guid.guid();
      double lat = 35.910259;
      double lng = -79.055473;
      int radius = 25;

      var location = await _geoAccountRepository.update(identifier: identifier, lat: lat, lng: lng, radius: radius);
      expect(location, isA<Location>());
    });

    test("Geo Account Repository throws error on Update geo account fail", () async {
      String identifier = faker.guid.guid();
      double lat = 35.910259;
      double lng = -79.055473;
      int radius = 25;
      when(() => _mockGeoAccountProvider.update(identifier: identifier, body: any(named: "body"))).thenAnswer((_) async => const ApiResponse(body: {}, error: "error", isOK: false));

      expect(
        _geoAccountRepositoryWithMock.update(identifier: identifier, lat: lat, lng: lng, radius: radius), 
        throwsA(isA<ApiException>())
      );
    });
  });
}