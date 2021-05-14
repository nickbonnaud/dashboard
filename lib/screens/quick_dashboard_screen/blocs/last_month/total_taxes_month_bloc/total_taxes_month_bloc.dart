import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:equatable/equatable.dart';

part 'total_taxes_month_event.dart';
part 'total_taxes_month_state.dart';

class TotalTaxesMonthBloc extends Bloc<TotalTaxesMonthEvent, TotalTaxesMonthState> {
  final TransactionRepository _transactionRepository;
  
  TotalTaxesMonthBloc({required TransactionRepository transactionRepository})
    : _transactionRepository = transactionRepository,
      super(TotalTaxesInitial());

  @override
  Stream<TotalTaxesMonthState> mapEventToState(TotalTaxesMonthEvent event) async* {
    if (event is FetchTotalTaxesMonth) {
      yield* _mapFetchTotalTaxesToState();
    }
  }

  Stream<TotalTaxesMonthState> _mapFetchTotalTaxesToState() async* {
    yield Loading();
    try {
      final int totalTaxes = await _transactionRepository.fetchTotalTaxesMonth();
      yield TotalTaxesLoaded(totalTaxes: totalTaxes);
    } on ApiException catch (exception) {
      yield FetchTotalTaxesFailed(error: exception.error);
    }
  }
}
