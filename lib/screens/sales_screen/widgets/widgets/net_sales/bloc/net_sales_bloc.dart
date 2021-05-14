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
        _dateRangeStream = dateRangeCubit.stream.listen(_onDateRangeChanged);
      }

  @override
  Stream<NetSalesState> mapEventToState(NetSalesEvent event) async* {
    if (event is InitNetSales) {
      yield* _mapInitNetSalesToSales();
    } else if (event is DateRangeChanged) {
      yield* _mapDateRangeChangedToState(event: event);
    }
  }

  @override
  Future<void> close() {
    _dateRangeStream.cancel();
    return super.close();
  }

  Stream<NetSalesState> _mapInitNetSalesToSales() async* {
    yield Loading();

    try {
      final int total = await _transactionRepository.fetchNetSalesToday();
      yield NetSalesLoaded(netSales: total);
    } on ApiException catch (exception) {
      yield FetchFailed(error: exception.error);
    }
  }

  Stream<NetSalesState> _mapDateRangeChangedToState({required DateRangeChanged event}) async* {
    yield Loading();

    try {
      final int total = await _transactionRepository.fetchNetSalesDateRange(dateRange: event.dateRange);
      yield NetSalesLoaded(netSales: total);
    } on ApiException catch (exception) {
      yield FetchFailed(error: exception.error);
    }
  }

  void _onDateRangeChanged(DateTimeRange? dateRange) {
    add(DateRangeChanged(dateRange: dateRange));
  }
}
