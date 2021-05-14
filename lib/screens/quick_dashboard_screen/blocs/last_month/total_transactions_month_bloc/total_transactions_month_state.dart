part of 'total_transactions_month_bloc.dart';

abstract class TotalTransactionsMonthState extends Equatable {
  const TotalTransactionsMonthState();
  
  @override
  List<Object> get props => [];
}

class TotalTransactionsInitial extends TotalTransactionsMonthState {}

class Loading extends TotalTransactionsMonthState {}

class TotalTransactionsLoaded extends TotalTransactionsMonthState {
  final int totalTransactions;

  const TotalTransactionsLoaded({required this.totalTransactions});

  @override
  List<Object> get props => [totalTransactions];

  @override
  String toString() => 'TotalTransactionsLoaded { totalTransactions: $totalTransactions }';
}

class FetchTotalTransactionsFailed extends TotalTransactionsMonthState {
  final String error;

  const FetchTotalTransactionsFailed({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'FetchTotalTransactionsFailed { error: $error }';
}
