import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/models/business/business_account.dart';
import 'package:dashboard/providers/business_provider.dart';
import 'package:dashboard/repositories/business_account_repository.dart';
import 'package:dashboard/repositories/business_repository.dart';
import 'package:dashboard/repositories/token_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/business_account_screen/bloc/business_account_screen_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simple_animations/simple_animations.dart';

class MockBusinessAccountRepository extends Mock implements BusinessAccountRepository {}
class MockBusinessBloc extends Mock implements BusinessBloc {}
class MockBusinessAccount extends Mock implements BusinessAccount {}

void main() {
  
  group("Business Account Screen Bloc Tests", () {
    late BusinessAccountRepository _businessAccountRepository;
    late BusinessAccount _businessAccount;
    late BusinessAccountScreenBloc _businessAccountScreenBloc;
    late BusinessAccountScreenBloc _businessAccountScreenBlocWithMockBusinessBloc;
    late BusinessBloc _businessBloc;

    late BusinessAccountScreenState _baseState;

    setUp(() {
      _businessAccountRepository = MockBusinessAccountRepository();
      _businessAccount = MockBusinessAccount();
      when(() => _businessAccount.entityType).thenReturn(EntityType.llc);
      _businessBloc = MockBusinessBloc();
      _businessAccountScreenBloc = BusinessAccountScreenBloc(
        accountRepository: _businessAccountRepository,
        businessAccount: _businessAccount,
        businessBloc: BusinessBloc(
          businessRepository: BusinessRepository(
            businessProvider: BusinessProvider(), 
            tokenRepository: TokenRepository()
          )
        )
      );
      _businessAccountScreenBlocWithMockBusinessBloc = BusinessAccountScreenBloc(
        accountRepository: _businessAccountRepository,
        businessBloc: _businessBloc,
        businessAccount: _businessAccount
      );

      _baseState = BusinessAccountScreenState.empty(entityType: _businessAccount.entityType);
      registerFallbackValue(BusinessAccountUpdated(businessAccount: _businessAccount));
    });

    tearDown(() {
      _businessAccountScreenBloc.close();
      _businessAccountScreenBlocWithMockBusinessBloc.close();
    });

    test("Initial state of BusinessAccountScreenBloc is BusinessAccountScreenState.empty()", () {
      expect(_businessAccountScreenBloc.state, BusinessAccountScreenState.empty(entityType: EntityType.llc));
    });

    blocTest<BusinessAccountScreenBloc, BusinessAccountScreenState>(
      "EntityTypeSelected event changes state: entityType: corp",
      build: () => _businessAccountScreenBloc,
      act: (bloc) => bloc.add(EntityTypeSelected(entityType: EntityType.corporation)),
      expect: () => [_baseState.update(entityType: EntityType.corporation)]
    );

    blocTest<BusinessAccountScreenBloc, BusinessAccountScreenState>(
      "NameChanged event changes state: isNameValid: false",
      build: () => _businessAccountScreenBloc,
      act: (bloc) => bloc.add(NameChanged(name: "a")),
      wait: Duration(milliseconds: 300),
      expect: () => [_baseState.update(isNameValid: false)]
    );

    blocTest<BusinessAccountScreenBloc, BusinessAccountScreenState>(
      "AddressChanged event changes state: isAddressValid: false",
      build: () => _businessAccountScreenBloc,
      act: (bloc) => bloc.add(AddressChanged(address: "a")),
      wait: Duration(milliseconds: 300),
      expect: () => [_baseState.update(isAddressValid: false)]
    );

    blocTest<BusinessAccountScreenBloc, BusinessAccountScreenState>(
      "AddressSecondaryChanged event changes state: isAddressSecondaryValid: false",
      build: () => _businessAccountScreenBloc,
      act: (bloc) => bloc.add(AddressSecondaryChanged(addressSecondary: "a")),
      wait: Duration(milliseconds: 300),
      expect: () => [_baseState.update(isAddressSecondaryValid: false)]
    );
    
    blocTest<BusinessAccountScreenBloc, BusinessAccountScreenState>(
      "CityChanged event changes state: isCityValidValid: false",
      build: () => _businessAccountScreenBloc,
      act: (bloc) => bloc.add(CityChanged(city: "f")),
      wait: Duration(milliseconds: 300),
      expect: () => [_baseState.update(isCityValid: false)]
    );

    blocTest<BusinessAccountScreenBloc, BusinessAccountScreenState>(
      "StateChanged event changes state: isStateValid: false",
      build: () => _businessAccountScreenBloc,
      act: (bloc) => bloc.add(StateChanged(state: "y")),
      wait: Duration(milliseconds: 300),
      expect: () => [_baseState.update(isStateValid: false)]
    );

    blocTest<BusinessAccountScreenBloc, BusinessAccountScreenState>(
      "ZipChanged event changes state: isZipValid: false",
      build: () => _businessAccountScreenBloc,
      act: (bloc) => bloc.add(ZipChanged(zip: "e")),
      wait: Duration(milliseconds: 300),
      expect: () => [_baseState.update(isZipValid: false)]
    );

    blocTest<BusinessAccountScreenBloc, BusinessAccountScreenState>(
      "EinChanged event changes state: isEinValid: false",
      build: () => _businessAccountScreenBloc,
      act: (bloc) => bloc.add(EinChanged(ein: "m")),
      wait: Duration(milliseconds: 300),
      expect: () => [_baseState.update(isEinValid: false)]
    );

    blocTest<BusinessAccountScreenBloc, BusinessAccountScreenState>(
      "Submitted event changes state: [isSubmitting: true], [isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.STOP]",
      build: () => _businessAccountScreenBloc,
      act: (bloc) {
        when(() => _businessAccountRepository.store(
          name: 'name', 
          address: 'address',
          addressSecondary: 'addressSecondary',
          city: 'city',
          state: ('state').toUpperCase(),
          zip: 'zip',
          entityType: BusinessAccount.entityTypeToString(entityType: EntityType.corporation),
          ein: "ein"
        )).thenAnswer((_) async => MockBusinessAccount());
        bloc.add(Submitted(
          name: 'name', 
          address: 'address',
          addressSecondary: 'addressSecondary',
          city: 'city',
          state: 'state',
          zip: 'zip',
          entityType: EntityType.corporation,
          ein: "ein"
        ));
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.stop)]
    );

    blocTest<BusinessAccountScreenBloc, BusinessAccountScreenState>(
      "Submitted event calls BusinessAccountRepository.store()",
      build: () => _businessAccountScreenBloc,
      act: (bloc) {
        when(() => _businessAccountRepository.store(
          name: 'name', 
          address: 'address',
          addressSecondary: 'addressSecondary',
          city: 'city',
          state: ('state').toUpperCase(),
          zip: 'zip',
          entityType: BusinessAccount.entityTypeToString(entityType: EntityType.corporation),
          ein: "ein"
        )).thenAnswer((_) async => MockBusinessAccount());
        bloc.add(Submitted(
          name: 'name', 
          address: 'address',
          addressSecondary: 'addressSecondary',
          city: 'city',
          state: 'state',
          zip: 'zip',
          entityType: EntityType.corporation,
          ein: "ein"
        ));
      },
      verify: (_) {
        verify(() => _businessAccountRepository.store(
          name: 'name', 
          address: 'address',
          addressSecondary: 'addressSecondary',
          city: 'city',
          state: ('state').toUpperCase(),
          zip: 'zip',
          entityType: BusinessAccount.entityTypeToString(entityType: EntityType.corporation),
          ein: "ein"
        )).called(1);
      }
    );

    blocTest<BusinessAccountScreenBloc, BusinessAccountScreenState>(
      "Submitted event calls BusinessBloc.add()",
      build: () => _businessAccountScreenBlocWithMockBusinessBloc,
      act: (bloc) {
        when(() => _businessAccountRepository.store(
          name: 'name', 
          address: 'address',
          addressSecondary: 'addressSecondary',
          city: 'city',
          state: ('state').toUpperCase(),
          zip: 'zip',
          entityType: BusinessAccount.entityTypeToString(entityType: EntityType.corporation),
          ein: "ein"
        )).thenAnswer((_) async => MockBusinessAccount());
        when(() => _businessBloc.add(any(that: isA<BusinessAccountUpdated>()))).thenReturn(null);
        bloc.add(Submitted(
          name: 'name', 
          address: 'address',
          addressSecondary: 'addressSecondary',
          city: 'city',
          state: 'state',
          zip: 'zip',
          entityType: EntityType.corporation,
          ein: "ein"
        ));
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
          name: 'name', 
          address: 'address',
          addressSecondary: 'addressSecondary',
          city: 'city',
          state: ('state').toUpperCase(),
          zip: 'zip',
          entityType: BusinessAccount.entityTypeToString(entityType: EntityType.corporation),
          ein: "ein"
        )).thenThrow(ApiException(error: "error"));
        bloc.add(Submitted(
          name: 'name', 
          address: 'address',
          addressSecondary: 'addressSecondary',
          city: 'city',
          state: 'state',
          zip: 'zip',
          entityType: EntityType.corporation,
          ein: "ein"
        ));
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, isFailure: true, errorMessage: "error", errorButtonControl: CustomAnimationControl.playFromStart)]
    );

    blocTest<BusinessAccountScreenBloc, BusinessAccountScreenState>(
      "Updated event changes state: [isSubmitting: true], [isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.STOP]",
      build: () => _businessAccountScreenBloc,
      act: (bloc) {
        when(() => _businessAccountRepository.update(
          identifier: "identifier",
          name: 'name', 
          address: 'address',
          addressSecondary: 'addressSecondary',
          city: 'city',
          state: ('state').toUpperCase(),
          zip: 'zip',
          entityType: BusinessAccount.entityTypeToString(entityType: EntityType.corporation),
          ein: "ein"
        )).thenAnswer((_) async => MockBusinessAccount());
        bloc.add(Updated(
          id: "identifier",
          name: 'name', 
          address: 'address',
          addressSecondary: 'addressSecondary',
          city: 'city',
          state: 'state',
          zip: 'zip',
          entityType: EntityType.corporation,
          ein: "ein"
        ));
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.stop)]
    );

    blocTest<BusinessAccountScreenBloc, BusinessAccountScreenState>(
      "Updated event calls BusinessAccountRepository.update()",
      build: () => _businessAccountScreenBloc,
      act: (bloc) {
        when(() => _businessAccountRepository.update(
          identifier: 'identifier',
          name: 'name', 
          address: 'address',
          addressSecondary: 'addressSecondary',
          city: 'city',
          state: ('state').toUpperCase(),
          zip: 'zip',
          entityType: BusinessAccount.entityTypeToString(entityType: EntityType.corporation),
          ein: "ein"
        )).thenAnswer((_) async => MockBusinessAccount());
        bloc.add(Updated(
          id: "identifier",
          name: 'name', 
          address: 'address',
          addressSecondary: 'addressSecondary',
          city: 'city',
          state: 'state',
          zip: 'zip',
          entityType: EntityType.corporation,
          ein: "ein"
        ));
      },
      verify: (_) {
        verify(() => _businessAccountRepository.update(
          identifier: "identifier",
          name: 'name', 
          address: 'address',
          addressSecondary: 'addressSecondary',
          city: 'city',
          state: ('state').toUpperCase(),
          zip: 'zip',
          entityType: BusinessAccount.entityTypeToString(entityType: EntityType.corporation),
          ein: "ein"
        )).called(1);
      }
    );

    blocTest<BusinessAccountScreenBloc, BusinessAccountScreenState>(
      "Updated event calls BusinessBloc.add()",
      build: () => _businessAccountScreenBlocWithMockBusinessBloc,
      act: (bloc) {
        when(() => _businessAccountRepository.update(
          identifier: "identifier",
          name: 'name', 
          address: 'address',
          addressSecondary: 'addressSecondary',
          city: 'city',
          state: ('state').toUpperCase(),
          zip: 'zip',
          entityType: BusinessAccount.entityTypeToString(entityType: EntityType.corporation),
          ein: "ein"
        )).thenAnswer((_) async => MockBusinessAccount());
        when(() => _businessBloc.add(any(that: isA<BusinessAccountUpdated>()))).thenReturn(null);
        bloc.add(Updated(
          id: "identifier",
          name: 'name', 
          address: 'address',
          addressSecondary: 'addressSecondary',
          city: 'city',
          state: 'state',
          zip: 'zip',
          entityType: EntityType.corporation,
          ein: "ein"
        ));
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
          identifier: "identifier",
          name: 'name', 
          address: 'address',
          addressSecondary: 'addressSecondary',
          city: 'city',
          state: ('state').toUpperCase(),
          zip: 'zip',
          entityType: BusinessAccount.entityTypeToString(entityType: EntityType.corporation),
          ein: "ein"
        )).thenThrow(ApiException(error: "error"));
        bloc.add(Updated(
          id: "identifier",
          name: 'name', 
          address: 'address',
          addressSecondary: 'addressSecondary',
          city: 'city',
          state: 'state',
          zip: 'zip',
          entityType: EntityType.corporation,
          ein: "ein"
        ));
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