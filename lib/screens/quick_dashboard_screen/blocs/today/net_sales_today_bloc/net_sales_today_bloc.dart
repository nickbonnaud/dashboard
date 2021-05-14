import 'dart:async';

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
      super(NetSalesInitial());

  @override
  Stream<NetSalesTodayState> mapEventToState(NetSalesTodayEvent event) async* {
    if (event is FetchNetSalesToday) {
      yield* _mapFetchNetSalesToState();
    }
  }

  Stream<NetSalesTodayState> _mapFetchNetSalesToState() async* {
    yield Loading();
    try {
      final int netSales = await _transactionRepository.fetchNetSalesToday();
      yield NetSalesLoaded(netSales: netSales);
    } on ApiException catch (exception) {
      yield FetchFailed(error: exception.error);
    }
  }
}
