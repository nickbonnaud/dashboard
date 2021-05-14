part of 'total_sales_bloc.dart';

abstract class TotalSalesState extends Equatable {
  const TotalSalesState();
  
  @override
  List<Object> get props => [];
}

class TotalSalesInitial extends TotalSalesState {}

class Loading extends TotalSalesState {}

class TotalSalesLoaded extends TotalSalesState {
  final int totalSales;

  const TotalSalesLoaded({required this.totalSales});

  @override
  List<Object> get props => [totalSales];

  @override
  String toString() => 'TotalSalesLoaded { totalSales: $totalSales }';
}

class FetchFailed extends TotalSalesState {
  final String error;

  const FetchFailed({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'FetchFailed { error: $error }';
}