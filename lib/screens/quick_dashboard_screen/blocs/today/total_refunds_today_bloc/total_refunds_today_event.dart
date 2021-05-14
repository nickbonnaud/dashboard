part of 'total_refunds_today_bloc.dart';

abstract class TotalRefundsTodayEvent extends Equatable {
  const TotalRefundsTodayEvent();

  @override
  List<Object> get props => [];
}

class FetchTotalRefundsToday extends TotalRefundsTodayEvent {}
