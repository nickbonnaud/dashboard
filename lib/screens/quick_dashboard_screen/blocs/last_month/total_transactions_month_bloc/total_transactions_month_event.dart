part of 'total_transactions_month_bloc.dart';

abstract class TotalTransactionsMonthEvent extends Equatable {
  const TotalTransactionsMonthEvent();

  @override
  List<Object> get props => [];
}

class FetchTotalTransactionsMonth extends TotalTransactionsMonthEvent {}