import 'package:dashboard/models/api_response.dart';
import 'package:dashboard/models/business/bank_account.dart';
import 'package:dashboard/providers/bank_provider.dart';
import 'package:dashboard/repositories/bank_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBankProvider extends Mock implements BankProvider {}

void main() {
  group("Bank Repository Tests", () {
    late BankRepository _bankRepository;
    late BankProvider _mockBankProvider;
    late BankRepository _bankRepositoryWithMock;

    setUp(() {
      _bankRepository = BankRepository(bankProvider: BankProvider());
      _mockBankProvider = MockBankProvider();
      _bankRepositoryWithMock = BankRepository(bankProvider: _mockBankProvider);
      registerFallbackValue(Map());
    });

    test("The Bank Repository can store a BankAccount", () async {
      var bankAccount = await _bankRepository.store(
        firstName: faker.person.firstName(),
        lastName: faker.person.lastName(), 
        routingNumber: "1245", 
        accountNumber: "2342143", 
        accountType: "checking", 
        address: faker.address.streetAddress(), 
        addressSecondary: faker.address.buildingNumber(), 
        city: faker.address.city(), 
        state: 'NC', 
        zip: faker.address.zipCode()
      );
      expect(bankAccount is BankAccount, true);
    });

    test("The Bank Repository throws error on store fail", () async {
      when(() => _mockBankProvider.store(body: any(named: 'body'))).thenAnswer((_) async => ApiResponse(body: {}, error: "error", isOK: false));
      expect(_bankRepositoryWithMock.store(
        firstName: faker.person.firstName(),
        lastName: faker.person.lastName(), 
        routingNumber: "1245", 
        accountNumber: "2342143", 
        accountType: "checking", 
        address: faker.address.streetAddress(), 
        addressSecondary: faker.address.buildingNumber(), 
        city: faker.address.city(), 
        state: 'NC', 
        zip: faker.address.zipCode()
      ), throwsA(isA<ApiException>()));
    });

    test("The Bank Repository can update a Bank Account", () async {
      var bankAccount = await _bankRepository.update(
        identifier: faker.guid.guid(),
        firstName: faker.person.firstName(),
        lastName: faker.person.lastName(), 
        routingNumber: "1245", 
        accountNumber: "2342143", 
        accountType: "checking", 
        address: faker.address.streetAddress(), 
        addressSecondary: faker.address.buildingNumber(), 
        city: faker.address.city(), 
        state: 'NC', 
        zip: faker.address.zipCode()
      );

      expect(bankAccount is BankAccount, true);
    });

    test("The Bank Repository throws error on update fail", () async {
      final String identifier = faker.guid.guid();
      when(() => _mockBankProvider.update(identifier: identifier, body: any(named: 'body'))).thenAnswer((_) async => ApiResponse(body: {}, error: "error", isOK: false));
      expect(_bankRepositoryWithMock.update(
        identifier: identifier,
        firstName: faker.person.firstName(),
        lastName: faker.person.lastName(), 
        routingNumber: "1245", 
        accountNumber: "2342143", 
        accountType: "checking", 
        address: faker.address.streetAddress(), 
        addressSecondary: faker.address.buildingNumber(), 
        city: faker.address.city(), 
        state: 'NC', 
        zip: faker.address.zipCode()
      ), throwsA(isA<ApiException>()));
    });
  });
}