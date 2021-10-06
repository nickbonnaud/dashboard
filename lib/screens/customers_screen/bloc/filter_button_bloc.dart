import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'filter_button_event.dart';
part 'filter_button_state.dart';

class FilterButtonBloc extends Bloc<FilterButtonEvent, FilterButtonState> {
  FilterButtonBloc()
    : super(FilterButtonState.initial()) { _eventHandler(); }

  void _eventHandler() {
    on<SearchHistoricChanged>((event, emit) => _mapSearchHistoricChangedToState(emit: emit));
    on<WithTransactionsChanged>((event, emit) => _mapWithTransactionsChangedToState(emit: emit));
  }

  void _mapSearchHistoricChangedToState({required Emitter<FilterButtonState> emit}) async {
    emit(state.update(searchHistoric: !state.searchHistoric));
  }

  void _mapWithTransactionsChangedToState({required Emitter<FilterButtonState> emit}) async {
    emit(state.update(withTransactions: !state.withTransactions));
  }
}
