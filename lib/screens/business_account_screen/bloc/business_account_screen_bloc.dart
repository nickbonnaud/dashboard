import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/models/business/business_account.dart';
import 'package:dashboard/repositories/business_account_repository.dart';
import 'package:dashboard/resources/constants.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/resources/helpers/validators.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:simple_animations/simple_animations.dart';

part 'business_account_screen_event.dart';
part 'business_account_screen_state.dart';

class BusinessAccountScreenBloc extends Bloc<BusinessAccountScreenEvent, BusinessAccountScreenState> {
  final BusinessAccountRepository _accountRepository;
  final BusinessBloc _businessBloc;
  
  BusinessAccountScreenBloc({required BusinessAccountRepository accountRepository, required BusinessBloc businessBloc, required BusinessAccount businessAccount}) 
    : _accountRepository = accountRepository,
      _businessBloc = businessBloc,
      super(BusinessAccountScreenState.empty(entityType: businessAccount.entityType));

  @override
  Stream<Transition<BusinessAccountScreenEvent, BusinessAccountScreenState>> transformEvents(Stream<BusinessAccountScreenEvent> events, transitionFn) {
    final nonDebounceStream = events.where((event) => 
      event is Submitted ||
      event is Updated ||
      event is Reset ||
      event is EntityTypeSelected ||
      event is ChangeEntityTypeSelected
    );

    final debounceStream = events.where((event) => 
      event is !Submitted &&
      event is !Updated &&
      event is !Reset &&
      event is !EntityTypeSelected &&
      event is !ChangeEntityTypeSelected
    ).debounceTime(Duration(milliseconds: 300));
    
    return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), transitionFn);
  }
  
  @override
  Stream<BusinessAccountScreenState> mapEventToState(BusinessAccountScreenEvent event) async* {
    if (event is EntityTypeSelected) {
      yield* _mapEntityTypeSelectedToState(event: event);
    } else if (event is NameChanged) {
      yield* _mapNameChangedToState(event: event);
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
    } else if (event is EinChanged) {
      yield* _mapEinChangedToState(event: event);
    } else if (event is Submitted) {
      yield* _mapSubmittedToState(event: event);
    } else if (event is Updated) {
      yield* _mapUpdatedToState(event: event);
    } else if (event is ChangeEntityTypeSelected) {
      yield* _mapChangeEntityTypeSelectedToState();
    } else if (event is Reset) {
      yield* _mapResetToState();
    }
  }

  Stream<BusinessAccountScreenState> _mapEntityTypeSelectedToState({required EntityTypeSelected event}) async* {
    yield state.update(entityType: event.entityType);
  }
  
  Stream<BusinessAccountScreenState> _mapNameChangedToState({required NameChanged event}) async* {
    yield state.update(isNameValid: Validators.isValidBusinessName(name: event.name));
  }

  Stream<BusinessAccountScreenState> _mapAddressChangedToState({required AddressChanged event}) async* {
    yield state.update(isAddressValid: Validators.isValidAddress(address: event.address));
  }

  Stream<BusinessAccountScreenState> _mapAddressSecondaryChangedToState({required AddressSecondaryChanged event}) async* {
    yield state.update(isAddressSecondaryValid: Validators.isValidAddressSecondary(address: event.addressSecondary));
  }

  Stream<BusinessAccountScreenState> _mapCityChangedToState({required CityChanged event}) async* {
    yield state.update(isCityValid: Validators.isValidCity(city: event.city));
  }

  Stream<BusinessAccountScreenState> _mapStateChangedToState({required StateChanged event}) async* {
    yield state.update(isStateValid: Constants.states.contains(event.state.toUpperCase()));
  }

  Stream<BusinessAccountScreenState> _mapZipChangedToState({required ZipChanged event}) async* {
    yield state.update(isZipValid: Validators.isValidZip(zip: event.zip));
  }

  Stream<BusinessAccountScreenState> _mapEinChangedToState({required EinChanged event}) async* {
    yield state.update(isEinValid: Validators.isValidEin(ein: event.ein));
  }

  Stream<BusinessAccountScreenState> _mapSubmittedToState({required Submitted event}) async* {
    yield state.update(isSubmitting: true);
    
    try {
      final BusinessAccount account = await _accountRepository.store(
        name: event.name, 
        address: event.address,
        addressSecondary: event.addressSecondary,
        city: event.city,
        state: event.state.toUpperCase(),
        zip: event.zip,
        entityType: BusinessAccount.entityTypeToString(entityType: event.entityType),
        ein: event.ein
      );
      _updateBusinessBloc(account: account);
      yield state.update(isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.STOP);
    } on ApiException catch (exception) {
      yield state.update(isSubmitting: false, isFailure: true, errorMessage: exception.error, errorButtonControl: CustomAnimationControl.PLAY_FROM_START);
    }
  }

  Stream<BusinessAccountScreenState> _mapUpdatedToState({required Updated event}) async* {
    yield state.update(isSubmitting: true);

    try {
      BusinessAccount account = await _accountRepository.update(
        name: event.name, 
        address: event.address,
        addressSecondary: event.addressSecondary,
        city: event.city,
        state: event.state.toUpperCase(),
        zip: event.zip,
        entityType: BusinessAccount.entityTypeToString(entityType: event.entityType),
        ein: event.ein,
        identifier: event.id
      );
      _updateBusinessBloc(account: account);
      yield state.update(isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.STOP);
    } on ApiException catch (exception) {
      yield state.update(isSubmitting: false, isFailure: true, errorMessage: exception.error, errorButtonControl: CustomAnimationControl.PLAY_FROM_START);
    }
  }

  Stream<BusinessAccountScreenState> _mapChangeEntityTypeSelectedToState() async* {
    yield state.update(entityType: EntityType.unknown);
  }
  
  Stream<BusinessAccountScreenState> _mapResetToState() async* {
    yield state.update(isSuccess: false, isFailure: false, errorMessage: "", errorButtonControl: CustomAnimationControl.STOP);
  }

  void _updateBusinessBloc({required BusinessAccount account}) {
    _businessBloc.add(BusinessAccountUpdated(businessAccount: account));
  }
}
