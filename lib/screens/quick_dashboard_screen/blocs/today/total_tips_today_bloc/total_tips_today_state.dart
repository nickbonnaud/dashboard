part of 'total_tips_today_bloc.dart';

abstract class TotalTipsTodayState extends Equatable {
  const TotalTipsTodayState();
  
  @override
  List<Object> get props => [];
}

class TotalTipsInitial extends TotalTipsTodayState {}

class Loading extends TotalTipsTodayState {}

class TotalTipsLoaded extends TotalTipsTodayState {
  final int totalTips;

  const TotalTipsLoaded({required this.totalTips});

  @override
  List<Object> get props => [totalTips];

  @override
  String toString() => 'TotalTipsLoaded { totalTips: $totalTips }';
}

class FetchFailed extends TotalTipsTodayState {
  final String error;

  const FetchFailed({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'FetchFailed { error: $error }';
}


