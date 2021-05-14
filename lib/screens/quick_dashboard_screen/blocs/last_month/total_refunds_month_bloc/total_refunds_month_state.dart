part of 'total_refunds_month_bloc.dart';

abstract class TotalRefundsMonthState extends Equatable {
  const TotalRefundsMonthState();
  
  @override
  List<Object> get props => [];
}

class TotalRefundsInitial extends TotalRefundsMonthState {}

class Loading extends TotalRefundsMonthState {}

class TotalRefundsLoaded extends TotalRefundsMonthState {
  final int totalRefunds;

  const TotalRefundsLoaded({required this.totalRefunds});

  @override
  List<Object> get props => [totalRefunds];

  @override
  String toString() => 'TotalRefundsLoaded { totalRefunds: $totalRefunds }';
}

class FetchTotalRefundsFailed extends TotalRefundsMonthState {
  final String error;

  const FetchTotalRefundsFailed({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'FetchTotalRefundsFailed { error: $error }';
}
