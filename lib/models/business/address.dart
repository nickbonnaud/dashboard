import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Address extends Equatable {
  final String address;
  final String? addressSecondary;
  final String city;
  final String state;
  final String zip;

  Address({
    required this.address,
    required this.city,
    required this.state,
    required this.zip,
    this.addressSecondary
  });

  Address.fromJson({required Map<String, dynamic> json})
    : address = json['address']!,
      addressSecondary = json['address_secondary'],
      city = json['city']!,
      state = json['state']!,
      zip = json['zip']!;

  factory Address.empty() => Address(
    address: "",
    city: "",
    state: "",
    zip: ""
  );

  @override
  List<Object> get props => [address, addressSecondary ?? "", city, state, zip];

  @override
  String toString() => 'Address { address: $address, addressSecondary: $addressSecondary, city: $city, state: $state, zip: $zip }';
}