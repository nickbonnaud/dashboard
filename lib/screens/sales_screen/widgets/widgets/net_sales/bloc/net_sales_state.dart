part of 'net_sales_bloc.dart';

abstract class NetSalesState extends Equatable {
  const NetSalesState();
  
  @override
  List<Object> get props => [];
}

class NetSalesInitial extends NetSalesState {}

class Loading extends NetSalesState {}

class NetSalesLoaded extends NetSalesState {
  final int netSales;

  const NetSalesLoaded({required this.netSales});

  @override
  List<Object> get props => [netSales];

  @override
  String toString() => 'NetSalesLoaded { netSales: $netSales }';
}

class FetchFailed extends NetSalesState {
  final String error;

  const FetchFailed({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'FetchFailed { error: $error }';
}
