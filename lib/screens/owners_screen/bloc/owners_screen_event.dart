part of 'owners_screen_bloc.dart';

abstract class OwnersScreenEvent extends Equatable {
  const OwnersScreenEvent();

  @override
  List<Object?> get props => [];
}

class OwnerAdded extends OwnersScreenEvent {
  final OwnerAccount owner;

  const OwnerAdded({required this.owner});

  @override
  List<Object> get props => [owner];

  @override
  String toString() => 'OwnerAdded { owner: $owner }';
}

class OwnerUpdated extends OwnersScreenEvent {
  final OwnerAccount owner;
  
  const OwnerUpdated({required this.owner});

  @override
  List<Object> get props => [owner];

  @override
  String toString() => 'OwnerUpdated { owner: $owner }';
}

class OwnerRemoved extends OwnersScreenEvent {
  final OwnerAccount owner;

  const OwnerRemoved({required this.owner});

  @override
  List<Object> get props => [owner];

  @override
  String toString() => 'OwnerRemoved { owner: $owner }';
}

class PrimaryRemoved extends OwnersScreenEvent {
  final OwnerAccount account;

  const PrimaryRemoved({required this.account});

  @override
  List<Object> get props => [account];

  @override
  String toString() => 'PrimaryRemoved { account: $account }';
}

class ShowForm extends OwnersScreenEvent {
  final OwnerAccount? account;

  const ShowForm({required this.account});

  @override
  List<Object?> get props => [account];

  @override
  String toString() => 'ShowForm { account: $account }';
}

class HideForm extends OwnersScreenEvent {}
