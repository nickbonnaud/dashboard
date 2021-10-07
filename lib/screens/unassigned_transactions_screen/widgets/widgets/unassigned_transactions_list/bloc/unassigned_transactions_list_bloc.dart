import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/models/unassigned_transaction/unassigned_transaction.dart';
import 'package:dashboard/repositories/unassigned_transaction_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/unassigned_transactions_screen/cubit/date_range_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'unassigned_transactions_list_event.dart';
part 'unassigned_transactions_list_state.dart';

class UnassignedTransactionsListBloc extends Bloc<UnassignedTransactionsListEvent, UnassignedTransactionsListState> {
  final UnassignedTransactionRepository _unassignedTransactionRepository;

  late StreamSubscription _dateRangeStream;
  
  UnassignedTransactionsListBloc({required DateRangeCubit dateRangeCubit, required UnassignedTransactionRepository unassignedTransactionRepository})
    : _unassignedTransactionRepository = unassignedTransactionRepository,
      super(UnassignedTransactionsListState.initial(currentDateRange: dateRangeCubit.state)) {
        _eventHandler();
        _dateRangeStream = dateRangeCubit.stream.listen(_onDateRangeChanged);
      }

  void _eventHandler() {
    on<Init>((event, emit) async => await _mapInitToState(emit: emit));
    on<FetchAll>((event, emit) async => await _mapFetchAllToState(emit: emit));
    on<FetchMore>((event, emit) async => await _mapFetchMoreToState(emit: emit));
    on<DateRangeChanged>((event, emit) => _mapDateRangeChangedToState(event: event, emit: emit));
  }

  @override
  Future<void> close() {
    _dateRangeStream.cancel();
    return super.close();
  }

  Future<void> _mapInitToState({required Emitter<UnassignedTransactionsListState> emit}) async {
    emit(state.update(loading: true));

    try {
      final PaginateDataHolder paginateData = await _unassignedTransactionRepository.fetchAll();
      _handleSuccess(paginateData: paginateData, emit: emit);
    } on ApiException catch (exception) {
      _handleError(error: exception.error, emit: emit);
    }
  }

  Future<void> _mapFetchAllToState({required Emitter<UnassignedTransactionsListState> emit}) async {
    _startFetch(emit: emit);

    try {
      final PaginateDataHolder paginateData = await _unassignedTransactionRepository.fetchAll(dateRange: state.currentDateRange);
      _handleSuccess(paginateData: paginateData, emit: emit);
    } on ApiException catch (exception) {
      _handleError(error: exception.error, emit: emit);
    }
  }

  Future<void> _mapFetchMoreToState({required Emitter<UnassignedTransactionsListState> emit}) async {
    if (!state.loading && !state.paginating && !state.hasReachedEnd) {
      emit(state.update(paginating: true));
      try {
        final PaginateDataHolder paginateData = await _unassignedTransactionRepository.paginate(url: state.nextUrl!);
        _handleSuccess(paginateData: paginateData, emit: emit);
      } on ApiException catch (exception) {
        _handleError(error: exception.error, emit: emit);
      }
    }
  }

  void _mapDateRangeChangedToState({required DateRangeChanged event, required Emitter<UnassignedTransactionsListState> emit}) {
    final DateTimeRange? previousDateRange = state.currentDateRange;
    if (previousDateRange != event.dateRange) {
      emit(state.update(currentDateRange: event.dateRange, isDateReset: event.dateRange == null));
      add(FetchAll());
    }
  }

  void _handleSuccess({required PaginateDataHolder paginateData, required Emitter<UnassignedTransactionsListState> emit}) {
    emit(state.update(
      loading: false,
      paginating: false,
      transactions: state.transactions + (paginateData.data as List<UnassignedTransaction>),
      nextUrl: paginateData.next,
      hasReachedEnd: paginateData.next == null
    ));
  }

  void _startFetch({required Emitter<UnassignedTransactionsListState> emit}) {
    emit(state.update(
      loading: true,
      transactions: [],
      nextUrl: null,
      hasReachedEnd: true,
      errorMessage: "",
    ));
  }

  void _handleError({required String error, required Emitter<UnassignedTransactionsListState> emit}) {
    emit(state.update(loading: false, paginating: false, errorMessage: error)); 
  }

  void _onDateRangeChanged(DateTimeRange? dateRange) {
    add(DateRangeChanged(dateRange: dateRange));
  }
}
