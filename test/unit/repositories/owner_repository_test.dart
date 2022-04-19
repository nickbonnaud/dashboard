import 'package:dashboard/models/api_response.dart';
import 'package:dashboard/models/business/owner_account.dart';
import 'package:dashboard/providers/owner_provider.dart';
import 'package:dashboard/repositories/owner_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOwnerProvider extends Mock implements OwnerProvider {}

void main() {
  group("Owner Repository Tests", () {
    late OwnerRepository _ownerRepository;
    late OwnerProvider _mockOwnerProvider;
    late OwnerRepository _ownerRepositoryWithMock;

    setUp(() {
      _ownerRepository = const OwnerRepository();
      _mockOwnerProvider = MockOwnerProvider();
      _ownerRepositoryWithMock = OwnerRepository(ownerProvider: _mockOwnerProvider);
      registerFallbackValue({});
    });
    
    test("Owner Repository can Store owner account", () async {
      var ownerAccount = await _ownerRepository.store(
        firstName: faker.person.firstName(),
        lastName: faker.person.lastName(),
        title: faker.company.position(),
        phone: faker.phoneNumber.us(),
        email: faker.internet.email(),
        primary: true,
        percentOwnership: faker.randomGenerator.integer(100, min: 10),
        dob: '11/15/1980',
        ssn: '123456789',
        address: faker.address.streetAddress(),
        addressSecondary: faker.address.buildingNumber(),
        city: faker.address.city(),
        state: 'NC',
        zip: faker.address.zipCode()
      );

      expect(ownerAccount, isA<OwnerAccount>());
    });

  test("Owner Repository throws error on Store owner account fail", () async {
    when(() => _mockOwnerProvider.store(body: any(named: "body"))).thenAnswer((_) async => const ApiResponse(body: {}, error: "error", isOK: false));
    expect(
      _ownerRepositoryWithMock.store(
        firstName: faker.person.firstName(),
        lastName: faker.person.lastName(),
        title: faker.company.position(),
        phone: faker.phoneNumber.us(),
        email: faker.internet.email(),
        primary: true,
        percentOwnership: faker.randomGenerator.integer(100, min: 10),
        dob: '11/15/1980',
        ssn: '123456789',
        address: faker.address.streetAddress(),
        addressSecondary: faker.address.buildingNumber(),
        city: faker.address.city(),
        state: 'NC',
        zip: faker.address.zipCode()
      ),
      throwsA(isA<ApiException>())
    );
  });

    test("Owner Repository can Update owner account", () async {
      var ownerAccount = await _ownerRepository.update(
        identifier: faker.guid.guid(),
        firstName: faker.person.firstName(),
        lastName: faker.person.lastName(),
        title: faker.company.position(),
        phone: faker.phoneNumber.us(),
        email: faker.internet.email(),
        primary: true,
        percentOwnership: faker.randomGenerator.integer(100, min: 10),
        dob: '11/15/1980',
        ssn: '123456789',
        address: faker.address.streetAddress(),
        addressSecondary: faker.address.buildingNumber(),
        city: faker.address.city(),
        state: 'NC',
        zip: faker.address.zipCode()
      );

      expect(ownerAccount, isA<OwnerAccount>());
    });

  test("Owner Repository throws error on Update owner account fail", () async {
    final String identifier = faker.guid.guid();
    when(() => _mockOwnerProvider.update(identifier: identifier, body: any(named: "body"))).thenAnswer((_) async => const ApiResponse(body: {}, error: "error", isOK: false));
    expect(
      _ownerRepositoryWithMock.update(
        identifier: identifier,
        firstName: faker.person.firstName(),
        lastName: faker.person.lastName(),
        title: faker.company.position(),
        phone: faker.phoneNumber.us(),
        email: faker.internet.email(),
        primary: true,
        percentOwnership: faker.randomGenerator.integer(100, min: 10),
        dob: '11/15/1980',
        ssn: '123456789',
        address: faker.address.streetAddress(),
        addressSecondary: faker.address.buildingNumber(),
        city: faker.address.city(),
        state: 'NC',
        zip: faker.address.zipCode()
      ),
      throwsA(isA<ApiException>())
    );
  });

    test("Owner Repository can remove an owner", () async {
      var ownerRemoved = await _ownerRepository.remove(identifier: faker.guid.guid());
      expect(ownerRemoved, isA<bool>());
    });

    test("Owner Repository throws error on remove owner fail", () async {
      final String identifier = faker.guid.guid();
      when(() => _mockOwnerProvider.remove(identifier: identifier)).thenAnswer((_) async => const ApiResponse(body: {}, error: "error", isOK: false));
      expect(
        _ownerRepositoryWithMock.remove(identifier: identifier), 
        throwsA(isA<ApiException>())
      );
    });
  });
}