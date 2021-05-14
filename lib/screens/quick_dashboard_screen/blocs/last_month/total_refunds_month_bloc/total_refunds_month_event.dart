part of 'total_refunds_month_bloc.dart';

abstract class TotalRefundsMonthEvent extends Equatable {
  const TotalRefundsMonthEvent();

  @override
  List<Object> get props => [];
}

class FetchTotalRefundsMonth extends TotalRefundsMonthEvent {}
