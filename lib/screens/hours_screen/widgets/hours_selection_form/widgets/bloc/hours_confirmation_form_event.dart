part of 'hours_confirmation_form_bloc.dart';

abstract class HoursConfirmationFormEvent extends Equatable {
  const HoursConfirmationFormEvent();

  @override
  List<Object> get props => [];
}

class HoursChanged extends HoursConfirmationFormEvent {
  final int day;
  final List<Hour> hours;

  const HoursChanged({required this.day, required this.hours});

  @override
  List<Object> get props => [day, hours];

  @override
  String toString() => 'HoursChanged { day: $day, hour: $hours }';
}

class Submitted extends HoursConfirmationFormEvent {
  final String sunday;
  final String monday;
  final String tuesday;
  final String wednesday;
  final String thursday;
  final String friday;
  final String saturday;

  const Submitted({
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
    sunday,
    monday,
    tuesday,
    wednesday,
    thursday,
    friday,
    saturday
  ];

  @override
  String toString() => '''Submitted {
    sunday: $sunday,
    monday: $monday,
    tuesday: $tuesday,
    wednesday: $wednesday,
    thursday,: $thursday
    friday: $friday,
    saturday: $saturday
  }''';
}

class Reset extends HoursConfirmationFormEvent {}