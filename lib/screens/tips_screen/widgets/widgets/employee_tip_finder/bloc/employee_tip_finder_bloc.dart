import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dashboard/models/business/employee_tip.dart';
import 'package:dashboard/repositories/tips_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/tips_screen/cubits/date_range_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'employee_tip_finder_event.dart';
part 'employee_tip_finder_state.dart';

class EmployeeTipFinderBloc extends Bloc<EmployeeTipFinderEvent, EmployeeTipFinderState> {
  final TipsRepository _tipsRepository;
  
  late StreamSubscription _dateRangeStream;
  
  EmployeeTipFinderBloc({required DateRangeCubit dateRangeCubit, required TipsRepository tipsRepository})
    : _tipsRepository = tipsRepository,
      super(EmployeeTipFinderState.initial(currentDateRange: dateRangeCubit.state)) {
        _dateRangeStream = dateRangeCubit.stream.listen(_onDateRangeChanged);
      }
  
  @override
  Stream<EmployeeTipFinderState> mapEventToState(EmployeeTipFinderEvent event) async* {
    if (event is Fetch) {
      yield* _mapFetchToState(firstName: event.firstName, lastName: event.lastName);
    } else if (event is DateRangeChanged) {
      yield* _mapDateRangeChangedToState(event: event);
    }
  }

  String get employeeFirstName => state.currentFirstName;
  String get employeeLastName => state.currentLastName;

  @override
  Future<void> close() {
    _dateRangeStream.cancel();
    return super.close();
  }

  Stream<EmployeeTipFinderState> _mapFetchToState({@required String? firstName, @required String? lastName}) async* {
    yield* _startFetch(firstName: firstName, lastName: lastName);

    try {
      final List<EmployeeTip> employeeTips = await _tipsRepository.fetchByCustomerName(firstName: firstName, lastName: lastName, dateRange: state.currentDateRange);
      yield* _handleSuccess(employeeTips: employeeTips);
    } on ApiException catch (exception) {
      yield* _handleError(error: exception.error);
    }
  }

  Stream<EmployeeTipFinderState> _mapDateRangeChangedToState({required DateRangeChanged event}) async* {
    final DateTimeRange? previousDateRange = state.currentDateRange;
    
    if (previousDateRange != event.dateRange && (state.currentFirstName.isNotEmpty || state.currentLastName.isNotEmpty)) {
      yield state.update(currentDateRange: event.dateRange, isDateReset: event.dateRange == null);

      yield* _mapFetchToState(firstName: state.currentFirstName, lastName: state.currentLastName);
    }
  }
  
  Stream<EmployeeTipFinderState> _startFetch({@required String? firstName, @required String? lastName}) async* {
    yield state.update(
      loading: true,
      tips: [],
      errorMessage: "",
      currentFirstName: firstName,
      currentLastName: lastName
    );
  }

  Stream<EmployeeTipFinderState> _handleSuccess({required List<EmployeeTip> employeeTips}) async* {
    yield state.update(
      loading: false,
      tips: employeeTips,
    );
  }

  Stream<EmployeeTipFinderState> _handleError({required String error}) async* {
    yield state.update(loading: false, errorMessage: error);
  }
  
  void _onDateRangeChanged(DateTimeRange? dateRange) {
    add(DateRangeChanged(dateRange: dateRange));
  } 
}
