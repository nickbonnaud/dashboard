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
        _eventHandler();
        _dateRangeStream = dateRangeCubit.stream.listen(_onDateRangeChanged);
      }

  void _eventHandler() {
    on<InitTipList>((event, emit) => _mapInitTipListToState(emit: emit));
    on<FetchAll>((event, emit) => _mapFetchAllToState(emit: emit));
    on<FetchMore>((event, emit) => _mapFetchMoreToState(emit: emit));
    on<DateRangeChanged>((event, emit) => _mapDateRangeChangedToState(event: event, emit: emit));
  }

  @override
  Future<void> close() {
    _dateRangeStream.cancel();
    return super.close();
  }
  
  void _mapInitTipListToState({required Emitter<EmployeeTipsListState> emit}) async {
    emit(state.update(loading: true));

    try {
      final PaginateDataHolder paginateData = await _tipsRepository.fetchAll();
      _handleSuccess(paginateData: paginateData, emit: emit);
    } on ApiException catch (exception) {
      _handleError(error: exception.error, emit: emit);
    }
  }

  void _mapFetchAllToState({required Emitter<EmployeeTipsListState> emit}) async {
    _startFetch(emit: emit);

    try {
      final PaginateDataHolder paginateData = await _tipsRepository.fetchAll(dateRange: state.currentDateRange);
      _handleSuccess(paginateData: paginateData, emit: emit);
    } on ApiException catch (exception) {
      _handleError(error: exception.error, emit: emit);
    }
  }

  void _mapFetchMoreToState({required Emitter<EmployeeTipsListState> emit}) async {
    if (!state.loading && !state.hasReachedEnd) {
      try {
        final PaginateDataHolder paginateData = await _tipsRepository.paginate(url: state.nextUrl!);
        _handleSuccess(paginateData: paginateData, emit: emit);
      } on ApiException catch (exception) {
        _handleError(error: exception.error, emit: emit);
      }
    }
  }

  void _mapDateRangeChangedToState({required DateRangeChanged event, required Emitter<EmployeeTipsListState> emit}) async {
    final DateTimeRange? previousDateRange = state.currentDateRange;

    if (previousDateRange != event.dateRange) {
      emit(state.update(currentDateRange: event.dateRange, isDateReset: event.dateRange == null));
      _mapFetchAllToState(emit: emit);
    }
  }

  void _startFetch({required Emitter<EmployeeTipsListState> emit}) async {
    emit(state.update(
      loading: true,
      tips: [],
      nextUrl: null,
      hasReachedEnd: true,
      errorMessage: '',
    ));
  }

  void _handleSuccess({required PaginateDataHolder paginateData, required Emitter<EmployeeTipsListState> emit}) async {
    emit(state.update(
      loading: false,
      tips: state.tips + (paginateData.data as List<EmployeeTip>),
      nextUrl: paginateData.next,
      hasReachedEnd: paginateData.next == null
    ));
  }

  void _handleError({required String error, required Emitter<EmployeeTipsListState> emit}) async {
    emit(state.update(loading: false, errorMessage: error)); 
  }
  
  void _onDateRangeChanged(DateTimeRange? dateRange) {
    add(DateRangeChanged(dateRange: dateRange));
  }
}
