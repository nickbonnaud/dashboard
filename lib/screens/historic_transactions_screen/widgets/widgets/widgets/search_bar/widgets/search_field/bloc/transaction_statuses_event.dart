part of 'transaction_statuses_bloc.dart';

abstract class TransactionStatusesEvent extends Equatable {
  const TransactionStatusesEvent();

  @override
  List<Object> get props => [];
}

class InitStatuses extends TransactionStatusesEvent {}
