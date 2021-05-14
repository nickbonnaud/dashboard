import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/sales_screen/cubit/date_range_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'total_tips_event.dart';
part 'total_tips_state.dart';

class TotalTipsBloc extends Bloc<TotalTipsEvent, TotalTipsState> {
  final TransactionRepository _transactionRepository;

  late StreamSubscription _dateRangeStream;
  
  TotalTipsBloc({required DateRangeCubit dateRangeCubit, required TransactionRepository transactionRepository})
    : _transactionRepository = transactionRepository,
      super(TotalTipsInitial()) {
        _dateRangeStream = dateRangeCubit.stream.listen(_onDateRangeChanged);
      }

  @override
  Stream<TotalTipsState> mapEventToState(TotalTipsEvent event) async* {
    if (event is InitTotalTips) {
      yield* _mapInitTotalTipsToState();
    } else if (event is DateRangeChanged) {
      yield* _mapDateRangeChangedToState(event: event);
    }
  }

  @override
  Future<void> close() {
    _dateRangeStream.cancel();
    return super.close();
  }

  Stream<TotalTipsState> _mapInitTotalTipsToState() async* {
    yield Loading();

    try {
      final int total = await _transactionRepository.fetchTotalTipsToday();
      yield TotalTipsLoaded(totalTips: total);
    } on ApiException catch (exception) {
      yield FetchFailed(error: exception.error);
    }
  }

  Stream<TotalTipsState> _mapDateRangeChangedToState({required DateRangeChanged event}) async* {
    yield Loading();

    try {
      final int total = await _transactionRepository.fetchTotalTipsDateRange(dateRange: event.dateRange);
      yield TotalTipsLoaded(totalTips: total);
    } on ApiException catch (exception) {
      yield FetchFailed(error: exception.error);
    }
  }

  void _onDateRangeChanged(DateTimeRange? dateRange) {
    add(DateRangeChanged(dateRange: dateRange));
  }
}
