import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/sales_screen/cubit/date_range_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'net_sales_event.dart';
part 'net_sales_state.dart';

class NetSalesBloc extends Bloc<NetSalesEvent, NetSalesState> {
  final TransactionRepository _transactionRepository;

  late StreamSubscription _dateRangeStream;
  
  NetSalesBloc({required DateRangeCubit dateRangeCubit, required TransactionRepository transactionRepository})
    : _transactionRepository = transactionRepository,
      super(NetSalesInitial()) {
        _eventHandler();
        _dateRangeStream = dateRangeCubit.stream.listen(_onDateRangeChanged);
      }

  void _eventHandler() {
    on<InitNetSales>((event, emit) => _mapInitNetSalesToSales(emit: emit));
    on<DateRangeChanged>((event, emit) => _mapDateRangeChangedToState(event: event, emit: emit));
  }

  @override
  Future<void> close() {
    _dateRangeStream.cancel();
    return super.close();
  }

  void _mapInitNetSalesToSales({required Emitter<NetSalesState> emit}) async {
    emit(Loading());

    try {
      final int total = await _transactionRepository.fetchNetSalesToday();
      emit(NetSalesLoaded(netSales: total));
    } on ApiException catch (exception) {
      emit(FetchFailed(error: exception.error));
    }
  }

  void _mapDateRangeChangedToState({required DateRangeChanged event, required Emitter<NetSalesState> emit}) async {
    emit(Loading());

    try {
      final int total = await _transactionRepository.fetchNetSalesDateRange(dateRange: event.dateRange);
      emit(NetSalesLoaded(netSales: total));
    } on ApiException catch (exception) {
      emit(FetchFailed(error: exception.error));
    }
  }

  void _onDateRangeChanged(DateTimeRange? dateRange) {
    add(DateRangeChanged(dateRange: dateRange));
  }
}
