import 'dart:async';

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
      super(TotalSalesInitial());

  @override
  Stream<TotalSalesMonthState> mapEventToState(TotalSalesMonthEvent event) async* {
    if (event is FetchTotalSalesMonth) {
      yield* _mapFetchTotalSalesToState();
    }
  }

  Stream<TotalSalesMonthState> _mapFetchTotalSalesToState() async* {
    yield Loading();
    try {
      final int totalSales = await _transactionRepository.fetchTotalSalesMonth();
      yield TotalSalesLoaded(totalSales: totalSales);
    } on ApiException catch (exception) {
      yield FetchTotalSalesFailed(error: exception.error);
    }
  }
}
