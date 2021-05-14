import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/sales_screen/cubit/date_range_cubit.dart';
import 'package:dashboard/screens/sales_screen/widgets/widgets/net_sales/bloc/net_sales_bloc.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  group("Net Sales Bloc Tests", () {
    late TransactionRepository transactionRepository;
    late NetSalesBloc netSalesBloc;

    late int _netSales;

    setUp(() {
      transactionRepository = MockTransactionRepository();
      netSalesBloc = NetSalesBloc(dateRangeCubit: DateRangeCubit(), transactionRepository: transactionRepository);
    });
  
    tearDown(() {
      netSalesBloc.close();
    });

    test("Initial state of NetSalesBloc is NetSalesInitial()", () {
      expect(netSalesBloc.state, NetSalesInitial());
    });

    blocTest<NetSalesBloc, NetSalesState>(
      "InitNetSales event changes state: [Loading()], [NetSalesLoaded(netSales: total)]",
      build: () {
        _netSales = faker.randomGenerator.integer(500);
        when(() => transactionRepository.fetchNetSalesToday()).thenAnswer((_) async => _netSales);
        return netSalesBloc;
      },
      act: (bloc) => bloc.add(InitNetSales()),
      expect: () => [Loading(), NetSalesLoaded(netSales: _netSales)]
    );

    blocTest<NetSalesBloc, NetSalesState>(
      "InitNetSales calls transactionRepository.fetchNetSalesToday()",
      build: () {
        _netSales = faker.randomGenerator.integer(500);
        when(() => transactionRepository.fetchNetSalesToday()).thenAnswer((_) async => _netSales);
        return netSalesBloc;
      },
      act: (bloc) => bloc.add(InitNetSales()),
      verify: (_) {
        verify(() => transactionRepository.fetchNetSalesToday()).called(1);
      }
    );

    blocTest<NetSalesBloc, NetSalesState>(
      "InitNetSales event on error changes state: [Loading()], [FetchFailed()]",
      build: () {
        _netSales = faker.randomGenerator.integer(500);
        when(() => transactionRepository.fetchNetSalesToday()).thenThrow(ApiException(error: "error"));
        return netSalesBloc;
      },
      act: (bloc) => bloc.add(InitNetSales()),
      expect: () => [Loading(), FetchFailed(error: "error")]
    );

    blocTest<NetSalesBloc, NetSalesState>(
      "DateRangeChanged event changes state: [Loading()], [NetSalesLoaded(netSales: total)]",
      build: () {
        _netSales = faker.randomGenerator.integer(500);
        when(() => transactionRepository.fetchNetSalesDateRange(dateRange: any(named: "dateRange"))).thenAnswer((_) async => _netSales);
        return netSalesBloc;
      },
      act: (bloc) => bloc.add(DateRangeChanged(dateRange: DateTimeRange(start: DateTime.now(), end: DateTime.now()))),
      expect: () => [Loading(), NetSalesLoaded(netSales: _netSales)]
    );

    blocTest<NetSalesBloc, NetSalesState>(
      "DateRangeChanged calls transactionRepository.fetchNetSalesDateRange()",
      build: () {
        _netSales = faker.randomGenerator.integer(500);
        when(() => transactionRepository.fetchNetSalesDateRange(dateRange: any(named: "dateRange"))).thenAnswer((_) async => _netSales);
        return netSalesBloc;
      },
      act: (bloc) => bloc.add(DateRangeChanged(dateRange: DateTimeRange(start: DateTime.now(), end: DateTime.now()))),
      verify: (_) {
        verify(() => transactionRepository.fetchNetSalesDateRange(dateRange: any(named: "dateRange"))).called(1);
      }
    );

    blocTest<NetSalesBloc, NetSalesState>(
      "DateRangeChanged event on error changes state: [Loading()], [FetchFailed()]",
      build: () {
        _netSales = faker.randomGenerator.integer(500);
        when(() => transactionRepository.fetchNetSalesDateRange(dateRange: any(named: "dateRange"))).thenThrow(ApiException(error: "error"));
        return netSalesBloc;
      },
      act: (bloc) => bloc.add(DateRangeChanged(dateRange: DateTimeRange(start: DateTime.now(), end: DateTime.now()))),
      expect: () => [Loading(), FetchFailed(error: "error")]
    );
  });
}