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
      _dateRangeStream = dateRangeCubit.stream.listen(_onDateRangeChanged);
      _filterButtonStream = filterButtonCubit.stream.listen(_onFilterChanged);
    }

  @override
  Stream<RefundsListState> mapEventToState(RefundsListEvent event) async* {
    if (event is Init) {
      yield* _mapInitToState();
    } else if (event is FetchAll) {
      yield* _mapFetchAllToState();
    } else if (event is FetchMore) {
      yield* _mapFetchMoreToState();
    } else if (event is FetchByRefundId) {
      yield* _mapFetchByRefundIdToState(refundId: event.refundId);
    } else if (event is FetchByTransactionId) {
      yield* _mapFetchByTransactionIdToState(transactionId: event.transactionId);
    } else if (event is FetchByCustomerId) {
      yield* _mapFetchByCustomerIdToState(customerId: event.customerId);
    } else if (event is FetchByCustomerName) {
      yield* _mapFetchByCustomerNameToState(customerName: FullName(first: event.firstName, last: event.lastName));
    } else if (event is DateRangeChanged) {
      yield* _mapDateRangeChangedToState(event: event);
    } else if (event is FilterChanged) {
      yield* _mapFilterChangedToState(event: event);
    }
  }

  @override
  Future<void> close() {
    _dateRangeStream.cancel();
    _filterButtonStream.cancel();
    return super.close();
  }

  Stream<RefundsListState> _mapInitToState() async* {
    yield state.update(loading: true);

    try {
      final PaginateDataHolder paginateData = await _refundRepository.fetchAll();
      yield* _handleSuccess(paginateData: paginateData);
    } on ApiException catch (exception) {
      yield* _handleError(error: exception.error);
    }
  }

  Stream<RefundsListState> _mapFetchAllToState() async* {
    yield* _startFetch();

    try {
      final PaginateDataHolder paginateData = await _refundRepository.fetchAll(dateRange: state.currentDateRange);
      yield* _handleSuccess(paginateData: paginateData);
    } on ApiException catch (exception) {
      yield* _handleError(error: exception.error);
    }
  }

  Stream<RefundsListState> _mapFetchMoreToState() async* {
    if (!state.loading && !state.paginating && !state.hasReachedEnd) {
      yield state.update(paginating: true);
      try {
        final PaginateDataHolder paginateData = await _refundRepository.paginate(url: state.nextUrl!);
        yield* _handleSuccess(paginateData: paginateData);
      } on ApiException catch (exception) {
        yield* _handleError(error: exception.error);
      }
    }
  }

  Stream<RefundsListState> _mapFetchByRefundIdToState({required String refundId}) async* {
    yield* _startFetch(currentIdQuery: refundId);

    try {
      final PaginateDataHolder paginateData = await _refundRepository.fetchByRefundId(refundId: refundId);
      yield* _handleSuccess(paginateData: paginateData);
    } on ApiException catch (exception) {
      yield* _handleError(error: exception.error);
    }
  }

  Stream<RefundsListState> _mapFetchByTransactionIdToState({required String transactionId}) async* {
    yield* _startFetch(currentIdQuery: transactionId);

    try {
      final PaginateDataHolder paginateData = await _refundRepository.fetchByTransactionId(transactionId: transactionId);
      yield* _handleSuccess(paginateData: paginateData);
    } on ApiException catch (exception) {
      yield* _handleError(error: exception.error);
    }
  }

  Stream<RefundsListState> _mapFetchByCustomerIdToState({required String customerId}) async* {
    yield* _startFetch(currentIdQuery: customerId);

    try {
      final PaginateDataHolder paginateData = await _refundRepository.fetchByCustomerId(customerId: customerId, dateRange: state.currentDateRange);
      yield* _handleSuccess(paginateData: paginateData);
    } on ApiException catch (exception) {
      yield* _handleError(error: exception.error);
    }
  }

  Stream<RefundsListState> _mapFetchByCustomerNameToState({required FullName customerName}) async* {
    yield* _startFetch(currentNameQuery: customerName);

    try {
      final PaginateDataHolder paginateData = await _refundRepository.fetchByCustomerName(firstName: customerName.first, lastName: customerName.last, dateRange: state.currentDateRange);
      yield* _handleSuccess(paginateData: paginateData);
    } on ApiException catch (exception) {
      yield* _handleError(error: exception.error);
    }
  }

  Stream<RefundsListState> _mapDateRangeChangedToState({required DateRangeChanged event}) async* {
    final DateTimeRange? previousDateRange = state.currentDateRange;

    if (previousDateRange != event.dateRange) {
      yield state.update(currentDateRange: event.dateRange, isDateReset: event.dateRange == null);
      switch (state.currentFilter) {
        case FilterType.refundId:
          yield* _mapFetchByRefundIdToState(refundId: state.currentIdQuery!);
          break;
        case FilterType.transactionId:
          yield* _mapFetchByTransactionIdToState(transactionId: state.currentIdQuery!);
          break;
        case FilterType.customerId:
          yield* _mapFetchByCustomerIdToState(customerId: state.currentIdQuery!);
          break;
        case FilterType.customerName:
          yield* _mapFetchByCustomerNameToState(customerName: state.currentNameQuery!);
          break;
        default:
          yield* _mapFetchAllToState();
      }
    }
  }

  Stream<RefundsListState> _mapFilterChangedToState({required FilterChanged event}) async* {
    if (event.filter == FilterType.all) {
      yield state.update(currentFilter: event.filter, isDateReset: true);
      yield* _mapFetchAllToState();
    } else {
      yield state.update(currentFilter: event.filter);
    }
  }

  Stream<RefundsListState> _startFetch({String? currentIdQuery, FullName? currentNameQuery}) async* {
    yield state.reset(currentIdQuery: currentIdQuery, currentNameQuery: currentNameQuery);
  }
  
  Stream<RefundsListState> _handleSuccess({required PaginateDataHolder paginateData}) async* {
    yield state.update(
      loading: false,
      paginating: false,
      refunds: state.refunds + (paginateData.data as List<RefundResource>),
      nextUrl: paginateData.next,
      hasReachedEnd: paginateData.next == null
    );
  }

  Stream<RefundsListState> _handleError({required String error}) async* {
    yield state.update(loading: false, paginating: false, errorMessage: error); 
  }
  
  void _onDateRangeChanged(DateTimeRange? dateRange) {
    add(DateRangeChanged(dateRange: dateRange));
  }

  void _onFilterChanged(FilterType filter) {
    add(FilterChanged(filter: filter));
  }
}
