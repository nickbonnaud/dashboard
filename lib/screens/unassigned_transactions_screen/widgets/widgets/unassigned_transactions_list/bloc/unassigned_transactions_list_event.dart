part of 'unassigned_transactions_list_bloc.dart';

abstract class UnassignedTransactionsListEvent extends Equatable {
  const UnassignedTransactionsListEvent();

  @override
  List<Object?> get props => [];
}

class Init extends UnassignedTransactionsListEvent {}

class FetchAll extends UnassignedTransactionsListEvent {}

class FetchMore extends UnassignedTransactionsListEvent {}

class DateRangeChanged extends UnassignedTransactionsListEvent {
  final DateTimeRange? dateRange;

  const DateRangeChanged({@required this.dateRange});

  @override
  List<Object?> get props => [dateRange];

  @override
  String toString() => 'DateRangeChanged { dateRange: $dateRange }';
}
