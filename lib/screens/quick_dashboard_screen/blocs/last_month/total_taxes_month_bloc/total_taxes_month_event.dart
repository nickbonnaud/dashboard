part of 'total_taxes_month_bloc.dart';

abstract class TotalTaxesMonthEvent extends Equatable {
  const TotalTaxesMonthEvent();

  @override
  List<Object> get props => [];
}

class FetchTotalTaxesMonth extends TotalTaxesMonthEvent {}