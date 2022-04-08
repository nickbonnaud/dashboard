import 'package:dashboard/models/photo.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Customer extends Equatable {
  final String identifier;
  final String email;
  final String firstName;
  final String lastName;
  final Photo photo;

  const Customer({
    required this.identifier, 
    required this.email, 
    required this.firstName, 
    required this.lastName, 
    required this.photo
  });

  Customer.fromJson({required Map<String, dynamic> json})
    : identifier = json['identifier']!,
      email = json['email']!,
      firstName = json['first_name']!,
      lastName = json['last_name']!,
      photo = Photo.fromJson(json: json['photo']!);

  // Customer update({
  //   String? identifier,
  //   String? email,
  //   String? firstName,
  //   String? lastName,
  //   Photo? photo
  // }) {
  //   return Customer(
  //     identifier: identifier ?? this.identifier, 
  //     email: email ?? this.email, 
  //     firstName: firstName ?? this.email, 
  //     lastName: lastName ?? this.lastName, 
  //     photo: photo ?? this.photo
  //   );
  // }

  @override
  List<Object> get props => [
    identifier,
    email,
    firstName,
    lastName,
    photo
  ];

  @override
  String toString() => '''Customer {
    identifier: $identifier,
    email: $email,
    firstName: $firstName,
    lastName: $lastName,
    photo: $photo
  }''';
}