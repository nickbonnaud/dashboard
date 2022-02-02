import 'package:dashboard/models/api_response.dart';
import 'package:dashboard/models/business/photos.dart';
import 'package:dashboard/providers/photos_provider.dart';
import 'package:dashboard/repositories/photos_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';

class MockPhotosProvider extends Mock implements PhotosProvider {}

void main() {
  group("Photos Repository Tests", () {
    late PhotosRepository _photosRepository;
    late PhotosProvider _mockPhotosProvider;
    late PhotosRepository _photosRepositoryWithMock;

    setUp(() {
      _photosRepository = PhotosRepository(photosProvider: PhotosProvider());
      _mockPhotosProvider = MockPhotosProvider();
      _photosRepositoryWithMock = PhotosRepository(photosProvider: _mockPhotosProvider);
      registerFallbackValue(Map());
    });
    
    test("Photos Repository can Store logo", () async {
      final XFile file = XFile("fake_path");
      final String identifier = faker.guid.guid();
      var photos = await _photosRepository.storeLogo(file: file, profileIdentifier: identifier);
      expect(photos, isA<Photos>());
      expect(photos.logo.name.isNotEmpty, true);
    });

    test("Photos Repository throws error on Store logo fail", () async {
      final XFile file = XFile("fake_path");
      final String identifier = faker.guid.guid();
      when(() => _mockPhotosProvider.storeLogo(identifier: identifier, body: any(named: 'body'))).thenAnswer((_) async => ApiResponse(body: {}, error: "error", isOK: false));

      expect(
        _photosRepositoryWithMock.storeLogo(file: file, profileIdentifier: identifier), 
        throwsA(isA<ApiException>())
      );
    });

    test("Photos Repository can Store a Banner", () async {
      final XFile file = XFile("fake_path");
      final String identifier = faker.guid.guid();
      var photos = await _photosRepository.storeBanner(file: file, profileIdentifier: identifier);
      expect(photos, isA<Photos>());
      expect(photos.banner.name.isNotEmpty, true);
    });

    test("Photos Repository throws error on Store banner fail", () async {
      final XFile file = XFile("fake_path");
      final String identifier = faker.guid.guid();
      when(() => _mockPhotosProvider.storeBanner(identifier: identifier, body: any(named: 'body'))).thenAnswer((_) async => ApiResponse(body: {}, error: "error", isOK: false));

      expect(
        _photosRepositoryWithMock.storeBanner(file: file, profileIdentifier: identifier), 
        throwsA(isA<ApiException>())
      );
    });
  });
}