import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/models/unassigned_transaction/unassigned_transaction.dart';
import 'package:dashboard/repositories/unassigned_transaction_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/unassigned_transactions_screen/cubit/date_range_cubit.dart';
import 'package:dashboard/screens/unassigned_transactions_screen/widgets/widgets/unassigned_transactions_list/bloc/unassigned_transactions_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUnassignedTransactionRepository extends Mock implements UnassignedTransactionRepository {}
class MockUnassignedTransaction extends Mock implements UnassignedTransaction {}

void main() {
  group("Unassigned Transactions List Bloc Tests", () {
    late UnassignedTransactionRepository unassignedTransactionRepository;
    late DateRangeCubit dateRangeCubit;
    late UnassignedTransactionsListBloc unassignedTransactionsListBloc;
    
    late UnassignedTransactionsListState _baseState;
    late List<UnassignedTransaction> _transactions;
    late List<UnassignedTransaction> _paginateTransactions;
    late DateTimeRange _dateRange;

    setUp(() {
      unassignedTransactionRepository = MockUnassignedTransactionRepository();
      dateRangeCubit = DateRangeCubit();
      unassignedTransactionsListBloc = UnassignedTransactionsListBloc(dateRangeCubit: dateRangeCubit, unassignedTransactionRepository: unassignedTransactionRepository);
      
      _baseState = unassignedTransactionsListBloc.state;
    });

    tearDown(() {
      dateRangeCubit.close();
      unassignedTransactionsListBloc.close();
    });

    test("Initial state of UnassignedTransactionsListBloc is UnassignedTransactionsListState.initial()", () {
      expect(unassignedTransactionsListBloc.state, UnassignedTransactionsListState.initial(currentDateRange: dateRangeCubit.state));
    });

    blocTest<UnassignedTransactionsListBloc, UnassignedTransactionsListState>(
      "Init event changes state: [loading: true], [loading: false, transactions: transactions, nextUrl: null, hasReachedEnd: true]",
      build: () => unassignedTransactionsListBloc,
      act: (bloc) {
        _transactions = List.generate(10, (index) => MockUnassignedTransaction());
        when(() => unassignedTransactionRepository.fetchAll()).thenAnswer((_) async => PaginateDataHolder(data: _transactions, next: null));
        bloc.add(Init());
      },
      expect: () => [_baseState.update(loading: true), _baseState.update(loading: false, transactions: _transactions, nextUrl: null, hasReachedEnd: true)]
    );

    blocTest<UnassignedTransactionsListBloc, UnassignedTransactionsListState>(
      "Init event calls unassignedTransactionRepository.fetchAll()",
      build: () => unassignedTransactionsListBloc,
      act: (bloc) {
        _transactions = List.generate(10, (index) => MockUnassignedTransaction());
        when(() => unassignedTransactionRepository.fetchAll()).thenAnswer((_) async => PaginateDataHolder(data: _transactions, next: null));
        bloc.add(Init());
      },
      verify: (_) {
        verify(() => unassignedTransactionRepository.fetchAll()).called(1);
      }
    );

    blocTest<UnassignedTransactionsListBloc, UnassignedTransactionsListState>(
      "Init event on error changes state: [loading: true], [loading: false, errorMessage: error]",
      build: () => unassignedTransactionsListBloc,
      act: (bloc) {
        _transactions = List.generate(10, (index) => MockUnassignedTransaction());
        when(() => unassignedTransactionRepository.fetchAll()).thenThrow(ApiException(error: "error"));
        bloc.add(Init());
      },
      expect: () => [_baseState.update(loading: true), _baseState.update(loading: false, errorMessage: "error")]
    );

    blocTest<UnassignedTransactionsListBloc, UnassignedTransactionsListState>(
      "FetchAll event changes state: [loading: true, transactions: [], nextUrl: null, hasReachedEnd: true, errorMessage: ""], [loading: false, transactions: transactions, nextUrl: next, hasReachedEnd: false]",
      build: () => unassignedTransactionsListBloc,
      seed: () => _baseState.update(transactions: List.generate(4, (index) => MockUnassignedTransaction()), nextUrl: "next-url", hasReachedEnd: false, errorMessage: "error"),
      act: (bloc) {
        _transactions = List.generate(10, (index) => MockUnassignedTransaction());
        when(() => unassignedTransactionRepository.fetchAll()).thenAnswer((_) async => PaginateDataHolder(data: _transactions, next: "next"));
        bloc.add(FetchAll());
      },
      expect: () => [_baseState.update(loading: true, transactions: [], nextUrl: null, hasReachedEnd: true, errorMessage: ""), _baseState.update(loading: false, transactions: _transactions, nextUrl: "next", hasReachedEnd: false)]
    );

    blocTest<UnassignedTransactionsListBloc, UnassignedTransactionsListState>(
      "FetchAll event calls unassignedTransactionRepository.fetchAll()",
      build: () => unassignedTransactionsListBloc,
      seed: () => _baseState.update(transactions: List.generate(4, (index) => MockUnassignedTransaction()), nextUrl: "next-url", hasReachedEnd: false, errorMessage: "error"),
      act: (bloc) {
        _transactions = List.generate(10, (index) => MockUnassignedTransaction());
        when(() => unassignedTransactionRepository.fetchAll()).thenAnswer((_) async => PaginateDataHolder(data: _transactions, next: "next"));
        bloc.add(FetchAll());
      },
      verify: (_) {
        verify(() => unassignedTransactionRepository.fetchAll()).called(1);
      }
    );

    blocTest<UnassignedTransactionsListBloc, UnassignedTransactionsListState>(
      "FetchAll event on error changes state: [loading: true, transactions: [], nextUrl: null, hasReachedEnd: true, errorMessage: ""], [loading: false, errorMessage: error]",
      build: () => unassignedTransactionsListBloc,
      seed: () => _baseState.update(transactions: List.generate(4, (index) => MockUnassignedTransaction()), nextUrl: "next-url", hasReachedEnd: false, errorMessage: "error"),
      act: (bloc) {
        _transactions = List.generate(10, (index) => MockUnassignedTransaction());
        when(() => unassignedTransactionRepository.fetchAll()).thenThrow(ApiException(error: "error"));
        bloc.add(FetchAll());
      },
      expect: () => [_baseState.update(loading: true, transactions: [], nextUrl: null, hasReachedEnd: true, errorMessage: ""), _baseState.update(loading: false, transactions: [], nextUrl: null, hasReachedEnd: true, errorMessage: "error")]
    );

    blocTest<UnassignedTransactionsListBloc, UnassignedTransactionsListState>(
      "FetchMore event changes state: [loading: false, transactions: transactions, nextUrl: null, hasReachedEnd: true]",
      build: () => unassignedTransactionsListBloc,
      seed: () {
        _transactions = List.generate(4, (index) => MockUnassignedTransaction());
        _baseState = _baseState.update(transactions: _transactions, nextUrl: "next-url", hasReachedEnd: false);
        return _baseState;
      },
      act: (bloc) {
        _paginateTransactions = List.generate(10, (index) => MockUnassignedTransaction());
        when(() => unassignedTransactionRepository.paginate(url: any(named: "url"))).thenAnswer((_) async => PaginateDataHolder(data: _paginateTransactions, next: null));
        bloc.add(FetchMore());
      },
      expect: () {
        var firstState = _baseState.update(paginating: true);
        var secondState = firstState.update(loading: false, transactions: _transactions + _paginateTransactions, nextUrl: null, hasReachedEnd: true, paginating: false);
        return [firstState, secondState];
      }
    );

    blocTest<UnassignedTransactionsListBloc, UnassignedTransactionsListState>(
      "FetchMore event calls unassignedTransactionRepository.paginate()",
      build: () => unassignedTransactionsListBloc,
      seed: () {
        _transactions = List.generate(4, (index) => MockUnassignedTransaction());
        return _baseState.update(transactions: _transactions, nextUrl: "next-url", hasReachedEnd: false);
      },
      act: (bloc) {
        _paginateTransactions = List.generate(10, (index) => MockUnassignedTransaction());
        when(() => unassignedTransactionRepository.paginate(url: any(named: "url"))).thenAnswer((_) async => PaginateDataHolder(data: _paginateTransactions, next: null));
        bloc.add(FetchMore());
      },
      verify: (_) {
        verify(() => unassignedTransactionRepository.paginate(url: any(named: "url"))).called(1);
      }
    );

    blocTest<UnassignedTransactionsListBloc, UnassignedTransactionsListState>(
      "FetchMore event on error changes state: [loading: false, errorMessage: error]",
      build: () => unassignedTransactionsListBloc,
      seed: () {
        _transactions = List.generate(4, (index) => MockUnassignedTransaction());
        _baseState = _baseState.update(transactions: _transactions, nextUrl: "next-url", hasReachedEnd: false);
        return _baseState;
      },
      act: (bloc) {
        _paginateTransactions = List.generate(10, (index) => MockUnassignedTransaction());
        when(() => unassignedTransactionRepository.paginate(url: any(named: "url"))).thenThrow(ApiException(error: "error"));
        bloc.add(FetchMore());
      },
      expect: () {
        var firstState = _baseState.update(paginating: true);
        var secondState = firstState.update(loading: false, errorMessage: "error", paginating: false);
        return [firstState, secondState];
      } 
    );

    blocTest<UnassignedTransactionsListBloc, UnassignedTransactionsListState>(
      "FetchMore event never calls unassignedTransactionRepository.paginate() if loading",
      build: () => unassignedTransactionsListBloc,
      seed: () {
        _transactions = List.generate(4, (index) => MockUnassignedTransaction());
        return _baseState.update(loading: true, transactions: _transactions, nextUrl: "next-url", hasReachedEnd: false);
      },
      act: (bloc) {
        _paginateTransactions = List.generate(10, (index) => MockUnassignedTransaction());
        when(() => unassignedTransactionRepository.paginate(url: any(named: "url"))).thenAnswer((_) async => PaginateDataHolder(data: _paginateTransactions, next: null));
        bloc.add(FetchMore());
      },
      verify: (_) {
        verifyNever(() => unassignedTransactionRepository.paginate(url: any(named: "url")));
      }
    );

    blocTest<UnassignedTransactionsListBloc, UnassignedTransactionsListState>(
      "FetchMore event never calls unassignedTransactionRepository.paginate() if hasReachedEnd",
      build: () => unassignedTransactionsListBloc,
      seed: () {
        _transactions = List.generate(4, (index) => MockUnassignedTransaction());
        return _baseState.update(transactions: _transactions, nextUrl: null, hasReachedEnd: true);
      },
      act: (bloc) {
        _paginateTransactions = List.generate(10, (index) => MockUnassignedTransaction());
        when(() => unassignedTransactionRepository.paginate(url: any(named: "url"))).thenAnswer((_) async => PaginateDataHolder(data: _paginateTransactions, next: null));
        bloc.add(FetchMore());
      },
      verify: (_) {
        verifyNever(() => unassignedTransactionRepository.paginate(url: any(named: "url")));
      }
    );

    blocTest<UnassignedTransactionsListBloc, UnassignedTransactionsListState>(
      "DateRangeChanged event changes state: [currentDateRange: dateRange, isDateReset: false], [loading: true, transactions: [], nextUrl: null, hasReachedEnd: true], [loading: false, transactions: transactions, nextUrl: null, hasReachedEnd: true]",
      build: () => unassignedTransactionsListBloc,
      seed: () {
        _transactions = List.generate(4, (index) => MockUnassignedTransaction());
        _baseState = _baseState.update(transactions: _transactions, nextUrl: "next-url", hasReachedEnd: false);
        return _baseState;
      },
      act: (bloc) {
        _transactions = List.generate(10, (index) => MockUnassignedTransaction());
        _dateRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());
        when(() => unassignedTransactionRepository.fetchAll(dateRange: _dateRange)).thenAnswer((_) async => PaginateDataHolder(data: _transactions, next: null));
        bloc.add(DateRangeChanged(dateRange: _dateRange));
      },
      expect: () {
        UnassignedTransactionsListState firstState = _baseState.update(currentDateRange: _dateRange, isDateReset: false);
        UnassignedTransactionsListState secondState = _baseState.update(currentDateRange: _dateRange, loading: true, transactions: [], nextUrl: null, hasReachedEnd: true);
        UnassignedTransactionsListState thirdState = _baseState.update(currentDateRange: _dateRange, loading: false, transactions: _transactions, nextUrl: null, hasReachedEnd: true);
        return [firstState, secondState, thirdState];
      }
    );

    blocTest<UnassignedTransactionsListBloc, UnassignedTransactionsListState>(
      "DateRangeChanged event calls unassignedTransactionRepository.fetchAll()",
      build: () => unassignedTransactionsListBloc,
      seed: () {
        _transactions = List.generate(4, (index) => MockUnassignedTransaction());
        _baseState = _baseState.update(transactions: _transactions, nextUrl: "next-url", hasReachedEnd: false);
        return _baseState;
      },
      act: (bloc) {
        _transactions = List.generate(10, (index) => MockUnassignedTransaction());
        _dateRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());
        when(() => unassignedTransactionRepository.fetchAll(dateRange: _dateRange)).thenAnswer((_) async => PaginateDataHolder(data: _transactions, next: null));
        bloc.add(DateRangeChanged(dateRange: _dateRange));
      },
      verify: (_) {
        verify(() => unassignedTransactionRepository.fetchAll(dateRange: _dateRange)).called(1);
      }
    );

    blocTest<UnassignedTransactionsListBloc, UnassignedTransactionsListState>(
      "DateRangeChanged event on error changes state: [currentDateRange: dateRange, isDateReset: false], [loading: true, transactions: [], nextUrl: null, hasReachedEnd: true], [loading: false, errorMessage: error]",
      build: () => unassignedTransactionsListBloc,
      seed: () {
        _transactions = List.generate(4, (index) => MockUnassignedTransaction());
        _baseState = _baseState.update(transactions: _transactions, nextUrl: "next-url", hasReachedEnd: false);
        return _baseState;
      },
      act: (bloc) {
        _transactions = List.generate(10, (index) => MockUnassignedTransaction());
        _dateRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());
        when(() => unassignedTransactionRepository.fetchAll(dateRange: _dateRange)).thenThrow(ApiException(error: "error"));
        bloc.add(DateRangeChanged(dateRange: _dateRange));
      },
      expect: () {
        UnassignedTransactionsListState firstState = _baseState.update(currentDateRange: _dateRange, isDateReset: false);
        UnassignedTransactionsListState secondState = _baseState.update(currentDateRange: _dateRange, loading: true, transactions: [], nextUrl: null, hasReachedEnd: true);
        UnassignedTransactionsListState thirdState = _baseState.update(currentDateRange: _dateRange, loading: false, transactions: [], nextUrl: null, hasReachedEnd: true, errorMessage: "error");
        return [firstState, secondState, thirdState];
      }
    );

    blocTest<UnassignedTransactionsListBloc, UnassignedTransactionsListState>(
      "DateRangeChanged event never calls unassignedTransactionRepository.fetchAll() if dateRange same",
      build: () => unassignedTransactionsListBloc,
      seed: () {
        _transactions = List.generate(4, (index) => MockUnassignedTransaction());
        _dateRange = _dateRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());
        _baseState = _baseState.update(currentDateRange: _dateRange, transactions: _transactions, nextUrl: "next-url", hasReachedEnd: false);
        return _baseState;
      },
      act: (bloc) {
        _transactions = List.generate(10, (index) => MockUnassignedTransaction());
        when(() => unassignedTransactionRepository.fetchAll(dateRange: _dateRange)).thenAnswer((_) async => PaginateDataHolder(data: _transactions, next: null));
        bloc.add(DateRangeChanged(dateRange: _dateRange));
      },
      verify: (_) {
        verifyNever(() => unassignedTransactionRepository.fetchAll(dateRange: _dateRange));
      }
    );
  });
}