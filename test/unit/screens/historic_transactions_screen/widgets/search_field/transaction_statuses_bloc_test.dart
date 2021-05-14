import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/models/status.dart';
import 'package:dashboard/repositories/status_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/historic_transactions_screen/widgets/widgets/widgets/search_bar/widgets/search_field/bloc/transaction_statuses_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockStatusRepository extends Mock implements StatusRepository {}
class MockStatus extends Mock implements Status {}

void main() {
  
  group("Transaction Statuses Bloc Tests", () {
    late StatusRepository statusRepository;
    late TransactionStatusesBloc transactionStatusesBloc;
    
    late TransactionStatusesState baseState;

    List<Status> _generateStatuses() => List.generate(3, (_) => MockStatus());

    late List<Status> _statusList;

    setUp(() {
      statusRepository = MockStatusRepository();
      transactionStatusesBloc = TransactionStatusesBloc(statusRepository: statusRepository);
      baseState = transactionStatusesBloc.state;
    });

    tearDown(() {
      transactionStatusesBloc.close();
    });

    test("Initial state of TransactionStatusesBloc is TransactionStatusesState.initial()", () {
      expect(transactionStatusesBloc.state, TransactionStatusesState.initial());
    });

    blocTest<TransactionStatusesBloc, TransactionStatusesState>(
      "InitStatuses event changes state: [loading: true, statuses: defaultStatuses], [loading: false, statuses: statuses, fetchFailed: false]",
      build: () => transactionStatusesBloc,
      act: (bloc) {
        _statusList = _generateStatuses();
        when(() => statusRepository.fetchTransactionStatuses()).thenAnswer((_) async => _statusList);
        bloc.add(InitStatuses());
      },
      expect: () => [
        baseState.update(loading: true),
        baseState.update(loading: false, statuses: _statusList, fetchFailed: false)
      ]
    );

    blocTest<TransactionStatusesBloc, TransactionStatusesState>(
      "InitStatuses event calls statusRepository.fetchTransactionStatuses()",
      build: () => transactionStatusesBloc,
      act: (bloc) {
        _statusList = _generateStatuses();
        when(() => statusRepository.fetchTransactionStatuses()).thenAnswer((_) async => _statusList);
        bloc.add(InitStatuses());
      },
      verify: (_) {
        verify(() => statusRepository.fetchTransactionStatuses()).called(1);
      }
    );

    blocTest<TransactionStatusesBloc, TransactionStatusesState>(
      "InitStatuses event on error changes state: [loading: true, statuses: defaultStatuses], [loading: false, fetchFailed: true]",
      build: () => transactionStatusesBloc,
      act: (bloc) {
        _statusList = _generateStatuses();
        when(() => statusRepository.fetchTransactionStatuses()).thenThrow(ApiException(error: "error"));
        bloc.add(InitStatuses());
      },
      expect: () => [baseState.update(loading: true), baseState.update(loading: false, fetchFailed: true)]
    );
  });
}