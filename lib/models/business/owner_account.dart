import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'address.dart';

@immutable
class OwnerAccount extends Equatable {
  final String identifier;
  final String dob;
  final String ssn;
  final String firstName;
  final String lastName;
  final String title;
  final String phone;
  final String email;
  final bool primary;
  final int percentOwnership;
  final Address address;

  const OwnerAccount({
    required this.identifier,
    required this.dob,
    required this.ssn,
    required this.firstName,
    required this.lastName,
    required this.title,
    required this.phone,
    required this.email,
    required this.primary,
    required this.percentOwnership,
    required this.address
  });

  OwnerAccount.fromJson({required Map<String, dynamic> json})
    : identifier = json['identifier']!,
      dob = json['dob']!,
      ssn = json['ssn']!,
      firstName = json['first_name']!,
      lastName = json['last_name']!,
      title = json['title']!,
      phone = json['phone']!,
      email = json['email']!,
      primary = json['primary']!,
      percentOwnership = json['percent_ownership']!,
      address = Address.fromJson(json: json['address']!);

  OwnerAccount update({
    String? identifier,
    String? dob,
    String? ssn,
    String? firstName,
    String? lastName,
    String? title,
    String? phone,
    String? email,
    bool? primary,
    int? percentOwnership,
    Address? address,
  }) {
    return OwnerAccount(
      identifier: identifier ?? this.identifier,
      dob: dob ?? this.dob, 
      ssn: ssn ?? this.ssn, 
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      title: title ?? this.title,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      primary: primary ?? this.primary,
      percentOwnership: percentOwnership ?? this.percentOwnership,
      address: address ?? this.address
    );
  }

  @override
  List<Object> get props => [
    identifier,
    dob,
    ssn,
    firstName,
    lastName,
    title,
    phone,
    email,
    primary,
    percentOwnership,
    address
  ];

  @override
  String toString() => '''OwnerAccount {
    identifier: $identifier,
    dob: $dob,
    ssn: $ssn,
    firstName: $firstName,
    lastName: $lastName,
    title: $title,
    phone: $phone,
    email: $email,
    primary: $primary,
    percentOwnership: $percentOwnership,
    address: $address
  }''';
}