import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dashboard/repositories/refund_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:equatable/equatable.dart';

part 'total_refunds_today_event.dart';
part 'total_refunds_today_state.dart';

class TotalRefundsTodayBloc extends Bloc<TotalRefundsTodayEvent, TotalRefundsTodayState> {
  final RefundRepository _refundRepository;
  
  TotalRefundsTodayBloc({required RefundRepository refundRepository})
    : _refundRepository = refundRepository,
      super(TotalRefundsInitial());

  @override
  Stream<TotalRefundsTodayState> mapEventToState(TotalRefundsTodayEvent event) async* {
    if (event is FetchTotalRefundsToday) {
      yield* _mapFetchTotalRefundsToState();
    }
  }

  Stream<TotalRefundsTodayState> _mapFetchTotalRefundsToState() async* {
    yield Loading();

    try {
      final int totalRefunds = await _refundRepository.fetchTotalRefundsToday();
      yield TotalRefundsLoaded(totalRefunds: totalRefunds);
    } on ApiException catch (exception) {
      yield FetchFailed(error: exception.error);
    }
  }
}
