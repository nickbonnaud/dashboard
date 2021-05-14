part of 'total_taxes_bloc.dart';

abstract class TotalTaxesState extends Equatable {
  const TotalTaxesState();
  
  @override
  List<Object> get props => [];
}

class TotalTaxesInitial extends TotalTaxesState {}

class Loading extends TotalTaxesState {}

class TotalTaxesLoaded extends TotalTaxesState {
  final int totalTaxes;

  const TotalTaxesLoaded({required this.totalTaxes});

  @override
  List<Object> get props => [totalTaxes];

  @override
  String toString() => 'TotalTaxesLoaded { totalTaxes: $totalTaxes }';
}

class FetchFailed extends TotalTaxesState {
  final String error;

  const FetchFailed({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'FetchFailed { error: $error }';
}