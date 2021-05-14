import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Location extends Equatable {
  final String identifier;
  final double lat;
  final double lng;
  final int radius;

  Location({required this.identifier, required this.lat, required this.lng, required this.radius});

  Location.fromJson({required Map<String, dynamic> json})
    : identifier = json['identifier']!,
      lat = json['lat']!,
      lng = json['lng']!,
      radius = json['radius']!;

  factory Location.empty() => Location(
    identifier: "",
    lat: 0.0,
    lng: 0.0,
    radius: 50
  );

  // Location update({
  //   String? identifier,
  //   double? lat,
  //   double? lng,
  //   int? radius,
  // }) {
  //   return Location(
  //     identifier: identifier ?? this.identifier, 
  //     lat: lat ?? this.lat, 
  //     lng: lng ?? this.lng, 
  //     radius: radius ?? this.radius
  //   );
  // }

  @override
  List<Object> get props => [
    identifier,
    lat,
    lng,
    radius
  ];

  @override
  String toString() => '''Location {
    identifier: $identifier,
    lat: $lat,
    lng: $lng,
    radius: $radius
  }''';
}