part of 'total_sales_month_bloc.dart';

abstract class TotalSalesMonthEvent extends Equatable {
  const TotalSalesMonthEvent();

  @override
  List<Object> get props => [];
}

class FetchTotalSalesMonth extends TotalSalesMonthEvent {}
