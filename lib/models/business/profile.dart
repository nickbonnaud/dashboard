import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'hours.dart';

@immutable
class Profile extends Equatable {
  final String identifier;
  final String name;
  final String website;
  final String description;
  final String phone;
  final String? googlePlaceId;
  final Hours hours;

  const Profile({
    required this.identifier,
    required this.name,
    required this.website,
    required this.description,
    required this.phone,
    required this.hours,
    this.googlePlaceId
  });

   Profile.fromJson({required Map<String, dynamic> json}) 
    : identifier = json['identifier']!,
      name = json['name']!,
      website = json['website']!,
      description = json['description']!,
      phone = json['phone']!,
      googlePlaceId = json['google_place_id'],
      hours = 
        json['hours'] != null 
          ? Hours.fromJson(json: json['hours']) 
          : Hours.empty();

  factory Profile.empty() {
    return Profile(
      identifier: "", 
      name: "", 
      website: "", 
      description: "", 
      phone: "phone", 
      googlePlaceId: "googlePlaceId", 
      hours: Hours.empty()
    );
  }

  Profile update({
    String? identifier,
    String? name,
    String? website,
    String? description,
    String? phone,
    String? googlePlaceId,
    Hours? hours
  }) {
    return Profile(
      identifier: identifier ?? this.identifier,
      name: name ?? this.name,
      website: website ?? this.website,
      description: description ?? this.description,
      phone: phone ?? this.phone,
      googlePlaceId: googlePlaceId ?? this.googlePlaceId,
      hours: hours ?? this.hours
    );
  }

  @override
  List<Object?> get props => [identifier, name, website, description, phone, googlePlaceId, hours];

  @override
  String toString() => '''Profile {
    identifier: $identifier,
    name: $name,
    website: $website,
    description: $description,
    phone: $phone,
    googlePlaceId: $googlePlaceId,
    hours: $hours
  }''';
}