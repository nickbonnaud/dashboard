part of 'total_sales_today_bloc.dart';

abstract class TotalSalesTodayState extends Equatable {
  const TotalSalesTodayState();
  
  @override
  List<Object> get props => [];
}

class TotalSalesInitial extends TotalSalesTodayState {}

class Loading extends TotalSalesTodayState {}

class TotalSalesLoaded extends TotalSalesTodayState {
  final int totalSales;

  const TotalSalesLoaded({required this.totalSales});

  @override
  List<Object> get props => [totalSales];

  @override
  String toString() => 'TotalSalesLoaded { totalSales: $totalSales }';
}

class FetchFailed extends TotalSalesTodayState {
  final String error;

  const FetchFailed({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'FetchFailed { error: $error }';
}
