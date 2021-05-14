import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dashboard/models/transaction_filter.dart';
import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/models/transaction/transaction_resource.dart';
import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/historic_transactions_screen/cubits/date_range_cubit.dart';
import 'package:dashboard/screens/historic_transactions_screen/cubits/filter_button_cubit.dart';
import 'package:dashboard/screens/historic_transactions_screen/widgets/models/full_name.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'transactions_list_event.dart';
part 'transactions_list_state.dart';

class TransactionsListBloc extends Bloc<TransactionsListEvent, TransactionsListState> {
  final TransactionRepository _transactionRepository;
  
  late StreamSubscription _dateRangeStream;
  late StreamSubscription _filterButtonStream;
  
  TransactionsListBloc({
    required FilterButtonCubit filterButtonCubit,
    required DateRangeCubit dateRangeCubit,
    required TransactionRepository transactionRepository
  })
    : _transactionRepository = transactionRepository,
      super(TransactionsListState.initial(
        currentFilter: filterButtonCubit.state,
        currentDateRange: dateRangeCubit.state
      )
    ) {
      _filterButtonStream = filterButtonCubit.stream.listen(_onFilterChanged);
      _dateRangeStream = dateRangeCubit.stream.listen(_onDateRangeChanged);
    }

  @override
  Stream<TransactionsListState> mapEventToState(TransactionsListEvent event) async* {
    if (event is Init) {
      yield* _mapInitToState();
    } else if (event is FetchAll) {
      yield* _mapFetchAllToState();
    } else if (event is FetchMoreTransactions) {
      yield* _mapFetchMoreTransactionsToState();
    } else if (event is FetchByStatus) {
      yield* _mapFetchByStatusToState(code: event.code);
    } else if (event is FetchByCustomerId) {
      yield* _mapFetchByCustomerIdToState(customerId: event.customerId);
    } else if (event is FetchByTransactionId) {
      yield* _mapFetchByTransactionIdToState(transactionId: event.transactionId);
    } else if (event is FetchByCustomerName) {
      yield* _mapFetchByCustomerNameToState(customerName: FullName(first: event.firstName, last: event.lastName));
    } else if (event is FetchByEmployeeName) {
      yield* _mapFetchByEmployeeNameToState(employeeName: FullName(first: event.firstName, last: event.lastName));
    } else if (event is DateRangeChanged) {
      yield* _mapDateRangeChangedToState(event: event);
    } else if (event is FilterChanged) {
      yield* _mapFilterChangedToState(event: event);
    }
  }

  @override
  Future<void> close() {
    _filterButtonStream.cancel();
    _dateRangeStream.cancel();
    return super.close();
  }

  Stream<TransactionsListState> _mapInitToState() async* {
    yield state.update(loading: true);
    
    try {
      final PaginateDataHolder paginateData = await _transactionRepository.fetchAll();
      yield* _handleSuccess(paginateData: paginateData);
    } on ApiException catch (exception) {
      yield* _handleError(error: exception.error);
    }
  }

  Stream<TransactionsListState> _mapFetchAllToState() async* {
    yield* _startFetch();

    try {
      final PaginateDataHolder paginateData = await _transactionRepository.fetchAll(dateRange: state.currentDateRange);
      yield* _handleSuccess(paginateData: paginateData);
    } on ApiException catch (exception) {
      yield* _handleError(error: exception.error);
    }
  }

  Stream<TransactionsListState> _mapFetchMoreTransactionsToState() async* {
    if (!state.loading && !state.paginating && !state.hasReachedEnd) {
      yield state.update(paginating: true);
      try {
        final PaginateDataHolder paginateData = await _transactionRepository.paginate(url: state.nextUrl!);
        yield* _handleSuccess(paginateData: paginateData);
      } on ApiException catch (exception) {
        yield* _handleError(error: exception.error);
      }
    }
  }

  Stream<TransactionsListState> _mapFetchByStatusToState({required int code}) async* {
    yield* _startFetch(currentIdQuery: code.toString());

    try {
      final PaginateDataHolder paginateData = await _transactionRepository.fetchByCode(code: code, dateRange: state.currentDateRange);
      yield* _handleSuccess(paginateData: paginateData);
    } on ApiException catch (exception) {
      yield* _handleError(error: exception.error);
    }
  }

