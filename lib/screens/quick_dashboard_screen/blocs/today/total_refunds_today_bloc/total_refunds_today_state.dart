part of 'total_refunds_today_bloc.dart';

abstract class TotalRefundsTodayState extends Equatable {
  const TotalRefundsTodayState();
  
  @override
  List<Object> get props => [];
}

class TotalRefundsInitial extends TotalRefundsTodayState {}

class Loading extends TotalRefundsTodayState {}

class TotalRefundsLoaded extends TotalRefundsTodayState {
  final int totalRefunds;

  const TotalRefundsLoaded({required this.totalRefunds});

  @override
  List<Object> get props => [totalRefunds];

  @override
  String toString() => 'TotalRefundsLoaded { totalRefunds: $totalRefunds }';
}

class FetchFailed extends TotalRefundsTodayState {
  final String error;

  const FetchFailed({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'FetchFailed { error: $error }';
}
