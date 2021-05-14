part of 'total_tips_bloc.dart';

abstract class TotalTipsState extends Equatable {
  const TotalTipsState();
  
  @override
  List<Object> get props => [];
}

class TotalTipsInitial extends TotalTipsState {}

class Loading extends TotalTipsState {}

class TotalTipsLoaded extends TotalTipsState {
  final int totalTips;

  const TotalTipsLoaded({required this.totalTips});

  @override
  List<Object> get props => [totalTips];

  @override
  String toString() => 'TotalTipsLoaded { totalTips: $totalTips }';
}

class FetchFailed extends TotalTipsState {
  final String error;

  const FetchFailed({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'FetchFailed { error: $error }';
}