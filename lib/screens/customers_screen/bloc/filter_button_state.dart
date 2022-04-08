part of 'filter_button_bloc.dart';

class FilterButtonState extends Equatable {
  final bool searchHistoric;
  final bool withTransactions;

  const FilterButtonState({required this.searchHistoric, required this.withTransactions});

  factory FilterButtonState.initial() {
    return const FilterButtonState(
      searchHistoric: true,
      withTransactions: true
    );
  }

  FilterButtonState update({bool? searchHistoric, bool? withTransactions}) {
    return FilterButtonState(
      searchHistoric: searchHistoric ?? this.searchHistoric,
      withTransactions: withTransactions ?? this.withTransactions
    );
  }

  @override
  List<Object?> get props => [searchHistoric, withTransactions];

  @override
  String toString() => 'FilterButtonState { searchHistoric: $searchHistoric, withTransactions: $withTransactions }';
}
