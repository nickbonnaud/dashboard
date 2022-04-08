import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/quick_dashboard_screen/blocs/today/net_sales_today_bloc/net_sales_today_bloc.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  group("Net Sales Today Bloc Tests", () {
    late TransactionRepository transactionRepository;
    late NetSalesTodayBloc netSalesTodayBloc;

    late int _netSales;

    setUp(() {
      transactionRepository = MockTransactionRepository();
      netSalesTodayBloc = NetSalesTodayBloc(transactionRepository: transactionRepository);
    });

    tearDown(() {
      netSalesTodayBloc.close();
    });

    test("Initial state of NetSalesTodayBloc is NetSalesInitial()", () {
      expect(netSalesTodayBloc.state, NetSalesInitial());
    });
    
    blocTest<NetSalesTodayBloc, NetSalesTodayState>(
      "FetchNetSalesToday event changes state: [Loading()], [NetSalesLoaded(netSales: netSales)]",
      build: () {
        _netSales = faker.randomGenerator.integer(500);
        when(() => transactionRepository.fetchNetSalesToday()).thenAnswer((_) async => _netSales);
        return netSalesTodayBloc;
      },
      act: (bloc) => bloc.add(FetchNetSalesToday()),
      expect: () => [Loading(), NetSalesLoaded(netSales: _netSales)]
    );

    blocTest<NetSalesTodayBloc, NetSalesTodayState>(
      "FetchNetSalesToday event calls transactionRepository.fetchNetSalesToday()",
      build: () {
        _netSales = faker.randomGenerator.integer(500);
        when(() => transactionRepository.fetchNetSalesToday()).thenAnswer((_) async => _netSales);
        return netSalesTodayBloc;
      },
      act: (bloc) => bloc.add(FetchNetSalesToday()),
      verify: (_) {
        verify(() => transactionRepository.fetchNetSalesToday()).called(1);
      }
    );
    
    blocTest<NetSalesTodayBloc, NetSalesTodayState>(
      "FetchNetSalesToday event on error changes state: [Loading()], [FetchFailed(error: exception.error)]",
      build: () {
        when(() => transactionRepository.fetchNetSalesToday()).thenThrow(const ApiException(error: "error"));
        return netSalesTodayBloc;
      },
      act: (bloc) => bloc.add(FetchNetSalesToday()),
      expect: () => [Loading(), const FetchFailed(error: "error")]
    );
  });
}