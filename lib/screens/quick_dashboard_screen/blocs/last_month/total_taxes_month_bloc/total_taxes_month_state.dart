part of 'total_taxes_month_bloc.dart';

abstract class TotalTaxesMonthState extends Equatable {
  const TotalTaxesMonthState();
  
  @override
  List<Object> get props => [];
}

class TotalTaxesInitial extends TotalTaxesMonthState {}

class Loading extends TotalTaxesMonthState {}

class TotalTaxesLoaded extends TotalTaxesMonthState {
  final int totalTaxes;

  const TotalTaxesLoaded({required this.totalTaxes});

  @override
  List<Object> get props => [totalTaxes];

  @override
  String toString() => 'TotalTaxesLoaded { totalTaxes: $totalTaxes }';
}

class FetchTotalTaxesFailed extends TotalTaxesMonthState {
  final String error;

  const FetchTotalTaxesFailed({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'FetchTotalTaxesFailed { error: $error }';
}
