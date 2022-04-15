import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/models/business/accounts.dart';
import 'package:dashboard/models/business/business.dart';
import 'package:dashboard/models/business/business_account.dart';
import 'package:dashboard/models/status.dart';
import 'package:dashboard/repositories/business_account_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/business_account_screen/bloc/business_account_screen_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simple_animations/simple_animations.dart';

import '../../../helpers/mock_data_generator.dart';

class MockBusinessAccountRepository extends Mock implements BusinessAccountRepository {}
class MockBusinessBloc extends Mock implements BusinessBloc {}
class MockBusinessAccount extends Mock implements BusinessAccount {}

void main() {
  
  group("Business Account Screen Bloc Tests", () {
    late BusinessAccountRepository _businessAccountRepository;
    late BusinessAccount _businessAccount;
    late BusinessAccountScreenBloc _businessAccountScreenBloc;
    late BusinessBloc _businessBloc;

    late BusinessAccountScreenState _baseState;

    setUp(() {
      MockDataGenerator mockDataGenerator = MockDataGenerator();
      
      Business business = Business(
        identifier: 'identifier',
        email: 'fake@gmail.com',
        profile: mockDataGenerator.createProfile(),
        photos: mockDataGenerator.createBusinessPhotos(),
        accounts: Accounts(
          businessAccount: mockDataGenerator.createBusinessAccount(entityType: EntityType.llc),
          ownerAccounts: const [],
          bankAccount: mockDataGenerator.createBankAccount(),
          accountStatus: const Status(name: "name", code: 200)
        ),
        location: mockDataGenerator.createLocation(),
        posAccount: mockDataGenerator.createPosAccount()
      );
      _businessAccount = business.accounts.businessAccount;

      _businessAccountRepository = MockBusinessAccountRepository();
      _businessBloc = MockBusinessBloc();

      when(() => _businessBloc.business).thenReturn(business);

      _businessAccountScreenBloc = BusinessAccountScreenBloc(
        accountRepository: _businessAccountRepository,
        businessBloc: _businessBloc,
        businessAccount: _businessAccount
      );

      _baseState = BusinessAccountScreenState.empty(businessAccount: _businessAccount);
      registerFallbackValue(BusinessAccountUpdated(businessAccount: _businessAccount));
    });

    tearDown(() {
      _businessAccountScreenBloc.close();
    });

    test("Initial state of BusinessAccountScreenBloc is BusinessAccountScreenState.empty()", () {
      expect(_businessAccountScreenBloc.state, BusinessAccountScreenState.empty(businessAccount: _businessAccount));
    });

    blocTest<BusinessAccountScreenBloc, BusinessAccountScreenState>(
      "EntityTypeSelected event changes state: entityType: corp",
      build: () => _businessAccountScreenBloc,
      act: (bloc) => bloc.add(const EntityTypeSelected(entityType: EntityType.corporation)),
      expect: () => [_baseState.update(entityType: EntityType.corporation)]
    );

    blocTest<BusinessAccountScreenBloc, BusinessAccountScreenState>(
      "NameChanged event changes state: isNameValid: false",
      build: () => _businessAccountScreenBloc,
      act: (bloc) => bloc.add(const NameChanged(name: "a")),
      wait: const Duration(milliseconds: 300),
      expect: () => [_baseState.update(name: "a", isNameValid: false)]
    );

    blocTest<BusinessAccountScreenBloc, BusinessAccountScreenState>(
      "AddressChanged event changes state: isAddressValid: false",
      build: () => _businessAccountScreenBloc,
      act: (bloc) => bloc.add(const AddressChanged(address: "a")),
      wait: const Duration(milliseconds: 300),
      expect: () => [_baseState.update(address: "a", isAddressValid: false)]
    );

    blocTest<BusinessAccountScreenBloc, BusinessAccountScreenState>(
      "AddressSecondaryChanged event changes state: isAddressSecondaryValid: false",
      build: () => _businessAccountScreenBloc,
      act: (bloc) => bloc.add(const AddressSecondaryChanged(addressSecondary: "a")),
      wait: const Duration(milliseconds: 300),
      expect: () => [_baseState.update(addressSecondary: "a", isAddressSecondaryValid: false)]
    );
    
    blocTest<BusinessAccountScreenBloc, BusinessAccountScreenState>(
      "CityChanged event changes state: isCityValidValid: false",
      build: () => _businessAccountScreenBloc,
      act: (bloc) => bloc.add(const CityChanged(city: "f")),
      wait: const Duration(milliseconds: 300),
      expect: () => [_baseState.update(city: 'f', isCityValid: false)]
    );

    blocTest<BusinessAccountScreenBloc, BusinessAccountScreenState>(
      "StateChanged event changes state: isStateValid: false",
      build: () => _businessAccountScreenBloc,
      act: (bloc) => bloc.add(const StateChanged(state: "y")),
      wait: const Duration(milliseconds: 300),
      expect: () => [_baseState.update(state: 'y', isStateValid: false)]
    );

    blocTest<BusinessAccountScreenBloc, BusinessAccountScreenState>(
      "ZipChanged event changes state: isZipValid: false",
      build: () => _businessAccountScreenBloc,
      act: (bloc) => bloc.add(const ZipChanged(zip: "e")),
      wait: const Duration(milliseconds: 300),
      expect: () => [_baseState.update(zip: 'e', isZipValid: false)]
    );

    blocTest<BusinessAccountScreenBloc, BusinessAccountScreenState>(
      "EinChanged event changes state: isEinValid: false",
      build: () => _businessAccountScreenBloc,
      act: (bloc) => bloc.add(const EinChanged(ein: "m")),
      wait: const Duration(milliseconds: 300),
      expect: () => [_baseState.update(ein: 'm', isEinValid: false)]
    );

    blocTest<BusinessAccountScreenBloc, BusinessAccountScreenState>(
      "Submitted event changes state: [isSubmitting: true], [isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.STOP]",
      build: () => _businessAccountScreenBloc,
      act: (bloc) {
        when(() => _businessAccountRepository.store(
          name: any(named: 'name'), 
          address: any(named: 'address'),
          addressSecondary: any(named: 'addressSecondary'),
          city: any(named: 'city'),
          state: any(named: 'state'),
          zip: any(named: 'zip'),
          entityType: any(named: 'entityType'),
          ein: any(named: 'ein')
        )).thenAnswer((_) async => MockBusinessAccount());
        bloc.add(Submitted());
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.stop)]
    );

    blocTest<BusinessAccountScreenBloc, BusinessAccountScreenState>(
      "Submitted event calls BusinessAccountRepository.store()",
      build: () => _businessAccountScreenBloc,
      act: (bloc) {
        when(() => _businessAccountRepository.store(
          name: any(named: 'name'), 
          address: any(named: 'address'),
          addressSecondary: any(named: 'addressSecondary'),
          city: any(named: 'city'),
          state: any(named: 'state'),
          zip: any(named: 'zip'),
          entityType: any(named: 'entityType'),
          ein: any(named: 'ein')
        )).thenAnswer((_) async => MockBusinessAccount());
        bloc.add(Submitted());
      },
      verify: (_) {
        verify(() => _businessAccountRepository.store(
          name: any(named: 'name'), 
          address: any(named: 'address'),
          addressSecondary: any(named: 'addressSecondary'),
          city: any(named: 'city'),
          state: any(named: 'state'),
          zip: any(named: 'zip'),
          entityType: any(named: 'entityType'),
          ein: any(named: 'ein')
        )).called(1);
      }
    );

    blocTest<BusinessAccountScreenBloc, BusinessAccountScreenState>(
      "Submitted event calls BusinessBloc.add()",
      build: () => _businessAccountScreenBloc,
      act: (bloc) {
        when(() => _businessAccountRepository.store(
          name: any(named: 'name'), 
          address: any(named: 'address'),
          addressSecondary: any(named: 'addressSecondary'),
          city: any(named: 'city'),
          state: any(named: 'state'),
          zip: any(named: 'zip'),
          entityType: any(named: 'entityType'),
          ein: any(named: 'ein')
        )).thenAnswer((_) async => MockBusinessAccount());
        when(() => _businessBloc.add(any(that: isA<BusinessAccountUpdated>()))).thenReturn(null);
        bloc.add(Submitted());
      },
      verify: (_) {
        verify(() => _businessBloc.add(any(that: isA<BusinessEvent>()))).called(1);
      }
    );

    blocTest<BusinessAccountScreenBloc, BusinessAccountScreenState>(
      "Submitted event on error changes state: [isSubmitting: true], [isSubmitting: false, isFailure: true, errorMessage: exception.error, errorButtonControl: CustomAnimationControl.PLAY_FROM_START]",
      build: () => _businessAccountScreenBloc,
      act: (bloc) {
        when(() => _businessAccountRepository.store(
          name: any(named: 'name'), 
          address: any(named: 'address'),
          addressSecondary: any(named: 'addressSecondary'),
          city: any(named: 'city'),
          state: any(named: 'state'),
          zip: any(named: 'zip'),
          entityType: any(named: 'entityType'),
          ein: any(named: 'ein')
        )).thenThrow(const ApiException(error: "error"));
        bloc.add(Submitted());
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, isFailure: true, errorMessage: "error", errorButtonControl: CustomAnimationControl.playFromStart)]
    );

    blocTest<BusinessAccountScreenBloc, BusinessAccountScreenState>(
      "Updated event changes state: [isSubmitting: true], [isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.STOP]",
      build: () => _businessAccountScreenBloc,
      act: (bloc) {
        when(() => _businessAccountRepository.update(
          identifier: any(named: "identifier"),
          name: any(named: 'name'), 
          address: any(named: 'address'),
          addressSecondary: any(named: 'addressSecondary'),
          city: any(named: 'city'),
          state: any(named: 'state'),
          zip: any(named: 'zip'),
          entityType: any(named: 'entityType'),
          ein: any(named: 'ein')
        )).thenAnswer((_) async => MockBusinessAccount());
        bloc.add(Updated());
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.stop)]
    );

    blocTest<BusinessAccountScreenBloc, BusinessAccountScreenState>(
      "Updated event calls BusinessAccountRepository.update()",
      build: () => _businessAccountScreenBloc,
      act: (bloc) {
        when(() => _businessAccountRepository.update(
          identifier: any(named: "identifier"),
          name: any(named: 'name'), 
          address: any(named: 'address'),
          addressSecondary: any(named: 'addressSecondary'),
          city: any(named: 'city'),
          state: any(named: 'state'),
          zip: any(named: 'zip'),
          entityType: any(named: 'entityType'),
          ein: any(named: 'ein')
        )).thenAnswer((_) async => MockBusinessAccount());
        bloc.add(Updated());
      },
      verify: (_) {
        verify(() => _businessAccountRepository.update(
          identifier: any(named: "identifier"),
          name: any(named: 'name'), 
          address: any(named: 'address'),
          addressSecondary: any(named: 'addressSecondary'),
          city: any(named: 'city'),
          state: any(named: 'state'),
          zip: any(named: 'zip'),
          entityType: any(named: 'entityType'),
          ein: any(named: 'ein')
        )).called(1);
      }
    );

    blocTest<BusinessAccountScreenBloc, BusinessAccountScreenState>(
      "Updated event calls BusinessBloc.add()",
      build: () => _businessAccountScreenBloc,
      act: (bloc) {
        when(() => _businessAccountRepository.update(
          identifier: any(named: "identifier"),
          name: any(named: 'name'), 
          address: any(named: 'address'),
          addressSecondary: any(named: 'addressSecondary'),
          city: any(named: 'city'),
          state: any(named: 'state'),
          zip: any(named: 'zip'),
          entityType: any(named: 'entityType'),
          ein: any(named: 'ein')
        )).thenAnswer((_) async => MockBusinessAccount());
        when(() => _businessBloc.add(any(that: isA<BusinessAccountUpdated>()))).thenReturn(null);
        bloc.add(Updated());
      },
      verify: (_) {
        verify(() => _businessBloc.add(any(that: isA<BusinessEvent>()))).called(1);
      }
    );

    blocTest<BusinessAccountScreenBloc, BusinessAccountScreenState>(
      "Updated event on error changes state: [isSubmitting: true], [isSubmitting: false, isFailure: true, errorMessage: exception.error, errorButtonControl: CustomAnimationControl.PLAY_FROM_START]",
      build: () => _businessAccountScreenBloc,
      act: (bloc) {
        when(() => _businessAccountRepository.update(
          identifier: any(named: "identifier"),
          name: any(named: 'name'), 
          address: any(named: 'address'),
          addressSecondary: any(named: 'addressSecondary'),
          city: any(named: 'city'),
          state: any(named: 'state'),
          zip: any(named: 'zip'),
          entityType: any(named: 'entityType'),
          ein: any(named: 'ein')
        )).thenThrow(const ApiException(error: "error"));
        bloc.add(Updated());
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, isFailure: true, errorMessage: "error", errorButtonControl: CustomAnimationControl.playFromStart)]
    );

    blocTest<BusinessAccountScreenBloc, BusinessAccountScreenState>(
      "ChangeEntityTypeSelected event changes state: resetEntityType: true",
      build: () => _businessAccountScreenBloc,
      act: (bloc) => bloc.add(ChangeEntityTypeSelected()),
      expect: () => [_baseState.update(entityType: EntityType.unknown)]
    );

    blocTest<BusinessAccountScreenBloc, BusinessAccountScreenState>(
      "Reset event changes state: isSuccess: false, isFailure: false, errorMessage: "", errorButtonControl: CustomAnimationControl.STOP",
      build: () => _businessAccountScreenBloc,
      act: (bloc) => bloc.add(Reset()),
      expect: () => [_baseState.update(isSuccess: false, isFailure: false, errorMessage: "", errorButtonControl: CustomAnimationControl.stop)]
    );
  }); 
}