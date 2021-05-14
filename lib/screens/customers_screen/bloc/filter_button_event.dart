part of 'filter_button_bloc.dart';

abstract class FilterButtonEvent extends Equatable {
  const FilterButtonEvent();

  @override
  List<Object> get props => [];
}

class SearchHistoricChanged extends FilterButtonEvent {}

class WithTransactionsChanged extends FilterButtonEvent {}