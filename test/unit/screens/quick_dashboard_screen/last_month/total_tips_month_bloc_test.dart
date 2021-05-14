import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/quick_dashboard_screen/blocs/last_month/total_tips_month_bloc/total_tips_month_bloc.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  group("Total Tips Month Bloc Tests", () {
    late TransactionRepository transactionRepository;
    late TotalTipsMonthBloc totalTipsMonthBloc;

    late int _totalTips;

    setUp(() {
      transactionRepository = MockTransactionRepository();
      totalTipsMonthBloc = TotalTipsMonthBloc(transactionRepository: transactionRepository);
    });

    tearDown(() {
      totalTipsMonthBloc.close();
    });

    test("Initial state of TotalTipsMonthBloc is TotalTipsInitial()", () {
      expect(totalTipsMonthBloc.state, TotalTipsInitial());
    });

    blocTest<TotalTipsMonthBloc, TotalTipsMonthState>(
      "FetchTotalTipsMonth event changes state: [Loading()], [TotalTipsLoaded()]",
      build: () {
        _totalTips = faker.randomGenerator.integer(1000);
        when(() => transactionRepository.fetchTotalTipsMonth()).thenAnswer((_) async => _totalTips);
        return totalTipsMonthBloc;
      },
      act: (bloc) => bloc.add(FetchTotalTipsMonth()),
      expect: () => [Loading(), TotalTipsLoaded(totalTips: _totalTips)]
    );

    blocTest<TotalTipsMonthBloc, TotalTipsMonthState>(
      "FetchTotalTipsMonth event calls transactionRepository.fetchTotalTipsMonth()",
      build: () {
        _totalTips = faker.randomGenerator.integer(1000);
        when(() => transactionRepository.fetchTotalTipsMonth()).thenAnswer((_) async => _totalTips);
        return totalTipsMonthBloc;
      },
      act: (bloc) => bloc.add(FetchTotalTipsMonth()),
      verify: (_) {
        verify(() => transactionRepository.fetchTotalTipsMonth()).called(1);
      }
    );

    blocTest<TotalTipsMonthBloc, TotalTipsMonthState>(
      "FetchTotalTipsMonth event on error changes state: [Loading()], [FetchTotalTipsFailed(error: error)]",
      build: () {
        when(() => transactionRepository.fetchTotalTipsMonth()).thenThrow(ApiException(error: "error"));
        return totalTipsMonthBloc;
      },
      act: (bloc) => bloc.add(FetchTotalTipsMonth()),
      expect: () => [Loading(), FetchTotalTipsFailed(error: "error")]
    );
  });
}