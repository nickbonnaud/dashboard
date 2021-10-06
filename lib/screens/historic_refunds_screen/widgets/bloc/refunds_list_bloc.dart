import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dashboard/models/transaction_filter.dart';
import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/models/refund/refund_resource.dart';
import 'package:dashboard/repositories/refund_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/historic_refunds_screen/cubits/date_range_cubit.dart';
import 'package:dashboard/screens/historic_refunds_screen/cubits/filter_button_cubit.dart';
import 'package:dashboard/screens/historic_refunds_screen/widgets/models/full_name.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'refunds_list_event.dart';
part 'refunds_list_state.dart';

class RefundsListBloc extends Bloc<RefundsListEvent, RefundsListState> {
  final RefundRepository _refundRepository;

  late StreamSubscription _dateRangeStream;
  late StreamSubscription _filterButtonStream;
  
  RefundsListBloc({
    required FilterButtonCubit filterButtonCubit,
    required DateRangeCubit dateRangeCubit,
    required RefundRepository refundRepository
  }) 
    : _refundRepository = refundRepository,
      super(RefundsListState.initial(
        currentFilter: filterButtonCubit.state,
        currentDateRange: dateRangeCubit.state
      )
    ) {
      _eventHandler();
      _dateRangeStream = dateRangeCubit.stream.listen(_onDateRangeChanged);
      _filterButtonStream = filterButtonCubit.stream.listen(_onFilterChanged);
    }

  void _eventHandler() {
    on<Init>((event, emit) => _mapInitToState(emit: emit));
    on<FetchAll>((event, emit) => _mapFetchAllToState(emit: emit));
    on<FetchMore>((event, emit) => _mapFetchMoreToState(emit: emit));
    on<FetchByRefundId>((event, emit) => _mapFetchByRefundIdToState(refundId: event.refundId, emit: emit));
    on<FetchByTransactionId>((event, emit) => _mapFetchByTransactionIdToState(transactionId: event.transactionId, emit: emit));
    on<FetchByCustomerId>((event, emit) => _mapFetchByCustomerIdToState(customerId: event.customerId, emit: emit));
    on<FetchByCustomerName>((event, emit) => _mapFetchByCustomerNameToState(fullName: FullName(first: event.firstName, last: event.lastName), emit: emit));
    on<DateRangeChanged>((event, emit) => _mapDateRangeChangedToState(event: event, emit: emit));
    on<FilterChanged>((event, emit) => _mapFilterChangedToState(event: event, emit: emit));
  }

  @override
  Future<void> close() {
    _dateRangeStream.cancel();
    _filterButtonStream.cancel();
    return super.close();
  }

  void _mapInitToState({required Emitter<RefundsListState> emit}) async {
    emit(state.update(loading: true));

    try {
      final PaginateDataHolder paginateData = await _refundRepository.fetchAll();
      _handleSuccess(paginateData: paginateData, emit: emit);
    } on ApiException catch (exception) {
      _handleError(error: exception.error, emit: emit);
    }
  }

  void _mapFetchAllToState({required Emitter<RefundsListState> emit}) async {
    _startFetch(emit: emit);

    try {
      final PaginateDataHolder paginateData = await _refundRepository.fetchAll(dateRange: state.currentDateRange);
      _handleSuccess(paginateData: paginateData, emit: emit);
    } on ApiException catch (exception) {
       _handleError(error: exception.error, emit: emit);
    }
  }

  void _mapFetchMoreToState({required Emitter<RefundsListState> emit}) async {
    if (!state.loading && !state.paginating && !state.hasReachedEnd) {
      emit(state.update(paginating: true));
      try {
        final PaginateDataHolder paginateData = await _refundRepository.paginate(url: state.nextUrl!);
        _handleSuccess(emit: emit, paginateData: paginateData);
      } on ApiException catch (exception) {
        _handleError(emit: emit, error: exception.error);
      }
    }
  }

