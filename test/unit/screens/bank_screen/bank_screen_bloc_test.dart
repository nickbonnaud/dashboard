import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/models/business/bank_account.dart';
import 'package:dashboard/models/business/business.dart';
import 'package:dashboard/repositories/bank_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/bank_screen/bloc/bank_screen_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simple_animations/simple_animations.dart';

import '../../../helpers/mock_data_generator.dart';

class MockBankRepository extends Mock implements BankRepository {}
class MockBankAccount extends Mock implements BankAccount {}
class MockBusinessBloc extends Mock implements BusinessBloc {}

void main() {
  
  group("Bank Screen Bloc Tests", () {
    late BankRepository _bankRepository;
    late BankAccount _bankAccount;
    late BankScreenBloc _bankScreenBloc;
    late BusinessBloc _businessBloc;

    late BankScreenState _baseState;

    setUp(() {
      Business business = MockDataGenerator().createBusiness();
      _bankAccount = business.accounts.bankAccount;

      _bankRepository = MockBankRepository();
      _businessBloc = MockBusinessBloc();
      when(() => _businessBloc.business).thenReturn(business);
      
      _bankScreenBloc = BankScreenBloc(
        bankRepository: _bankRepository, 
        businessBloc: _businessBloc
      );

      _baseState = BankScreenState.empty(bankAccount: _bankAccount);
      registerFallbackValue(BankAccountUpdated(bankAccount: _bankAccount));
    });

    tearDown(() {
      _bankScreenBloc.close();
    });

    test("Initial state of BankScreenBloc is BankScreenState.empty()", () {
      expect(_bankScreenBloc.state, BankScreenState.empty(bankAccount: _bankAccount));
    });

    blocTest<BankScreenBloc, BankScreenState>(
      "FirstNameChanged event changes state: isFirstNameValid", 
      build: () => _bankScreenBloc,
      act: (bloc) => bloc.add(const FirstNameChanged(firstName: "J")),
      wait: const Duration(milliseconds: 300),
      expect: () => [_baseState.update(firstName: "J", isFirstNameValid: false)]
    );

    blocTest<BankScreenBloc, BankScreenState>(
      "LastNameChanged event changes state: isLastNameValid", 
      build: () => _bankScreenBloc,
      act: (bloc) => bloc.add(const LastNameChanged(lastName: "J")),
      wait: const Duration(milliseconds: 300),
      expect: () => [_baseState.update(lastName: "J", isLastNameValid: false)]
    );

    blocTest<BankScreenBloc, BankScreenState>(
      "RoutingNumberChanged event changes state: isRoutingNumberValid", 
      build: () => _bankScreenBloc,
      act: (bloc) => bloc.add(const RoutingNumberChanged(routingNumber: "124")),
      wait: const Duration(milliseconds: 300),
      expect: () => [_baseState.update(routingNumber: "124", isRoutingNumberValid: false)]
    );

    blocTest<BankScreenBloc, BankScreenState>(
      "AccountNumberChanged event changes state: isAccountNumberValid", 
      build: () => _bankScreenBloc,
      act: (bloc) => bloc.add(const AccountNumberChanged(accountNumber: "124")),
      wait: const Duration(milliseconds: 300),
      expect: () => [_baseState.update(accountNumber: "124", isAccountNumberValid: false)]
    );

    blocTest<BankScreenBloc, BankScreenState>(
      "AccountTypeSelected event changes state: accountType", 
      build: () => _bankScreenBloc,
      act: (bloc) => bloc.add(const AccountTypeSelected(accountType: AccountType.saving)),
      expect: () => [_baseState.update(accountType: AccountType.saving)]
    );

    blocTest<BankScreenBloc, BankScreenState>(
      "AddressChanged event changes state: isAddressValid", 
      build: () => _bankScreenBloc,
      act: (bloc) => bloc.add(const AddressChanged(address: "N")),
      wait: const Duration(milliseconds: 300),
      expect: () => [_baseState.update(address: "N", isAddressValid: false)]
    );

    blocTest<BankScreenBloc, BankScreenState>(
      "AddressSecondaryChanged event changes state: isAddressSecondaryValid", 
      build: () => _bankScreenBloc,
      act: (bloc) => bloc.add(const AddressSecondaryChanged(addressSecondary: "N")),
      wait: const Duration(milliseconds: 300),
      expect: () => [_baseState.update(addressSecondary: "N", isAddressSecondaryValid: false)]
    );

    blocTest<BankScreenBloc, BankScreenState>(
      "CityChanged event changes state: isCityValid", 
      build: () => _bankScreenBloc,
      act: (bloc) => bloc.add(const CityChanged(city: "N")),
      wait: const Duration(milliseconds: 300),
      expect: () => [_baseState.update(city: "N", isCityValid: false)]
    );

    blocTest<BankScreenBloc, BankScreenState>(
      "StateChanged event changes state: isStateValid", 
      build: () => _bankScreenBloc,
      act: (bloc) => bloc.add(const StateChanged(state: "N")),
      wait: const Duration(milliseconds: 300),
      expect: () => [_baseState.update(state: "N", isStateValid: false)]
    );

    blocTest<BankScreenBloc, BankScreenState>(
      "ZipChanged event changes state: isZipValid", 
      build: () => _bankScreenBloc,
      act: (bloc) => bloc.add(const ZipChanged(zip: "1")),
      wait: const Duration(milliseconds: 300),
      expect: () => [_baseState.update(zip: "1", isZipValid: false)]
    );

    blocTest<BankScreenBloc, BankScreenState>(
      "Submitted event changes state: [isSubmitting:true], [isSubmitting:false, isSuccess:true, errorButtonControl:CustomAnimationControl.STOP]", 
      build: () => _bankScreenBloc,
      act: (bloc) {
        when(() => _bankRepository.store(
          firstName: _bankAccount.firstName,
          lastName: _bankAccount.lastName,
          routingNumber: _bankAccount.routingNumber,
          accountNumber: _bankAccount.accountNumber,
          accountType: BankAccount.accountTypeToString(accountType: _bankAccount.accountType),
          address: _bankAccount.address.address,
          addressSecondary: _bankAccount.address.addressSecondary ?? "",
          city: _bankAccount.address.city,
          state: _bankAccount.address.state,
          zip: _bankAccount.address.zip
        )).thenAnswer((_) async => MockBankAccount());
        bloc.add(Submitted());
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.stop)]
    );

    blocTest<BankScreenBloc, BankScreenState>(
      "Submitted event calls BankRepository Store", 
      build: () => _bankScreenBloc,
      act: (bloc) {
        when(() => _bankRepository.store(
          firstName: _bankAccount.firstName,
          lastName: _bankAccount.lastName,
          routingNumber: _bankAccount.routingNumber,
          accountNumber: _bankAccount.accountNumber,
          accountType: BankAccount.accountTypeToString(accountType: _bankAccount.accountType),
          address: _bankAccount.address.address,
          addressSecondary: _bankAccount.address.addressSecondary ?? "",
          city: _bankAccount.address.city,
          state: _bankAccount.address.state,
          zip: _bankAccount.address.zip
        )).thenAnswer((_) async => MockBankAccount());
        bloc.add(Submitted());
      },
      verify: (_) {
        verify(() => _bankRepository.store(
          firstName: _bankAccount.firstName,
          lastName: _bankAccount.lastName,
          routingNumber: _bankAccount.routingNumber,
          accountNumber: _bankAccount.accountNumber,
          accountType: BankAccount.accountTypeToString(accountType: _bankAccount.accountType),
          address: _bankAccount.address.address,
          addressSecondary: _bankAccount.address.addressSecondary ?? "",
          city: _bankAccount.address.city,
          state: _bankAccount.address.state,
          zip: _bankAccount.address.zip
        )).called(1);
      }
    );

    blocTest<BankScreenBloc, BankScreenState>(
      "Submitted event calls BusinessBloc.add", 
      build: () => _bankScreenBloc,
      act: (bloc) {
        when(() => _bankRepository.store(
          firstName: _bankAccount.firstName,
          lastName: _bankAccount.lastName,
          routingNumber: _bankAccount.routingNumber,
          accountNumber: _bankAccount.accountNumber,
          accountType: BankAccount.accountTypeToString(accountType: _bankAccount.accountType),
          address: _bankAccount.address.address,
          addressSecondary: _bankAccount.address.addressSecondary ?? "",
          city: _bankAccount.address.city,
          state: _bankAccount.address.state,
          zip: _bankAccount.address.zip
        )).thenAnswer((_) async => MockBankAccount());
        when(() => _businessBloc.add(any(that: isA<BusinessEvent>()))).thenReturn(null);
        bloc.add(Submitted());
      },
      verify: (_) {
        verify(() => _businessBloc.add(any(that: isA<BusinessEvent>())));
      }
    );

    blocTest<BankScreenBloc, BankScreenState>(
      "Submitted event on error changes state: [isSubmitting:true], [isSubmitting:false, isFailure:true, errorMessage:error errorButtonControl:CustomAnimationControl.PLAY_FROM_START]", 
      build: () => _bankScreenBloc,
      act: (bloc) {
        when(() => _bankRepository.store(
          firstName: _bankAccount.firstName,
          lastName: _bankAccount.lastName,
          routingNumber: _bankAccount.routingNumber,
          accountNumber: _bankAccount.accountNumber,
          accountType: BankAccount.accountTypeToString(accountType: _bankAccount.accountType),
          address: _bankAccount.address.address,
          addressSecondary: _bankAccount.address.addressSecondary ?? "",
          city: _bankAccount.address.city,
          state: _bankAccount.address.state,
          zip: _bankAccount.address.zip
        )).thenThrow(const ApiException(error: "error"));
        bloc.add(Submitted());
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, isFailure: true, errorMessage: "error", errorButtonControl: CustomAnimationControl.playFromStart)]
    );

    blocTest<BankScreenBloc, BankScreenState>(
      "Update event changes state: [isSubmitting:true], [isSubmitting:false, isSuccess:true, errorButtonControl:CustomAnimationControl.STOP]", 
      build: () => _bankScreenBloc,
      act: (bloc) {
        when(() => _bankRepository.update(
          identifier: _bankAccount.identifier,
          firstName: _bankAccount.firstName,
          lastName: _bankAccount.lastName,
          routingNumber: _bankAccount.routingNumber,
          accountNumber: _bankAccount.accountNumber,
          accountType: BankAccount.accountTypeToString(accountType: _bankAccount.accountType),
          address: _bankAccount.address.address,
          addressSecondary: _bankAccount.address.addressSecondary ?? "",
          city: _bankAccount.address.city,
          state: _bankAccount.address.state,
          zip: _bankAccount.address.zip
        )).thenAnswer((_) async => MockBankAccount());
        bloc.add(Updated());
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.stop)]
    );

    blocTest<BankScreenBloc, BankScreenState>(
      "Update event calls BankRepository Update", 
      build: () => _bankScreenBloc,
      act: (bloc) {
        when(() => _bankRepository.update(
          identifier: _bankAccount.identifier,
          firstName: _bankAccount.firstName,
          lastName: _bankAccount.lastName,
          routingNumber: _bankAccount.routingNumber,
          accountNumber: _bankAccount.accountNumber,
          accountType: BankAccount.accountTypeToString(accountType: _bankAccount.accountType),
          address: _bankAccount.address.address,
          addressSecondary: _bankAccount.address.addressSecondary ?? "",
          city: _bankAccount.address.city,
          state: _bankAccount.address.state,
          zip: _bankAccount.address.zip
        )).thenAnswer((_) async => MockBankAccount());
        bloc.add(Updated());
      },
      verify: (_) {
        verify(() => _bankRepository.update(
          identifier: _bankAccount.identifier,
          firstName: _bankAccount.firstName,
          lastName: _bankAccount.lastName,
          routingNumber: _bankAccount.routingNumber,
          accountNumber: _bankAccount.accountNumber,
          accountType: BankAccount.accountTypeToString(accountType: _bankAccount.accountType),
          address: _bankAccount.address.address,
          addressSecondary: _bankAccount.address.addressSecondary ?? "",
          city: _bankAccount.address.city,
          state: _bankAccount.address.state,
          zip: _bankAccount.address.zip
        )).called(1);
      }
    );

    blocTest<BankScreenBloc, BankScreenState>(
      "Update event calls BusinessBloc.add", 
      build: () => _bankScreenBloc,
      act: (bloc) {
        when(() => _bankRepository.update(
          identifier: _bankAccount.identifier,
          firstName: _bankAccount.firstName,
          lastName: _bankAccount.lastName,
          routingNumber: _bankAccount.routingNumber,
          accountNumber: _bankAccount.accountNumber,
          accountType: BankAccount.accountTypeToString(accountType: _bankAccount.accountType),
          address: _bankAccount.address.address,
          addressSecondary: _bankAccount.address.addressSecondary ?? "",
          city: _bankAccount.address.city,
          state: _bankAccount.address.state,
          zip: _bankAccount.address.zip
        )).thenAnswer((_) async => MockBankAccount());
        when(() => _businessBloc.add(any(that: isA<BusinessEvent>()))).thenReturn(null);
        bloc.add(Updated());
      },
      verify: (_) {
        verify(() => _businessBloc.add(any(that: isA<BusinessEvent>())));
      }
    );

    blocTest<BankScreenBloc, BankScreenState>(
      "Update event on error changes state: [isSubmitting:true], [isSubmitting:false, isFailure:true, errorMessage:error errorButtonControl:CustomAnimationControl.PLAY_FROM_START]", 
      build: () => _bankScreenBloc,
      act: (bloc) {
        when(() => _bankRepository.update(
          identifier: _bankAccount.identifier,
          firstName: _bankAccount.firstName,
          lastName: _bankAccount.lastName,
          routingNumber: _bankAccount.routingNumber,
          accountNumber: _bankAccount.accountNumber,
          accountType: BankAccount.accountTypeToString(accountType: _bankAccount.accountType),
          address: _bankAccount.address.address,
          addressSecondary: _bankAccount.address.addressSecondary ?? "",
          city: _bankAccount.address.city,
          state: _bankAccount.address.state,
          zip: _bankAccount.address.zip
        )).thenThrow(const ApiException(error: "error"));
        bloc.add(Updated());
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, isFailure: true, errorMessage: "error", errorButtonControl: CustomAnimationControl.playFromStart)]
    );
    
    blocTest<BankScreenBloc, BankScreenState>(
      "Reset event changes state: isSuccess:false, isFailure:false, errorMessage:"", errorButtonControl:CustomAnimationControl.STOP", 
      build: () => _bankScreenBloc,
      act: (bloc) => bloc.add(Reset()),
      expect: () => [_baseState.update(isSuccess: false, isFailure: false, errorMessage: "", errorButtonControl: CustomAnimationControl.stop)]
    );
    
    blocTest<BankScreenBloc, BankScreenState>(
      "ChangeAccountTypeSelected event changes state: accountType", 
      build: () => _bankScreenBloc,
      seed: () =>  _baseState.update(accountType: AccountType.checking),
      act: (bloc) => bloc.add(ChangeAccountTypeSelected()),
      expect: () => [_baseState.update(accountType: AccountType.saving)]
    );
  });
}