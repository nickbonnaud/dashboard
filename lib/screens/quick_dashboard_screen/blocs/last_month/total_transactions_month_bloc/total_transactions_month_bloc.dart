import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:equatable/equatable.dart';

part 'total_transactions_month_event.dart';
part 'total_transactions_month_state.dart';

class TotalTransactionsMonthBloc extends Bloc<TotalTransactionsMonthEvent, TotalTransactionsMonthState> {
  final TransactionRepository _transactionRepository;
  
  TotalTransactionsMonthBloc({required TransactionRepository transactionRepository})
    : _transactionRepository = transactionRepository,
      super(TotalTransactionsInitial());

  @override
  Stream<TotalTransactionsMonthState> mapEventToState(TotalTransactionsMonthEvent event) async* {
    if (event is FetchTotalTransactionsMonth) {
      yield* _mapFetchTotalTransactionsToState();
    }
  }

  Stream<TotalTransactionsMonthState> _mapFetchTotalTransactionsToState() async* {
    yield Loading();
    try {
      final int totalTransactions = await _transactionRepository.fetchTotalTransactionsMonth();
      yield TotalTransactionsLoaded(totalTransactions: totalTransactions);
    } on ApiException catch (exception) {
      yield FetchTotalTransactionsFailed(error: exception.error);
    }
  }
}
