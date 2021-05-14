import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/quick_dashboard_screen/blocs/last_month/total_transactions_month_bloc/total_transactions_month_bloc.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  group("Total Transactions Month Bloc Tests", () {
    late TransactionRepository transactionRepository;
    late TotalTransactionsMonthBloc totalTransactionsMonthBloc;

    late int _totalTransactions;

    setUp(() {
      transactionRepository = MockTransactionRepository();
      totalTransactionsMonthBloc = TotalTransactionsMonthBloc(transactionRepository: transactionRepository);
    });
    
    tearDown(() {
      totalTransactionsMonthBloc.close();
    });

    test("Initial state of TotalTransactionsMonthBloc is TotalTransactionsInitial()", () {
      expect(totalTransactionsMonthBloc.state, TotalTransactionsInitial());
    });

    blocTest<TotalTransactionsMonthBloc, TotalTransactionsMonthState>(
      "FetchTotalTransactionsMonth event changes state: [Loading()], [TotalTransactionsLoaded()]",
      build: () {
        _totalTransactions = faker.randomGenerator.integer(500);
        when(() => transactionRepository.fetchTotalTransactionsMonth()).thenAnswer((_) async => _totalTransactions);
        return totalTransactionsMonthBloc;
      },
      act: (bloc) => bloc.add(FetchTotalTransactionsMonth()),
      expect: () => [Loading(), TotalTransactionsLoaded(totalTransactions: _totalTransactions)]
    );

    blocTest<TotalTransactionsMonthBloc, TotalTransactionsMonthState>(
      "FetchTotalTransactionsMonth event calls transactionRepository.fetchTotalTransactionsMonth()]",
      build: () {
        _totalTransactions = faker.randomGenerator.integer(500);
        when(() => transactionRepository.fetchTotalTransactionsMonth()).thenAnswer((_) async => _totalTransactions);
        return totalTransactionsMonthBloc;
      },
      act: (bloc) => bloc.add(FetchTotalTransactionsMonth()),
      verify: (_) {
        verify(() => transactionRepository.fetchTotalTransactionsMonth()).called(1);
      }
    );

    blocTest<TotalTransactionsMonthBloc, TotalTransactionsMonthState>(
      "FetchTotalTransactionsMonth event on error changes state: [Loading()], [FetchTotalTransactionsFailed()]",
      build: () {
        when(() => transactionRepository.fetchTotalTransactionsMonth()).thenThrow(ApiException(error: "error"));
        return totalTransactionsMonthBloc;
      },
      act: (bloc) => bloc.add(FetchTotalTransactionsMonth()),
      expect: () => [Loading(), FetchTotalTransactionsFailed(error: "error")]
    );

  });
}