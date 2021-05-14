import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/models/transaction_filter.dart';
import 'package:dashboard/screens/historic_transactions_screen/cubits/filter_button_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Filter Button Cubit Tests", () {
    late FilterButtonCubit filterButtonCubit;

    setUp(() {
      filterButtonCubit = FilterButtonCubit();
    });

    tearDown(() {
      filterButtonCubit.close();
    });

    test("Intial State of FilterButtonCubit is FilterType.all", () {
      expect(filterButtonCubit.state, FilterType.all);
    });

    blocTest<FilterButtonCubit, FilterType>(
      "filterChanged event emits a filterType",
      build: () => filterButtonCubit,
      act: (cubit) => cubit.filterChanged(filter: FilterType.transactionId),
      expect: () => [FilterType.transactionId]
    );
  });
}