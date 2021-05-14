part of 'total_taxes_bloc.dart';

abstract class TotalTaxesEvent extends Equatable {
  const TotalTaxesEvent();

  @override
  List<Object?> get props => [];
}

class InitTotalTaxes extends TotalTaxesEvent {}

class DateRangeChanged extends TotalTaxesEvent {
  final DateTimeRange? dateRange;

  const DateRangeChanged({@required this.dateRange});

  @override
  List<Object?> get props => [dateRange];

  @override
  String toString() => 'DateRangeChanged { dateRange: $dateRange }';
}