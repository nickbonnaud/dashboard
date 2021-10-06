import 'package:bloc/bloc.dart';
import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:equatable/equatable.dart';

part 'net_sales_month_event.dart';
part 'net_sales_month_state.dart';

class NetSalesMonthBloc extends Bloc<NetSalesMonthEvent, NetSalesMonthState> {
  final TransactionRepository _transactionRepository;
 
  NetSalesMonthBloc({required TransactionRepository transactionRepository})
    : _transactionRepository = transactionRepository,
      super(NetSalesInitial()) { _eventHandler(); }

  void _eventHandler() {
    on<FetchNetSalesMonth>((event, emit) => _mapFetchNetSalesToState(emit: emit));
  }

  void _mapFetchNetSalesToState({required Emitter<NetSalesMonthState> emit}) async {
    emit(Loading());
    try {
      final int netSales = await _transactionRepository.fetchNetSalesMonth();
      emit(NetSalesLoaded(netSales: netSales));
    } on ApiException catch (exception) {
      emit(FetchNetSalesFailed(error: exception.error));
    }
  }
}
