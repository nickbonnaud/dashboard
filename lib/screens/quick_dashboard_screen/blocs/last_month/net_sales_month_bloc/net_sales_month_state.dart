part of 'net_sales_month_bloc.dart';

abstract class NetSalesMonthState extends Equatable {
  const NetSalesMonthState();
  
  @override
  List<Object> get props => [];
}

class NetSalesInitial extends NetSalesMonthState {}

class Loading extends NetSalesMonthState {}

class NetSalesLoaded extends NetSalesMonthState {
  final int netSales;

  const NetSalesLoaded({required this.netSales});

  @override
  List<Object> get props => [netSales];

  @override
  String toString() => 'NetSalesLoaded { netSales: $netSales }';
}

class FetchNetSalesFailed extends NetSalesMonthState {
  final String error;

  const FetchNetSalesFailed({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'FetchNetSalesFailed { error: $error }';
}
