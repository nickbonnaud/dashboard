import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/models/transaction_filter.dart';
import 'package:dashboard/screens/historic_transactions_screen/cubits/filter_button_cubit.dart';
import 'package:dashboard/screens/historic_transactions_screen/widgets/bloc/transactions_list_bloc.dart';
import 'package:dashboard/screens/historic_transactions_screen/widgets/widgets/widgets/search_bar/widgets/search_field/widgets/id_search_field/bloc/id_search_field_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTransactionsListBloc extends Mock implements TransactionsListBloc {}
class MockFilterButtonCubit extends Mock implements FilterButtonCubit {}
class MockTransactionsListEvent extends Mock implements TransactionsListEvent {}

void main() {
  group("Id Search Field Bloc Tests", () {
    late TransactionsListBloc transactionsListBloc;
    late FilterButtonCubit filterButtonCubit;
    late IdSearchFieldBloc idSearchFieldBloc;

    late IdSearchFieldState baseState;

    late String _currentId;

    setUp(() {
      transactionsListBloc = MockTransactionsListBloc();
      filterButtonCubit = MockFilterButtonCubit();
      idSearchFieldBloc = IdSearchFieldBloc(transactionsListBloc: transactionsListBloc, filterButtonCubit: filterButtonCubit);
      baseState = idSearchFieldBloc.state;
      registerFallbackValue<TransactionsListEvent>(MockTransactionsListEvent());
    });

    tearDown(() {
      idSearchFieldBloc.close();
    });

    test("Initial state of IdSearchFieldBloc is IdSearchFieldState.initial()", () {
      expect(idSearchFieldBloc.state, IdSearchFieldState.initial());
    });

    blocTest<IdSearchFieldBloc, IdSearchFieldState>(
      "FieldChanged event changes state: [isFieldValid: false, currentId: currentId]",
      build: () => idSearchFieldBloc,
      wait: Duration(seconds: 1),
      act: (bloc) => bloc.add(FieldChanged(id: "453")),
      expect: () => [baseState.update(isFieldValid: false, currentId: "453")]
    );

    blocTest<IdSearchFieldBloc, IdSearchFieldState>(
      "FieldChanged event only calls transactionsListBloc.add when isFieldValid",
      build: () => idSearchFieldBloc,
      wait: Duration(seconds: 1),
      act: (bloc) {
        when(() => transactionsListBloc.add(any(that: isA<TransactionsListEvent>()))).thenReturn(null);
        bloc.add(FieldChanged(id: "453"));
      },
      verify: (_) {
        verifyNever(() => transactionsListBloc.add(any(that: isA<TransactionsListEvent>())));
      }
    );

    blocTest<IdSearchFieldBloc, IdSearchFieldState>(
      "FieldChanged event only calls transactionsListBloc.add when previousId != event.id",
      build: () => idSearchFieldBloc,
      seed: () {
        _currentId = "67b4655e-27c3-453a-b438-99c53d38735f";
        return IdSearchFieldState(isFieldValid: true, currentId: _currentId);
      },
      wait: Duration(seconds: 1),
      act: (bloc) {
        when(() => transactionsListBloc.add(any(that: isA<TransactionsListEvent>()))).thenReturn(null);
        bloc.add(FieldChanged(id: _currentId));
      },
      verify: (_) {
        verifyNever(() => transactionsListBloc.add(any(that: isA<TransactionsListEvent>())));
      }
    );

    blocTest<IdSearchFieldBloc, IdSearchFieldState>(
      "FieldChanged event calls transactionsListBloc.add when isFieldValid: true, currentId: event.id",
      build: () => idSearchFieldBloc,
      wait: Duration(seconds: 1),
      act: (bloc) {
        when(() => transactionsListBloc.add(any(that: isA<TransactionsListEvent>()))).thenReturn(null);
        when(() => filterButtonCubit.state).thenReturn(FilterType.customerId);
        bloc.add(FieldChanged(id: "67b4655e-27c3-453a-b438-99c53d38735f"));
      },
      verify: (_) {
        verify(() => transactionsListBloc.add(any(that: isA<TransactionsListEvent>()))).called(1);
      }
    );
  });
}