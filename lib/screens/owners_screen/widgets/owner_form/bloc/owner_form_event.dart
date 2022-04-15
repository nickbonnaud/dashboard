part of 'owner_form_bloc.dart';

abstract class OwnerFormEvent extends Equatable {
  const OwnerFormEvent();

  @override
  List<Object> get props => [];
}

class FirstNameChanged extends OwnerFormEvent {
  final String firstName;

  const FirstNameChanged({required this.firstName});

  @override
  List<Object> get props => [firstName];

  @override
  String toString() => 'FirstNameChanged { firstName: $firstName }';
}

class LastNameChanged extends OwnerFormEvent {
  final String lastName;

  const LastNameChanged({required this.lastName});

  @override
  List<Object> get props => [lastName];

  @override
  String toString() => 'LastNameChanged { lastName: $lastName }';
}

class TitleChanged extends OwnerFormEvent {
  final String title;

  const TitleChanged({required this.title});

  @override
  List<Object> get props => [title];

  @override
  String toString() => 'TitleChanged { title: $title }';
}

class PhoneChanged extends OwnerFormEvent {
  final String phone;

  const PhoneChanged({required this.phone});

  @override
  List<Object> get props => [phone];

  @override
  String toString() => 'PhoneChanged { phone: $phone }';
}

class EmailChanged extends OwnerFormEvent {
  final String email;

  const EmailChanged({required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'EmailChanged { email: $email }';
}

class PrimaryChanged extends OwnerFormEvent {
  final bool isPrimary;

  const PrimaryChanged({required this.isPrimary});

  @override
  List<Object> get props => [isPrimary];

  @override
  String toString() => 'PrimaryChanged { isPrimary: $isPrimary }';
}

class PercentOwnershipChanged extends OwnerFormEvent {
  final int percentOwnership;

  const PercentOwnershipChanged({required this.percentOwnership});

  @override
  List<Object> get props => [percentOwnership];

  @override
  String toString() => 'PercentOwnershipChanged { percentOwnership: $percentOwnership }';
}

class DobChanged extends OwnerFormEvent {
  final String dob;

  const DobChanged({required this.dob});

  @override
  List<Object> get props => [dob];

  @override
  String toString() => 'DobChanged { dob: $dob }';
}

class SsnChanged extends OwnerFormEvent {
  final String ssn;

  const SsnChanged({required this.ssn});

  @override
  List<Object> get props => [ssn];

  @override
  String toString() => 'SsnChanged { ssn: $ssn }';
}

class AddressChanged extends OwnerFormEvent {
  final String address;

  const AddressChanged({required this.address});

  @override
  List<Object> get props => [address];

  @override
  String toString() => 'AddressChanged {address: $address }';
}

class AddressSecondaryChanged extends OwnerFormEvent {
  final String addressSecondary;

  const AddressSecondaryChanged({required this.addressSecondary});

  @override
  List<Object> get props => [addressSecondary];

  @override
  String toString() => 'AddressSecondaryChanged { addressSecondary: $addressSecondary }';
}

class CityChanged extends OwnerFormEvent {
  final String city;

  const CityChanged({required this.city});

  @override
  List<Object> get props => [city];

  @override
  String toString() => 'CityChanged { city: $city }';
}

class StateChanged extends OwnerFormEvent {
  final String state;

  const StateChanged({required this.state});

  @override
  List<Object> get props => [state];

  @override
  String toString() => 'StateChanged { state: $state }';
}

class ZipChanged extends OwnerFormEvent {
  final String zip;

  const ZipChanged({required this.zip});

  @override
  List<Object> get props => [zip];

  @override
  String toString() => 'ZipChanged { zip: $zip }';
}

class Submitted extends OwnerFormEvent {}

class Updated extends OwnerFormEvent {}

class Reset extends OwnerFormEvent {}
