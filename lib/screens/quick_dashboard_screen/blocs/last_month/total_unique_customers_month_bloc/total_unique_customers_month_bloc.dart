import 'package:bloc/bloc.dart';
import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:equatable/equatable.dart';

part 'total_unique_customers_month_event.dart';
part 'total_unique_customers_month_state.dart';

class TotalUniqueCustomersMonthBloc extends Bloc<TotalUniqueCustomersMonthEvent, TotalUniqueCustomersMonthState> {
  final TransactionRepository _transactionRepository;
  
  TotalUniqueCustomersMonthBloc({required TransactionRepository transactionRepository})
    : _transactionRepository = transactionRepository,
      super(TotalUniqueCustomersInitial()) { _eventHandler(); }

  void _eventHandler() {
    on<FetchTotalUniqueCustomersMonth>((event, emit) => _mapFetchTotalUniqueCustomersToState(emit: emit));
  }

  void _mapFetchTotalUniqueCustomersToState({required Emitter<TotalUniqueCustomersMonthState> emit}) async {
    emit(Loading());
    try {
      final int totalUniqueCustomers = await _transactionRepository.fetchTotalUniqueCustomersMonth();
      emit(TotalUniqueCustomersLoaded(totalUniqueCustomers: totalUniqueCustomers));
    } on ApiException catch (exception) {
      emit(FetchTotalUniqueCustomersFailed(error: exception.error));
    }
  }
}
