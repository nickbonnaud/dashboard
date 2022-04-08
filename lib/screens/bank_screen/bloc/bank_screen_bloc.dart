import 'package:bloc/bloc.dart';
import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/models/business/bank_account.dart';
import 'package:dashboard/repositories/bank_repository.dart';
import 'package:dashboard/resources/constants.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/resources/helpers/debouncer.dart';
import 'package:dashboard/resources/helpers/validators.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:simple_animations/simple_animations.dart';

part 'bank_screen_event.dart';
part 'bank_screen_state.dart';

class BankScreenBloc extends Bloc<BankScreenEvent, BankScreenState> {
  final BankRepository _bankRepository;
  final BusinessBloc _businessBloc;

  final Duration _debounceTime = const Duration(milliseconds: 300);
  
  BankScreenBloc({required BankRepository bankRepository, required BusinessBloc businessBloc, required BankAccount bankAccount})
    : _bankRepository = bankRepository,
      _businessBloc = businessBloc,
      super(BankScreenState.empty(accountType: bankAccount.accountType)) {
        _eventHandler();
  }

  void _eventHandler() {
    on<FirstNameChanged>((event, emit) => _mapFirstNameChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<LastNameChanged>((event, emit) => _mapLastNameChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<RoutingNumberChanged>((event, emit) => _mapRoutingNumberChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<AccountNumberChanged>((event, emit) => _mapAccountNumberChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<AddressChanged>((event, emit) => _mapAddressChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<AddressSecondaryChanged>((event, emit) => _mapAddressSecondaryChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<CityChanged>((event, emit) => _mapCityChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<StateChanged>((event, emit) => _mapStateChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<ZipChanged>((event, emit) => _mapZipChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<AccountTypeSelected>((event, emit) => _mapAccountTypeSelectedToState(event: event, emit: emit));
    on<Submitted>((event, emit) async => await _mapSubmittedToState(event: event, emit: emit));
    on<Updated>((event, emit) async => await _mapUpdatedToState(event: event, emit: emit));
    on<ChangeAccountTypeSelected>((event, emit) => _mapChangeAccountTypeSelectedToState(emit: emit));
    on<Reset>((event, emit) => _mapResetToState(emit: emit));
  }

  void _mapFirstNameChangedToState({required FirstNameChanged event, required Emitter<BankScreenState> emit}) {
    emit(state.update(isFirstNameValid: Validators.isValidFirstName(name: event.firstName)));
  }

  void _mapLastNameChangedToState({required LastNameChanged event, required Emitter<BankScreenState> emit}) {
    emit(state.update(isLastNameValid: Validators.isValidLastName(name: event.lastName)));
  }

  void _mapRoutingNumberChangedToState({required RoutingNumberChanged event, required Emitter<BankScreenState> emit}) {
    emit(state.update(isRoutingNumberValid: Validators.isValidRoutingNumber(routingNumber: event.routingNumber)));
  }

  void _mapAccountNumberChangedToState({required AccountNumberChanged event, required Emitter<BankScreenState> emit}) {
    emit(state.update(isAccountNumberValid: Validators.isValidAccountNumber(accountNumber: event.accountNumber)));
  }

  void _mapAccountTypeSelectedToState({required AccountTypeSelected event, required Emitter<BankScreenState> emit}) {
    emit(state.update(accountType: event.accountType));
  }

  void _mapAddressChangedToState({required AddressChanged event, required Emitter<BankScreenState> emit}) {
    emit(state.update(isAddressValid: Validators.isValidAddress(address: event.address)));
  }

  void _mapAddressSecondaryChangedToState({required AddressSecondaryChanged event, required Emitter<BankScreenState> emit}) {
    emit(state.update(isAddressSecondaryValid: Validators.isValidAddressSecondary(address: event.addressSecondary)));
  }

  void _mapCityChangedToState({required CityChanged event, required Emitter<BankScreenState> emit}) {
    emit(state.update(isCityValid: Validators.isValidCity(city: event.city)));
  }

  void _mapStateChangedToState({required StateChanged event, required Emitter<BankScreenState> emit}) {
    emit(state.update(isStateValid: Constants.states.contains(event.state.toUpperCase())));
  }

  void _mapZipChangedToState({required ZipChanged event, required Emitter<BankScreenState> emit}) {
    emit(state.update(isZipValid: Validators.isValidZip(zip: event.zip)));
  }

  Future<void> _mapSubmittedToState({required Submitted event, required Emitter<BankScreenState> emit}) async {
    emit(state.update(isSubmitting: true));

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
      emit(state.update(isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.stop));
    } on ApiException catch (exception) {
      emit(state.update(isSubmitting: false, isFailure: true, errorMessage: exception.error, errorButtonControl: CustomAnimationControl.playFromStart));
    }
  }

  Future<void> _mapUpdatedToState({required Updated event, required Emitter<BankScreenState> emit}) async {
    emit(state.update(isSubmitting: true));
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
      emit(state.update(isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.stop));
    } on ApiException catch (exception) {
      emit(state.update(isSubmitting: false, isFailure: true, errorMessage: exception.error, errorButtonControl: CustomAnimationControl.playFromStart));
    }
  }

  void _mapResetToState({required Emitter<BankScreenState> emit}) {
    emit(state.update(isSuccess: false, isFailure: false, errorMessage: "", errorButtonControl: CustomAnimationControl.stop));
  }

  void _mapChangeAccountTypeSelectedToState({required Emitter<BankScreenState> emit}) {
    emit(state.update(accountType: AccountType.unknown));
  }

  void _updateBusinessBloc({required BankAccount bankAccount}) {
    _businessBloc.add(BankAccountUpdated(bankAccount: bankAccount));
  }
}
