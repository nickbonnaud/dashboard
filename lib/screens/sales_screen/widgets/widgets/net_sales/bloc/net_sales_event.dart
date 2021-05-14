part of 'net_sales_bloc.dart';

abstract class NetSalesEvent extends Equatable {
  const NetSalesEvent();

  @override
  List<Object?> get props => [];
}

class InitNetSales extends NetSalesEvent {}

class DateRangeChanged extends NetSalesEvent {
  final DateTimeRange? dateRange;

  const DateRangeChanged({@required this.dateRange});

  @override
  List<Object?> get props => [dateRange];

  @override
  String toString() => 'DateRangeChanged { dateRange: $dateRange }';
}
