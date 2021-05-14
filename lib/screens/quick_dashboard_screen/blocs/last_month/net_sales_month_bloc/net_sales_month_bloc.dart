import 'dart:async';

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
      super(NetSalesInitial());

  @override
  Stream<NetSalesMonthState> mapEventToState(NetSalesMonthEvent event) async* {
    if (event is FetchNetSalesMonth) {
      yield* _mapFetchNetSalesToState();
    }
  }

  Stream<NetSalesMonthState> _mapFetchNetSalesToState() async* {
    yield Loading();
    try {
      final int netSales = await _transactionRepository.fetchNetSalesMonth();
      yield NetSalesLoaded(netSales: netSales);
    } on ApiException catch (exception) {
      yield FetchNetSalesFailed(error: exception.error);
    }
  }
}
