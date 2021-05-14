part of 'hours_screen_bloc.dart';

abstract class HoursScreenEvent extends Equatable {
  const HoursScreenEvent();

  @override
  List<Object> get props => [];
}

class EarliestOpeningChanged extends HoursScreenEvent {
  final TimeOfDay time;

  const EarliestOpeningChanged({required this.time});

  @override
  List<Object> get props => [time];

  @override
  String toString() => 'EarliestOpeningChanged { time: $time }';
}

class LatestClosingChanged extends HoursScreenEvent {
  final TimeOfDay time;

  const LatestClosingChanged({required this.time});

  @override
  List<Object> get props => [time];

  @override
  String toString() => 'LatestClosingChanged { time: $time }';
}

class Reset extends HoursScreenEvent {}