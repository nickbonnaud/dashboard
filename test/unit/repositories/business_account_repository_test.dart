import 'package:dashboard/models/api_response.dart';
import 'package:dashboard/models/business/business_account.dart';
import 'package:dashboard/providers/business_account_provider.dart';
import 'package:dashboard/repositories/business_account_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBankAccountProvider extends Mock implements BusinessAccountProvider {}

void main() {
  group("Business Account Repository Tests", () {
    late BusinessAccountRepository _accountRepository;
    late BusinessAccountProvider _mockAccountProvider;
    late BusinessAccountRepository _accountRepositoryWithMock;

    setUp(() {
      _accountRepository = BusinessAccountRepository(accountProvider: BusinessAccountProvider());
      _mockAccountProvider = MockBankAccountProvider();
      _accountRepositoryWithMock = BusinessAccountRepository(accountProvider: _mockAccountProvider);
      registerFallbackValue<Map<String, dynamic>>(Map());
    });

    test("The Business Account Repository can store a Business Account", () async {
      var account = await _accountRepository.store(
        name: faker.company.name(),
        address: faker.address.streetAddress(), 
        addressSecondary: faker.address.buildingNumber(), 
        city: faker.address.city(), 
        state: 'NC', 
        zip: faker.address.zipCode(),
        entityType: "llc",
      );
      expect(account is BusinessAccount, true);
    });

    test("The Business Account Repository throws error on store fail", () async {
      when(() => _mockAccountProvider.store(body: any(named: "body"))).thenAnswer((_) async => ApiResponse(body: {}, error: "error", isOK: false));
      expect(
        _accountRepositoryWithMock.store(
          name: faker.company.name(),
          address: faker.address.streetAddress(), 
          addressSecondary: faker.address.buildingNumber(), 
          city: faker.address.city(), 
          state: 'NC', 
          zip: faker.address.zipCode(),
          entityType: "llc",
        ), 
        throwsA(isA<ApiException>())
      );
    });

    test("The Business Account can add optional EIN", () async {
      var account = await _accountRepository.store(
        name: faker.company.name(),
        address: faker.address.streetAddress(), 
        addressSecondary: faker.address.buildingNumber(), 
        city: faker.address.city(), 
        state: 'NC', 
        zip: faker.address.zipCode(),
        entityType: "llc",
        ein: 'fake_ein'
      );

      expect(account.ein != null, true);
    });

    test("The Business Account Repository can update a Business Account", () async {
      var account = await _accountRepository.update(
        identifier: faker.guid.guid(),
        name: faker.company.name(),
        address: faker.address.streetAddress(), 
        addressSecondary: faker.address.buildingNumber(), 
        city: faker.address.city(), 
        state: 'NC', 
        zip: faker.address.zipCode(),
        entityType: "llc"
      );

      expect(account is BusinessAccount, true);
    });

    test("The Business Account Repository throws error on update fail", () async {
      final String identifier = faker.guid.guid();
      when(() => _mockAccountProvider.update(identifier: identifier, body: any(named: "body"))).thenAnswer((_) async => ApiResponse(body: {}, error: "error", isOK: false));
      expect(
        _accountRepositoryWithMock.update(
          identifier: identifier,
          name: faker.company.name(),
          address: faker.address.streetAddress(), 
          addressSecondary: faker.address.buildingNumber(), 
          city: faker.address.city(), 
          state: 'NC', 
          zip: faker.address.zipCode(),
          entityType: "llc",
        ), 
        throwsA(isA<ApiException>())
      );
    });

    test("The Business Account Repository can update with an EIN", () async {
      var account = await _accountRepository.update(
        identifier: faker.guid.guid(),
        name: faker.company.name(),
        address: faker.address.streetAddress(), 
        addressSecondary: faker.address.buildingNumber(), 
        city: faker.address.city(), 
        state: 'NC', 
        zip: faker.address.zipCode(),
        entityType: "llc",
        ein: "fake_ein"
      );

      expect(account.ein != null, true);
    });
  });
}