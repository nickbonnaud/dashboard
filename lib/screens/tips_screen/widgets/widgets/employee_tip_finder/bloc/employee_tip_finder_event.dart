part of 'employee_tip_finder_bloc.dart';

abstract class EmployeeTipFinderEvent extends Equatable {
  const EmployeeTipFinderEvent();

  @override
  List<Object?> get props => [];
}

class Fetch extends EmployeeTipFinderEvent {
  final String? firstName;
  final String ?lastName;

  const Fetch({required this.firstName, required this.lastName});

  @override
  List<Object?> get props => [firstName, lastName];

  @override
  String toString() => 'Fetch { firstName: $firstName, lastName: $lastName }';
}

class DateRangeChanged extends EmployeeTipFinderEvent {
  final DateTimeRange? dateRange;

  const DateRangeChanged({required this.dateRange});

  @override
  List<Object?> get props => [dateRange];

  @override
  String toString() => 'DateRangeChanged { dateRange: $dateRange }';
}
