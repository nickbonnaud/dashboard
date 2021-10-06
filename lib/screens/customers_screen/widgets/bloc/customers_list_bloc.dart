import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dashboard/models/customer/customer_resource.dart';
import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/repositories/customer_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../cubit/date_range_cubit.dart';
import '../../bloc/filter_button_bloc.dart';

part 'customers_list_event.dart';
part 'customers_list_state.dart';

class CustomersListBloc extends Bloc<CustomersListEvent, CustomersListState> {
  final CustomerRepository _customerRepository;
  final FilterButtonBloc _filterButtonBloc;

  late StreamSubscription _dateRangeStream;
  late StreamSubscription _filterButtonStream;

  CustomersListBloc({
    required CustomerRepository customerRepository,
    required DateRangeCubit dateRangeCubit,
    required FilterButtonBloc filterButtonBloc
  }) 
    : _customerRepository = customerRepository,
      _filterButtonBloc = filterButtonBloc,
      super(CustomersListState.initial(currentDateRange: dateRangeCubit.state)) {
        _eventHandler();
        
        _dateRangeStream = dateRangeCubit.stream.listen(_onDateRangeChanged);
        _filterButtonStream = filterButtonBloc.stream.listen(_onFilterChanged);
  }

  void _eventHandler() {
    on<Init>((event, emit) => _mapInitToState(emit: emit));
    on<FetchAll>((event, emit) => _mapFetchToState(emit: emit));
    on<FetchMore>((event, emit) => _mapFetchMoreToState(emit: emit));
    on<DateRangeChanged>((event, emit) => _mapDateRangeChangedToState(event: event, emit: emit));
    on<FilterButtonChanged>((event, emit) => _mapFilterButtonChangedToState(emit: emit));
  }

  @override
  Future<void> close() {
    _dateRangeStream.cancel();
    _filterButtonStream.cancel();
    return super.close();
  }

  void _mapInitToState({required Emitter<CustomersListState> emit}) async {
    emit(state.update(loading: true));

    try {
      final PaginateDataHolder paginateData = await _customerRepository.fetchAll(
        searchHistoric: _filterButtonBloc.state.searchHistoric,
        withTransactions: _filterButtonBloc.state.withTransactions
      );
      _handleSuccess(paginateData: paginateData, emit: emit);
    } on ApiException catch (exception) {
      _handleError(error: exception.error, emit: emit);
    }
  }

  void _mapFetchToState({required Emitter<CustomersListState> emit}) async {
    _startFetch(emit: emit);

    try {
      final PaginateDataHolder paginateData = await _customerRepository.fetchAll(
        searchHistoric: _filterButtonBloc.state.searchHistoric,
        withTransactions: _filterButtonBloc.state.withTransactions,
        dateRange: state.currentDateRange
      );
      _handleSuccess(paginateData: paginateData, emit: emit);
    } on ApiException catch (exception) {
      _handleError(error: exception.error, emit: emit);
    }
  }

  void _mapFetchMoreToState({required Emitter<CustomersListState> emit}) async {
    if (!state.loading && !state.paginating && !state.hasReachedEnd) {
      emit(state.update(paginating: true));
      try {
        final PaginateDataHolder paginateData = await _customerRepository.paginate(url: state.nextUrl!);
        _handleSuccess(paginateData: paginateData, emit: emit);
      } on ApiException catch (exception) {
        _handleError(error: exception.error, emit: emit);
      }
    }
  }

  void _mapDateRangeChangedToState({required DateRangeChanged event, required Emitter<CustomersListState> emit}) async {
    final DateTimeRange? previousDateRange = state.currentDateRange;
    if (previousDateRange != event.dateRange) {
      emit(state.update(currentDateRange: event.dateRange, isDateReset: event.dateRange == null));
      _mapFetchToState(emit: emit);
    }
  }

  void _mapFilterButtonChangedToState({required Emitter<CustomersListState> emit}) async {
    _mapFetchToState(emit: emit);
  }

  void _startFetch({required Emitter<CustomersListState> emit}) async {
    emit(state.reset());
  }
  
  void _handleSuccess({required PaginateDataHolder paginateData, required Emitter<CustomersListState> emit}) async {
    emit(state.update(
      loading: false,
      paginating: false,
      customers: state.customers + (paginateData.data as List<CustomerResource>),
      nextUrl: paginateData.next,
      hasReachedEnd: paginateData.next == null
    ));
  }

  void _handleError({required String error, required Emitter<CustomersListState> emit}) async {
    emit(state.update(loading: false, paginating: false, errorMessage: error));
  }
  
  void _onDateRangeChanged(DateTimeRange? dateRange) {
    add(DateRangeChanged(dateRange: dateRange));
  }

  void _onFilterChanged(FilterButtonState filterButtonState) {
    add(FilterButtonChanged());
  }
}
