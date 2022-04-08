import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/sales_screen/cubit/date_range_cubit.dart';
import 'package:dashboard/screens/sales_screen/widgets/widgets/total_sales/bloc/total_sales_bloc.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  group("Total Sales Bloc Tests", () {
    late TransactionRepository transactionRepository;
    late TotalSalesBloc totalSalesBloc;

    late int _totalSales;

    setUp(() {
      transactionRepository = MockTransactionRepository();
      totalSalesBloc = TotalSalesBloc(dateRangeCubit: DateRangeCubit(), transactionRepository: transactionRepository);
    });

    tearDown(() {
      totalSalesBloc.close();
    });

    test("Initial State of TotalSalesBloc is TotalSalesInitial()", () {
      expect(totalSalesBloc.state, TotalSalesInitial());
    });

    blocTest<TotalSalesBloc, TotalSalesState>(
      "InitTotalSales event changes state: [Loading()], [TotalSalesLoaded()]",
      build: () {
        _totalSales = faker.randomGenerator.integer(500);
        when(() => transactionRepository.fetchTotalSalesToday()).thenAnswer((_) async => _totalSales);
        return totalSalesBloc;
      },
      act: (bloc) => bloc.add(InitTotalSales()),
      expect: () => [Loading(), TotalSalesLoaded(totalSales: _totalSales)]
    );

    blocTest<TotalSalesBloc, TotalSalesState>(
      "InitTotalSales event calls transactionRepository.fetchTotalSalesToday()",
      build: () {
        _totalSales = faker.randomGenerator.integer(500);
        when(() => transactionRepository.fetchTotalSalesToday()).thenAnswer((_) async => _totalSales);
        return totalSalesBloc;
      },
      act: (bloc) => bloc.add(InitTotalSales()),
      verify: (_) {
        verify(() => transactionRepository.fetchTotalSalesToday()).called(1);
      }
    );

    blocTest<TotalSalesBloc, TotalSalesState>(
      "InitTotalSales event on error changes state: [Loading()], [FetchFailed()]",
      build: () {
        _totalSales = faker.randomGenerator.integer(500);
        when(() => transactionRepository.fetchTotalSalesToday()).thenThrow(const ApiException(error: "error"));
        return totalSalesBloc;
      },
      act: (bloc) => bloc.add(InitTotalSales()),
      expect: () => [Loading(), const FetchFailed(error: "error")]
    );

    blocTest<TotalSalesBloc, TotalSalesState>(
      "DateRangeChanged event changes state: [Loading()], [TotalSalesLoaded()]",
      build: () {
        _totalSales = faker.randomGenerator.integer(500);
        when(() => transactionRepository.fetchTotalSalesDateRange(dateRange: any(named: "dateRange"))).thenAnswer((_) async => _totalSales);
        return totalSalesBloc;
      },
      act: (bloc) => bloc.add(DateRangeChanged(dateRange: DateTimeRange(start: DateTime.now(), end: DateTime.now()))),
      expect: () => [Loading(), TotalSalesLoaded(totalSales: _totalSales)]
    );

    blocTest<TotalSalesBloc, TotalSalesState>(
      "DateRangeChanged event calls transactionRepository.fetchTotalSalesDateRange()",
      build: () {
        _totalSales = faker.randomGenerator.integer(500);
        when(() => transactionRepository.fetchTotalSalesDateRange(dateRange: any(named: "dateRange"))).thenAnswer((_) async => _totalSales);
        return totalSalesBloc;
      },
      act: (bloc) => bloc.add(DateRangeChanged(dateRange: DateTimeRange(start: DateTime.now(), end: DateTime.now()))),
      verify: (_) {
        verify(() => transactionRepository.fetchTotalSalesDateRange(dateRange: any(named: "dateRange"))).called(1);
      }
    );

    blocTest<TotalSalesBloc, TotalSalesState>(
      "DateRangeChanged event on error changes state: [Loading()], [FetchFailed()]",
      build: () {
        _totalSales = faker.randomGenerator.integer(500);
        when(() => transactionRepository.fetchTotalSalesDateRange(dateRange: any(named: "dateRange"))).thenThrow(const ApiException(error: "error"));
        return totalSalesBloc;
      },
      act: (bloc) => bloc.add(DateRangeChanged(dateRange: DateTimeRange(start: DateTime.now(), end: DateTime.now()))),
      expect: () => [Loading(), const FetchFailed(error: "error")]
    );
  });
}