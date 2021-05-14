part of 'recent_transactions_bloc.dart';

abstract class RecentTransactionsEvent extends Equatable {
  const RecentTransactionsEvent();

  @override
  List<Object> get props => [];
}

class InitRecentTransactions extends RecentTransactionsEvent {}
