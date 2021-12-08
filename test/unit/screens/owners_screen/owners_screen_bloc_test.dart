import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/models/business/owner_account.dart';
import 'package:dashboard/models/business/address.dart' as BusinessAddress;
import 'package:dashboard/repositories/owner_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/owners_screen/bloc/owners_screen_bloc.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOwnerRepository extends Mock implements OwnerRepository {}
class MockBusinessBloc extends Mock implements BusinessBloc {}
class MockOwnerAccount extends Mock implements OwnerAccount {}

main() {
  group("Owners Screen Bloc Tests", () {
    late OwnerRepository ownerRepository;
    late BusinessBloc businessBloc;
    late OwnersScreenBloc ownersScreenBloc;

    late List<OwnerAccount> _ownersList;
    late OwnersScreenState _baseState;

    setUp(() {
      ownerRepository = MockOwnerRepository();
      businessBloc = MockBusinessBloc();
      _ownersList = [MockOwnerAccount(), MockOwnerAccount()];
      _ownersList.forEach((owner) {
        when(() => owner.identifier).thenReturn(faker.guid.guid());
      });
      ownersScreenBloc = OwnersScreenBloc(businessBloc: businessBloc, ownerRepository: ownerRepository, ownerAccounts: _ownersList);
      _baseState = ownersScreenBloc.state;
      registerFallbackValue(OwnerAccountsUpdated(ownerAccounts: _ownersList));
    });

    tearDown(() {
      ownersScreenBloc.close();
    });

    test("Initial state of OwnersScreenBloc is OwnersScreenState.initial()", () {
      expect(ownersScreenBloc.state, OwnersScreenState.initial(owners: _ownersList));
    });

    blocTest<OwnersScreenBloc, OwnersScreenState>(
      "OwnerAdded event changes state: [owners: newOwnersList]",
      build: () => ownersScreenBloc,
      act: (bloc) {
        OwnerAccount newOwner = MockOwnerAccount();
        when(() => newOwner.identifier).thenReturn(faker.guid.guid());
        _ownersList.add(newOwner);
        bloc.add(OwnerAdded(owner: newOwner));
      },
      expect: () => [_baseState.update(owners: _ownersList)]
    );

    blocTest<OwnersScreenBloc, OwnersScreenState>(
      "OwnerAdded event changes calls businessBloc.add()",
      build: () => ownersScreenBloc,
      act: (bloc) {
        OwnerAccount newOwner = MockOwnerAccount();
        when(() => newOwner.identifier).thenReturn(faker.guid.guid());
        _ownersList.add(newOwner);
        when(() => businessBloc.add(any(that: isA<OwnerAccountsUpdated>()))).thenReturn(null);
        bloc.add(OwnerAdded(owner: newOwner));
      },
      verify: (_) {
        verify(() => businessBloc.add(any(that: isA<OwnerAccountsUpdated>()))).called(1);
      }
    );

    blocTest<OwnersScreenBloc, OwnersScreenState>(
      "OwnerRemoved event changes state: [isSubmitting: true] [owners: newOwnersList, isSubmitting: false, isSuccess:  true]",
      build: () => ownersScreenBloc,
      act: (bloc) {
        OwnerAccount ownerToRemove = _ownersList.first;
        _ownersList = _ownersList.where((owner) => owner.identifier != ownerToRemove.identifier).toList();
        when(() => ownerRepository.remove(identifier: any(named: "identifier"))).thenAnswer((_) async => true);
        when(() => businessBloc.add(any(that: isA<OwnerAccountsUpdated>()))).thenReturn(null);
        bloc.add(OwnerRemoved(owner: ownerToRemove));
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(owners: _ownersList, isSubmitting: false, isSuccess: true)]
    );

    blocTest<OwnersScreenBloc, OwnersScreenState>(
      "OwnerRemoved event calls ownerRepository.remove()",
      build: () => ownersScreenBloc,
      act: (bloc) {
        OwnerAccount ownerToRemove = _ownersList.first;
        _ownersList = _ownersList.where((owner) => owner.identifier != ownerToRemove.identifier).toList();
        when(() => ownerRepository.remove(identifier: any(named: "identifier"))).thenAnswer((_) async => true);
        when(() => businessBloc.add(any(that: isA<OwnerAccountsUpdated>()))).thenReturn(null);
        bloc.add(OwnerRemoved(owner: ownerToRemove));
      },
      verify: (_) {
        verify(() => ownerRepository.remove(identifier: any(named: "identifier"))).called(1);
      }
    );

    blocTest<OwnersScreenBloc, OwnersScreenState>(
      "OwnerRemoved event calls businessBloc.add()",
      build: () => ownersScreenBloc,
      act: (bloc) {
        OwnerAccount ownerToRemove = _ownersList.first;
        _ownersList = _ownersList.where((owner) => owner.identifier != ownerToRemove.identifier).toList();
        when(() => ownerRepository.remove(identifier: any(named: "identifier"))).thenAnswer((_) async => true);
        when(() => businessBloc.add(any(that: isA<OwnerAccountsUpdated>()))).thenReturn(null);
        bloc.add(OwnerRemoved(owner: ownerToRemove));
      },
      verify: (_) {
        verify(() => businessBloc.add(any(that: isA<OwnerAccountsUpdated>()))).called(1);
      }
    );

    blocTest<OwnersScreenBloc, OwnersScreenState>(
      "OwnerRemoved event on error changes state: [isSubmitting: true] [isSubmitting: false, errorMessage: error]",
      build: () => ownersScreenBloc,
      act: (bloc) {
        OwnerAccount ownerToRemove = _ownersList.first;
        _ownersList = _ownersList.where((owner) => owner.identifier != ownerToRemove.identifier).toList();
        when(() => ownerRepository.remove(identifier: any(named: "identifier"))).thenThrow(ApiException(error: "error"));
        bloc.add(OwnerRemoved(owner: ownerToRemove));
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, errorMessage: "error")]
    );

    blocTest<OwnersScreenBloc, OwnersScreenState>(
      "PrimaryRemoved event changes state: [owners: newOwnersList]",
      build: () => ownersScreenBloc,
      seed: () {
        OwnerAccount updatedOwner = OwnerAccount(
          identifier: "fake_identifier",
          dob: "11/22/1990",
          ssn: "123-23-3212",
          firstName: faker.person.firstName(),
          lastName: faker.person.lastName(),
          title: "CEO",
          phone: "7352825392",
          email: faker.internet.email(),
          primary: true,
          percentOwnership: 25,
          address: BusinessAddress.Address(
            address: faker.address.streetAddress(),
            addressSecondary: faker.address.buildingNumber(),
            city: faker.address.city(),
            state: "NC",
            zip: faker.address.zipCode()
          )
        );
        _ownersList.add(updatedOwner);
        return _baseState.update(owners: _ownersList);
      },
      act: (bloc) {
        when(() => ownerRepository.update(
          identifier: any(named: "identifier"),
          firstName: any(named: "firstName"), 
          lastName: any(named: "lastName"), 
          title: any(named: "title"), 
          phone: any(named: "phone"), 
          email: any(named: "email"), 
          primary: any(named: "primary"), 
          percentOwnership: any(named: "percentOwnership"), 
          dob: any(named: "dob"), 
          ssn: any(named: "ssn"), 
          address: any(named: "address"), 
          addressSecondary: any(named: "addressSecondary"), 
          city: any(named: "city"), 
          state: any(named: "state"), 
          zip: any(named: "zip")
        )).thenAnswer((_) async {
          OwnerAccount updatedOwner = _ownersList.firstWhere((owner) => owner.identifier == "fake_identifier");
          updatedOwner = updatedOwner.update(primary: false);
          _ownersList = _ownersList.where((owner) => owner.identifier != updatedOwner.identifier).toList()..add(updatedOwner);
          return updatedOwner;
        });
        when(() => businessBloc.add(any(that: isA<OwnerAccountsUpdated>()))).thenReturn(null);
        bloc.add(PrimaryRemoved(account: _ownersList.firstWhere((owner) => owner.identifier == "fake_identifier")));
      },
      expect: () => [_baseState.update(owners: _ownersList)]
    );

    blocTest<OwnersScreenBloc, OwnersScreenState>(
      "PrimaryRemoved event calls ownerRepository.update()",
      build: () => ownersScreenBloc,
      seed: () {
        OwnerAccount updatedOwner = OwnerAccount(
          identifier: "fake_identifier",
          dob: "11/22/1990",
          ssn: "123-23-3212",
          firstName: faker.person.firstName(),
          lastName: faker.person.lastName(),
          title: "CEO",
          phone: "7352825392",
          email: faker.internet.email(),
          primary: true,
          percentOwnership: 25,
          address: BusinessAddress.Address(
            address: faker.address.streetAddress(),
            addressSecondary: faker.address.buildingNumber(),
            city: faker.address.city(),
            state: "NC",
            zip: faker.address.zipCode()
          )
        );
        _ownersList.add(updatedOwner);
        return _baseState.update(owners: _ownersList);
      },
      act: (bloc) {
        when(() => ownerRepository.update(
          identifier: any(named: "identifier"),
          firstName: any(named: "firstName"), 
          lastName: any(named: "lastName"), 
          title: any(named: "title"), 
          phone: any(named: "phone"), 
          email: any(named: "email"), 
          primary: any(named: "primary"), 
          percentOwnership: any(named: "percentOwnership"), 
          dob: any(named: "dob"), 
          ssn: any(named: "ssn"), 
          address: any(named: "address"), 
          addressSecondary: any(named: "addressSecondary"), 
          city: any(named: "city"), 
          state: any(named: "state"), 
          zip: any(named: "zip")
        )).thenAnswer((_) async {
          OwnerAccount updatedOwner = _ownersList.firstWhere((owner) => owner.identifier == "fake_identifier");
          updatedOwner = updatedOwner.update(primary: false);
          _ownersList = _ownersList.where((owner) => owner.identifier != updatedOwner.identifier).toList()..add(updatedOwner);
          return updatedOwner;
        });
        when(() => businessBloc.add(any(that: isA<OwnerAccountsUpdated>()))).thenReturn(null);
        bloc.add(PrimaryRemoved(account: _ownersList.firstWhere((owner) => owner.identifier == "fake_identifier")));
      },
      verify: (_) {
        verify(() => ownerRepository.update(
          identifier: any(named: "identifier"),
          firstName: any(named: "firstName"), 
          lastName: any(named: "lastName"), 
          title: any(named: "title"), 
          phone: any(named: "phone"), 
          email: any(named: "email"), 
          primary: any(named: "primary"), 
          percentOwnership: any(named: "percentOwnership"), 
          dob: any(named: "dob"), 
          ssn: any(named: "ssn"), 
          address: any(named: "address"), 
          addressSecondary: any(named: "addressSecondary"), 
          city: any(named: "city"), 
          state: any(named: "state"), 
          zip: any(named: "zip")
        )).called(1);
      }
    );

    blocTest<OwnersScreenBloc, OwnersScreenState>(
      "PrimaryRemoved event calls businessBloc.add()",
      build: () => ownersScreenBloc,
      seed: () {
        OwnerAccount updatedOwner = OwnerAccount(
          identifier: "fake_identifier",
          dob: "11/22/1990",
          ssn: "123-23-3212",
          firstName: faker.person.firstName(),
          lastName: faker.person.lastName(),
          title: "CEO",
          phone: "7352825392",
          email: faker.internet.email(),
          primary: true,
          percentOwnership: 25,
          address: BusinessAddress.Address(
            address: faker.address.streetAddress(),
            addressSecondary: faker.address.buildingNumber(),
            city: faker.address.city(),
            state: "NC",
            zip: faker.address.zipCode()
          )
        );
        _ownersList.add(updatedOwner);
        return _baseState.update(owners: _ownersList);
      },
      act: (bloc) {
        when(() => ownerRepository.update(
          identifier: any(named: "identifier"),
          firstName: any(named: "firstName"), 
          lastName: any(named: "lastName"), 
          title: any(named: "title"), 
          phone: any(named: "phone"), 
          email: any(named: "email"), 
          primary: any(named: "primary"), 
          percentOwnership: any(named: "percentOwnership"), 
          dob: any(named: "dob"), 
          ssn: any(named: "ssn"), 
          address: any(named: "address"), 
          addressSecondary: any(named: "addressSecondary"), 
          city: any(named: "city"), 
          state: any(named: "state"), 
          zip: any(named: "zip")
        )).thenAnswer((_) async {
          OwnerAccount updatedOwner = _ownersList.firstWhere((owner) => owner.identifier == "fake_identifier");
          updatedOwner = updatedOwner.update(primary: false);
          _ownersList = _ownersList.where((owner) => owner.identifier != updatedOwner.identifier).toList()..add(updatedOwner);
          return updatedOwner;
        });
        when(() => businessBloc.add(any(that: isA<OwnerAccountsUpdated>()))).thenReturn(null);
        bloc.add(PrimaryRemoved(account: _ownersList.firstWhere((owner) => owner.identifier == "fake_identifier")));
      },
      verify: (_) {
        verify(() => businessBloc.add(any(that: isA<OwnerAccountsUpdated>()))).called(1);
      }
    );

    blocTest<OwnersScreenBloc, OwnersScreenState>(
      "PrimaryRemoved event on error changes state: [errorMessage: error]",
      build: () => ownersScreenBloc,
      seed: () {
        OwnerAccount updatedOwner = OwnerAccount(
          identifier: "fake_identifier",
          dob: "11/22/1990",
          ssn: "123-23-3212",
          firstName: faker.person.firstName(),
          lastName: faker.person.lastName(),
          title: "CEO",
          phone: "7352825392",
          email: faker.internet.email(),
          primary: true,
          percentOwnership: 25,
          address: BusinessAddress.Address(
            address: faker.address.streetAddress(),
            addressSecondary: faker.address.buildingNumber(),
            city: faker.address.city(),
            state: "NC",
            zip: faker.address.zipCode()
          )
        );
        _ownersList.add(updatedOwner);
        return _baseState.update(owners: _ownersList);
      },
      act: (bloc) {
        when(() => ownerRepository.update(
          identifier: any(named: "identifier"),
          firstName: any(named: "firstName"), 
          lastName: any(named: "lastName"), 
          title: any(named: "title"), 
          phone: any(named: "phone"), 
          email: any(named: "email"), 
          primary: any(named: "primary"), 
          percentOwnership: any(named: "percentOwnership"), 
          dob: any(named: "dob"), 
          ssn: any(named: "ssn"), 
          address: any(named: "address"), 
          addressSecondary: any(named: "addressSecondary"), 
          city: any(named: "city"), 
          state: any(named: "state"), 
          zip: any(named: "zip")
        )).thenThrow(ApiException(error: "error"));
        when(() => businessBloc.add(any(that: isA<OwnerAccountsUpdated>()))).thenReturn(null);
        bloc.add(PrimaryRemoved(account: _ownersList.firstWhere((owner) => owner.identifier == "fake_identifier")));
      },
      expect: () => [_baseState.update(errorMessage: "error")]
    );

    blocTest<OwnersScreenBloc, OwnersScreenState>(
      "ShowForm event changes state: [formVisible: true, editingAccount: event.account]",
      build: () => ownersScreenBloc,
      act: (bloc) => bloc.add(ShowForm(account: _ownersList.first)),
      expect: () => [_baseState.update(formVisible: true, editingAccount: _ownersList.first)]
    );

    blocTest<OwnersScreenBloc, OwnersScreenState>(
      "HideForm event changes state: [formVisible: false, editingAccount: null]",
      build: () => ownersScreenBloc,
      seed: () => _baseState.update(formVisible: true, editingAccount: _ownersList.first),
      act: (bloc) => bloc.add(HideForm()),
      expect: () => [OwnersScreenState.initial(owners: _ownersList)]
    );

    blocTest<OwnersScreenBloc, OwnersScreenState>(
      "OwnerUpdated event changes state: [owners: updatedOwners]",
      build: () => ownersScreenBloc,
      act: (bloc) {
        OwnerAccount updatedOwner = _ownersList.first;
        _ownersList = _ownersList.where((owner) => owner.identifier != updatedOwner.identifier).toList()..add(updatedOwner);
        when(() => businessBloc.add(any(that: isA<OwnerAccountsUpdated>()))).thenReturn(null);
        bloc.add(OwnerUpdated(owner: updatedOwner));
      },
      expect: () => [_baseState.update(owners: _ownersList)]
    );

    blocTest<OwnersScreenBloc, OwnersScreenState>(
      "OwnerUpdated event calls BusinessBloc.add()",
      build: () => ownersScreenBloc,
      act: (bloc) {
        OwnerAccount updatedOwner = _ownersList.first;
        _ownersList = _ownersList.where((owner) => owner.identifier != updatedOwner.identifier).toList()..add(updatedOwner);
        when(() => businessBloc.add(any(that: isA<OwnerAccountsUpdated>()))).thenReturn(null);
        bloc.add(OwnerUpdated(owner: updatedOwner));
      },
      verify: (_) {
        verify(() => businessBloc.add(any(that: isA<OwnerAccountsUpdated>()))).called(1);
      }
    );
  });
}