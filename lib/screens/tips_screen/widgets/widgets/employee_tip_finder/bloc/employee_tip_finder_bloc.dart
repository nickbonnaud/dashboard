import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dashboard/models/business/employee_tip.dart';
import 'package:dashboard/repositories/tips_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/tips_screen/cubits/date_range_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'employee_tip_finder_event.dart';
part 'employee_tip_finder_state.dart';

class EmployeeTipFinderBloc extends Bloc<EmployeeTipFinderEvent, EmployeeTipFinderState> {
  final TipsRepository _tipsRepository;
  
  late StreamSubscription _dateRangeStream;
  
  EmployeeTipFinderBloc({required DateRangeCubit dateRangeCubit, required TipsRepository tipsRepository})
    : _tipsRepository = tipsRepository,
      super(EmployeeTipFinderState.initial(currentDateRange: dateRangeCubit.state)) {
        _eventHandler();
        _dateRangeStream = dateRangeCubit.stream.listen(_onDateRangeChanged);
      }
  
  void _eventHandler() {
    on<Fetch>((event, emit) async => await _mapFetchToState(emit: emit, firstName: event.firstName, lastName: event.lastName));
    on<DateRangeChanged>((event, emit) => _mapDateRangeChangedToState(event: event, emit: emit));
  }

  String get employeeFirstName => state.currentFirstName;
  String get employeeLastName => state.currentLastName;

  @override
  Future<void> close() {
    _dateRangeStream.cancel();
    return super.close();
  }

  Future<void> _mapFetchToState({required Emitter<EmployeeTipFinderState> emit, @required String? firstName, @required String? lastName}) async {
    _startFetch(emit: emit, firstName: firstName, lastName: lastName);

    try {
      final List<EmployeeTip> employeeTips = await _tipsRepository.fetchByCustomerName(firstName: firstName, lastName: lastName, dateRange: state.currentDateRange);
      _handleSuccess(employeeTips: employeeTips, emit: emit);
    } on ApiException catch (exception) {
      _handleError(error: exception.error, emit: emit);
    }
  }

  void _mapDateRangeChangedToState({required DateRangeChanged event, required Emitter<EmployeeTipFinderState> emit}) {
    final DateTimeRange? previousDateRange = state.currentDateRange;
    
    if (previousDateRange != event.dateRange && (state.currentFirstName.isNotEmpty || state.currentLastName.isNotEmpty)) {
      emit(state.update(currentDateRange: event.dateRange, isDateReset: event.dateRange == null));

      add(Fetch(firstName: state.currentFirstName, lastName: state.currentLastName));
    }
  }
  
  void _startFetch({required Emitter<EmployeeTipFinderState> emit, @required String? firstName, @required String? lastName}) {
    emit(state.update(
      loading: true,
      tips: [],
      errorMessage: "",
      currentFirstName: firstName,
      currentLastName: lastName
    ));
  }

  void _handleSuccess({required List<EmployeeTip> employeeTips, required Emitter<EmployeeTipFinderState> emit}) {
    emit(state.update(
      loading: false,
      tips: employeeTips,
    ));
  }

  void _handleError({required String error, required Emitter<EmployeeTipFinderState> emit}) {
    emit(state.update(loading: false, errorMessage: error));
  }
  
  void _onDateRangeChanged(DateTimeRange? dateRange) {
    add(DateRangeChanged(dateRange: dateRange));
  } 
}
