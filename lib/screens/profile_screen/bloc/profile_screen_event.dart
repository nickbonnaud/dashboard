part of 'profile_screen_bloc.dart';

abstract class ProfileScreenEvent extends Equatable {
  const ProfileScreenEvent();

  @override
  List<Object> get props => [];
}

class PlaceQueryChanged extends ProfileScreenEvent {
  final String query;

  const PlaceQueryChanged({required this.query});

  @override
  List<Object> get props => [query];

  @override
  String toString() => 'PlaceQueryChanged { query: $query }';
}

class PredictionSelected extends ProfileScreenEvent {
  final Prediction prediction;

  const PredictionSelected({required this.prediction});

  @override
  List<Object> get props => [prediction];

  @override
  String toString() => 'PredictionSelected { prediction: $prediction }';
}

class NameChanged extends ProfileScreenEvent {
  final String name;

  const NameChanged({required this.name});

  @override
  List<Object> get props => [name];

  @override
  String toString() => 'NameChanged { name: $name }';
}

class WebsiteChanged extends ProfileScreenEvent {
  final String website;

  const WebsiteChanged({required this.website});

  @override
  List<Object> get props => [website];

  @override
  String toString() => 'WebsiteChanged { website: $website }'; 
}

class DescriptionChanged extends ProfileScreenEvent {
  final String description;
  
  const DescriptionChanged({required this.description});

  @override
  List<Object> get props => [description];

  @override
  String toString() => 'DescriptionChanged { description: $description }';
}

class PhoneChanged extends ProfileScreenEvent {
  final String phone;

  const PhoneChanged({required this.phone});

  @override
  List<Object> get props => [phone];

  @override
  String toString() => 'PhoneChanged { phone: $phone }';
}

class Submitted extends ProfileScreenEvent {
  final String name;
  final String website;
  final String description;
  final String phone;

  const Submitted({
    required this.name,
    required this.website,
    required this.description,
    required this.phone
  });

  @override
  List<Object> get props => [
    name,
    website,
    description,
    phone
  ];

  @override
  String toString() => '''Submitted {
    name: $name,
    website: $website,
    description: $description,
    phone: $phone
  }''';
}

class Updated extends ProfileScreenEvent {
  final String name;
  final String website;
  final String description;
  final String phone;
  final String id;

  const Updated({
    required this.name,
    required this.website,
    required this.description,
    required this.phone,
    required this.id
  });

  @override
  List<Object> get props => [
    name,
    website,
    description,
    phone,
    id
  ];

  @override
  String toString() => '''Updated {
    name: $name,
    website: $website,
    description: $description,
    phone: $phone,
    id: $id
  }''';
}

class Reset extends ProfileScreenEvent {}
