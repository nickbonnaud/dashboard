import 'package:bloc/bloc.dart';
import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/models/business/business_account.dart';
import 'package:dashboard/repositories/business_account_repository.dart';
import 'package:dashboard/resources/constants.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/resources/helpers/debouncer.dart';
import 'package:dashboard/resources/helpers/validators.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:simple_animations/simple_animations.dart';

part 'business_account_screen_event.dart';
part 'business_account_screen_state.dart';

class BusinessAccountScreenBloc extends Bloc<BusinessAccountScreenEvent, BusinessAccountScreenState> {
  final BusinessAccountRepository _accountRepository;
  final BusinessBloc _businessBloc;

  final Duration _debounceTime = const Duration(milliseconds: 300);
  
  BusinessAccountScreenBloc({required BusinessAccountRepository accountRepository, required BusinessBloc businessBloc, required BusinessAccount businessAccount}) 
    : _accountRepository = accountRepository,
      _businessBloc = businessBloc,
      super(BusinessAccountScreenState.empty(businessAccount: businessBloc.business.accounts.businessAccount)) {
        _eventHandler();
  }

  void _eventHandler() {
    on<NameChanged>((event, emit) => _mapNameChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<AddressChanged>((event, emit) => _mapAddressChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<AddressSecondaryChanged>((event, emit) => _mapAddressSecondaryChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<CityChanged>((event, emit) => _mapCityChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<StateChanged>((event, emit) => _mapStateChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<ZipChanged>((event, emit) => _mapZipChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<EinChanged>((event, emit) => _mapEinChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<EntityTypeSelected>((event, emit) => _mapEntityTypeSelectedToState(event: event, emit: emit));
    on<Submitted>((event, emit) async => await _mapSubmittedToState(event: event, emit: emit));
    on<Updated>((event, emit) async => await _mapUpdatedToState(event: event, emit: emit));
    on<ChangeEntityTypeSelected>((event, emit) => _mapChangeEntityTypeSelectedToState(emit: emit));
    on<Reset>((event, emit) => _mapResetToState(emit: emit));
  }

  void _mapEntityTypeSelectedToState({required EntityTypeSelected event, required Emitter<BusinessAccountScreenState> emit}) {
    emit(state.update(entityType: event.entityType));
  }
  
  void _mapNameChangedToState({required NameChanged event, required Emitter<BusinessAccountScreenState> emit}) {
    emit(state.update(name: event.name, isNameValid: Validators.isValidBusinessName(name: event.name)));
  }

  void _mapAddressChangedToState({required AddressChanged event, required Emitter<BusinessAccountScreenState> emit}) {
    emit(state.update(address: event.address, isAddressValid: Validators.isValidAddress(address: event.address)));
  }

  void _mapAddressSecondaryChangedToState({required AddressSecondaryChanged event, required Emitter<BusinessAccountScreenState> emit}) {
    emit(state.update(addressSecondary: event.addressSecondary, isAddressSecondaryValid: Validators.isValidAddressSecondary(address: event.addressSecondary)));
  }

  void _mapCityChangedToState({required CityChanged event, required Emitter<BusinessAccountScreenState> emit}) {
    emit(state.update(city: event.city, isCityValid: Validators.isValidCity(city: event.city)));
  }

  void _mapStateChangedToState({required StateChanged event, required Emitter<BusinessAccountScreenState> emit}) {
    emit(state.update(state:event.state, isStateValid: Constants.states.contains(event.state.toUpperCase())));
  }

  void _mapZipChangedToState({required ZipChanged event, required Emitter<BusinessAccountScreenState> emit}) {
    emit(state.update(zip: event.zip, isZipValid: Validators.isValidZip(zip: event.zip)));
  }

  void _mapEinChangedToState({required EinChanged event, required Emitter<BusinessAccountScreenState> emit}) {
    emit(state.update(ein: event.ein, isEinValid: Validators.isValidEin(ein: event.ein)));
  }

  Future<void> _mapSubmittedToState({required Submitted event, required Emitter<BusinessAccountScreenState> emit}) async {
    emit(state.update(isSubmitting: true));
    
    try {
      final BusinessAccount account = await _accountRepository.store(
        name: state.name, 
        address: state.address,
        addressSecondary: state.addressSecondary,
        city: state.city,
        state: state.state.toUpperCase(),
        zip: state.zip,
        entityType: BusinessAccount.entityTypeToString(entityType: state.entityType),
        ein: state.entityType != EntityType.soleProprietorship ? state.ein : ""
      );
      _updateBusinessBloc(account: account);
      emit(state.update(isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.stop));
    } on ApiException catch (exception) {
      emit(state.update(isSubmitting: false, isFailure: true, errorMessage: exception.error, errorButtonControl: CustomAnimationControl.playFromStart));
    }
  }

  Future<void> _mapUpdatedToState({required Updated event, required Emitter<BusinessAccountScreenState> emit}) async {
    emit(state.update(isSubmitting: true));

    try {
      BusinessAccount account = await _accountRepository.update(
        name: state.name, 
        address: state.address,
        addressSecondary: state.addressSecondary,
        city: state.city,
        state: state.state.toUpperCase(),
        zip: state.zip,
        entityType: BusinessAccount.entityTypeToString(entityType: state.entityType),
        ein: state.ein,
        identifier: _businessBloc.business.accounts.businessAccount.identifier
      );
      _updateBusinessBloc(account: account);
      emit(state.update(isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.stop));
    } on ApiException catch (exception) {
      emit(state.update(isSubmitting: false, isFailure: true, errorMessage: exception.error, errorButtonControl: CustomAnimationControl.playFromStart));
    }
  }

  void _mapChangeEntityTypeSelectedToState({required Emitter<BusinessAccountScreenState> emit}) {
    emit(state.update(entityType: EntityType.unknown));
  }
  
  void _mapResetToState({required Emitter<BusinessAccountScreenState> emit}) {
    emit(state.update(isSuccess: false, isFailure: false, errorMessage: "", errorButtonControl: CustomAnimationControl.stop));
  }

  void _updateBusinessBloc({required BusinessAccount account}) {
    _businessBloc.add(BusinessAccountUpdated(businessAccount: account));
  }
}
