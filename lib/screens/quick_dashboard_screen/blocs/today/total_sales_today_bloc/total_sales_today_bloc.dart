import 'package:bloc/bloc.dart';
import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:equatable/equatable.dart';

part 'total_sales_today_event.dart';
part 'total_sales_today_state.dart';

class TotalSalesTodayBloc extends Bloc<TotalSalesTodayEvent, TotalSalesTodayState> {
  final TransactionRepository _transactionRepository;
  
  TotalSalesTodayBloc({required TransactionRepository transactionRepository})
    : _transactionRepository = transactionRepository,
      super(TotalSalesInitial()) { _eventHandler(); }

  void _eventHandler() {
    on<FetchTotalSalesToday>((event, emit) async => await _mapFetchTotalSalesToState(emit: emit));
  }

  Future<void> _mapFetchTotalSalesToState({required Emitter<TotalSalesTodayState> emit}) async {
    emit(Loading());
    try {
      final int totalSales = await _transactionRepository.fetchTotalSalesToday();
      emit(TotalSalesLoaded(totalSales: totalSales));
    } on ApiException catch (exception) {
      emit(FetchFailed(error: exception.error));
    }
  }
}
