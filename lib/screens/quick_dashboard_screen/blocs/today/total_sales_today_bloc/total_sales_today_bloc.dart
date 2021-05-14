import 'dart:async';

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
      super(TotalSalesInitial());

  @override
  Stream<TotalSalesTodayState> mapEventToState(TotalSalesTodayEvent event) async* {
    if (event is FetchTotalSalesToday) {
      yield* _mapFetchTotalSalesToState();
    }
  }

  Stream<TotalSalesTodayState> _mapFetchTotalSalesToState() async* {
    yield Loading();
    try {
      final int totalSales = await _transactionRepository.fetchTotalSalesToday();
      yield TotalSalesLoaded(totalSales: totalSales);
    } on ApiException catch (exception) {
      yield FetchFailed(error: exception.error);
    }
  }
}
