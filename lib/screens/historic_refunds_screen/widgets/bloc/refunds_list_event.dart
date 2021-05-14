part of 'refunds_list_bloc.dart';

abstract class RefundsListEvent extends Equatable {
  const RefundsListEvent();

  @override
  List<Object?> get props => [];
}

class Init extends RefundsListEvent {}

class FetchAll extends RefundsListEvent {}

class FetchMore extends RefundsListEvent {}

class FetchByRefundId extends RefundsListEvent {
  final String refundId;

  const FetchByRefundId({required this.refundId});

  @override
  List<Object> get props => [refundId];

  @override
  String toString() => 'FetchByRefundId { refundId: $refundId }';
}

class FetchByTransactionId extends RefundsListEvent {
  final String transactionId;

  const FetchByTransactionId({required this.transactionId});

  @override
  List<Object> get props => [transactionId];

  @override
  String toString() => 'FetchByTransactionId { transactionId: $transactionId }';
}

class FetchByCustomerId extends RefundsListEvent {
  final String customerId;

  const FetchByCustomerId({required this.customerId});

  @override
  List<Object> get props => [customerId];

  @override
  String toString() => 'FetchByCustomerId { customerId: $customerId }';
}

class FetchByCustomerName extends RefundsListEvent {
  final String? firstName;
  final String? lastName;

  const FetchByCustomerName({@required this.firstName, @required this.lastName});

  @override
  List<Object?> get props => [firstName, lastName];

  @override
  String toString() => 'FetchByCustomerName { firstName: $firstName, lastName: $lastName }';
}

class DateRangeChanged extends RefundsListEvent {
  final DateTimeRange? dateRange;

  const DateRangeChanged({@required this.dateRange});

  @override
  List<Object?> get props => [dateRange];

  @override
  String toString() => 'DateRangeChanged { dateRange: $dateRange }';
}

class FilterChanged extends RefundsListEvent {
  final FilterType filter;

  const FilterChanged({required this.filter});

  @override
  List<Object> get props => [filter];

  @override
  String toString() => 'FilterChanged { filter: $filter }';
}
