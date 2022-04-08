import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/repositories/refund_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/quick_dashboard_screen/blocs/today/total_refunds_today_bloc/total_refunds_today_bloc.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRefundRepository extends Mock implements RefundRepository {}

void main() {
  group("Total Refunds Today Bloc Tests", () {
    late RefundRepository refundRepository;
    late TotalRefundsTodayBloc totalRefundsTodayBloc;

    late int _totalRefunds;

    setUp(() {
      refundRepository = MockRefundRepository();
      totalRefundsTodayBloc = TotalRefundsTodayBloc(refundRepository: refundRepository);
    });

    tearDown(() {
      totalRefundsTodayBloc.close();
    });

    test("Initial state of TotalRefundsTodayBloc is TotalRefundsInitial()", () {
      expect(totalRefundsTodayBloc.state, TotalRefundsInitial());
    });

    blocTest<TotalRefundsTodayBloc, TotalRefundsTodayState>(
      "FetchTotalRefundsToday event changes state: [Loading()], [TotalRefundsLoaded(totalRefunds: totalRefunds)]",
      build: () {
        _totalRefunds = faker.randomGenerator.integer(500);
        when(() => refundRepository.fetchTotalRefundsToday()).thenAnswer((_) async => _totalRefunds);
        return totalRefundsTodayBloc;
      },
      act: (bloc) => bloc.add(FetchTotalRefundsToday()),
      expect: () => [Loading(), TotalRefundsLoaded(totalRefunds: _totalRefunds)]
    );

    blocTest<TotalRefundsTodayBloc, TotalRefundsTodayState>(
      "FetchTotalRefundsToday event calls refundRepository.fetchTotalRefundsToday()",
      build: () {
        _totalRefunds = faker.randomGenerator.integer(500);
        when(() => refundRepository.fetchTotalRefundsToday()).thenAnswer((_) async => _totalRefunds);
        return totalRefundsTodayBloc;
      },
      act: (bloc) => bloc.add(FetchTotalRefundsToday()),
      verify: (_) {
        verify(() => refundRepository.fetchTotalRefundsToday()).called(1);
      }
    );
    
    blocTest<TotalRefundsTodayBloc, TotalRefundsTodayState>(
      "FetchTotalRefundsToday event on error changes state: [Loading()], [FetchFailed(error: exception.error)]",
      build: () {
        _totalRefunds = faker.randomGenerator.integer(500);
        when(() => refundRepository.fetchTotalRefundsToday()).thenThrow(const ApiException(error: "error"));
        return totalRefundsTodayBloc;
      },
      act: (bloc) => bloc.add(FetchTotalRefundsToday()),
      expect: () => [Loading(), const FetchFailed(error: "error")]
    );
  });
}