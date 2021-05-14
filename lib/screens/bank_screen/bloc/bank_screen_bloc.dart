import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/models/business/bank_account.dart';
import 'package:dashboard/repositories/bank_repository.dart';
import 'package:dashboard/resources/constants.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/resources/helpers/validators.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:rxdart/rxdart.dart';

part 'bank_screen_event.dart';
part 'bank_screen_state.dart';

class BankScreenBloc extends Bloc<BankScreenEvent, BankScreenState> {
  final BankRepository _bankRepository;
  final BusinessBloc _businessBloc;
  
  BankScreenBloc({required BankRepository bankRepository, required BusinessBloc businessBloc, required BankAccount bankAccount})
    : _bankRepository = bankRepository,
      _businessBloc = businessBloc,
      super(BankScreenState.empty(accountType: bankAccount.accountType));

  @override
  Stream<Transition<BankScreenEvent, BankScreenState>> transformEvents(Stream<BankScreenEvent> events, transitionFn) {
    final nonDebounceStream = events.where((event) => 
      event is Submitted ||
      event is Updated ||
      event is Reset ||
      event is AccountTypeSelected ||
      event is ChangeAccountTypeSelected
    );

    final debounceStream = events.where((event) => 
      event is !Submitted &&
      event is !Updated &&
      event is !Reset &&
      event is !AccountTypeSelected &&
      event is !ChangeAccountTypeSelected
    ).debounceTime(Duration(milliseconds: 300));

    return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), transitionFn);
  }
  
  @override
  Stream<BankScreenState> mapEventToState(BankScreenEvent event) async* {
    if (event is FirstNameChanged) {
      yield* _mapFirstNameChangedToState(event: event);
    } else if (event is LastNameChanged) {
      yield* _mapLastNameChangedToState(event: event);
    } else if (event is RoutingNumberChanged) {
      yield* _mapRoutingNumberChangedToState(event: event);
    } else if (event is AccountNumberChanged) {
      yield* _mapAccountNumberChangedToState(event: event);
    } else if (event is AccountTypeSelected) {
      yield* _mapAccountTypeSelectedToState(event: event);
    } else if (event is AddressChanged) {
      yield* _mapAddressChangedToState(event: event);
    } else if (event is AddressSecondaryChanged) {
      yield* _mapAddressSecondaryChangedToState(event: event);
    } else if (event is CityChanged) {
      yield* _mapCityChangedToState(event: event);
    } else if (event is StateChanged) {
      yield* _mapStateChangedToState(event: event);
    } else if (event is ZipChanged) {
      yield* _mapZipChangedToState(event: event);
    } else if (event is Submitted) {
      yield* _mapSubmittedToState(event: event);
    } else if (event is Updated) {
      yield* _mapUpdatedToState(event: event);
    } else if (event is ChangeAccountTypeSelected) {
      yield* _mapChangeAccountTypeSelectedToState();
    } else if (event is Reset) {
      yield* _mapResetToState();
    }
  }

  Stream<BankScreenState> _mapFirstNameChangedToState({required FirstNameChanged event}) async* {
    yield state.update(isFirstNameValid: Validators.isValidFirstName(name: event.firstName));
  }

  Stream<BankScreenState> _mapLastNameChangedToState({required LastNameChanged event}) async* {
    yield state.update(isLastNameValid: Validators.isValidLastName(name: event.lastName));
  }

  Stream<BankScreenState> _mapRoutingNumberChangedToState({required RoutingNumberChanged event}) async* {
    yield state.update(isRoutingNumberValid: Validators.isValidRoutingNumber(routingNumber: event.routingNumber));
  }

  Stream<BankScreenState> _mapAccountNumberChangedToState({required AccountNumberChanged event}) async* {
    yield state.update(isAccountNumberValid: Validators.isValidAccountNumber(accountNumber: event.accountNumber));
  }

  Stream<BankScreenState> _mapAccountTypeSelectedToState({required AccountTypeSelected event}) async* {
    yield state.update(accountType: event.accountType);
  }

  Stream<BankScreenState> _mapAddressChangedToState({required AddressChanged event}) async* {
    yield state.update(isAddressValid: Validators.isValidAddress(address: event.address));
  }

  Stream<BankScreenState> _mapAddressSecondaryChangedToState({required AddressSecondaryChanged event}) async* {
    yield state.update(isAddressSecondaryValid: Validators.isValidAddressSecondary(address: event.addressSecondary));
  }

  Stream<BankScreenState> _mapCityChangedToState({required CityChanged event}) async* {
    yield state.update(isCityValid: Validators.isValidCity(city: event.city));
  }

  Stream<BankScreenState> _mapStateChangedToState({required StateChanged event}) async* {
    yield state.update(isStateValid: Constants.states.contains(event.state.toUpperCase()));
  }

  Stream<BankScreenState> _mapZipChangedToState({required ZipChanged event}) async* {
    yield state.update(isZipValid: Validators.isValidZip(zip: event.zip));
  }

  Stream<BankScreenState> _mapSubmittedToState({required Submitted event}) async* {
    yield state.update(isSubmitting: true);

    try {
      final BankAccount account = await _bankRepository.store(
        firstName: event.firstName,
        lastName: event.lastName,
        routingNumber: event.routingNumber,
        accountNumber: event.accountNumber,
        accountType: BankAccount.accountTypeToString(accountType: event.accountType),
        address: event.address,
        addressSecondary: event.addressSecondary,
        city: event.city,
        state: event.state,
        zip: event.zip
      );
      _updateBusinessBloc(bankAccount: account);
      yield state.update(isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.STOP);
    } on ApiException catch (exception) {
      yield state.update(isSubmitting: false, isFailure: true, errorMessage: exception.error, errorButtonControl: CustomAnimationControl.PLAY_FROM_START);
    }
  }

  Stream<BankScreenState> _mapUpdatedToState({required Updated event}) async* {
    yield state.update(isSubmitting: true);
    try {
      final BankAccount account = await _bankRepository.update(
        identifier: event.identifier,
        firstName: event.firstName,
        lastName: event.lastName,
        routingNumber: event.routingNumber,
        accountNumber: event.accountNumber,
        accountType: BankAccount.accountTypeToString(accountType: event.accountType),
        address: event.address,
        addressSecondary: event.addressSecondary,
        city: event.city,
        state: event.state,
        zip: event.zip
      );
      _updateBusinessBloc(bankAccount: account);
      yield state.update(isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.STOP);
    } on ApiException catch (exception) {
      yield state.update(isSubmitting: false, isFailure: true, errorMessage: exception.error, errorButtonControl: CustomAnimationControl.PLAY_FROM_START);
    }
  }

  Stream<BankScreenState> _mapResetToState() async* {
    yield state.update(isSuccess: false, isFailure: false, errorMessage: "", errorButtonControl: CustomAnimationControl.STOP);
  }

  Stream<BankScreenState> _mapChangeAccountTypeSelectedToState() async* {
    yield state.update(accountType: AccountType.unknown);
  }

  void _updateBusinessBloc({required BankAccount bankAccount}) {
    _businessBloc.add(BankAccountUpdated(bankAccount: bankAccount));
  }
}
