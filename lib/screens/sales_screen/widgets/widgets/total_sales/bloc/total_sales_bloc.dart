import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/sales_screen/cubit/date_range_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'total_sales_event.dart';
part 'total_sales_state.dart';

class TotalSalesBloc extends Bloc<TotalSalesEvent, TotalSalesState> {
  final TransactionRepository _transactionRepository;

  late StreamSubscription _dateRangeStream;
  
  TotalSalesBloc({required DateRangeCubit dateRangeCubit, required TransactionRepository transactionRepository})
    : _transactionRepository = transactionRepository,
      super(TotalSalesInitial()) {
        _eventHandler();
        _dateRangeStream = dateRangeCubit.stream.listen(_onDateRangeChanged);
      }

  void _eventHandler() {
    on<InitTotalSales>((event, emit) => _mapInitTotalSalesToState(emit: emit));
    on<DateRangeChanged>((event, emit) => _mapDateRangeChangedToState(event: event, emit: emit));
  }

  @override
  Future<void> close() {
    _dateRangeStream.cancel();
    return super.close();
  }

  void _mapInitTotalSalesToState({required Emitter<TotalSalesState> emit}) async {
    emit(Loading());

    try {
      final int total = await _transactionRepository.fetchTotalSalesToday();
      emit(TotalSalesLoaded(totalSales: total));
    } on ApiException catch (exception) {
      emit(FetchFailed(error: exception.error));
    }
  }

  void _mapDateRangeChangedToState({required DateRangeChanged event, required Emitter<TotalSalesState> emit}) async {
    emit(Loading());

    try {
      final int total = await _transactionRepository.fetchTotalSalesDateRange(dateRange: event.dateRange);
      emit(TotalSalesLoaded(totalSales: total));
    } on ApiException catch (exception) {
      emit(FetchFailed(error: exception.error));
    }
  }

  void _onDateRangeChanged(DateTimeRange? dateRange) {
    add(DateRangeChanged(dateRange: dateRange));
  }
}
