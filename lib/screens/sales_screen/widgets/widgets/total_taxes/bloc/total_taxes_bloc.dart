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
        _eventHandler();
        _dateRangeStream = dateRangeCubit.stream.listen(_onDateRangeChanged);
      }

  void _eventHandler() {
    on<InitTotalTaxes>((event, emit) => _mapInitTotalTaxesToState(emit: emit));
    on<DateRangeChanged>((event, emit) => _mapDateRangeChangedToState(event: event, emit: emit));
  }

  @override
  Future<void> close() {
    _dateRangeStream.cancel();
    return super.close();
  }

  void _mapInitTotalTaxesToState({required Emitter<TotalTaxesState> emit}) async {
    emit(Loading());

    try {
      final int total = await _transactionRepository.fetchTotalTaxesToday();
      emit(TotalTaxesLoaded(totalTaxes: total));
    } on ApiException catch (exception) {
      emit(FetchFailed(error: exception.error));
    }
  }

  void _mapDateRangeChangedToState({required DateRangeChanged event, required Emitter<TotalTaxesState> emit}) async {
    emit(Loading());

    try {
      final int total = await _transactionRepository.fetchTotalTaxesDateRange(dateRange: event.dateRange);
      emit(TotalTaxesLoaded(totalTaxes: total));
    } on ApiException catch (exception) {
      emit(FetchFailed(error: exception.error));
    }
  }

  void _onDateRangeChanged(DateTimeRange? dateRange) {
    add(DateRangeChanged(dateRange: dateRange));
  }
}
