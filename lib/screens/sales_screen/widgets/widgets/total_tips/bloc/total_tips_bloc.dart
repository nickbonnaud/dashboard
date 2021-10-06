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
        _eventHandler();
        _dateRangeStream = dateRangeCubit.stream.listen(_onDateRangeChanged);
      }

  void _eventHandler() {
    on<InitTotalTips>((event, emit) => _mapInitTotalTipsToState(emit: emit));
    on<DateRangeChanged>((event, emit) => _mapDateRangeChangedToState(event: event, emit: emit));
  }
  
  @override
  Future<void> close() {
    _dateRangeStream.cancel();
    return super.close();
  }

  void _mapInitTotalTipsToState({required Emitter<TotalTipsState> emit}) async {
    emit(Loading());

    try {
      final int total = await _transactionRepository.fetchTotalTipsToday();
      emit(TotalTipsLoaded(totalTips: total));
    } on ApiException catch (exception) {
      emit(FetchFailed(error: exception.error));
    }
  }

  void _mapDateRangeChangedToState({required DateRangeChanged event, required Emitter<TotalTipsState> emit}) async {
    emit(Loading());

    try {
      final int total = await _transactionRepository.fetchTotalTipsDateRange(dateRange: event.dateRange);
      emit(TotalTipsLoaded(totalTips: total));
    } on ApiException catch (exception) {
      emit(FetchFailed(error: exception.error));
    }
  }

  void _onDateRangeChanged(DateTimeRange? dateRange) {
    add(DateRangeChanged(dateRange: dateRange));
  }
}
