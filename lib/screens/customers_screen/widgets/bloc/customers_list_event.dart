part of 'customers_list_bloc.dart';

abstract class CustomersListEvent extends Equatable {
  const CustomersListEvent();

  @override
  List<Object?> get props => [];
}

class Init extends CustomersListEvent {}

class FetchAll extends CustomersListEvent {}

class FetchMore extends CustomersListEvent {}

class DateRangeChanged extends CustomersListEvent {
  final DateTimeRange? dateRange;

  const DateRangeChanged({@required this.dateRange});

  @override
  List<Object?> get props => [dateRange];

  @override
  String toString() => 'DateRangeChanged { dateRange: $dateRange }';
}

class FilterButtonChanged extends CustomersListEvent {}