  void _mapFetchByRefundIdToState({required String refundId, required Emitter<RefundsListState> emit}) async {
    _startFetch(emit: emit, currentIdQuery: refundId);

    try {
      final PaginateDataHolder paginateData = await _refundRepository.fetchByRefundId(refundId: refundId);
      _handleSuccess(paginateData: paginateData, emit: emit);
    } on ApiException catch (exception) {
      _handleError(error: exception.error, emit: emit);
    }
  }

  void _mapFetchByTransactionIdToState({required String transactionId, required Emitter<RefundsListState> emit}) async {
    _startFetch(emit: emit, currentIdQuery: transactionId);

    try {
      final PaginateDataHolder paginateData = await _refundRepository.fetchByTransactionId(transactionId: transactionId);
      _handleSuccess(paginateData: paginateData, emit: emit);
    } on ApiException catch (exception) {
      _handleError(error: exception.error, emit: emit);
    }
  }

  void _mapFetchByCustomerIdToState({required String customerId, required Emitter<RefundsListState> emit}) async {
    _startFetch(emit: emit, currentIdQuery: customerId);

    try {
      final PaginateDataHolder paginateData = await _refundRepository.fetchByCustomerId(customerId: customerId, dateRange: state.currentDateRange);
      _handleSuccess(paginateData: paginateData, emit: emit);
    } on ApiException catch (exception) {
      _handleError(error: exception.error, emit: emit);
    }
  }

  void _mapFetchByCustomerNameToState({required FullName fullName, required Emitter<RefundsListState> emit}) async {
    _startFetch(emit: emit, currentNameQuery: fullName);

    try {
      final PaginateDataHolder paginateData = await _refundRepository.fetchByCustomerName(firstName: fullName.first, lastName: fullName.last, dateRange: state.currentDateRange);
      _handleSuccess(paginateData: paginateData, emit: emit);
    } on ApiException catch (exception) {
      _handleError(error: exception.error, emit: emit);
    }
  }

  void _mapDateRangeChangedToState({required DateRangeChanged event, required Emitter<RefundsListState> emit}) async {
    final DateTimeRange? previousDateRange = state.currentDateRange;

    if (previousDateRange != event.dateRange) {
      emit(state.update(currentDateRange: event.dateRange, isDateReset: event.dateRange == null));
      switch (state.currentFilter) {
        case FilterType.refundId:
          _mapFetchByRefundIdToState(refundId: state.currentIdQuery!, emit: emit);
          break;
        case FilterType.transactionId:
          _mapFetchByTransactionIdToState(transactionId: state.currentIdQuery!, emit: emit);
          break;
        case FilterType.customerId:
          _mapFetchByCustomerIdToState(customerId: state.currentIdQuery!, emit: emit);
          break;
        case FilterType.customerName:
          _mapFetchByCustomerNameToState(fullName: state.currentNameQuery!, emit: emit);
          break;
        default:
          _mapFetchAllToState(emit: emit);
      }
    }
  }

  void _mapFilterChangedToState({required FilterChanged event, required Emitter<RefundsListState> emit}) async {
    if (event.filter == FilterType.all) {
      emit(state.update(currentFilter: event.filter, isDateReset: true));
      _mapFetchAllToState(emit: emit);
    } else {
      emit(state.update(currentFilter: event.filter));
    }
  }

  void _startFetch({required Emitter<RefundsListState> emit, String? currentIdQuery, FullName? currentNameQuery}) async {
    emit(state.reset(currentIdQuery: currentIdQuery, currentNameQuery: currentNameQuery));
  }
  
  void _handleSuccess({required PaginateDataHolder paginateData, required Emitter<RefundsListState> emit}) async {
    emit(state.update(
      loading: false,
      paginating: false,
      refunds: state.refunds + (paginateData.data as List<RefundResource>),
      nextUrl: paginateData.next,
      hasReachedEnd: paginateData.next == null
    ));
  }

  void _handleError({required String error, required Emitter<RefundsListState> emit}) async {
    emit(state.update(loading: false, paginating: false, errorMessage: error)); 
  }
  
  void _onDateRangeChanged(DateTimeRange? dateRange) {
    add(DateRangeChanged(dateRange: dateRange));
  }

  void _onFilterChanged(FilterType filter) {
    add(FilterChanged(filter: filter));
  }
}
