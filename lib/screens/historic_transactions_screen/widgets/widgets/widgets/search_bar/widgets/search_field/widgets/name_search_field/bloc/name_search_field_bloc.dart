import 'package:bloc/bloc.dart';
import 'package:dashboard/models/transaction_filter.dart';
import 'package:dashboard/resources/helpers/debouncer.dart';
import 'package:dashboard/resources/helpers/validators.dart';
import 'package:dashboard/screens/historic_transactions_screen/cubits/filter_button_cubit.dart';
import 'package:dashboard/screens/historic_transactions_screen/widgets/bloc/transactions_list_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'name_search_field_event.dart';
part 'name_search_field_state.dart';

class NameSearchFieldBloc extends Bloc<NameSearchFieldEvent, NameSearchFieldState> {
  final TransactionsListBloc _transactionsListBloc;
  final FilterButtonCubit _filterButtonCubit;
  
  NameSearchFieldBloc({required TransactionsListBloc transactionsListBloc, required FilterButtonCubit filterButtonCubit})
    : _transactionsListBloc = transactionsListBloc,
      _filterButtonCubit = filterButtonCubit,
      super(NameSearchFieldState.initial()) { _eventHandler(); }
  
  void _eventHandler() {
    on<NameChanged>((event, emit) => _mapNameChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: Duration(seconds: 1)));
    on<Reset>((event, emit) => _mapResetToState(emit: emit));
  }

  void _mapNameChangedToState({required NameChanged event, required Emitter<NameSearchFieldState> emit}) {
    final String previousFirstName = state.firstName;
    final String previousLastName = state.lastName;
    final bool isValidFirstName = Validators.isValidFirstName(name: event.firstName);
    final bool isValidLastName = Validators.isValidLastName(name: event.lastName);
    final bool firstNameChanged = previousFirstName != event.firstName;
    final bool lastNameChanged = previousLastName != event.lastName;

    emit(state.update(firstName: event.firstName, isFirstNameValid: isValidFirstName, lastName: event.lastName, isLastNameValid: isValidLastName));
    
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

  void _mapResetToState({required Emitter<NameSearchFieldState> emit}) {
    emit(NameSearchFieldState.initial());
  }

  void _updateQuery({@required String? firstName, @required String? lastName}) {
    _filterButtonCubit.state == FilterType.customerName
        ? _transactionsListBloc.add(FetchByCustomerName(firstName: firstName, lastName: lastName))
        : _transactionsListBloc.add(FetchByEmployeeName(firstName: firstName, lastName: lastName));
  }
}
