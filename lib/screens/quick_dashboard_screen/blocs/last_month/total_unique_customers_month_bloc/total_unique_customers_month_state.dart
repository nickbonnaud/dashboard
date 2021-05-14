part of 'total_unique_customers_month_bloc.dart';

abstract class TotalUniqueCustomersMonthState extends Equatable {
  const TotalUniqueCustomersMonthState();
  
  @override
  List<Object> get props => [];
}

class TotalUniqueCustomersInitial extends TotalUniqueCustomersMonthState {}

class Loading extends TotalUniqueCustomersMonthState {}

class TotalUniqueCustomersLoaded extends TotalUniqueCustomersMonthState {
  final int totalUniqueCustomers;

  const TotalUniqueCustomersLoaded({required this.totalUniqueCustomers});

  @override
  List<Object> get props => [totalUniqueCustomers];

  @override
  String toString() => 'TotalUniqueCustomersLoaded { totalUniqueCustomers: $totalUniqueCustomers }';
}

class FetchTotalUniqueCustomersFailed extends TotalUniqueCustomersMonthState {
  final String error;

  const FetchTotalUniqueCustomersFailed({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'FetchTotalUniqueCustomersFailed { error: $error }';
}
