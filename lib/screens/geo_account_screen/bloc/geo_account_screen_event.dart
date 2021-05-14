part of 'geo_account_screen_bloc.dart';

abstract class GeoAccountScreenEvent extends Equatable {
  const GeoAccountScreenEvent();

  @override
  List<Object> get props => [];
}

class LocationChanged extends GeoAccountScreenEvent {
  final LatLng location;

  const LocationChanged({required this.location});

  @override
  List<Object> get props => [location];

  @override
  String toString() => 'LocationChanged { location: $location }';
}

class RadiusChanged extends GeoAccountScreenEvent {
  final double radius;

  const RadiusChanged({required this.radius});

  @override
  List<Object> get props => [radius];

  @override
  String toString() => 'RadiusChanged { radius: $radius }';
}

class Submitted extends GeoAccountScreenEvent {}

class Updated extends GeoAccountScreenEvent {
  final String identifier;

  const Updated({required this.identifier});

  @override
  List<Object> get props => [identifier];

  @override
  String toString() => 'Updated { identifier: $identifier }';
}

class Reset extends GeoAccountScreenEvent {}
