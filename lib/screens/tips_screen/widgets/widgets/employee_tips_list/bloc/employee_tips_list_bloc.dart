import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dashboard/models/business/employee_tip.dart';
import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/repositories/tips_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/tips_screen/cubits/date_range_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'employee_tips_list_event.dart';
part 'employee_tips_list_state.dart';

class EmployeeTipsListBloc extends Bloc<EmployeeTipsListEvent, EmployeeTipsListState> {
  final TipsRepository _tipsRepository;

  late StreamSubscription _dateRangeStream;
  
  EmployeeTipsListBloc({required DateRangeCubit dateRangeCubit, required TipsRepository tipsRepository})
    : _tipsRepository = tipsRepository,
      super(EmployeeTipsListState.initial(currentDateRange: dateRangeCubit.state)) {
        _dateRangeStream = dateRangeCubit.stream.listen(_onDateRangeChanged);
      }

  @override
  Stream<EmployeeTipsListState> mapEventToState(EmployeeTipsListEvent event) async* {
    if (event is InitTipList) {
      yield* _mapInitTipListToState();
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
  
  Stream<EmployeeTipsListState> _mapInitTipListToState() async* {
    yield state.update(loading: true);

    try {
      final PaginateDataHolder paginateData = await _tipsRepository.fetchAll();
      yield* _handleSuccess(paginateData: paginateData);
    } on ApiException catch (exception) {
      yield* _handleError(error: exception.error);
    }
  }

  Stream<EmployeeTipsListState> _mapFetchAllToState() async* {
    yield* _startFetch();

    try {
      final PaginateDataHolder paginateData = await _tipsRepository.fetchAll(dateRange: state.currentDateRange);
      yield* _handleSuccess(paginateData: paginateData);
    } on ApiException catch (exception) {
      yield* _handleError(error: exception.error);
    }
  }

  Stream<EmployeeTipsListState> _mapFetchMoreToState() async* {
    if (!state.loading && !state.hasReachedEnd) {
      try {
        final PaginateDataHolder paginateData = await _tipsRepository.paginate(url: state.nextUrl!);
        yield* _handleSuccess(paginateData: paginateData);
      } on ApiException catch (exception) {
      yield* _handleError(error: exception.error);
    }
    }
  }

  Stream<EmployeeTipsListState> _mapDateRangeChangedToState({required DateRangeChanged event}) async* {
    final DateTimeRange? previousDateRange = state.currentDateRange;

    if (previousDateRange != event.dateRange) {
      yield state.update(currentDateRange: event.dateRange, isDateReset: event.dateRange == null);
      yield* _mapFetchAllToState();
    }
  }


  Stream<EmployeeTipsListState> _startFetch() async* {
    yield state.update(
      loading: true,
      tips: [],
      nextUrl: null,
      hasReachedEnd: true,
      errorMessage: '',
    );
  }

  Stream<EmployeeTipsListState> _handleSuccess({required PaginateDataHolder paginateData}) async* {
    yield state.update(
      loading: false,
      tips: state.tips + (paginateData.data as List<EmployeeTip>),
      nextUrl: paginateData.next,
      hasReachedEnd: paginateData.next == null
    );
  }

  Stream<EmployeeTipsListState> _handleError({required String error}) async* {
    yield state.update(loading: false, errorMessage: error); 
  }
  
  void _onDateRangeChanged(DateTimeRange? dateRange) {
    add(DateRangeChanged(dateRange: dateRange));
  }
}
