import 'package:dashboard/models/api_response.dart';
import 'package:dashboard/models/business/profile.dart';
import 'package:dashboard/providers/profile_provider.dart';
import 'package:dashboard/repositories/profile_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileProvider extends Mock implements ProfileProvider {}

void main() {
  group("Profile Repository Tests", () {
    late ProfileRepository _profileRepository;
    late ProfileProvider _mockProfileProvider;
    late ProfileRepository _profileRepositoryWithMock;

    setUp(() {
      _profileRepository = ProfileRepository(profileProvider: ProfileProvider());
      _mockProfileProvider = MockProfileProvider();
      _profileRepositoryWithMock = ProfileRepository(profileProvider: _mockProfileProvider);
      registerFallbackValue(Map());
    });
    
    test("Profile Repository can Store profile", () async {
      var profile = await _profileRepository.store(
        name: faker.company.name(),
        website: faker.internet.domainName(),
        description: faker.lorem.sentence(),
        phone: faker.phoneNumber.us()
      );
      expect(profile, isA<Profile>());
    });

    test("Profile Repository throw error on Store profile fail", () async {
      when(() => _mockProfileProvider.store(body: any(named: "body"))).thenAnswer((_) async => ApiResponse(body: {}, error: "error", isOK: false));
      expect(
        _profileRepositoryWithMock.store(
          name: faker.company.name(),
          website: faker.internet.domainName(),
          description: faker.lorem.sentence(),
          phone: faker.phoneNumber.us()
        ), 
        throwsA(isA<ApiException>())
      );
    });

    test("Profile Repository can Update profile", () async {
      var profile = await _profileRepository.update(
        identifier: faker.guid.guid(),
        name: faker.company.name(),
        website: faker.internet.domainName(),
        description: faker.lorem.sentence(),
        phone: faker.phoneNumber.us()
      );
      expect(profile, isA<Profile>());
    });

    test("Profile Repository throw error on Update profile fail", () async {
      final String identifier = faker.guid.guid();
      when(() => _mockProfileProvider.update(identifier: identifier, body: any(named: "body"))).thenAnswer((_) async => ApiResponse(body: {}, error: "error", isOK: false));
      expect(
        _profileRepositoryWithMock.update(
          identifier: identifier,
          name: faker.company.name(),
          website: faker.internet.domainName(),
          description: faker.lorem.sentence(),
          phone: faker.phoneNumber.us()
        ), 
        throwsA(isA<ApiException>())
      );
    });
  });
}