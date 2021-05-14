import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dashboard/models/transaction_filter.dart';
import 'package:dashboard/resources/helpers/validators.dart';
import 'package:dashboard/screens/historic_transactions_screen/cubits/filter_button_cubit.dart';
import 'package:dashboard/screens/historic_transactions_screen/widgets/bloc/transactions_list_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

part 'name_search_field_event.dart';
part 'name_search_field_state.dart';

class NameSearchFieldBloc extends Bloc<NameSearchFieldEvent, NameSearchFieldState> {
  final TransactionsListBloc _transactionsListBloc;
  final FilterButtonCubit _filterButtonCubit;
  
  NameSearchFieldBloc({required TransactionsListBloc transactionsListBloc, required FilterButtonCubit filterButtonCubit})
    : _transactionsListBloc = transactionsListBloc,
      _filterButtonCubit = filterButtonCubit,
      super(NameSearchFieldState.initial());
  
  @override
  Stream<Transition<NameSearchFieldEvent, NameSearchFieldState>> transformEvents(Stream<NameSearchFieldEvent> events, transitionFn) {
    final nonDebounceStream = events.where((event) => event is Reset);
    final debounceStream = events.where((event) => event is !Reset).debounceTime(Duration(seconds: 1));
    return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), transitionFn);
  }
  
  @override
  Stream<NameSearchFieldState> mapEventToState(NameSearchFieldEvent event) async* {
    if (event is NameChanged) {
      yield* _mapNameChangedToState(event: event);
    } else if (event is Reset) {
      yield* _mapResetToState();
    }
  }

  Stream<NameSearchFieldState> _mapNameChangedToState({required NameChanged event}) async* {
    final String previousFirstName = state.firstName;
    final String previousLastName = state.lastName;
    final bool isValidFirstName = Validators.isValidFirstName(name: event.firstName);
    final bool isValidLastName = Validators.isValidLastName(name: event.lastName);
    final bool firstNameChanged = previousFirstName != event.firstName;
    final bool lastNameChanged = previousLastName != event.lastName;

    yield state.update(firstName: event.firstName, isFirstNameValid: isValidFirstName, lastName: event.lastName, isLastNameValid: isValidLastName);
    
    if (firstNameChanged && (isValidFirstName || event.firstName.length == 0)) {
      final String? lastName = isValidLastName ? event.lastName : null;
      
      if (isValidFirstName || isValidLastName) {
        _updateQuery(firstName: event.firstName, lastName: lastName);
      }
    } else if (lastNameChanged && (isValidLastName || event.lastName.length ==0)) {
      final String? firstName = isValidFirstName ? event.firstName : null;
      
      if (isValidFirstName || isValidLastName) {
        _updateQuery(firstName: firstName, lastName: event.lastName);
      }
    }
  }

  Stream<NameSearchFieldState> _mapResetToState() async* {
    yield NameSearchFieldState.initial();
  }

  void _updateQuery({@required String? firstName, @required String? lastName}) {
    _filterButtonCubit.state == FilterType.customerName
        ? _transactionsListBloc.add(FetchByCustomerName(firstName: firstName, lastName: lastName))
        : _transactionsListBloc.add(FetchByEmployeeName(firstName: firstName, lastName: lastName));
  }
}
