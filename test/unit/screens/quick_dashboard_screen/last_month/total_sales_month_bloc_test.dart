import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/quick_dashboard_screen/blocs/last_month/total_sales_month_bloc/total_sales_month_bloc.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  group("Total Sales Month Tests", () {
    late TransactionRepository transactionRepository;
    late TotalSalesMonthBloc totalSalesMonthBloc;

    late int _totalSales;

    setUp(() {
      transactionRepository = MockTransactionRepository();
      totalSalesMonthBloc = TotalSalesMonthBloc(transactionRepository: transactionRepository);
    });

    tearDown(() {
      totalSalesMonthBloc.close();
    });

    test("Initial state of TotalSalesMonthBloc is TotalSalesInitial()", () {
      expect(totalSalesMonthBloc.state, TotalSalesInitial());
    });

    blocTest<TotalSalesMonthBloc, TotalSalesMonthState>(
      "FetchTotalSalesMonth event changes state: [Loading()], [TotalSalesLoaded()]",
      build: () {
        _totalSales = faker.randomGenerator.integer(1000);
        when(() => transactionRepository.fetchTotalSalesMonth()).thenAnswer((_) async => _totalSales);
        return totalSalesMonthBloc;
      },
      act: (bloc) => bloc.add(FetchTotalSalesMonth()),
      expect: () => [Loading(), TotalSalesLoaded(totalSales: _totalSales)]
    );

    blocTest<TotalSalesMonthBloc, TotalSalesMonthState>(
      "FetchTotalSalesMonth event calls transactionRepository.fetchTotalSalesMonth()",
      build: () {
        _totalSales = faker.randomGenerator.integer(1000);
        when(() => transactionRepository.fetchTotalSalesMonth()).thenAnswer((_) async => _totalSales);
        return totalSalesMonthBloc;
      },
      act: (bloc) => bloc.add(FetchTotalSalesMonth()),
      verify: (_) {
        verify(() => transactionRepository.fetchTotalSalesMonth()).called(1);
      }
    );

    blocTest<TotalSalesMonthBloc, TotalSalesMonthState>(
      "FetchTotalSalesMonth event on error changes state: [Loading()], [FetchTotalSalesFailed()]",
      build: () {
        when(() => transactionRepository.fetchTotalSalesMonth()).thenThrow(const ApiException(error: "error"));
        return totalSalesMonthBloc;
      },
      act: (bloc) => bloc.add(FetchTotalSalesMonth()),
      expect: () => [Loading(), const FetchTotalSalesFailed(error: "error")]
    );
  });
}