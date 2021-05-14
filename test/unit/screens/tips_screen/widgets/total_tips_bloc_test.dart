import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/tips_screen/cubits/date_range_cubit.dart';
import 'package:dashboard/screens/tips_screen/widgets/widgets/total_tips/bloc/total_tips_bloc.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  group("Total Tips Bloc Tests", () {
    late TransactionRepository transactionRepository;
    late DateRangeCubit dateRangeCubit;
    late TotalTipsBloc totalTipsBloc;

    late int _totalTips;
    late DateTimeRange _dateRange;

    setUp(() {
      transactionRepository = MockTransactionRepository();
      dateRangeCubit = DateRangeCubit();
      totalTipsBloc = TotalTipsBloc(dateRangeCubit: dateRangeCubit, transactionRepository: transactionRepository);
    });

    tearDown(() {
      dateRangeCubit.close();
      totalTipsBloc.close();
    });

    test("Initial state of TotalTipsBloc is TotalTipsInitial()", () {
      expect(totalTipsBloc.state, TotalTipsInitial());
    });

    blocTest<TotalTipsBloc, TotalTipsState>(
      "InitTotal event changes state: [Loading()], [TotalTipsLoaded()]",
      build: () {
        _totalTips = faker.randomGenerator.integer(1000);
        when(() => transactionRepository.fetchTotalTipsToday()).thenAnswer((_) async => _totalTips);
        return totalTipsBloc;
      },
      act: (bloc) => bloc.add(InitTotal()),
      expect: () => [Loading(), TotalTipsLoaded(totalTips: _totalTips)]
    );

    blocTest<TotalTipsBloc, TotalTipsState>(
      "InitTotal event calls transactionRepository.fetchTotalTipsToday()",
      build: () {
        _totalTips = faker.randomGenerator.integer(1000);
        when(() => transactionRepository.fetchTotalTipsToday()).thenAnswer((_) async => _totalTips);
        return totalTipsBloc;
      },
      act: (bloc) => bloc.add(InitTotal()),
      verify: (_) {
        verify(() => transactionRepository.fetchTotalTipsToday()).called(1);
      }
    );

    blocTest<TotalTipsBloc, TotalTipsState>(
      "InitTotal event on error changes state: [Loading()], [TotalTipsLoaded()]",
      build: () {
        _totalTips = faker.randomGenerator.integer(1000);
        when(() => transactionRepository.fetchTotalTipsToday()).thenThrow(ApiException(error: "error"));
        return totalTipsBloc;
      },
      act: (bloc) => bloc.add(InitTotal()),
      expect: () => [Loading(), FetchTotalTipsFailed(error: "error")]
    );

    blocTest<TotalTipsBloc, TotalTipsState>(
      "DateRangeChanged event changes state: [Loading()], [TotalTipsLoaded()]",
      build: () => totalTipsBloc,
      act: (bloc) {
        _dateRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());
        _totalTips = faker.randomGenerator.integer(1000);
        when(() => transactionRepository.fetchTotalTipsDateRange(dateRange: _dateRange)).thenAnswer((_) async => _totalTips);
        return bloc.add(DateRangeChanged(dateRange: _dateRange));
      },
      expect: () => [Loading(), TotalTipsLoaded(totalTips: _totalTips)]
    );

    blocTest<TotalTipsBloc, TotalTipsState>(
      "DateRangeChanged event calls transactionRepository.fetchTotalTipsDateRange()",
      build: () => totalTipsBloc,
      act: (bloc) {
        _dateRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());
        _totalTips = faker.randomGenerator.integer(1000);
        when(() => transactionRepository.fetchTotalTipsDateRange(dateRange: _dateRange)).thenAnswer((_) async => _totalTips);
        return bloc.add(DateRangeChanged(dateRange: _dateRange));
      },
      verify: (_) {
        verify(() => transactionRepository.fetchTotalTipsDateRange(dateRange: _dateRange)).called(1);
      }
    );

    blocTest<TotalTipsBloc, TotalTipsState>(
      "DateRangeChanged event on error changes state: [Loading()], [FetchTotalTipsFailed()]",
      build: () => totalTipsBloc,
      act: (bloc) {
        _dateRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());
        _totalTips = faker.randomGenerator.integer(1000);
        when(() => transactionRepository.fetchTotalTipsDateRange(dateRange: _dateRange)).thenThrow(ApiException(error: "error"));
        return bloc.add(DateRangeChanged(dateRange: _dateRange));
      },
      expect: () => [Loading(), FetchTotalTipsFailed(error: "error")]
    );
  });
}