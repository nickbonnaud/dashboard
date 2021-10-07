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
      super(TotalTransactionsInitial()) { _eventHandler(); }

  void _eventHandler() {
    on<FetchTotalTransactionsMonth>((event, emit) async => await _mapFetchTotalTransactionsToState(emit: emit));
  }

  Future<void> _mapFetchTotalTransactionsToState({required Emitter<TotalTransactionsMonthState> emit}) async {
    emit(Loading());
    try {
      final int totalTransactions = await _transactionRepository.fetchTotalTransactionsMonth();
      emit(TotalTransactionsLoaded(totalTransactions: totalTransactions));
    } on ApiException catch (exception) {
      emit(FetchTotalTransactionsFailed(error: exception.error));
    }
  }
}
