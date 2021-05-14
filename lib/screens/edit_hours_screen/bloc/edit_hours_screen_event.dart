part of 'edit_hours_screen_bloc.dart';

abstract class EditHoursScreenEvent extends Equatable {
  const EditHoursScreenEvent();

  @override
  List<Object> get props => [];
}

class HoursChanged extends EditHoursScreenEvent {
  final int day;
  final List<Hour> hours;

  const HoursChanged({required this.day, required this.hours});

  @override
  List<Object> get props => [day, hours];

  @override
  String toString() => 'HoursChanged { day: $day, hour: $hours }';
}

class Updated extends EditHoursScreenEvent {
  final String identifier;
  final String sunday;
  final String monday;
  final String tuesday;
  final String wednesday;
  final String thursday;
  final String friday;
  final String saturday;

  const Updated({
    required this.identifier,
    required this.sunday,
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday
  });

  @override
  List<Object> get props => [
    identifier,
    sunday,
    monday,
    tuesday,
    wednesday,
    thursday,
    friday,
    saturday
  ];

  @override
  String toString() => '''Updated {
    identifier: $identifier,
    sunday: $sunday,
    monday: $monday,
    tuesday: $tuesday,
    wednesday: $wednesday,
    thursday,: $thursday
    friday: $friday,
    saturday: $saturday
  }''';
}

class HourAdded extends EditHoursScreenEvent {
  final Hour hour;
  final int day;

  const HourAdded({required this.hour, required this.day});

  @override
  List<Object> get props => [hour, day];

  @override
  String toString() => 'HourAdded { hour: $hour, day: $day }';
}

class HourRemoved extends EditHoursScreenEvent {
  final int day;

  const HourRemoved({required this.day});

  @override
  List<Object> get props => [day];

  @override
  String toString() => 'HourRemoved { day: $day }';
}

class Reset extends EditHoursScreenEvent {}
