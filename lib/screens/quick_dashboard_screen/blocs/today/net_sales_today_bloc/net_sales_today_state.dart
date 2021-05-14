part of 'net_sales_today_bloc.dart';

abstract class NetSalesTodayState extends Equatable {
  const NetSalesTodayState();
  
  @override
  List<Object> get props => [];
}

class NetSalesInitial extends NetSalesTodayState {}

class Loading extends NetSalesTodayState {}

class NetSalesLoaded extends NetSalesTodayState {
  final int netSales;

  const NetSalesLoaded({required this.netSales});

  @override
  List<Object> get props => [netSales];

  @override
  String toString() => 'NetSalesLoaded { netSales: $netSales }';
}

class FetchFailed extends NetSalesTodayState {
  final String error;

  const FetchFailed({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'FetchFailed { error: $error }';
}
