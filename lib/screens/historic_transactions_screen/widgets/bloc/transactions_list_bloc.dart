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
      _eventHandler();
      _filterButtonStream = filterButtonCubit.stream.listen(_onFilterChanged);
      _dateRangeStream = dateRangeCubit.stream.listen(_onDateRangeChanged);
    }

  void _eventHandler() {
    on<Init>((event, emit) async => await _mapInitToState(emit: emit));
    on<FetchAll>((event, emit) async => await _mapFetchAllToState(emit: emit));
    on<FetchMoreTransactions>((event, emit) async => await _mapFetchMoreTransactionsToState(emit: emit));
    on<FetchByStatus>((event, emit) async => await _mapFetchByStatusToState(code: event.code, emit: emit));
    on<FetchByCustomerId>((event, emit) async => await _mapFetchByCustomerIdToState(customerId: event.customerId, emit: emit));
    on<FetchByTransactionId>((event, emit) async => await _mapFetchByTransactionIdToState(transactionId: event.transactionId, emit: emit));
    on<FetchByCustomerName>((event, emit) async => await _mapFetchByCustomerNameToState(customerName: FullName(first: event.firstName, last: event.lastName), emit: emit));
    on<FetchByEmployeeName>((event, emit) async => await _mapFetchByEmployeeNameToState(employeeName: FullName(first: event.firstName, last: event.lastName), emit: emit));
    on<DateRangeChanged>((event, emit) => _mapDateRangeChangedToState(event: event, emit: emit));
    on<FilterChanged>((event, emit) => _mapFilterChangedToState(event: event, emit: emit));
  }

  @override
  Future<void> close() {
    _filterButtonStream.cancel();
    _dateRangeStream.cancel();
    return super.close();
  }

  Future<void> _mapInitToState({required Emitter<TransactionsListState> emit}) async {
    emit(state.update(loading: true));
    
    try {
      final PaginateDataHolder paginateData = await _transactionRepository.fetchAll();
      _handleSuccess(paginateData: paginateData, emit: emit);
    } on ApiException catch (exception) {
      _handleError(error: exception.error, emit: emit);
    }
  }

  Future<void> _mapFetchAllToState({required Emitter<TransactionsListState> emit}) async {
    _startFetch(emit: emit);

    try {
      final PaginateDataHolder paginateData = await _transactionRepository.fetchAll(dateRange: state.currentDateRange);
      _handleSuccess(paginateData: paginateData, emit: emit);
    } on ApiException catch (exception) {
      _handleError(error: exception.error, emit: emit);
    }
  }

  Future<void> _mapFetchMoreTransactionsToState({required Emitter<TransactionsListState> emit}) async {
    if (!state.loading && !state.paginating && !state.hasReachedEnd) {
      emit(state.update(paginating: true));
      try {
        final PaginateDataHolder paginateData = await _transactionRepository.paginate(url: state.nextUrl!);
        _handleSuccess(paginateData: paginateData, emit: emit);
      } on ApiException catch (exception) {
        _handleError(error: exception.error, emit: emit);
      }
    }
  }

  Future<void> _mapFetchByStatusToState({required int code, required Emitter<TransactionsListState> emit}) async {
    _startFetch(emit: emit, currentIdQuery: code.toString());

    try {
      final PaginateDataHolder paginateData = await _transactionRepository.fetchByCode(code: code, dateRange: state.currentDateRange);
      _handleSuccess(paginateData: paginateData, emit: emit);
    } on ApiException catch (exception) {
      _handleError(error: exception.error, emit: emit);
    }
  }

  Future<void> _mapFetchByCustomerIdToState({required String customerId, required Emitter<TransactionsListState> emit}) async {
    _startFetch(emit: emit, currentIdQuery: customerId);

    try {
      final PaginateDataHolder paginateData = await _transactionRepository.fetchByCustomerId(customerId: customerId, dateRange: state.currentDateRange);
      _handleSuccess(paginateData: paginateData, emit: emit);
    } on ApiException catch (exception) {
      _handleError(error: exception.error, emit: emit);
    }
  }

  Future<void> _mapFetchByTransactionIdToState({required String transactionId, required Emitter<TransactionsListState> emit}) async {
    _startFetch(emit: emit, currentIdQuery: transactionId);

    try {
      final PaginateDataHolder paginateData = await _transactionRepository.fetchByTransactionId(transactionId: transactionId);
      _handleSuccess(paginateData: paginateData, emit: emit);
    } on ApiException catch (exception) {
      _handleError(error: exception.error, emit: emit);
    }
  }

  Future<void> _mapFetchByCustomerNameToState({required FullName customerName, required Emitter<TransactionsListState> emit}) async {
    _startFetch(emit: emit, currentNameQuery: customerName);

    try {
      final PaginateDataHolder paginateData = await _transactionRepository.fetchByCustomerName(firstName: customerName.first, lastName: customerName.last, dateRange: state.currentDateRange);
      _handleSuccess(paginateData: paginateData, emit: emit);
    } on ApiException catch (exception) {
      _handleError(error: exception.error, emit: emit);
    }
  }

  Future<void> _mapFetchByEmployeeNameToState({required FullName employeeName, required Emitter<TransactionsListState> emit}) async {
    _startFetch(emit: emit, currentNameQuery: employeeName);

    try {
      final PaginateDataHolder paginateData = await _transactionRepository.fetchByEmployeeName(firstName: employeeName.first, lastName: employeeName.last, dateRange: state.currentDateRange);
      _handleSuccess(paginateData: paginateData, emit: emit);
    } on ApiException catch (exception) {
      _handleError(error: exception.error, emit: emit);
    }
  }

  void _mapDateRangeChangedToState({required DateRangeChanged event, required Emitter<TransactionsListState> emit}) {
    final DateTimeRange? previousDateRange = state.currentDateRange;

    if (previousDateRange != event.dateRange) {
      emit(state.update(currentDateRange: event.dateRange, isDateReset: event.dateRange == null));
      switch (state.currentFilter) {
        case FilterType.transactionId:
          add(FetchByTransactionId(transactionId: state.currentIdQuery!));
          break;
        case FilterType.customerId:
          add(FetchByCustomerId(customerId: state.currentIdQuery!));
          break;
        case FilterType.status:
          add(FetchByStatus(code: int.parse(state.currentIdQuery!)));
          break;
        case FilterType.customerName:
          add(FetchByCustomerName(firstName: state.currentNameQuery!.first, lastName: state.currentNameQuery!.last));
          break;
        case FilterType.employeeName:
          add(FetchByEmployeeName(firstName: state.currentNameQuery!.first, lastName: state.currentNameQuery!.last));
          break;
        default:
          add(FetchAll());
      }
    }
  }

  void _mapFilterChangedToState({required FilterChanged event, required Emitter<TransactionsListState> emit}) {
    if (event.filter == FilterType.all) {
      emit(state.update(currentFilter: event.filter, isDateReset: true));
      add(FetchAll());
    } else {
      emit(state.update(currentFilter: event.filter));
    }
  }
  
  void _startFetch({required Emitter<TransactionsListState> emit, String? currentIdQuery, FullName? currentNameQuery}) {
    emit(state.reset(currentIdQuery: currentIdQuery, currentNameQuery: currentNameQuery));
  }
  
  void _handleSuccess({required PaginateDataHolder paginateData, required Emitter<TransactionsListState> emit}) {
    emit(state.update(
      loading: false,
      paginating: false,
      transactions: state.transactions + (paginateData.data as List<TransactionResource>),
      nextUrl: paginateData.next,
      hasReachedEnd: paginateData.next == null
    ));
  }

  void _handleError({required String error, required Emitter<TransactionsListState> emit}) {
    emit(state.update(loading: false, paginating: false, errorMessage: error)); 
  }

  void _onDateRangeChanged(DateTimeRange? dateRange) {
    add(DateRangeChanged(dateRange: dateRange));
  }

  void _onFilterChanged(FilterType filter) {
    add(FilterChanged(filter: filter));
  }
}
