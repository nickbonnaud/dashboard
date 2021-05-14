import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/quick_dashboard_screen/blocs/today/total_tips_today_bloc/total_tips_today_bloc.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  group("Total Tips Today Bloc Tests", () {
    late TransactionRepository transactionRepository;
    late TotalTipsTodayBloc tipsTodayBloc;

    late int _totalTips;

    setUp(() {
      transactionRepository = MockTransactionRepository();
      tipsTodayBloc = TotalTipsTodayBloc(transactionRepository: transactionRepository);
    });

    tearDown(() {
      tipsTodayBloc.close();
    });

    test("Initial state of TotalTipsTodayBloc is TotalTipsInitial()", () {
      expect(tipsTodayBloc.state, TotalTipsInitial());
    });

    blocTest<TotalTipsTodayBloc, TotalTipsTodayState>(
      "FetchTotalTipsToday event changes state: [Loading(), TotalTipsLoaded(totalTips: totalTips)]",
      build: () {
        _totalTips = faker.randomGenerator.integer(500);
        when(() => transactionRepository.fetchTotalTipsToday()).thenAnswer((_) async => _totalTips);
        return tipsTodayBloc;
      },
      act: (bloc) => bloc.add(FetchTotalTipsToday()),
      expect: () => [Loading(), TotalTipsLoaded(totalTips: _totalTips)]
    );

    blocTest<TotalTipsTodayBloc, TotalTipsTodayState>(
      "FetchTotalTipsToday event calls transactionRepository.fetchTotalTipsToday()",
      build: () {
        _totalTips = faker.randomGenerator.integer(500);
        when(() => transactionRepository.fetchTotalTipsToday()).thenAnswer((_) async => _totalTips);
        return tipsTodayBloc;
      },
      act: (bloc) => bloc.add(FetchTotalTipsToday()),
      verify: (_) {
        verify(() => transactionRepository.fetchTotalTipsToday()).called(1);
      }
    );

    blocTest<TotalTipsTodayBloc, TotalTipsTodayState>(
      "FetchTotalTipsToday event on error changes state: [Loading(), FetchFailed(error: exception.error)]",
      build: () {
        when(() => transactionRepository.fetchTotalTipsToday()).thenThrow(ApiException(error: "error"));
        return tipsTodayBloc;
      },
      act: (bloc) => bloc.add(FetchTotalTipsToday()),
      expect: () => [Loading(), FetchFailed(error: "error")]
    );
  });
}