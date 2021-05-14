import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/quick_dashboard_screen/blocs/last_month/net_sales_month_bloc/net_sales_month_bloc.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  group("Net Sales Month Bloc Tests", () {
    late TransactionRepository transactionRepository;
    late NetSalesMonthBloc netSalesMonthBloc;

    late int _netSales;

    setUp(() {
      transactionRepository = MockTransactionRepository();
      netSalesMonthBloc = NetSalesMonthBloc(transactionRepository: transactionRepository);
    });

    tearDown(() {
      netSalesMonthBloc.close();
    });

    test("Initial state of NetSalesMonthBloc is NetSalesInitial()", () {
      expect(netSalesMonthBloc.state, NetSalesInitial());
    });

    blocTest<NetSalesMonthBloc, NetSalesMonthState>(
      "FetchNetSalesMonth event changes state: [Loading()], [NetSalesLoaded()]",
      build: () {
        _netSales = faker.randomGenerator.integer(1000);
        when(() => transactionRepository.fetchNetSalesMonth()).thenAnswer((_) async => _netSales);
        return netSalesMonthBloc;
      },
      act: (bloc) => bloc.add(FetchNetSalesMonth()),
      expect: () => [Loading(), NetSalesLoaded(netSales: _netSales)]
    );

    blocTest<NetSalesMonthBloc, NetSalesMonthState>(
      "FetchNetSalesMonth event calls transactionRepository.fetchNetSalesMonth()",
      build: () {
        _netSales = faker.randomGenerator.integer(1000);
        when(() => transactionRepository.fetchNetSalesMonth()).thenAnswer((_) async => _netSales);
        return netSalesMonthBloc;
      },
      act: (bloc) => bloc.add(FetchNetSalesMonth()),
      verify: (_) {
        verify(() => transactionRepository.fetchNetSalesMonth()).called(1);
      }
    );

    blocTest<NetSalesMonthBloc, NetSalesMonthState>(
      "FetchNetSalesMonth event on error changes state: [Loading()], [FetchNetSalesFailed()]",
      build: () {
        when(() => transactionRepository.fetchNetSalesMonth()).thenThrow(ApiException(error: "error"));
        return netSalesMonthBloc;
      },
      act: (bloc) => bloc.add(FetchNetSalesMonth()),
      expect: () => [Loading(), FetchNetSalesFailed(error: "error")]
    );
  });
}