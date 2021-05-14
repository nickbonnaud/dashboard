part of 'net_sales_month_bloc.dart';

abstract class NetSalesMonthEvent extends Equatable {
  const NetSalesMonthEvent();

  @override
  List<Object> get props => [];
}

class FetchNetSalesMonth extends NetSalesMonthEvent {}
