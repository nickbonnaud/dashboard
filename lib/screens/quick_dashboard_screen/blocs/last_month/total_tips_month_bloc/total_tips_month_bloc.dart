import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:equatable/equatable.dart';

part 'total_tips_month_event.dart';
part 'total_tips_month_state.dart';

class TotalTipsMonthBloc extends Bloc<TotalTipsMonthEvent, TotalTipsMonthState> {
  final TransactionRepository _transactionRepository;
  
  TotalTipsMonthBloc({required TransactionRepository transactionRepository})
    : _transactionRepository = transactionRepository,
      super(TotalTipsInitial());

  @override
  Stream<TotalTipsMonthState> mapEventToState(TotalTipsMonthEvent event) async* {
    if (event is FetchTotalTipsMonth) {
      yield* _mapFetchTotalTipsToState();
    }
  }

  Stream<TotalTipsMonthState> _mapFetchTotalTipsToState() async* {
    yield Loading();
    try {
      final int totalTips = await _transactionRepository.fetchTotalTipsMonth();
      yield TotalTipsLoaded(totalTips: totalTips);
    } on ApiException catch (exception) {
      yield FetchTotalTipsFailed(error: exception.error);
    }
  }
}
