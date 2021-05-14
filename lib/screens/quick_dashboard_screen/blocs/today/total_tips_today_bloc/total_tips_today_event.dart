part of 'total_tips_today_bloc.dart';

abstract class TotalTipsTodayEvent extends Equatable {
  const TotalTipsTodayEvent();

  @override
  List<Object> get props => [];
}

class FetchTotalTipsToday extends TotalTipsTodayEvent {}