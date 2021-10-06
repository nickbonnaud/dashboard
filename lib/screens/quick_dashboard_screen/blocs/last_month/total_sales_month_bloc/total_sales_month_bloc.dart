import 'package:bloc/bloc.dart';
import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:equatable/equatable.dart';

part 'total_sales_month_event.dart';
part 'total_sales_month_state.dart';

class TotalSalesMonthBloc extends Bloc<TotalSalesMonthEvent, TotalSalesMonthState> {
  final TransactionRepository _transactionRepository;
  
  TotalSalesMonthBloc({required TransactionRepository transactionRepository})
    : _transactionRepository = transactionRepository,
      super(TotalSalesInitial()) { _eventHandler(); }

  void _eventHandler() {
    on<FetchTotalSalesMonth>((event, emit) => _mapFetchTotalSalesToState(emit: emit));
  }

  void _mapFetchTotalSalesToState({required Emitter<TotalSalesMonthState> emit}) async {
    emit(Loading());
    try {
      final int totalSales = await _transactionRepository.fetchTotalSalesMonth();
      emit(TotalSalesLoaded(totalSales: totalSales));
    } on ApiException catch (exception) {
      emit(FetchTotalSalesFailed(error: exception.error));
    }
  }
}
