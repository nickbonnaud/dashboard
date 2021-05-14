import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/screens/customers_screen/bloc/filter_button_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Filter Button Bloc Tests", () {
    late FilterButtonBloc filterButtonBloc;
    late FilterButtonState baseState;

    setUp(() {
      filterButtonBloc = FilterButtonBloc();
      baseState = FilterButtonState.initial();
    });

    tearDown(() {
      filterButtonBloc.close();
    });

    test("Intial state of FilterButtonBloc is FilterButtonState.initial()", () {
      expect(filterButtonBloc.state, FilterButtonState.initial());
    });

    blocTest<FilterButtonBloc, FilterButtonState>(
      "SearchHistoricChanged event changes state: [searchHistoric: !searchHistoric]", 
      build: () => filterButtonBloc,
      act: (bloc) => bloc.add(SearchHistoricChanged()),
      expect: () => [baseState.update(searchHistoric: !baseState.searchHistoric)]
    );

    blocTest<FilterButtonBloc, FilterButtonState>(
      "WithTransactionsChanged event changes state: [withTransactions: !withTransactions]", 
      build: () => filterButtonBloc,
      act: (bloc) => bloc.add(WithTransactionsChanged()),
      expect: () => [baseState.update(withTransactions: !baseState.withTransactions)]
    );
  });
}