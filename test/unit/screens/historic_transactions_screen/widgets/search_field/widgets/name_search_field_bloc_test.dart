import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/models/transaction_filter.dart';
import 'package:dashboard/resources/helpers/validators.dart';
import 'package:dashboard/screens/historic_transactions_screen/cubits/filter_button_cubit.dart';
import 'package:dashboard/screens/historic_transactions_screen/widgets/bloc/transactions_list_bloc.dart';
import 'package:dashboard/screens/historic_transactions_screen/widgets/widgets/widgets/search_bar/widgets/search_field/widgets/name_search_field/bloc/name_search_field_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTransactionsListBloc extends Mock implements TransactionsListBloc {}
class MockFilterButtonCubit extends Mock implements FilterButtonCubit {}
class MockTransactionsListEvent extends Mock implements TransactionsListEvent {}

void main() {
  group("Name Search Field Bloc Tests", () {
    late TransactionsListBloc transactionsListBloc;
    late FilterButtonCubit filterButtonCubit;
    late NameSearchFieldBloc nameSearchFieldBloc;

    late NameSearchFieldState baseState;

    late String _firstName;
    late String _lastName;

    setUp(() {
      transactionsListBloc = MockTransactionsListBloc();
      filterButtonCubit = MockFilterButtonCubit();
      nameSearchFieldBloc = NameSearchFieldBloc(transactionsListBloc: transactionsListBloc, filterButtonCubit: filterButtonCubit);
      baseState = nameSearchFieldBloc.state;
      registerFallbackValue(MockTransactionsListEvent());
    });

    tearDown(() {
      nameSearchFieldBloc.close();
    });

    test("Initial state of NameSearchFieldBloc is NameSearchFieldState.initial()", () {
      expect(nameSearchFieldBloc.state, NameSearchFieldState.initial());
    });

    blocTest<NameSearchFieldBloc, NameSearchFieldState>(
      "NameChanged event changes state: [firstName: first, isFirstNameValid: isFirstNameValid, lastName: lastName, isLastNameValid: isLastNameValid]",
      build: () => nameSearchFieldBloc,
      wait: Duration(seconds: 1),
      act: (bloc) {
        when(() => filterButtonCubit.state).thenReturn(FilterType.customerName);
        when(() => transactionsListBloc.add(any(that: isA<TransactionsListEvent>()))).thenReturn(null);
        _firstName = "a";
        _lastName = "m";
        bloc.add(NameChanged(firstName: _firstName, lastName: _lastName));
      },
      expect: () => [baseState.update(firstName: _firstName, lastName: _lastName, isFirstNameValid: Validators.isValidFirstName(name: _firstName), isLastNameValid: Validators.isValidLastName(name: _lastName))]
    );

    blocTest<NameSearchFieldBloc, NameSearchFieldState>(
      "NameChanged event does not call TransactionsListBloc.add() if invalid first and last name",
      build: () => nameSearchFieldBloc,
      wait: Duration(seconds: 1),
      act: (bloc) {
        when(() => filterButtonCubit.state).thenReturn(FilterType.customerName);
        when(() => transactionsListBloc.add(any(that: isA<TransactionsListEvent>()))).thenReturn(null);
        _firstName = "a";
        _lastName = "m";
        bloc.add(NameChanged(firstName: _firstName, lastName: _lastName));
      },
      verify: (_) {
        verifyNever(() => transactionsListBloc.add(any(that: isA<TransactionsListEvent>())));
      }
    );

    blocTest<NameSearchFieldBloc, NameSearchFieldState>(
      "NameChanged event calls TransactionsListBloc.add() if valid first and invalid last name",
      build: () => nameSearchFieldBloc,
      wait: Duration(seconds: 1),
      act: (bloc) {
        when(() => filterButtonCubit.state).thenReturn(FilterType.customerName);
        when(() => transactionsListBloc.add(any(that: isA<TransactionsListEvent>()))).thenReturn(null);
        _firstName = "andrew";
        _lastName = "m";
        bloc.add(NameChanged(firstName: _firstName, lastName: _lastName));
      },
      verify: (_) {
        verify(() => transactionsListBloc.add(any(that: isA<TransactionsListEvent>()))).called(1);
      }
    );

    blocTest<NameSearchFieldBloc, NameSearchFieldState>(
      "NameChanged event calls TransactionsListBloc.add() if invalid first and valid last name",
      build: () => nameSearchFieldBloc,
      wait: Duration(seconds: 1),
      act: (bloc) {
        when(() => filterButtonCubit.state).thenReturn(FilterType.customerName);
        when(() => transactionsListBloc.add(any(that: isA<TransactionsListEvent>()))).thenReturn(null);
        _firstName = "a";
        _lastName = "may";
        bloc.add(NameChanged(firstName: _firstName, lastName: _lastName));
      },
      verify: (_) {
        verify(() => transactionsListBloc.add(any(that: isA<TransactionsListEvent>()))).called(1);
      }
    );

    blocTest<NameSearchFieldBloc, NameSearchFieldState>(
      "NameChanged event calls TransactionsListBloc.add() if valid first and valid last name",
      build: () => nameSearchFieldBloc,
      wait: Duration(seconds: 1),
      act: (bloc) {
        when(() => filterButtonCubit.state).thenReturn(FilterType.customerName);
        when(() => transactionsListBloc.add(any(that: isA<TransactionsListEvent>()))).thenReturn(null);
        _firstName = "andrew";
        _lastName = "may";
        bloc.add(NameChanged(firstName: _firstName, lastName: _lastName));
      },
      verify: (_) {
        verify(() => transactionsListBloc.add(any(that: isA<TransactionsListEvent>()))).called(1);
      }
    );

    blocTest<NameSearchFieldBloc, NameSearchFieldState>(
      "Reset event changes state to NameSearchFieldState.initial()",
      build: () => nameSearchFieldBloc,
      act: (bloc) => bloc.add(Reset()),
      expect: () => [NameSearchFieldState.initial()]
    );
  });
}