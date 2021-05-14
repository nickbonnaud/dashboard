import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/quick_dashboard_screen/blocs/today/total_sales_today_bloc/total_sales_today_bloc.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  group("Total Sales Today Bloc Tests", () {
    late TransactionRepository transactionRepository;
    late TotalSalesTodayBloc totalSalesTodayBloc;

    late int _totalSales;

    setUp(() {
      transactionRepository = MockTransactionRepository();
      totalSalesTodayBloc = TotalSalesTodayBloc(transactionRepository: transactionRepository);
    });

    tearDown(() {
      totalSalesTodayBloc.close();
    });

    test("Initial state of TotalSalesTodayBloc is TotalSalesInitial()", () {
      expect(totalSalesTodayBloc.state, TotalSalesInitial());
    });

    blocTest<TotalSalesTodayBloc, TotalSalesTodayState>(
      "FetchTotalSalesToday event changes state: [Loading()], [TotalSalesLoaded(totalSales: totalSales)]",
      build: () {
        _totalSales = faker.randomGenerator.integer(500);
        when(() => transactionRepository.fetchTotalSalesToday()).thenAnswer((_) async => _totalSales);
        return totalSalesTodayBloc;
      },
      act: (bloc) => bloc.add(FetchTotalSalesToday()),
      expect: () => [Loading(), TotalSalesLoaded(totalSales: _totalSales)]
    );

    blocTest<TotalSalesTodayBloc, TotalSalesTodayState>(
      "FetchTotalSalesToday event calls transactionRepository.fetchTotalSalesToday()",
      build: () {
        _totalSales = faker.randomGenerator.integer(500);
        when(() => transactionRepository.fetchTotalSalesToday()).thenAnswer((_) async => _totalSales);
        return totalSalesTodayBloc;
      },
      act: (bloc) => bloc.add(FetchTotalSalesToday()),
      verify: (_) {
        verify(() => transactionRepository.fetchTotalSalesToday()).called(1);
      }
    );

    blocTest<TotalSalesTodayBloc, TotalSalesTodayState>(
      "FetchTotalSalesToday event on error changes state: [Loading()], [FetchFailed(error: exception.error)]",
      build: () {
        when(() => transactionRepository.fetchTotalSalesToday()).thenThrow(ApiException(error: "error"));
        return totalSalesTodayBloc;
      },
      act: (bloc) => bloc.add(FetchTotalSalesToday()),
      expect: () => [Loading(), FetchFailed(error: "error")]
    );
  });
}