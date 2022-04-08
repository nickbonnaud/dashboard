import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/models/transaction/transaction_resource.dart';
import 'package:dashboard/models/transaction_filter.dart';
import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/historic_transactions_screen/cubits/date_range_cubit.dart';
import 'package:dashboard/screens/historic_transactions_screen/cubits/filter_button_cubit.dart';
import 'package:dashboard/screens/historic_transactions_screen/widgets/bloc/transactions_list_bloc.dart';
import 'package:dashboard/screens/historic_transactions_screen/widgets/models/full_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}
class MockTransaction extends Mock implements TransactionResource {}

void main() {
  group("Transactions List Bloc Tests", () {
    late TransactionRepository transactionRepository;
    late FilterButtonCubit filterButtonCubit;
    late DateRangeCubit dateRangeCubit;
    late TransactionsListBloc transactionsListBloc;
    
    late TransactionsListState baseState;

    List<TransactionResource> _generateTransactions({int numTransactions = 10}) {
      return List.generate(numTransactions, (index) => MockTransaction());
    }

    late List<TransactionResource> _transactionsList;
    late List<TransactionResource> _previousTransactionsList;
    late DateTimeRange _dateRange;

    setUp(() {
      transactionRepository = MockTransactionRepository();
      filterButtonCubit = FilterButtonCubit();
      dateRangeCubit = DateRangeCubit();
      baseState = TransactionsListState.initial(currentFilter: filterButtonCubit.state, currentDateRange: dateRangeCubit.state);
      transactionsListBloc = TransactionsListBloc(
        transactionRepository: transactionRepository,
        filterButtonCubit: filterButtonCubit,
        dateRangeCubit: dateRangeCubit
      );
    });

    tearDown(() {
      filterButtonCubit.close();
      dateRangeCubit.close();
      transactionsListBloc.close();
    });

    test("Initial state of TransactionsListBloc is TransactionsListState.initial()", () {
      expect(transactionsListBloc.state, TransactionsListState.initial(currentFilter: filterButtonCubit.state, currentDateRange: dateRangeCubit.state));
    });

    blocTest<TransactionsListBloc, TransactionsListState>(
      "Init event changes state: [loading: true], [loading: false, transactions: List<MockTransactions>, nextUrl: next, hasReachedEnd: false]",
      build: () => transactionsListBloc,
      act: (bloc) {
        _transactionsList = _generateTransactions();
        when(() => transactionRepository.fetchAll()).thenAnswer((_) async => PaginateDataHolder(data: _transactionsList, next: "next"));
        bloc.add(Init());
      },
      expect: () => [baseState.update(loading: true), baseState.update(loading: false, transactions: _transactionsList, nextUrl: "next", hasReachedEnd: false)]
    );

    blocTest<TransactionsListBloc, TransactionsListState>(
      "Init event calls transactionRepository.fetchAll()",
      build: () => transactionsListBloc,
      act: (bloc) {
        _transactionsList = _generateTransactions();
        when(() => transactionRepository.fetchAll()).thenAnswer((_) async => PaginateDataHolder(data: _transactionsList, next: "next"));
        bloc.add(Init());
      },
      verify: (_) {
        verify(() => transactionRepository.fetchAll()).called(1);
      }
    );

    blocTest<TransactionsListBloc, TransactionsListState>(
      "Init event on error changes state: [loading: true], [loading: false, errorMessage: error]",
      build: () => transactionsListBloc,
      act: (bloc) {
        _transactionsList = _generateTransactions();
        when(() => transactionRepository.fetchAll()).thenThrow(const ApiException(error: "error"));
        bloc.add(Init());
      },
      expect: () => [baseState.update(loading: true), baseState.update(loading: false, errorMessage: "error")]
    );

    blocTest<TransactionsListBloc, TransactionsListState>(
      "FetchAll event changes state: [TransactionsListState.reset()], [loading: false, transactions: List<MockTransactions>, nextUrl: next, hasReachedEnd: false]",
      build: () => transactionsListBloc,
      seed: () => baseState.update(transactions: _generateTransactions(numTransactions: 4), nextUrl: null, hasReachedEnd: true, errorMessage: "error"),
      act: (bloc) {
        _transactionsList = _generateTransactions();
        when(() => transactionRepository.fetchAll(dateRange: baseState.currentDateRange))
          .thenAnswer((_) async => PaginateDataHolder(data: _transactionsList, next: "next"));
        bloc.add(FetchAll());
      },
      expect: () {
        TransactionsListState firstState = baseState.reset(currentIdQuery: baseState.currentIdQuery, currentNameQuery: baseState.currentNameQuery);
        TransactionsListState secondState = firstState.update(loading: false, transactions: _transactionsList, nextUrl: "next", hasReachedEnd: false);
        return [firstState, secondState];
      }
    );

    blocTest<TransactionsListBloc, TransactionsListState>(
      "FetchAll event calls transactionRepository.fetchAll()",
      build: () => transactionsListBloc,
      seed: () => baseState.update(transactions: _generateTransactions(numTransactions: 4), nextUrl: null, hasReachedEnd: true, errorMessage: "error"),
      act: (bloc) {
        _transactionsList = _generateTransactions();
        when(() => transactionRepository.fetchAll(dateRange: baseState.currentDateRange))
          .thenAnswer((_) async => PaginateDataHolder(data: _transactionsList, next: "next"));
        bloc.add(FetchAll());
      },
      verify: (_) {
        verify(() => transactionRepository.fetchAll(dateRange: baseState.currentDateRange)).called(1);
      }
    );

    blocTest<TransactionsListBloc, TransactionsListState>(
      "FetchAll event on error changes state: [TransactionsListState.reset()], [loading: false, errorMessage: error]",
      build: () => transactionsListBloc,
      seed: () => baseState.update(transactions: _generateTransactions(numTransactions: 4), nextUrl: null, hasReachedEnd: true, errorMessage: "error"),
      act: (bloc) {
        _transactionsList = _generateTransactions();
        when(() => transactionRepository.fetchAll(dateRange: baseState.currentDateRange))
          .thenThrow(const ApiException(error: "error"));
        bloc.add(FetchAll());
      },
      expect: () {
        TransactionsListState firstState = baseState.reset(currentIdQuery: baseState.currentIdQuery, currentNameQuery: baseState.currentNameQuery);
        TransactionsListState secondState = firstState.update(loading: false, errorMessage: "error");
        return [firstState, secondState];
      }
    );

    blocTest<TransactionsListBloc, TransactionsListState>(
      "FetchMoreTransactions event changes state: [paginating: true] [loading: false, transactions: List<MockTransactions>, nextUrl: null, hasReachedEnd: true, paginating: false]",
      build: () => transactionsListBloc,
      seed: () {
        _transactionsList =_generateTransactions();
        baseState = baseState.update(transactions: _transactionsList, nextUrl: "nextUrl", hasReachedEnd: false);
        return baseState;
      },
      act: (bloc) {
        List<TransactionResource> paginatedTransactions = _generateTransactions();
        _transactionsList = _transactionsList + paginatedTransactions;
        when(() => transactionRepository.paginate(url: any(named: 'url')))
          .thenAnswer((_) async => PaginateDataHolder(data: paginatedTransactions, next: null));
        bloc.add(FetchMoreTransactions());
      },
      expect: () {
        var firstState = baseState.update(paginating: true);
        var secondState = firstState.update(transactions: _transactionsList, nextUrl: null, hasReachedEnd: true, paginating: false);
        return [firstState, secondState];
      }
    );

    blocTest<TransactionsListBloc, TransactionsListState>(
      "FetchMoreTransactions event calls transactionRepository.paginate()",
      build: () => transactionsListBloc,
      seed: () {
        _transactionsList =_generateTransactions();
        return baseState.update(transactions: _transactionsList, nextUrl: "nextUrl", hasReachedEnd: false);
      },
      act: (bloc) {
        List<TransactionResource> paginatedTransactions = _generateTransactions();
        _transactionsList = _transactionsList + paginatedTransactions;
        when(() => transactionRepository.paginate(url: any(named: 'url')))
          .thenAnswer((_) async => PaginateDataHolder(data: paginatedTransactions, next: null));
        bloc.add(FetchMoreTransactions());
      },
      verify: (_) {
        verify(() => transactionRepository.paginate(url: any(named: "url"))).called(1);
      }
    );

    blocTest<TransactionsListBloc, TransactionsListState>(
      "FetchMoreTransactions event on error changes state: [paginating: true] [loading: false, errorMessage: error, paginating: false]",
      build: () => transactionsListBloc,
      seed: () {
        _transactionsList =_generateTransactions();
        baseState = baseState.update(transactions: _transactionsList, nextUrl: "nextUrl", hasReachedEnd: false);
        return baseState;
      },
      act: (bloc) {
        when(() => transactionRepository.paginate(url: any(named: 'url')))
          .thenThrow(const ApiException(error: "error"));
        bloc.add(FetchMoreTransactions());
      },
      expect: () {
        var firstState = baseState.update(paginating: true);
        var secondState = firstState.update(transactions: _transactionsList,nextUrl: "nextUrl", hasReachedEnd: false, errorMessage: "error", paginating: false);
        return [firstState, secondState];
      }
    );

    blocTest<TransactionsListBloc, TransactionsListState>(
      "FetchByStatus event changes state: [TransactionsListState.reset(currentIdQuery: code.toString())], [loading: false, transactions: List<MockTransactions>, nextUrl: next, hasReachedEnd: false]",
      build: () => transactionsListBloc,
      seed: () => baseState.update(transactions: _generateTransactions(numTransactions: 4), nextUrl: null, hasReachedEnd: true, errorMessage: "error"),
      act: (bloc) {
        _transactionsList = _generateTransactions();
        when(() => transactionRepository.fetchByCode(code: any(named: "code")))
          .thenAnswer((_) async => PaginateDataHolder(data: _transactionsList, next: "next"));
        bloc.add(const FetchByStatus(code: 200));
      },
      expect: () {
        TransactionsListState firstState = baseState.reset(currentIdQuery: 200.toString(), currentNameQuery: baseState.currentNameQuery);
        TransactionsListState secondState = firstState.update(loading: false, transactions: _transactionsList, nextUrl: "next", hasReachedEnd: false);
        return [firstState, secondState];
      }
    );

    blocTest<TransactionsListBloc, TransactionsListState>(
      "FetchByStatus event calls transactionRepository.fetchByCode()",
      build: () => transactionsListBloc,
      seed: () => baseState.update(transactions: _generateTransactions(numTransactions: 4), nextUrl: null, hasReachedEnd: true, errorMessage: "error"),
      act: (bloc) {
        _transactionsList = _generateTransactions();
        when(() => transactionRepository.fetchByCode(code: any(named: "code")))
          .thenAnswer((_) async => PaginateDataHolder(data: _transactionsList, next: "next"));
        bloc.add(const FetchByStatus(code: 200));
      },
      verify: (_) {
        verify(() => transactionRepository.fetchByCode(code: any(named: "code"))).called(1);
      }
    );

    blocTest<TransactionsListBloc, TransactionsListState>(
      "FetchByStatus event on error changes state: [TransactionsListState.reset(currentIdQuery: code.toString())], [loading: false, errorMessage: error]",
      build: () => transactionsListBloc,
      seed: () => baseState.update(transactions: _generateTransactions(numTransactions: 4), nextUrl: null, hasReachedEnd: true, errorMessage: "error"),
      act: (bloc) {
        when(() => transactionRepository.fetchByCode(code: any(named: "code")))
          .thenThrow(const ApiException(error: "error"));
        bloc.add(const FetchByStatus(code: 200));
      },
      expect: () {
        TransactionsListState firstState = baseState.reset(currentIdQuery: 200.toString(), currentNameQuery: baseState.currentNameQuery);
        TransactionsListState secondState = firstState.update(loading: false, errorMessage: "error");
        return [firstState, secondState];
      }
    );

    blocTest<TransactionsListBloc, TransactionsListState>(
      "FetchByCustomerId event changes state: [TransactionsListState.reset(currentIdQuery: customerId)], [loading: false, transactions: List<MockTransactions>, nextUrl: next, hasReachedEnd: false]",
      build: () => transactionsListBloc,
      seed: () => baseState.update(transactions: _generateTransactions(numTransactions: 4), nextUrl: null, hasReachedEnd: true, errorMessage: "error"),
      act: (bloc) {
        _transactionsList = _generateTransactions();
        when(() => transactionRepository.fetchByCustomerId(customerId: any(named: "customerId")))
          .thenAnswer((_) async => PaginateDataHolder(data: _transactionsList, next: "next"));
        bloc.add(const FetchByCustomerId(customerId: "customerId"));
      },
      expect: () {
        TransactionsListState firstState = baseState.reset(currentIdQuery: "customerId", currentNameQuery: baseState.currentNameQuery);
        TransactionsListState secondState = firstState.update(loading: false, transactions: _transactionsList, nextUrl: "next", hasReachedEnd: false);
        return [firstState, secondState];
      }
    );

    blocTest<TransactionsListBloc, TransactionsListState>(
      "FetchByCustomerId event calls transactionRepository.fetchByCustomerId()",
      build: () => transactionsListBloc,
      seed: () => baseState.update(transactions: _generateTransactions(numTransactions: 4), nextUrl: null, hasReachedEnd: true, errorMessage: "error"),
      act: (bloc) {
        _transactionsList = _generateTransactions();
        when(() => transactionRepository.fetchByCustomerId(customerId: any(named: "customerId")))
          .thenAnswer((_) async => PaginateDataHolder(data: _transactionsList, next: "next"));
        bloc.add(const FetchByCustomerId(customerId: "customerId"));
      },
      verify: (_) {
        verify(() => transactionRepository.fetchByCustomerId(customerId: any(named: "customerId"))).called(1);
      }
    );

    blocTest<TransactionsListBloc, TransactionsListState>(
      "FetchByCustomerId event on error changes state: [TransactionsListState.reset(currentIdQuery: customerId)], [loading: false, errorMessage: error]",
      build: () => transactionsListBloc,
      seed: () => baseState.update(transactions: _generateTransactions(numTransactions: 4), nextUrl: null, hasReachedEnd: true, errorMessage: "error"),
      act: (bloc) {
        when(() => transactionRepository.fetchByCustomerId(customerId: any(named: "customerId")))
          .thenThrow(const ApiException(error: "error"));
        bloc.add(const FetchByCustomerId(customerId: "customerId"));
      },
      expect: () {
        TransactionsListState firstState = baseState.reset(currentIdQuery: "customerId", currentNameQuery: baseState.currentNameQuery);
        TransactionsListState secondState = firstState.update(loading: false, errorMessage: "error");
        return [firstState, secondState];
      }
    );

    blocTest<TransactionsListBloc, TransactionsListState>(
      "FetchByTransactionId event changes state: [TransactionsListState.reset(currentIdQuery: transactionId)], [loading: false, transactions: List<MockTransactions>, nextUrl: next, hasReachedEnd: false]",
      build: () => transactionsListBloc,
      seed: () => baseState.update(transactions: _generateTransactions(numTransactions: 4), nextUrl: null, hasReachedEnd: true, errorMessage: "error"),
      act: (bloc) {
        _transactionsList = _generateTransactions();
        when(() => transactionRepository.fetchByTransactionId(transactionId: any(named: "transactionId")))
          .thenAnswer((_) async => PaginateDataHolder(data: _transactionsList, next: "next"));
        bloc.add(const FetchByTransactionId(transactionId: "transactionId"));
      },
      expect: () {
        TransactionsListState firstState = baseState.reset(currentIdQuery: "transactionId", currentNameQuery: baseState.currentNameQuery);
        TransactionsListState secondState = firstState.update(loading: false, transactions: _transactionsList, nextUrl: "next", hasReachedEnd: false);
        return [firstState, secondState];
      }
    );

    blocTest<TransactionsListBloc, TransactionsListState>(
      "FetchByTransactionId event calls transactionRepository.fetchByTransactionId()",
      build: () => transactionsListBloc,
      seed: () => baseState.update(transactions: _generateTransactions(numTransactions: 4), nextUrl: null, hasReachedEnd: true, errorMessage: "error"),
      act: (bloc) {
        _transactionsList = _generateTransactions();
        when(() => transactionRepository.fetchByTransactionId(transactionId: any(named: "transactionId")))
          .thenAnswer((_) async => PaginateDataHolder(data: _transactionsList, next: "next"));
        bloc.add(const FetchByTransactionId(transactionId: "transactionId"));
      },
      verify: (_) {
        verify(() => transactionRepository.fetchByTransactionId(transactionId: any(named: "transactionId"))).called(1);
      }
    );

    blocTest<TransactionsListBloc, TransactionsListState>(
      "FetchByTransactionId event on error changes state: [TransactionsListState.reset(currentIdQuery: transactionId)], [loading: false, errorMessage: error]",
      build: () => transactionsListBloc,
      seed: () => baseState.update(transactions: _generateTransactions(numTransactions: 4), nextUrl: null, hasReachedEnd: true, errorMessage: "error"),
      act: (bloc) {
        when(() => transactionRepository.fetchByTransactionId(transactionId: any(named: "transactionId")))
          .thenThrow(const ApiException(error: "error"));
        bloc.add(const FetchByTransactionId(transactionId: "transactionId"));
      },
      expect: () {
        TransactionsListState firstState = baseState.reset(currentIdQuery: "transactionId", currentNameQuery: baseState.currentNameQuery);
        TransactionsListState secondState = firstState.update(loading: false, errorMessage: "error");
        return [firstState, secondState];
      }
    );

    blocTest<TransactionsListBloc, TransactionsListState>(
      "FetchByCustomerName event changes state: [TransactionsListState.reset(currentNameQuery: currentNameQuery)], [loading: false, transactions: List<MockTransactions>, nextUrl: next, hasReachedEnd: false]",
      build: () => transactionsListBloc,
      seed: () => baseState.update(transactions: _generateTransactions(numTransactions: 4), nextUrl: null, hasReachedEnd: true, errorMessage: "error"),
      act: (bloc) {
        _transactionsList = _generateTransactions();
        when(() => transactionRepository.fetchByCustomerName(firstName: any(named: "firstName"), lastName: any(named: "lastName")))
          .thenAnswer((_) async => PaginateDataHolder(data: _transactionsList, next: "next"));
        bloc.add(const FetchByCustomerName(firstName: "first", lastName: "last"));
      },
      expect: () {
        TransactionsListState firstState = baseState.reset(currentIdQuery: baseState.currentIdQuery, currentNameQuery: const FullName(first: "first", last: "last"));
        TransactionsListState secondState = firstState.update(loading: false, transactions: _transactionsList, nextUrl: "next", hasReachedEnd: false);
        return [firstState, secondState];
      }
    );

    blocTest<TransactionsListBloc, TransactionsListState>(
      "FetchByCustomerName event calls transactionRepository.fetchByCustomerName()",
      build: () => transactionsListBloc,
      seed: () => baseState.update(transactions: _generateTransactions(numTransactions: 4), nextUrl: null, hasReachedEnd: true, errorMessage: "error"),
      act: (bloc) {
        _transactionsList = _generateTransactions();
        when(() => transactionRepository.fetchByCustomerName(firstName: any(named: "firstName"), lastName: any(named: "lastName")))
          .thenAnswer((_) async => PaginateDataHolder(data: _transactionsList, next: "next"));
        bloc.add(const FetchByCustomerName(firstName: "first", lastName: "last"));
      },
      verify: (_) {
        verify(() => transactionRepository.fetchByCustomerName(firstName: any(named: "firstName"), lastName: any(named: "lastName"))).called(1);
      }
    );

    blocTest<TransactionsListBloc, TransactionsListState>(
      "FetchByCustomerName event changes state: [TransactionsListState.reset(currentNameQuery: currentNameQuery)], [loading: false, errorMessage: error]",
      build: () => transactionsListBloc,
      seed: () => baseState.update(transactions: _generateTransactions(numTransactions: 4), nextUrl: null, hasReachedEnd: true, errorMessage: "error"),
      act: (bloc) {
        when(() => transactionRepository.fetchByCustomerName(firstName: any(named: "firstName"), lastName: any(named: "lastName")))
          .thenThrow(const ApiException(error: "error"));
        bloc.add(const FetchByCustomerName(firstName: "first", lastName: "last"));
      },
      expect: () {
        TransactionsListState firstState = baseState.reset(currentIdQuery: baseState.currentIdQuery, currentNameQuery: const FullName(first: "first", last: "last"));
        TransactionsListState secondState = firstState.update(loading: false, errorMessage: "error");
        return [firstState, secondState];
      }
    );

    blocTest<TransactionsListBloc, TransactionsListState>(
      "FetchByEmployeeName event changes state: [TransactionsListState.reset(currentNameQuery: currentNameQuery)], [loading: false, transactions: List<MockTransactions>, nextUrl: next, hasReachedEnd: false]",
      build: () => transactionsListBloc,
      seed: () => baseState.update(transactions: _generateTransactions(numTransactions: 4), nextUrl: null, hasReachedEnd: true, errorMessage: "error"),
      act: (bloc) {
        _transactionsList = _generateTransactions();
        when(() => transactionRepository.fetchByEmployeeName(firstName: any(named: "firstName"), lastName: any(named: "lastName")))
          .thenAnswer((_) async => PaginateDataHolder(data: _transactionsList, next: "next"));
        bloc.add(const FetchByEmployeeName(firstName: "first", lastName: "last"));
      },
      expect: () {
        TransactionsListState firstState = baseState.reset(currentIdQuery: baseState.currentIdQuery, currentNameQuery: const FullName(first: "first", last: "last"));
        TransactionsListState secondState = firstState.update(loading: false, transactions: _transactionsList, nextUrl: "next", hasReachedEnd: false);
        return [firstState, secondState];
      }
    );

    blocTest<TransactionsListBloc, TransactionsListState>(
      "FetchByEmployeeName event calls transactionRepository.fetchByEmployeeName()",
      build: () => transactionsListBloc,
      seed: () => baseState.update(transactions: _generateTransactions(numTransactions: 4), nextUrl: null, hasReachedEnd: true, errorMessage: "error"),
      act: (bloc) {
        _transactionsList = _generateTransactions();
        when(() => transactionRepository.fetchByEmployeeName(firstName: any(named: "firstName"), lastName: any(named: "lastName")))
          .thenAnswer((_) async => PaginateDataHolder(data: _transactionsList, next: "next"));
        bloc.add(const FetchByEmployeeName(firstName: "first", lastName: "last"));
      },
      verify: (_) {
        verify(() => transactionRepository.fetchByEmployeeName(firstName: any(named: "firstName"), lastName: any(named: "lastName"))).called(1);
      }
    );

    blocTest<TransactionsListBloc, TransactionsListState>(
      "FetchByEmployeeName event on error changes state: [TransactionsListState.reset(currentNameQuery: currentNameQuery)], [loading: false, errorMessage: error]",
      build: () => transactionsListBloc,
      seed: () => baseState.update(transactions: _generateTransactions(numTransactions: 4), nextUrl: null, hasReachedEnd: true, errorMessage: "error"),
      act: (bloc) {
        when(() => transactionRepository.fetchByEmployeeName(firstName: any(named: "firstName"), lastName: any(named: "lastName")))
          .thenThrow(const ApiException(error: "error"));
        bloc.add(const FetchByEmployeeName(firstName: "first", lastName: "last"));
      },
      expect: () {
        TransactionsListState firstState = baseState.reset(currentIdQuery: baseState.currentIdQuery, currentNameQuery: const FullName(first: "first", last: "last"));
        TransactionsListState secondState = firstState.update(loading: false, errorMessage: "error");
        return [firstState, secondState];
      }
    );

    blocTest<TransactionsListBloc, TransactionsListState>(
      "DateRangeChanged event changes state: [TransactionsListState.reset()], [loading: false, transactions: List<MockTransactions>, nextUrl: next, hasReachedEnd: false]",
      build: () => transactionsListBloc,
      seed: () {
        _previousTransactionsList = _generateTransactions(numTransactions: 4);
        return baseState.update(transactions: _previousTransactionsList, nextUrl: null, hasReachedEnd: true, errorMessage: "error");
      },
      act: (bloc) {
        _transactionsList = _generateTransactions();
        _dateRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());
        when(() => transactionRepository.fetchAll(dateRange: _dateRange))
          .thenAnswer((_) async => PaginateDataHolder(data: _transactionsList, next: "next"));
        bloc.add(DateRangeChanged(dateRange: _dateRange));
      },
      expect: () {
        TransactionsListState firstState = baseState.update(transactions: _previousTransactionsList, nextUrl: null, hasReachedEnd: true, errorMessage: "error", currentDateRange: _dateRange);
        TransactionsListState secondState = firstState.reset(currentIdQuery: baseState.currentIdQuery, currentNameQuery: baseState.currentNameQuery);
        TransactionsListState thirdState = secondState.update(loading: false, transactions: _transactionsList, nextUrl: "next", hasReachedEnd: false);
        return [firstState, secondState, thirdState];
      }
    );

    blocTest<TransactionsListBloc, TransactionsListState>(
      "FilterChanged event not FilterType.All changes state: [currentFilter: filter]",
      build: () => transactionsListBloc,
      act: (bloc) => bloc.add(const FilterChanged(filter: FilterType.customerId)),
      expect: () => [baseState.update(currentFilter: FilterType.customerId)]
    );

    blocTest<TransactionsListBloc, TransactionsListState>(
      "FilterChanged event changes state: [currentFilter: FilterType.All], [TransactionsListState.reset()], [loading: false, transactions: List<MockTransactions>, nextUrl: next, hasReachedEnd: false]",
      build: () => transactionsListBloc,
      seed: () {
        _previousTransactionsList = _generateTransactions(numTransactions: 4);
        return baseState.update(currentFilter: FilterType.transactionId, transactions: _previousTransactionsList, nextUrl: null, hasReachedEnd: true, errorMessage: "error");
      },
      act: (bloc) {
        _transactionsList = _generateTransactions();
        when(() => transactionRepository.fetchAll(dateRange: baseState.currentDateRange))
          .thenAnswer((_) async => PaginateDataHolder(data: _transactionsList, next: "next"));
        bloc.add(const FilterChanged(filter: FilterType.all));
      },
      expect: () {
        TransactionsListState firstState = baseState.update(currentFilter: FilterType.all, transactions: _previousTransactionsList, nextUrl: null, hasReachedEnd: true, errorMessage: "error");
        TransactionsListState secondState = firstState.reset(currentIdQuery: baseState.currentIdQuery, currentNameQuery: baseState.currentNameQuery);
        TransactionsListState thirdState = secondState.update(loading: false, transactions: _transactionsList, nextUrl: "next", hasReachedEnd: false);
        return [firstState, secondState, thirdState];
      }
    );
  });
}