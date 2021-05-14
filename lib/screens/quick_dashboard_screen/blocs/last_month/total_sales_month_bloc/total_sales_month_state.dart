part of 'total_sales_month_bloc.dart';

abstract class TotalSalesMonthState extends Equatable {
  const TotalSalesMonthState();
  
  @override
  List<Object> get props => [];
}

class TotalSalesInitial extends TotalSalesMonthState {}

class Loading extends TotalSalesMonthState {}

class TotalSalesLoaded extends TotalSalesMonthState {
  final int totalSales;

  const TotalSalesLoaded({required this.totalSales});

  @override
  List<Object> get props => [totalSales];

  @override
  String toString() => 'TotalSalesLoaded { totalSales: $totalSales }';
}

class FetchTotalSalesFailed extends TotalSalesMonthState {
  final String error;

  const FetchTotalSalesFailed({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'FetchTotalSalesFailed { error: $error }';
}