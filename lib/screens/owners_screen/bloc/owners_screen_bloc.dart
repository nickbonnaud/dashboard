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
      super(OwnersScreenState.initial(owners: ownerAccounts)) { _eventHandler(); }

  void _eventHandler() {
    on<OwnerAdded>((event, emit) => _mapOwnerAddedToState(event: event, emit: emit));
    on<OwnerRemoved>((event, emit) => _mapOwnerRemovedToState(event: event, emit: emit));
    on<PrimaryRemoved>((event, emit) => _mapPrimaryRemovedToState(event: event, emit: emit));
    on<ShowForm>((event, emit) => _mapShowFormToState(event: event, emit: emit));
    on<HideForm>((event, emit) => _mapHideFormToState(emit: emit));
    on<OwnerUpdated>((event, emit) => _mapOwnerUpdatedToState(event: event, emit: emit));
  }

  void _mapOwnerAddedToState({required OwnerAdded event, required Emitter<OwnersScreenState> emit}) async {
    List<OwnerAccount> updatedOwners = state.owners.where((owner) => owner.identifier != event.owner.identifier).toList()..add(event.owner);
    _updateBusinessBloc(updatedOwners: updatedOwners);
    emit(state.update(owners: updatedOwners));
  }

  void _mapOwnerRemovedToState({required OwnerRemoved event, required Emitter<OwnersScreenState> emit}) async {
    emit(state.update(isSubmitting:  true));
    try {
      await _ownerRepository.remove(identifier: event.owner.identifier);
      List<OwnerAccount> updatedOwners = state.owners.where((owner) => owner.identifier != event.owner.identifier).toList();
      _updateBusinessBloc(updatedOwners: updatedOwners);
      emit(state.update(owners: updatedOwners, isSubmitting: false, isSuccess:  true));
    } on ApiException catch (exception) {
      emit(state.update(isSubmitting: false, errorMessage: exception.error));
    }
  }

  void _mapPrimaryRemovedToState({required PrimaryRemoved event, required Emitter<OwnersScreenState> emit}) async {
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
      emit(state.update(owners: updatedOwners));
    } on ApiException catch (exception) {
      emit(state.update(errorMessage: exception.error));
    }
  }

  void _mapShowFormToState({required ShowForm event, required Emitter<OwnersScreenState> emit}) async {
    emit(state.update(formVisible: true, editingAccount: event.account));
  }

  void _mapHideFormToState({required Emitter<OwnersScreenState> emit}) async {
    emit(state.update(
      formVisible: false,
      resetEditingAccount: true
    ));
  }

  void _mapOwnerUpdatedToState({required OwnerUpdated event, required Emitter<OwnersScreenState> emit}) async {
    List<OwnerAccount> updatedOwners = state.owners.where(
      (owner) => owner.identifier != event.owner.identifier)
        .toList()..add(event.owner);
    _updateBusinessBloc(updatedOwners: updatedOwners);
    emit(state.update(owners: updatedOwners));
  }

  void _updateBusinessBloc({required List<OwnerAccount> updatedOwners}) {
    _businessBloc.add(OwnerAccountsUpdated(ownerAccounts: updatedOwners));
  }
}
