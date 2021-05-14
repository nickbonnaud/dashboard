import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/sales_screen/cubit/date_range_cubit.dart';
import 'package:dashboard/screens/sales_screen/widgets/widgets/total_tips/bloc/total_tips_bloc.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  group("Total Tips Bloc Tests", () {
    late TransactionRepository transactionRepository;
    late TotalTipsBloc totalTipsBloc;

    late int _totalTips;

    setUp(() {
      transactionRepository = MockTransactionRepository();
      totalTipsBloc = TotalTipsBloc(dateRangeCubit: DateRangeCubit(), transactionRepository: transactionRepository);
    });

    tearDown(() {
      totalTipsBloc.close();
    });

    test("Initial state of TotalTipsBloc is TotalTipsInitial()", () {
      expect(totalTipsBloc.state, TotalTipsInitial());
    });

    blocTest<TotalTipsBloc, TotalTipsState>(
      "InitTotalTips event changes state: [Loading(), TotalTipsLoaded()]",
      build: () {
        _totalTips = faker.randomGenerator.integer(500);
        when(() => transactionRepository.fetchTotalTipsToday()).thenAnswer((_) async => _totalTips);
        return totalTipsBloc;
      },
      act: (bloc) => bloc.add(InitTotalTips()),
      expect: () => [Loading(), TotalTipsLoaded(totalTips: _totalTips)]
    );

    blocTest<TotalTipsBloc, TotalTipsState>(
      "InitTotalTips event calls transactionRepository.fetchTotalTipsToday()",
      build: () {
        _totalTips = faker.randomGenerator.integer(500);
        when(() => transactionRepository.fetchTotalTipsToday()).thenAnswer((_) async => _totalTips);
        return totalTipsBloc;
      },
      act: (bloc) => bloc.add(InitTotalTips()),
      verify: (_) {
        verify(() => transactionRepository.fetchTotalTipsToday()).called(1);
      }
    );

    blocTest<TotalTipsBloc, TotalTipsState>(
      "InitTotalTips event on error changes state: [Loading(), FetchFailed()]",
      build: () {
        _totalTips = faker.randomGenerator.integer(500);
        when(() => transactionRepository.fetchTotalTipsToday()).thenThrow(ApiException(error: "error"));
        return totalTipsBloc;
      },
      act: (bloc) => bloc.add(InitTotalTips()),
      expect: () => [Loading(), FetchFailed(error: "error")]
    );

    blocTest<TotalTipsBloc, TotalTipsState>(
      "DateRangeChanged event changes state: [Loading(), TotalTipsLoaded()]",
      build: () {
        _totalTips = faker.randomGenerator.integer(500);
        when(() => transactionRepository.fetchTotalTipsDateRange(dateRange: any(named: "dateRange"))).thenAnswer((_) async => _totalTips);
        return totalTipsBloc;
      },
      act: (bloc) => bloc.add(DateRangeChanged(dateRange: DateTimeRange(start: DateTime.now(), end: DateTime.now()))),
      expect: () => [Loading(), TotalTipsLoaded(totalTips: _totalTips)]
    );

    blocTest<TotalTipsBloc, TotalTipsState>(
      "DateRangeChanged event calls transactionRepository.fetchTotalTipsDateRange()",
      build: () {
        _totalTips = faker.randomGenerator.integer(500);
        when(() => transactionRepository.fetchTotalTipsDateRange(dateRange: any(named: "dateRange"))).thenAnswer((_) async => _totalTips);
        return totalTipsBloc;
      },
      act: (bloc) => bloc.add(DateRangeChanged(dateRange: DateTimeRange(start: DateTime.now(), end: DateTime.now()))),
      verify: (_) {
        verify(() => transactionRepository.fetchTotalTipsDateRange(dateRange: any(named: "dateRange"))).called(1);
      }
    );

    blocTest<TotalTipsBloc, TotalTipsState>(
      "DateRangeChanged event on error changes state: [Loading(), FetchFailed()]",
      build: () {
        _totalTips = faker.randomGenerator.integer(500);
        when(() => transactionRepository.fetchTotalTipsDateRange(dateRange: any(named: "dateRange"))).thenThrow(ApiException(error: "error"));
        return totalTipsBloc;
      },
      act: (bloc) => bloc.add(DateRangeChanged(dateRange: DateTimeRange(start: DateTime.now(), end: DateTime.now()))),
      expect: () => [Loading(), FetchFailed(error: "error")]
    );
  });
}