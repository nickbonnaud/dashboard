import 'package:bloc/bloc.dart';
import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/models/transaction/transaction_resource.dart';
import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'recent_transactions_event.dart';
part 'recent_transactions_state.dart';

class RecentTransactionsBloc extends Bloc<RecentTransactionsEvent, RecentTransactionsState> {
  final TransactionRepository _transactionRepository;
  
  RecentTransactionsBloc({required TransactionRepository transactionRepository})
    : _transactionRepository = transactionRepository,
      super(RecentTransactionsState.initial()) { _eventHandler(); }

  void _eventHandler() {
    on<InitRecentTransactions>((event, emit) async => await _mapInitRecentTransactionsToState(emit: emit));
  }

  Future<void> _mapInitRecentTransactionsToState({required Emitter<RecentTransactionsState> emit}) async {
    emit(state.update(loading: true));

    try {
      final PaginateDataHolder paginateData =  await _transactionRepository.fetchAll();
      final List<TransactionResource> transactions = (paginateData.data as List<TransactionResource>).take(5).toList();
      emit(state.update(loading: false, transactions: transactions));
    } on ApiException catch (exception) {
      emit(state.update(loading: false, errorMessage: exception.error));
    }
  }
}
