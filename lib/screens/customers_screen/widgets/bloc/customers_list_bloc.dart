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
        _dateRangeStream = dateRangeCubit.stream.listen(_onDateRangeChanged);
        _filterButtonStream = filterButtonBloc.stream.listen(_onFilterChanged);
      }

  @override
  Stream<CustomersListState> mapEventToState(CustomersListEvent event) async* {
    if (event is Init) {
      yield* _mapInitToState();
    } else if (event is FetchAll) {
      yield* _mapFetchToState();
    } else if (event is FetchMore) {
      yield* _mapFetchMoreToState();
    } else if (event is DateRangeChanged) {
      yield* _mapDateRangeChangedToState(event: event);
    } else if (event is FilterButtonChanged) {
      yield* _mapFilterButtonChangedToState();
    }
  }

  @override
  Future<void> close() {
    _dateRangeStream.cancel();
    _filterButtonStream.cancel();
    return super.close();
  }

  Stream<CustomersListState> _mapInitToState() async* {
    yield state.update(loading: true);

    try {
      final PaginateDataHolder paginateData = await _customerRepository.fetchAll(
        searchHistoric: _filterButtonBloc.state.searchHistoric,
        withTransactions: _filterButtonBloc.state.withTransactions
      );
      yield* _handleSuccess(paginateData: paginateData);
    } on ApiException catch (exception) {
      yield* _handleError(error: exception.error);
    }
  }

  Stream<CustomersListState> _mapFetchToState() async* {
    yield* _startFetch();

    try {
      final PaginateDataHolder paginateData = await _customerRepository.fetchAll(
        searchHistoric: _filterButtonBloc.state.searchHistoric,
        withTransactions: _filterButtonBloc.state.withTransactions,
        dateRange: state.currentDateRange
      );
      yield* _handleSuccess(paginateData: paginateData);
    } on ApiException catch (exception) {
      yield* _handleError(error: exception.error);
    }
  }

  Stream<CustomersListState> _mapFetchMoreToState() async* {
    if (!state.loading && !state.paginating && !state.hasReachedEnd) {
      yield state.update(paginating: true);
      try {
        final PaginateDataHolder paginateData = await _customerRepository.paginate(url: state.nextUrl!);
        yield* _handleSuccess(paginateData: paginateData);
      } on ApiException catch (exception) {
        yield* _handleError(error: exception.error);
      }
    }
  }

  Stream<CustomersListState> _mapDateRangeChangedToState({required DateRangeChanged event}) async* {
    final DateTimeRange? previousDateRange = state.currentDateRange;
    if (previousDateRange != event.dateRange) {
      yield state.update(currentDateRange: event.dateRange, isDateReset: event.dateRange == null);
      yield* _mapFetchToState();
    }
  }

  Stream<CustomersListState> _mapFilterButtonChangedToState() async* {
    yield* _mapFetchToState();
  }

  Stream<CustomersListState> _startFetch() async* {
    yield state.reset();
  }
  
  Stream<CustomersListState> _handleSuccess({required PaginateDataHolder paginateData}) async* {
    yield state.update(
      loading: false,
      paginating: false,
      customers: state.customers + (paginateData.data as List<CustomerResource>),
      nextUrl: paginateData.next,
      hasReachedEnd: paginateData.next == null
    );
  }

  Stream<CustomersListState> _handleError({required String error}) async* {
    yield state.update(loading: false, paginating: false, errorMessage: error);
  }
  
  void _onDateRangeChanged(DateTimeRange? dateRange) {
    add(DateRangeChanged(dateRange: dateRange));
  }

  void _onFilterChanged(FilterButtonState filterButtonState) {
    add(FilterButtonChanged());
  }
}
