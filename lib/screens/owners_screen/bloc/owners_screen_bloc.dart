import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/models/business/owner_account.dart';
import 'package:dashboard/repositories/owner_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'owners_screen_event.dart';
part 'owners_screen_state.dart';

class OwnersScreenBloc extends Bloc<OwnersScreenEvent, OwnersScreenState> {
  final BusinessBloc _businessBloc;
  final OwnerRepository _ownerRepository;

  List<OwnerAccount> get owners => state.owners;
  
  OwnersScreenBloc({required BusinessBloc businessBloc, required OwnerRepository ownerRepository, required List<OwnerAccount> ownerAccounts}) 
    : _businessBloc = businessBloc,
      _ownerRepository = ownerRepository,
      super(OwnersScreenState.initial(owners: ownerAccounts));

  @override
  Stream<OwnersScreenState> mapEventToState(OwnersScreenEvent event) async* {
    if (event is OwnerAdded) {
      yield* _mapOwnerAddedToState(event: event);
    } else if (event is OwnerRemoved) {
      yield* _mapOwnerRemovedToState(event: event);
    } else if (event is PrimaryRemoved) {
      yield* _mapPrimaryRemovedToState(event: event);
    } else if (event is ShowForm) {
      yield* _mapShowFormToState(event: event);
    } else if (event is HideForm) {
      yield* _mapHideFormToState();
    } else if (event is OwnerUpdated) {
      yield* _mapOwnerUpdatedToState(event: event);
    }
  }

  Stream<OwnersScreenState> _mapOwnerAddedToState({required OwnerAdded event}) async* {
    List<OwnerAccount> updatedOwners = state.owners.where((owner) => owner.identifier != event.owner.identifier).toList()..add(event.owner);
    _updateBusinessBloc(updatedOwners: updatedOwners);
    yield state.update(owners: updatedOwners);
  }

  Stream<OwnersScreenState> _mapOwnerRemovedToState({required OwnerRemoved event}) async* {
    yield state.update(isSubmitting:  true);
    try {
      await _ownerRepository.remove(identifier: event.owner.identifier);
      List<OwnerAccount> updatedOwners = state.owners.where((owner) => owner.identifier != event.owner.identifier).toList();
      _updateBusinessBloc(updatedOwners: updatedOwners);
      yield state.update(owners: updatedOwners, isSubmitting: false, isSuccess:  true);
    } on ApiException catch (exception) {
      yield state.update(isSubmitting: false, errorMessage: exception.error);
    }
  }

  Stream<OwnersScreenState> _mapPrimaryRemovedToState({required PrimaryRemoved event}) async* {
    try {
      OwnerAccount updatedOwner = await _ownerRepository.update(
        identifier: event.account.identifier, 
        firstName: event.account.firstName, 
        lastName: event.account.lastName,
        title: event.account.title, 
        phone: event.account.phone, 
        email: event.account.email, 
        primary: false, 
        percentOwnership: event.account.percentOwnership,
        dob: event.account.dob, 
        ssn: event.account.ssn, 
        address: event.account.address.address,
        addressSecondary: event.account.address.addressSecondary, 
        city: event.account.address.city, 
        state: event.account.address.state, 
        zip: event.account.address.zip
      );
      
      final List<OwnerAccount> updatedOwners = state.owners.where(
        (owner) => owner.identifier != event.account.identifier)
          .toList()..add(updatedOwner);
      
      _updateBusinessBloc(updatedOwners: updatedOwners);
      yield state.update(owners: updatedOwners);
    } on ApiException catch (exception) {
      yield state.update(errorMessage: exception.error);
    }
  }

  Stream<OwnersScreenState> _mapShowFormToState({required ShowForm event}) async* {
    yield state.update(formVisible: true, editingAccount: event.account);
  }

  Stream<OwnersScreenState> _mapHideFormToState() async* {
    yield state.update(
      formVisible: false,
      resetEditingAccount: true
    );
  }

  Stream<OwnersScreenState> _mapOwnerUpdatedToState({required OwnerUpdated event}) async* {
    List<OwnerAccount> updatedOwners = state.owners.where(
      (owner) => owner.identifier != event.owner.identifier)
        .toList()..add(event.owner);
    _updateBusinessBloc(updatedOwners: updatedOwners);
    yield state.update(owners: updatedOwners);
  }

  void _updateBusinessBloc({required List<OwnerAccount> updatedOwners}) {
    _businessBloc.add(OwnerAccountsUpdated(ownerAccounts: updatedOwners));
  }
}
