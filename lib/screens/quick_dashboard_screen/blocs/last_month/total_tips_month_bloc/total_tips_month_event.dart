part of 'total_tips_month_bloc.dart';

abstract class TotalTipsMonthEvent extends Equatable {
  const TotalTipsMonthEvent();

  @override
  List<Object> get props => [];
}

class FetchTotalTipsMonth extends TotalTipsMonthEvent {}
