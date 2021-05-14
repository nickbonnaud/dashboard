part of 'business_bloc.dart';

abstract class BusinessEvent extends Equatable {
  const BusinessEvent();

  @override
  List<Object> get props => [];
}

class BusinessAuthenticated extends BusinessEvent {}

class BusinessLoggedIn extends BusinessEvent {
  final Business business;

  const BusinessLoggedIn({required this.business});

  @override
  List<Object> get props => [business];

  @override
  String toString() => 'BusinessLoggedIn { business: $business }';
}

class BusinessUpdated extends BusinessEvent {
  final Business business;

  const BusinessUpdated({required this.business});

  @override
  List<Object> get props => [business];

  @override
  String toString() => 'BusinessUpdated { business: $business }';
}

class BusinessLoggedOut extends BusinessEvent {}


class BankAccountUpdated extends BusinessEvent {
  final BankAccount bankAccount;

  const BankAccountUpdated({required this.bankAccount});

  @override
  List<Object> get props => [bankAccount];

  @override
  String toString() => 'BankAccountUpdated { bankAccount: $bankAccount }';
}

class PhotosUpdated extends BusinessEvent {
  final Photos photos;

  const PhotosUpdated({required this.photos});

  @override
  List<Object> get props => [photos];

  @override
  String toString() => 'PhotosUpdated { photos: $photos }';
}

class BusinessAccountUpdated extends BusinessEvent {
  final BusinessAccount businessAccount;

  const BusinessAccountUpdated({required this.businessAccount});

  @override
  List<Object> get props => [businessAccount];

  @override
  String toString() => 'BusinessAccountUpdated { businessAccount: $businessAccount }';
}

class HoursUpdated extends BusinessEvent {
  final Hours hours;

  const HoursUpdated({required this.hours});

  @override
  List<Object> get props => [hours];

  @override
  String toString() => 'HoursUpdated: { hours: $hours }';
}

class LocationUpdated extends BusinessEvent {
  final Location location;

  const LocationUpdated({required this.location});

  @override
  List<Object> get props => [location];

  @override
  String toString() => 'LocationUpdated { location: $location }';
}

class OwnerAccountsUpdated extends BusinessEvent {
  final List<OwnerAccount> ownerAccounts;

  const OwnerAccountsUpdated({required this.ownerAccounts});

  @override
  List<Object> get props => [ownerAccounts];

  @override
  String toString() => "OwnerAccountsUpdated { ownerAccounts: $ownerAccounts }";
}

class ProfileUpdated extends BusinessEvent {
  final Profile profile;

  const ProfileUpdated({required this.profile});

  @override
  List<Object> get props => [profile];

  @override
  String toString() => 'ProfileUpdated { profile: $profile }';
}

class EmailUpdated extends BusinessEvent {
  final String email;

  const EmailUpdated({required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => "EmailUpdated { email: $email }";
}
