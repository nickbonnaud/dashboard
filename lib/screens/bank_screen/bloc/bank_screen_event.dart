part of 'bank_screen_bloc.dart';

abstract class BankScreenEvent extends Equatable {
  const BankScreenEvent();

  @override
  List<Object> get props => [];
}

class FirstNameChanged extends BankScreenEvent {
  final String firstName;

  const FirstNameChanged({required this.firstName});

  @override
  List<Object> get props => [firstName];

  @override
  String toString() => 'FirstNameChanged { firstName: $firstName }';
}

class LastNameChanged extends BankScreenEvent {
  final String lastName;

  const LastNameChanged({required this.lastName});

  @override
  List<Object> get props => [lastName];

  @override
  String toString() => 'LastNameChanged { lastName: $lastName }';
}

class RoutingNumberChanged extends BankScreenEvent {
  final String routingNumber;

  const RoutingNumberChanged({required this.routingNumber});

  @override
  List<Object> get props => [routingNumber];

  @override
  String toString() => 'RoutingNumberChanged { routingNumber: $routingNumber }';
}

class AccountNumberChanged extends BankScreenEvent {
  final String accountNumber;

  const AccountNumberChanged({required this.accountNumber});

  @override
  List<Object> get props => [accountNumber];

  @override
  String toString() => 'AccountNumberChanged { accountNumber: $accountNumber }';
}

class AccountTypeSelected extends BankScreenEvent {
  final AccountType accountType;

  const AccountTypeSelected({required this.accountType});

  @override
  List<Object> get props => [accountType];

  @override
  String toString() => 'AccountTypeSelected { accountType: $accountType }';
}

class AddressChanged extends BankScreenEvent {
  final String address;

  const AddressChanged({required this.address});

  @override
  List<Object> get props => [address];

  @override
  String toString() => 'AddressChanged {address: $address }';
}

class AddressSecondaryChanged extends BankScreenEvent {
  final String addressSecondary;

  const AddressSecondaryChanged({required this.addressSecondary});

  @override
  List<Object> get props => [addressSecondary];

  @override
  String toString() => 'AddressSecondaryChanged { addressSecondary: $addressSecondary }';
}

class CityChanged extends BankScreenEvent {
  final String city;

  const CityChanged({required this.city});

  @override
  List<Object> get props => [city];

  @override
  String toString() => 'CityChanged { city: $city }';
}

class StateChanged extends BankScreenEvent {
  final String state;

  const StateChanged({required this.state});

  @override
  List<Object> get props => [state];

  @override
  String toString() => 'StateChanged { state: $state }';
}

class ZipChanged extends BankScreenEvent {
  final String zip;

  const ZipChanged({required this.zip});

  @override
  List<Object> get props => [zip];

  @override
  String toString() => 'ZipChanged { zip: $zip }';
}

class Submitted extends BankScreenEvent {}

class Updated extends BankScreenEvent {}

class ChangeAccountTypeSelected extends BankScreenEvent {}

class Reset extends BankScreenEvent {}