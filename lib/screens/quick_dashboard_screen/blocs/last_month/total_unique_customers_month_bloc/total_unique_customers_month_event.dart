part of 'total_unique_customers_month_bloc.dart';

abstract class TotalUniqueCustomersMonthEvent extends Equatable {
  const TotalUniqueCustomersMonthEvent();

  @override
  List<Object> get props => [];
}

class FetchTotalUniqueCustomersMonth extends TotalUniqueCustomersMonthEvent {}