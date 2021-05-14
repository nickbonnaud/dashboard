import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dashboard/repositories/refund_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:equatable/equatable.dart';

part 'total_refunds_month_event.dart';
part 'total_refunds_month_state.dart';

class TotalRefundsMonthBloc extends Bloc<TotalRefundsMonthEvent, TotalRefundsMonthState> {
  final RefundRepository _refundRepository;
  
  TotalRefundsMonthBloc({required RefundRepository refundRepository})
    : _refundRepository = refundRepository,
      super(TotalRefundsInitial());

  @override
  Stream<TotalRefundsMonthState> mapEventToState(TotalRefundsMonthEvent event) async* {
    if (event is FetchTotalRefundsMonth) {
      yield* _mapFetchTotalRefundsToState();
    }
  }

  Stream<TotalRefundsMonthState> _mapFetchTotalRefundsToState() async* {
    yield Loading();
    try {
      final int totalRefunds = await _refundRepository.fetchTotalRefundsMonth();
      yield TotalRefundsLoaded(totalRefunds: totalRefunds);
    } on ApiException catch (exception) {
      yield FetchTotalRefundsFailed(error: exception.error);
    }
  }
}
