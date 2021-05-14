part of 'transactions_list_bloc.dart';

abstract class TransactionsListEvent extends Equatable {
  const TransactionsListEvent();

  @override
  List<Object?> get props => [];
}

class Init extends TransactionsListEvent {}

class FetchAll extends TransactionsListEvent {}

class FetchMoreTransactions extends TransactionsListEvent {}

class FetchByStatus extends TransactionsListEvent {
  final int code;

  const FetchByStatus({required this.code});

  @override
  List<Object> get props => [code];

  @override
  String toString() => 'FetchByStatus { code: $code }';
}

class FetchByCustomerId extends TransactionsListEvent {
  final String customerId;

  const FetchByCustomerId({required this.customerId});

  @override
  List<Object> get props => [customerId];

  @override
  String toString() => 'FetchByCustomerId { customerId: $customerId }';
}

class FetchByTransactionId extends TransactionsListEvent {
  final String transactionId;

  const FetchByTransactionId({required this.transactionId});

  @override
  List<Object> get props => [transactionId];

  @override
  String toString() => 'FetchByTransactionId { transactionId: $transactionId }';
}

class FetchByCustomerName extends TransactionsListEvent {
  final String? firstName;
  final String? lastName;

  const FetchByCustomerName({@required this.firstName, @required this.lastName});

  @override
  List<Object?> get props => [firstName, lastName];

  @override
  String toString() => 'FetchByCustomerName { firstName: $firstName, lastName: $lastName }';
}

class FetchByEmployeeName extends TransactionsListEvent {
  final String? firstName;
  final String? lastName;

  const FetchByEmployeeName({@required this.firstName, @required this.lastName});

  @override
  List<Object?> get props => [firstName, lastName];

  @override
  String toString() => 'FetchByEmployeeName { firstName: $firstName, lastName: $lastName }';
}

class DateRangeChanged extends TransactionsListEvent {
  final DateTimeRange? dateRange;

  const DateRangeChanged({@required this.dateRange});

  @override
  List<Object?> get props => [dateRange];

  @override
  String toString() => 'DateRangeChanged { dateRange: $dateRange }';
}

class FilterChanged extends TransactionsListEvent {
  final FilterType filter;

  const FilterChanged({required this.filter});

  @override
  List<Object> get props => [filter];

  @override
  String toString() => 'FilterChanged { filter: $filter }';
}
