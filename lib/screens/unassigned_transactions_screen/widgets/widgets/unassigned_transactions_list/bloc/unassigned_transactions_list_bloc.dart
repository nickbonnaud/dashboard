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
        _dateRangeStream = dateRangeCubit.stream.listen(_onDateRangeChanged);
      }

  @override
  Stream<UnassignedTransactionsListState> mapEventToState(UnassignedTransactionsListEvent event) async* {
    if (event is Init) {
      yield* _mapInitToState();
    } else if (event is FetchAll) {
      yield* _mapFetchAllToState();
    } else if (event is FetchMore) {
      yield* _mapFetchMoreToState();
    } else if (event is DateRangeChanged) {
      yield* _mapDateRangeChangedToState(event: event);
    }
  }

  @override
  Future<void> close() {
    _dateRangeStream.cancel();
    return super.close();
  }

  Stream<UnassignedTransactionsListState> _mapInitToState() async* {
    yield state.update(loading: true);

    try {
      final PaginateDataHolder paginateData = await _unassignedTransactionRepository.fetchAll();
      yield* _handleSuccess(paginateData: paginateData);
    } on ApiException catch (exception) {
      yield* _handleError(error: exception.error);
    }
  }

  Stream<UnassignedTransactionsListState> _mapFetchAllToState() async* {
    yield* _startFetch();

    try {
      final PaginateDataHolder paginateData = await _unassignedTransactionRepository.fetchAll(dateRange: state.currentDateRange);
      yield* _handleSuccess(paginateData: paginateData);
    } on ApiException catch (exception) {
      yield* _handleError(error: exception.error);
    }
  }

  Stream<UnassignedTransactionsListState> _mapFetchMoreToState() async* {
    if (!state.loading && !state.paginating && !state.hasReachedEnd) {
      yield state.update(paginating: true);
      try {
        final PaginateDataHolder paginateData = await _unassignedTransactionRepository.paginate(url: state.nextUrl!);
        yield* _handleSuccess(paginateData: paginateData);
      } on ApiException catch (exception) {
        yield* _handleError(error: exception.error);
      }
    }
  }

  Stream<UnassignedTransactionsListState> _mapDateRangeChangedToState({required DateRangeChanged event}) async* {
    final DateTimeRange? previousDateRange = state.currentDateRange;
    if (previousDateRange != event.dateRange) {
      yield state.update(currentDateRange: event.dateRange, isDateReset: event.dateRange == null);
      yield* _mapFetchAllToState();
    }
  }

  Stream<UnassignedTransactionsListState> _handleSuccess({required PaginateDataHolder paginateData}) async* {
    yield state.update(
      loading: false,
      paginating: false,
      transactions: state.transactions + (paginateData.data as List<UnassignedTransaction>),
      nextUrl: paginateData.next,
      hasReachedEnd: paginateData.next == null
    );
  }

  Stream<UnassignedTransactionsListState> _startFetch() async* {
    yield state.update(
      loading: true,
      transactions: [],
      nextUrl: null,
      hasReachedEnd: true,
      errorMessage: "",
    );
  }

  Stream<UnassignedTransactionsListState> _handleError({required String error}) async* {
    yield state.update(loading: false, paginating: false, errorMessage: error); 
  }

  void _onDateRangeChanged(DateTimeRange? dateRange) {
    add(DateRangeChanged(dateRange: dateRange));
  }
}
