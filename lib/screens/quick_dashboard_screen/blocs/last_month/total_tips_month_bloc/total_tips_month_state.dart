part of 'total_tips_month_bloc.dart';

abstract class TotalTipsMonthState extends Equatable {
  const TotalTipsMonthState();
  
  @override
  List<Object> get props => [];
}

class TotalTipsInitial extends TotalTipsMonthState {}

class Loading extends TotalTipsMonthState {}

class TotalTipsLoaded extends TotalTipsMonthState {
  final int totalTips;

  const TotalTipsLoaded({required this.totalTips});

  @override
  List<Object> get props => [totalTips];

  @override
  String toString() => 'TotalTipsLoaded { totalTips: $totalTips }';
}

class FetchTotalTipsFailed extends TotalTipsMonthState {
  final String error;

  const FetchTotalTipsFailed({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'FetchTotalTipsFailed { error: $error }';
}

