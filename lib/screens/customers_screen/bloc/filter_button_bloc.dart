import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'filter_button_event.dart';
part 'filter_button_state.dart';

class FilterButtonBloc extends Bloc<FilterButtonEvent, FilterButtonState> {
  FilterButtonBloc() : super(FilterButtonState.initial());

  @override
  Stream<FilterButtonState> mapEventToState(FilterButtonEvent event) async* {
    if (event is SearchHistoricChanged) {
      yield* _mapSearchHistoricChangedToState();
    } else if (event is WithTransactionsChanged) {
      yield* _mapWithTransactionsChangedToState();
    }
  }

  Stream<FilterButtonState> _mapSearchHistoricChangedToState() async* {
    yield state.update(searchHistoric: !state.searchHistoric);
  }

  Stream<FilterButtonState> _mapWithTransactionsChangedToState() async* {
    yield state.update(withTransactions: !state.withTransactions);
  }
}
