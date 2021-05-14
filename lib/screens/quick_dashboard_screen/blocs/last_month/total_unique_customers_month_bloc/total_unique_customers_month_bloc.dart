import 'dart:async';

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
      super(TotalUniqueCustomersInitial());

  @override
  Stream<TotalUniqueCustomersMonthState> mapEventToState(TotalUniqueCustomersMonthEvent event) async* {
    if (event is FetchTotalUniqueCustomersMonth) {
      yield* _mapFetchTotalUniqueCustomersToState();
    }
  }

  Stream<TotalUniqueCustomersMonthState> _mapFetchTotalUniqueCustomersToState() async* {
    yield Loading();
    try {
      final int totalUniqueCustomers = await _transactionRepository.fetchTotalUniqueCustomersMonth();
      yield TotalUniqueCustomersLoaded(totalUniqueCustomers: totalUniqueCustomers);
    } on ApiException catch (exception) {
      yield FetchTotalUniqueCustomersFailed(error: exception.error);
    }
  }
}
