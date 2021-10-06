import 'package:bloc/bloc.dart';
import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:equatable/equatable.dart';

part 'net_sales_today_event.dart';
part 'net_sales_today_state.dart';

class NetSalesTodayBloc extends Bloc<NetSalesTodayEvent, NetSalesTodayState> {
  final TransactionRepository _transactionRepository;
 
  NetSalesTodayBloc({required TransactionRepository transactionRepository})
    : _transactionRepository = transactionRepository,
      super(NetSalesInitial()) { _eventHandler(); }

  void _eventHandler() {
    on<FetchNetSalesToday>((event, emit) => _mapFetchNetSalesToState(emit: emit));
  }

  void _mapFetchNetSalesToState({required Emitter<NetSalesTodayState> emit}) async {
    emit(Loading());
    try {
      final int netSales = await _transactionRepository.fetchNetSalesToday();
      emit(NetSalesLoaded(netSales: netSales));
    } on ApiException catch (exception) {
      emit(FetchFailed(error: exception.error));
    }
  }
}