  Stream<TransactionsListState> _mapFetchByCustomerIdToState({required String customerId}) async* {
    yield* _startFetch(currentIdQuery: customerId);

    try {
      final PaginateDataHolder paginateData = await _transactionRepository.fetchByCustomerId(customerId: customerId, dateRange: state.currentDateRange);
      yield* _handleSuccess(paginateData: paginateData);
    } on ApiException catch (exception) {
      yield* _handleError(error: exception.error);
    }
  }

  Stream<TransactionsListState> _mapFetchByTransactionIdToState({required String transactionId}) async* {
    yield* _startFetch(currentIdQuery: transactionId);

    try {
      final PaginateDataHolder paginateData = await _transactionRepository.fetchByTransactionId(transactionId: transactionId);
      yield* _handleSuccess(paginateData: paginateData);
    } on ApiException catch (exception) {
      yield* _handleError(error: exception.error);
    }
  }

  Stream<TransactionsListState> _mapFetchByCustomerNameToState({required FullName customerName}) async* {
    yield* _startFetch(currentNameQuery: customerName);

    try {
      final PaginateDataHolder paginateData = await _transactionRepository.fetchByCustomerName(firstName: customerName.first, lastName: customerName.last, dateRange: state.currentDateRange);
      yield* _handleSuccess(paginateData: paginateData);
    } on ApiException catch (exception) {
      yield* _handleError(error: exception.error);
    }
  }

  Stream<TransactionsListState> _mapFetchByEmployeeNameToState({required FullName employeeName}) async* {
    yield* _startFetch(currentNameQuery: employeeName);

    try {
      final PaginateDataHolder paginateData = await _transactionRepository.fetchByEmployeeName(firstName: employeeName.first, lastName: employeeName.last, dateRange: state.currentDateRange);
      yield* _handleSuccess(paginateData: paginateData);
    } on ApiException catch (exception) {
      yield* _handleError(error: exception.error);
    }
  }

  Stream<TransactionsListState> _mapDateRangeChangedToState({required DateRangeChanged event}) async* {
    final DateTimeRange? previousDateRange = state.currentDateRange;

    if (previousDateRange != event.dateRange) {
      yield state.update(currentDateRange: event.dateRange, isDateReset: event.dateRange == null);
      switch (state.currentFilter) {
        case FilterType.transactionId:
          yield* _mapFetchByTransactionIdToState(transactionId: state.currentIdQuery!);
          break;
        case FilterType.customerId:
          yield* _mapFetchByCustomerIdToState(customerId: state.currentIdQuery!);
          break;
        case FilterType.status:
          yield* _mapFetchByStatusToState(code: int.parse(state.currentIdQuery!));
          break;
        case FilterType.customerName:
          yield* _mapFetchByCustomerNameToState(customerName: state.currentNameQuery!);
          break;
        case FilterType.employeeName:
          yield* _mapFetchByEmployeeNameToState(employeeName: state.currentNameQuery!);
          break;
        default:
          yield* _mapFetchAllToState();
      }
    }
  }

  Stream<TransactionsListState> _mapFilterChangedToState({required FilterChanged event}) async* {
    if (event.filter == FilterType.all) {
      yield state.update(currentFilter: event.filter, isDateReset: true);
      yield* _mapFetchAllToState();
    } else {
      yield state.update(currentFilter: event.filter);
    }
  }
  
  Stream<TransactionsListState> _startFetch({String? currentIdQuery, FullName? currentNameQuery}) async* {
    yield state.reset(currentIdQuery: currentIdQuery, currentNameQuery: currentNameQuery);
  }
  
  Stream<TransactionsListState> _handleSuccess({required PaginateDataHolder paginateData}) async* {
    yield state.update(
      loading: false,
      paginating: false,
      transactions: state.transactions + (paginateData.data as List<TransactionResource>),
      nextUrl: paginateData.next,
      hasReachedEnd: paginateData.next == null
    );
  }

  Stream<TransactionsListState> _handleError({required String error}) async* {
    yield state.update(loading: false, paginating: false, errorMessage: error); 
  }

  void _onDateRangeChanged(DateTimeRange? dateRange) {
    add(DateRangeChanged(dateRange: dateRange));
  }

  void _onFilterChanged(FilterType filter) {
    add(FilterChanged(filter: filter));
  }
}
