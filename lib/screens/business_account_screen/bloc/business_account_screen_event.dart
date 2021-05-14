part of 'business_account_screen_bloc.dart';

abstract class BusinessAccountScreenEvent extends Equatable {
  const BusinessAccountScreenEvent();

  @override
  List<Object?> get props => [];
}

class NameChanged extends BusinessAccountScreenEvent {
  final String name;

  const NameChanged({required this.name});

  @override
  List<Object> get props => [name];

  @override
  String toString() => 'NameChanged { name: $name }';
}

class AddressChanged extends BusinessAccountScreenEvent {
  final String address;

  const AddressChanged({required this.address});

  @override
  List<Object> get props => [address];

  @override
  String toString() => 'AddressChanged {address: $address }';
}

class AddressSecondaryChanged extends BusinessAccountScreenEvent {
  final String addressSecondary;

  const AddressSecondaryChanged({required this.addressSecondary});

  @override
  List<Object> get props => [addressSecondary];

  @override
  String toString() => 'AddressSecondaryChanged { addressSecondary: $addressSecondary }';
}

class CityChanged extends BusinessAccountScreenEvent {
  final String city;

  const CityChanged({required this.city});

  @override
  List<Object> get props => [city];

  @override
  String toString() => 'CityChanged { city: $city }';
}

class StateChanged extends BusinessAccountScreenEvent {
  final String state;

  const StateChanged({required this.state});

  @override
  List<Object> get props => [state];

  @override
  String toString() => 'StateChanged { state: $state }';
}

class ZipChanged extends BusinessAccountScreenEvent {
  final String zip;

  const ZipChanged({required this.zip});

  @override
  List<Object> get props => [zip];

  @override
  String toString() => 'ZipChanged { zip: $zip }';
}

class EinChanged extends BusinessAccountScreenEvent {
  final String ein;

  const EinChanged({required this.ein});

  @override
  List<Object> get props => [ein];

  @override
  String toString() => 'EinChanged { ein: $ein }';
}

class EntityTypeSelected extends BusinessAccountScreenEvent {
  final EntityType entityType;

  const EntityTypeSelected({required this.entityType});

  @override
  List<Object> get props => [entityType];

  @override
  String toString() => 'EntityTypeSelected { entityType: $entityType }';
}

class ChangeEntityTypeSelected extends BusinessAccountScreenEvent {}

class Submitted extends BusinessAccountScreenEvent {
  final EntityType entityType;
  final String name;
  final String address;
  final String addressSecondary;
  final String city;
  final String state;
  final String zip;
  final String? ein;

  const Submitted({
    required this.entityType,
    required this.name,
    required this.address,
    required this.addressSecondary,
    required this.city,
    required this.state,
    required this.zip,
    this.ein
  });

  @override
  List<Object?> get props => [
    entityType,
    name,
    address,
    addressSecondary,
    city,
    state,
    zip,
    ein
  ];

  @override
  String toString() => '''Submitted {
    entityType: $entityType,
    name: $name,
    address: $address,
    addressSecondary: $addressSecondary,
    city: $city,
    state: $state,
    zip: $zip,
    ein: $ein
  }''';
}

class Updated extends BusinessAccountScreenEvent {
  final EntityType entityType;
  final String name;
  final String address;
  final String addressSecondary;
  final String city;
  final String state;
  final String zip;
  final String ein;
  final String id;

  const Updated({
    required this.entityType,
    required this.name,
    required this.address,
    required this.addressSecondary,
    required this.city,
    required this.state,
    required this.zip,
    required this.ein,
    required this.id
  });

  @override
  List<Object> get props => [
    entityType,
    name,
    address,
    addressSecondary,
    city,
    state,
    zip,
    ein,
    id
  ];

  @override
  String toString() => '''Updated {
    entityType: $entityType,
    name: $name,
    address: $address,
    addressSecondary: $addressSecondary,
    city: $city,
    state: $state,
    zip: $zip,
    ein: $ein,
    id: $id
  }''';
}

class Reset extends BusinessAccountScreenEvent {}
