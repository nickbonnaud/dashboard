import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/repositories/refund_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/quick_dashboard_screen/blocs/last_month/total_refunds_month_bloc/total_refunds_month_bloc.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRefundRepository extends Mock implements RefundRepository {}

void main() {
  group("Total Refunds Month Bloc Tests", () {
    late RefundRepository refundRepository;
    late TotalRefundsMonthBloc totalRefundsMonthBloc;

    late int _totalRefunds;

    setUp(() {
      refundRepository = MockRefundRepository();
      totalRefundsMonthBloc = TotalRefundsMonthBloc(refundRepository: refundRepository);
    });

    tearDown(() {
      totalRefundsMonthBloc.close();
    });

    test("Initial state of TotalRefundsMonthBloc is TotalRefundsInitial()", () {
      expect(totalRefundsMonthBloc.state, TotalRefundsInitial());
    });

    blocTest<TotalRefundsMonthBloc, TotalRefundsMonthState>(
      "FetchTotalRefundsMonth event changes state: [Loading()], [TotalRefundsLoaded()]",
      build: () {
        _totalRefunds = faker.randomGenerator.integer(1000);
        when(() => refundRepository.fetchTotalRefundsMonth()).thenAnswer((_) async => _totalRefunds);
        return totalRefundsMonthBloc;
      },
      act: (bloc) => bloc.add(FetchTotalRefundsMonth()),
      expect: () => [Loading(), TotalRefundsLoaded(totalRefunds: _totalRefunds)]
    );

    blocTest<TotalRefundsMonthBloc, TotalRefundsMonthState>(
      "FetchTotalRefundsMonth calls refundRepository.fetchTotalRefundsMonth()",
      build: () {
        _totalRefunds = faker.randomGenerator.integer(1000);
        when(() => refundRepository.fetchTotalRefundsMonth()).thenAnswer((_) async => _totalRefunds);
        return totalRefundsMonthBloc;
      },
      act: (bloc) => bloc.add(FetchTotalRefundsMonth()),
      verify: (_) {
        verify(() => refundRepository.fetchTotalRefundsMonth()).called(1);
      }
    );

    blocTest<TotalRefundsMonthBloc, TotalRefundsMonthState>(
      "FetchTotalRefundsMonth event on error changes state: [Loading()], [FetchTotalRefundsFailed()]",
      build: () {
        when(() => refundRepository.fetchTotalRefundsMonth()).thenThrow(ApiException(error: "error"));
        return totalRefundsMonthBloc;
      },
      act: (bloc) => bloc.add(FetchTotalRefundsMonth()),
      expect: () => [Loading(), FetchTotalRefundsFailed(error: "error")]
    );
  });
}