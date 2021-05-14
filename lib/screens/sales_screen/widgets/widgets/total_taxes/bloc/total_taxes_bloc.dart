import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/sales_screen/cubit/date_range_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'total_taxes_event.dart';
part 'total_taxes_state.dart';

class TotalTaxesBloc extends Bloc<TotalTaxesEvent, TotalTaxesState> {
  final TransactionRepository _transactionRepository;

  late StreamSubscription _dateRangeStream;
  
  TotalTaxesBloc({required DateRangeCubit dateRangeCubit, required TransactionRepository transactionRepository})
    : _transactionRepository = transactionRepository,
      super(TotalTaxesInitial()) {
        _dateRangeStream = dateRangeCubit.stream.listen(_onDateRangeChanged);
      }

  @override
  Stream<TotalTaxesState> mapEventToState(TotalTaxesEvent event) async* {
    if (event is InitTotalTaxes) {
      yield* _mapInitTotalTaxesToState();
    } else if (event is DateRangeChanged) {
      yield* _mapDateRangeChangedToState(event: event);
    }
  }

  @override
  Future<void> close() {
    _dateRangeStream.cancel();
    return super.close();
  }

  Stream<TotalTaxesState> _mapInitTotalTaxesToState() async* {
    yield Loading();

    try {
      final int total = await _transactionRepository.fetchTotalTaxesToday();
      yield TotalTaxesLoaded(totalTaxes: total);
    } on ApiException catch (exception) {
      yield FetchFailed(error: exception.error);
    }
  }

  Stream<TotalTaxesState> _mapDateRangeChangedToState({required DateRangeChanged event}) async* {
    yield Loading();

    try {
      final int total = await _transactionRepository.fetchTotalTaxesDateRange(dateRange: event.dateRange);
      yield TotalTaxesLoaded(totalTaxes: total);
    } on ApiException catch (exception) {
      yield FetchFailed(error: exception.error);
    }
  }

  void _onDateRangeChanged(DateTimeRange? dateRange) {
    add(DateRangeChanged(dateRange: dateRange));
  }
}
