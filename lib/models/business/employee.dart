import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Employee extends Equatable {
  final String identifier;
  final String externalId;
  final String firstName;
  final String lastName;
  final String? email;

  const Employee({required this.identifier, required this.externalId, required this.firstName, required this.lastName, this.email});

  static Employee fromJson({required Map<String, dynamic> json}) {
    return Employee(
      identifier: json['identifier']!,
      externalId: json['external_id']!,
      firstName: json['first_name']!,
      lastName: json['last_name']!,
      email: json['email']
    );
  }

  @override
  List<Object?> get props => [identifier, externalId, firstName, lastName, email];

  @override
  String toString() => 'Employee { identifier: $identifier, externalId: $externalId, firstName: $firstName, lastName: $lastName, email: $email }';
}