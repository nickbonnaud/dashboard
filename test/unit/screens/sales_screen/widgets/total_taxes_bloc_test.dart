import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/sales_screen/cubit/date_range_cubit.dart';
import 'package:dashboard/screens/sales_screen/widgets/widgets/total_taxes/bloc/total_taxes_bloc.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  group("Total Taxes Bloc Tests", () {
    late TransactionRepository transactionRepository;
    late TotalTaxesBloc totalTaxesBloc;

    late int _totalTaxes;

    setUp(() {
      transactionRepository = MockTransactionRepository();
      totalTaxesBloc = TotalTaxesBloc(dateRangeCubit: DateRangeCubit(), transactionRepository: transactionRepository);
    });

    tearDown(() {
      totalTaxesBloc.close();
    });

    test("Initial state of TotalTaxesBloc is TotalTaxesInitial()", () {
      expect(totalTaxesBloc.state, TotalTaxesInitial());
    });

    blocTest<TotalTaxesBloc, TotalTaxesState>(
      "InitTotalTaxes event changes state: [Loading()], [TotalTaxesLoaded()]",
      build: () {
        _totalTaxes = faker.randomGenerator.integer(500);
        when(() => transactionRepository.fetchTotalTaxesToday()).thenAnswer((_) async => _totalTaxes);
        return totalTaxesBloc;
      },
      act: (bloc) => bloc.add(InitTotalTaxes()),
      expect: () => [Loading(), TotalTaxesLoaded(totalTaxes: _totalTaxes)]
    );

    blocTest<TotalTaxesBloc, TotalTaxesState>(
      "InitTotalTaxes event calls transactionRepository.fetchTotalTaxesToday()",
      build: () {
        _totalTaxes = faker.randomGenerator.integer(500);
        when(() => transactionRepository.fetchTotalTaxesToday()).thenAnswer((_) async => _totalTaxes);
        return totalTaxesBloc;
      },
      act: (bloc) => bloc.add(InitTotalTaxes()),
      verify: (_) {
        verify(() => transactionRepository.fetchTotalTaxesToday()).called(1);
      }
    );

    blocTest<TotalTaxesBloc, TotalTaxesState>(
      "InitTotalTaxes event on error changes state: [Loading()], [FetchFailed()]",
      build: () {
        _totalTaxes = faker.randomGenerator.integer(500);
        when(() => transactionRepository.fetchTotalTaxesToday()).thenThrow(const ApiException(error: "error"));
        return totalTaxesBloc;
      },
      act: (bloc) => bloc.add(InitTotalTaxes()),
      expect: () => [Loading(), const FetchFailed(error: "error")]
    );

    blocTest<TotalTaxesBloc, TotalTaxesState>(
      "DateRangeChanged event changes state: [Loading()], [TotalTaxesLoaded()]",
      build: () {
        _totalTaxes = faker.randomGenerator.integer(500);
        when(() => transactionRepository.fetchTotalTaxesDateRange(dateRange: any(named: "dateRange"))).thenAnswer((_) async => _totalTaxes);
        return totalTaxesBloc;
      },
      act: (bloc) => bloc.add(DateRangeChanged(dateRange: DateTimeRange(start: DateTime.now(), end: DateTime.now()))),
      expect: () => [Loading(), TotalTaxesLoaded(totalTaxes: _totalTaxes)]
    );

    blocTest<TotalTaxesBloc, TotalTaxesState>(
      "DateRangeChanged event calls transactionRepository.fetchTotalTaxesDateRange()",
      build: () {
        _totalTaxes = faker.randomGenerator.integer(500);
        when(() => transactionRepository.fetchTotalTaxesDateRange(dateRange: any(named: "dateRange"))).thenAnswer((_) async => _totalTaxes);
        return totalTaxesBloc;
      },
      act: (bloc) => bloc.add(DateRangeChanged(dateRange: DateTimeRange(start: DateTime.now(), end: DateTime.now()))),
      verify: (_) {
        verify(() => transactionRepository.fetchTotalTaxesDateRange(dateRange: any(named: "dateRange"))).called(1);
      }
    );

    blocTest<TotalTaxesBloc, TotalTaxesState>(
      "DateRangeChanged event on error changes state: [Loading()], [FetchFailed()]",
      build: () {
        _totalTaxes = faker.randomGenerator.integer(500);
        when(() => transactionRepository.fetchTotalTaxesDateRange(dateRange: any(named: "dateRange"))).thenThrow(const ApiException(error: "error"));
        return totalTaxesBloc;
      },
      act: (bloc) => bloc.add(DateRangeChanged(dateRange: DateTimeRange(start: DateTime.now(), end: DateTime.now()))),
      expect: () => [Loading(), const FetchFailed(error: "error")]
    );
  });
}