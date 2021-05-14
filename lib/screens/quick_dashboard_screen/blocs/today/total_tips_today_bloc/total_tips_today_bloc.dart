import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:equatable/equatable.dart';

part 'total_tips_today_event.dart';
part 'total_tips_today_state.dart';

class TotalTipsTodayBloc extends Bloc<TotalTipsTodayEvent, TotalTipsTodayState> {
  final TransactionRepository _transactionRepository;
  
  TotalTipsTodayBloc({required TransactionRepository transactionRepository})
    : _transactionRepository = transactionRepository,
      super(TotalTipsInitial());

  @override
  Stream<TotalTipsTodayState> mapEventToState(TotalTipsTodayEvent event) async* {
    if (event is FetchTotalTipsToday) {
      yield* _mapFetchTotalTipsToState();
    }
  }

  Stream<TotalTipsTodayState> _mapFetchTotalTipsToState() async* {
    yield Loading();
    try {
      final int totalTips = await _transactionRepository.fetchTotalTipsToday();
      yield TotalTipsLoaded(totalTips: totalTips);
    } on ApiException catch (exception) {
      yield FetchFailed(error: exception.error);
    }
  }
}
