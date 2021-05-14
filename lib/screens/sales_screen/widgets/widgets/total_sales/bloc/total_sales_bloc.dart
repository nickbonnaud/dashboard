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
        _dateRangeStream = dateRangeCubit.stream.listen(_onDateRangeChanged);
      }

  @override
  Stream<TotalSalesState> mapEventToState(TotalSalesEvent event) async* {
    if (event is InitTotalSales) {
      yield* _mapInitTotalSalesToState();
    } else if (event is DateRangeChanged) {
      yield* _mapDateRangeChangedToState(event: event);
    }
  }

  @override
  Future<void> close() {
    _dateRangeStream.cancel();
    return super.close();
  }

  Stream<TotalSalesState> _mapInitTotalSalesToState() async* {
    yield Loading();

    try {
      final int total = await _transactionRepository.fetchTotalSalesToday();
      yield TotalSalesLoaded(totalSales: total);
    } on ApiException catch (exception) {
      yield FetchFailed(error: exception.error);
    }
  }

  Stream<TotalSalesState> _mapDateRangeChangedToState({required DateRangeChanged event}) async* {
    yield Loading();

    try {
      final int total = await _transactionRepository.fetchTotalSalesDateRange(dateRange: event.dateRange);
      yield TotalSalesLoaded(totalSales: total);
    } on ApiException catch (exception) {
      yield FetchFailed(error: exception.error);
    }
  }

  void _onDateRangeChanged(DateTimeRange? dateRange) {
    add(DateRangeChanged(dateRange: dateRange));
  }
}
