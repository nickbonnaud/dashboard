part of 'employee_tips_list_bloc.dart';

abstract class EmployeeTipsListEvent extends Equatable {
  const EmployeeTipsListEvent();

  @override
  List<Object?> get props => [];
}

class InitTipList extends EmployeeTipsListEvent {}

class FetchAll extends EmployeeTipsListEvent {}

class FetchMore extends EmployeeTipsListEvent {}

class DateRangeChanged extends EmployeeTipsListEvent {
  final DateTimeRange? dateRange;

  const DateRangeChanged({@required this.dateRange});

  @override
  List<Object?> get props => [dateRange];

  @override
  String toString() => 'DateRangeChanged { dateRange: $dateRange }';
}
