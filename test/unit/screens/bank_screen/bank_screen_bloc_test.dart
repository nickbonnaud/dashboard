import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/models/business/bank_account.dart';
import 'package:dashboard/providers/business_provider.dart';
import 'package:dashboard/repositories/bank_repository.dart';
import 'package:dashboard/repositories/business_repository.dart';
import 'package:dashboard/repositories/token_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/bank_screen/bloc/bank_screen_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simple_animations/simple_animations.dart';

class MockBankRepository extends Mock implements BankRepository {}
class MockBankAccount extends Mock implements BankAccount {}
class MockBusinessBloc extends Mock implements BusinessBloc {}

void main() {
  
  group("Bank Screen Bloc Tests", () {
    late BankRepository _bankRepository;
    late BankAccount _bankAccount;
    late BankScreenBloc _bankScreenBloc;
    late BankScreenBloc _bankScreenBlocWithMockBusinessBloc;
    late BusinessBloc _businessBloc;

    late BankScreenState _baseState;

    setUp(() {
      _bankRepository = MockBankRepository();
      _businessBloc = MockBusinessBloc();
      _bankAccount = MockBankAccount();
      when(() => _bankAccount.accountType).thenReturn(AccountType.checking);
      _bankScreenBloc = BankScreenBloc(
        bankRepository: _bankRepository, 
        bankAccount: _bankAccount, 
        businessBloc: BusinessBloc(
          businessRepository: BusinessRepository(
            businessProvider: BusinessProvider(), 
            tokenRepository: TokenRepository()
          )
        )
      );
      _bankScreenBlocWithMockBusinessBloc = BankScreenBloc(
        bankRepository: _bankRepository, 
        bankAccount: _bankAccount, 
        businessBloc: _businessBloc
      );
      _baseState = BankScreenState.empty(accountType: AccountType.checking);
      registerFallbackValue<BusinessEvent>(BankAccountUpdated(bankAccount: _bankAccount));
    });

    tearDown(() {
      _bankScreenBloc.close();
      _bankScreenBlocWithMockBusinessBloc.close();
    });

    test("Initial state of BankScreenBloc is BankScreenState.empty()", () {
      expect(_bankScreenBloc.state, BankScreenState.empty(accountType: _bankAccount.accountType));
    });

    blocTest<BankScreenBloc, BankScreenState>(
      "FirstNameChanged event changes state: isFirstNameValid", 
      build: () => _bankScreenBloc,
      act: (bloc) => bloc.add(FirstNameChanged(firstName: "J")),
      wait: Duration(milliseconds: 300),
      expect: () => [_baseState.update(isFirstNameValid: false)]
    );

    blocTest<BankScreenBloc, BankScreenState>(
      "LastNameChanged event changes state: isLastNameValid", 
      build: () => _bankScreenBloc,
      act: (bloc) => bloc.add(LastNameChanged(lastName: "J")),
      wait: Duration(milliseconds: 300),
      expect: () => [_baseState.update(isLastNameValid: false)]
    );

    blocTest<BankScreenBloc, BankScreenState>(
      "RoutingNumberChanged event changes state: isRoutingNumberValid", 
      build: () => _bankScreenBloc,
      act: (bloc) => bloc.add(RoutingNumberChanged(routingNumber: "124")),
      wait: Duration(milliseconds: 300),
      expect: () => [_baseState.update(isRoutingNumberValid: false)]
    );

    blocTest<BankScreenBloc, BankScreenState>(
      "AccountNumberChanged event changes state: isAccountNumberValid", 
      build: () => _bankScreenBloc,
      act: (bloc) => bloc.add(AccountNumberChanged(accountNumber: "124")),
      wait: Duration(milliseconds: 300),
      expect: () => [_baseState.update(isAccountNumberValid: false)]
    );

    blocTest<BankScreenBloc, BankScreenState>(
      "AccountTypeSelected event changes state: accountType", 
      build: () => _bankScreenBloc,
      act: (bloc) => bloc.add(AccountTypeSelected(accountType: AccountType.saving)),
      expect: () => [_baseState.update(accountType: AccountType.saving)]
    );

    blocTest<BankScreenBloc, BankScreenState>(
      "AddressChanged event changes state: isAddressValid", 
      build: () => _bankScreenBloc,
      act: (bloc) => bloc.add(AddressChanged(address: "N")),
      wait: Duration(milliseconds: 300),
      expect: () => [_baseState.update(isAddressValid: false)]
    );

    blocTest<BankScreenBloc, BankScreenState>(
      "AddressSecondaryChanged event changes state: isAddressSecondaryValid", 
      build: () => _bankScreenBloc,
      act: (bloc) => bloc.add(AddressSecondaryChanged(addressSecondary: "N")),
      wait: Duration(milliseconds: 300),
      expect: () => [_baseState.update(isAddressSecondaryValid: false)]
    );

    blocTest<BankScreenBloc, BankScreenState>(
      "CityChanged event changes state: isCityValid", 
      build: () => _bankScreenBloc,
      act: (bloc) => bloc.add(CityChanged(city: "N")),
      wait: Duration(milliseconds: 300),
      expect: () => [_baseState.update(isCityValid: false)]
    );

    blocTest<BankScreenBloc, BankScreenState>(
      "StateChanged event changes state: isStateValid", 
      build: () => _bankScreenBloc,
      act: (bloc) => bloc.add(StateChanged(state: "N")),
      wait: Duration(milliseconds: 300),
      expect: () => [_baseState.update(isStateValid: false)]
    );

    blocTest<BankScreenBloc, BankScreenState>(
      "ZipChanged event changes state: isZipValid", 
      build: () => _bankScreenBloc,
      act: (bloc) => bloc.add(ZipChanged(zip: "1")),
      wait: Duration(milliseconds: 300),
      expect: () => [_baseState.update(isZipValid: false)]
    );

    blocTest<BankScreenBloc, BankScreenState>(
      "Submitted event changes state: [isSubmitting:true], [isSubmitting:false, isSuccess:true, errorButtonControl:CustomAnimationControl.STOP]", 
      build: () => _bankScreenBloc,
      act: (bloc) {
        when(() => _bankRepository.store(
          firstName: "firstName",
          lastName: "lastName",
          routingNumber: "routingNumber",
          accountNumber: "accountNumber",
          accountType: BankAccount.accountTypeToString(accountType: AccountType.checking),
          address: "address",
          addressSecondary: "addressSecondary",
          city: "city",
          state: "state",
          zip: "zip"
        )).thenAnswer((_) async => MockBankAccount());
        bloc.add(Submitted(
          firstName: "firstName",
          lastName: "lastName",
          routingNumber: "routingNumber",
          accountNumber: "accountNumber",
          accountType: AccountType.checking,
          address: "address",
          addressSecondary: "addressSecondary",
          city: "city",
          state: "state",
          zip: "zip"
        ));
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.STOP)]
    );

    blocTest<BankScreenBloc, BankScreenState>(
      "Submitted event calls BankRepository Store", 
      build: () => _bankScreenBloc,
      act: (bloc) {
        when(() => _bankRepository.store(
          firstName: "firstName",
          lastName: "lastName",
          routingNumber: "routingNumber",
          accountNumber: "accountNumber",
          accountType: BankAccount.accountTypeToString(accountType: AccountType.checking),
          address: "address",
          addressSecondary: "addressSecondary",
          city: "city",
          state: "state",
          zip: "zip"
        )).thenAnswer((_) async => MockBankAccount());
        bloc.add(Submitted(
          firstName: "firstName",
          lastName: "lastName",
          routingNumber: "routingNumber",
          accountNumber: "accountNumber",
          accountType: AccountType.checking,
          address: "address",
          addressSecondary: "addressSecondary",
          city: "city",
          state: "state",
          zip: "zip"
        ));
      },
      verify: (_) {
        verify(() => _bankRepository.store(
          firstName: "firstName",
          lastName: "lastName",
          routingNumber: "routingNumber",
          accountNumber: "accountNumber",
          accountType: BankAccount.accountTypeToString(accountType: AccountType.checking),
          address: "address",
          addressSecondary: "addressSecondary",
          city: "city",
          state: "state",
          zip: "zip"
        )).called(1);
      }
    );

    blocTest<BankScreenBloc, BankScreenState>(
      "Submitted event calls BusinessBloc.add", 
      build: () => _bankScreenBlocWithMockBusinessBloc,
      act: (bloc) {
        when(() => _bankRepository.store(
          firstName: "firstName",
          lastName: "lastName",
          routingNumber: "routingNumber",
          accountNumber: "accountNumber",
          accountType: BankAccount.accountTypeToString(accountType: AccountType.checking),
          address: "address",
          addressSecondary: "addressSecondary",
          city: "city",
          state: "state",
          zip: "zip"
        )).thenAnswer((_) async => MockBankAccount());
        when(() => _businessBloc.add(any(that: isA<BusinessEvent>()))).thenReturn(null);
        bloc.add(Submitted(
          firstName: "firstName",
          lastName: "lastName",
          routingNumber: "routingNumber",
          accountNumber: "accountNumber",
          accountType: AccountType.checking,
          address: "address",
          addressSecondary: "addressSecondary",
          city: "city",
          state: "state",
          zip: "zip"
        ));
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
          firstName: "firstName",
          lastName: "lastName",
          routingNumber: "routingNumber",
          accountNumber: "accountNumber",
          accountType: BankAccount.accountTypeToString(accountType: AccountType.checking),
          address: "address",
          addressSecondary: "addressSecondary",
          city: "city",
          state: "state",
          zip: "zip"
        )).thenThrow(ApiException(error: "error"));
        bloc.add(Submitted(
          firstName: "firstName",
          lastName: "lastName",
          routingNumber: "routingNumber",
          accountNumber: "accountNumber",
          accountType: AccountType.checking,
          address: "address",
          addressSecondary: "addressSecondary",
          city: "city",
          state: "state",
          zip: "zip"
        ));
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, isFailure: true, errorMessage: "error", errorButtonControl: CustomAnimationControl.PLAY_FROM_START)]
    );

    blocTest<BankScreenBloc, BankScreenState>(
      "Update event changes state: [isSubmitting:true], [isSubmitting:false, isSuccess:true, errorButtonControl:CustomAnimationControl.STOP]", 
      build: () => _bankScreenBloc,
      act: (bloc) {
        when(() => _bankRepository.update(
          identifier: "identifier",
          firstName: "firstName",
          lastName: "lastName",
          routingNumber: "routingNumber",
          accountNumber: "accountNumber",
          accountType: BankAccount.accountTypeToString(accountType: AccountType.checking),
          address: "address",
          addressSecondary: "addressSecondary",
          city: "city",
          state: "state",
          zip: "zip"
        )).thenAnswer((_) async => MockBankAccount());
        bloc.add(Updated(
          identifier: "identifier",
          firstName: "firstName",
          lastName: "lastName",
          routingNumber: "routingNumber",
          accountNumber: "accountNumber",
          accountType: AccountType.checking,
          address: "address",
          addressSecondary: "addressSecondary",
          city: "city",
          state: "state",
          zip: "zip"
        ));
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.STOP)]
    );

    blocTest<BankScreenBloc, BankScreenState>(
      "Update event calls BankRepository Update", 
      build: () => _bankScreenBloc,
      act: (bloc) {
        when(() => _bankRepository.update(
          identifier: 'identifier',
          firstName: "firstName",
          lastName: "lastName",
          routingNumber: "routingNumber",
          accountNumber: "accountNumber",
          accountType: BankAccount.accountTypeToString(accountType: AccountType.checking),
          address: "address",
          addressSecondary: "addressSecondary",
          city: "city",
          state: "state",
          zip: "zip"
        )).thenAnswer((_) async => MockBankAccount());
        bloc.add(Updated(
          identifier: "identifier",
          firstName: "firstName",
          lastName: "lastName",
          routingNumber: "routingNumber",
          accountNumber: "accountNumber",
          accountType: AccountType.checking,
          address: "address",
          addressSecondary: "addressSecondary",
          city: "city",
          state: "state",
          zip: "zip"
        ));
      },
      verify: (_) {
        verify(() => _bankRepository.update(
          identifier: "identifier",
          firstName: "firstName",
          lastName: "lastName",
          routingNumber: "routingNumber",
          accountNumber: "accountNumber",
          accountType: BankAccount.accountTypeToString(accountType: AccountType.checking),
          address: "address",
          addressSecondary: "addressSecondary",
          city: "city",
          state: "state",
          zip: "zip"
        )).called(1);
      }
    );

    blocTest<BankScreenBloc, BankScreenState>(
      "Update event calls BusinessBloc.add", 
      build: () => _bankScreenBlocWithMockBusinessBloc,
      act: (bloc) {
        when(() => _bankRepository.update(
          identifier: "identifier",
          firstName: "firstName",
          lastName: "lastName",
          routingNumber: "routingNumber",
          accountNumber: "accountNumber",
          accountType: BankAccount.accountTypeToString(accountType: AccountType.checking),
          address: "address",
          addressSecondary: "addressSecondary",
          city: "city",
          state: "state",
          zip: "zip"
        )).thenAnswer((_) async => MockBankAccount());
        when(() => _businessBloc.add(any(that: isA<BusinessEvent>()))).thenReturn(null);
        bloc.add(Updated(
          identifier: "identifier",
          firstName: "firstName",
          lastName: "lastName",
          routingNumber: "routingNumber",
          accountNumber: "accountNumber",
          accountType: AccountType.checking,
          address: "address",
          addressSecondary: "addressSecondary",
          city: "city",
          state: "state",
          zip: "zip"
        ));
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
          identifier: "identifier",
          firstName: "firstName",
          lastName: "lastName",
          routingNumber: "routingNumber",
          accountNumber: "accountNumber",
          accountType: BankAccount.accountTypeToString(accountType: AccountType.checking),
          address: "address",
          addressSecondary: "addressSecondary",
          city: "city",
          state: "state",
          zip: "zip"
        )).thenThrow(ApiException(error: "error"));
        bloc.add(Updated(
          identifier: "identifier",
          firstName: "firstName",
          lastName: "lastName",
          routingNumber: "routingNumber",
          accountNumber: "accountNumber",
          accountType: AccountType.checking,
          address: "address",
          addressSecondary: "addressSecondary",
          city: "city",
          state: "state",
          zip: "zip"
        ));
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, isFailure: true, errorMessage: "error", errorButtonControl: CustomAnimationControl.PLAY_FROM_START)]
    );
    
    blocTest<BankScreenBloc, BankScreenState>(
      "Reset event changes state: isSuccess:false, isFailure:false, errorMessage:"", errorButtonControl:CustomAnimationControl.STOP", 
      build: () => _bankScreenBloc,
      act: (bloc) => bloc.add(Reset()),
      expect: () => [_baseState.update(isSuccess: false, isFailure: false, errorMessage: "", errorButtonControl: CustomAnimationControl.STOP)]
    );
    
    blocTest<BankScreenBloc, BankScreenState>(
      "ChangeAccountTypeSelected event changes state: accountType", 
      build: () => _bankScreenBloc,
      act: (bloc) => bloc.add(ChangeAccountTypeSelected()),
      expect: () => [_baseState.update(accountType: AccountType.unknown)]
    );
  });
}