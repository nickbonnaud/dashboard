import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/models/transaction/transaction_resource.dart';
import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/quick_dashboard_screen/blocs/recent_transactions_bloc/recent_transactions_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}
class MockTransactionResource extends Mock implements TransactionResource {}

void main() {
  group("Recent Transactions Bloc Tests", () {
    late TransactionRepository transactionRepository;
    late RecentTransactionsBloc recentTransactionsBloc;

    late RecentTransactionsState _baseState;
    late List<TransactionResource> _transactions;

    setUp(() {
      transactionRepository = MockTransactionRepository();
      recentTransactionsBloc = RecentTransactionsBloc(transactionRepository: transactionRepository);
      _baseState = recentTransactionsBloc.state;
    });

    tearDown(() {
      recentTransactionsBloc.close();
    });

    test("Initial state of RecentTransactionsBloc is RecentTransactionsState.initial()", () {
      expect(recentTransactionsBloc.state, RecentTransactionsState.initial());
    });

    blocTest<RecentTransactionsBloc, RecentTransactionsState>(
      "InitRecentTransactions event changes state: [loading: true], [loading: false, transactions: transactions]",
      build: () {
        _transactions = List.generate(10, (index) => MockTransactionResource());
        when(() => transactionRepository.fetchAll()).thenAnswer((_) async => PaginateDataHolder(data: _transactions));
        return recentTransactionsBloc;
      },
      act: (bloc) => bloc.add(InitRecentTransactions()),
      expect: () => [_baseState.update(loading: true), _baseState.update(loading: false, transactions: _transactions.take(5).toList())]
    );

    blocTest<RecentTransactionsBloc, RecentTransactionsState>(
      "InitRecentTransactions event calls transactionRepository.fetchAll()",
      build: () {
        _transactions = List.generate(10, (index) => MockTransactionResource());
        when(() => transactionRepository.fetchAll()).thenAnswer((_) async => PaginateDataHolder(data: _transactions));
        return recentTransactionsBloc;
      },
      act: (bloc) => bloc.add(InitRecentTransactions()),
      verify: (_) {
        verify(() => transactionRepository.fetchAll()).called(1);
      }
    );

    blocTest<RecentTransactionsBloc, RecentTransactionsState>(
      "InitRecentTransactions event on error changes state: [loading: true], [loading: false, errorMessage: error]",
      build: () {
        when(() => transactionRepository.fetchAll()).thenThrow(ApiException(error: "error"));
        return recentTransactionsBloc;
      },
      act: (bloc) => bloc.add(InitRecentTransactions()),
      expect: () => [_baseState.update(loading: true), _baseState.update(loading: false, errorMessage: "error")]
    );
  });
}