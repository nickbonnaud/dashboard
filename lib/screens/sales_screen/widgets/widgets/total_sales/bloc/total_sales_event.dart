part of 'total_sales_bloc.dart';

abstract class TotalSalesEvent extends Equatable {
  const TotalSalesEvent();

  @override
  List<Object?> get props => [];
}

class InitTotalSales extends TotalSalesEvent {}

class DateRangeChanged extends TotalSalesEvent {
  final DateTimeRange? dateRange;

  const DateRangeChanged({@required this.dateRange});

  @override
  List<Object?> get props => [dateRange];

  @override
  String toString() => 'DateRangeChanged { dateRange: $dateRange }';
}