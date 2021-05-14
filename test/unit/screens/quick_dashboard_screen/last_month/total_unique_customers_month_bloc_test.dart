import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/quick_dashboard_screen/blocs/last_month/total_unique_customers_month_bloc/total_unique_customers_month_bloc.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  group("Total Unique Customers Month Bloc Tests", () {
    late TransactionRepository transactionRepository;
    late TotalUniqueCustomersMonthBloc totalUniqueCustomersMonthBloc;

    late int _totalUniqueCustomers;

    setUp(() {
      transactionRepository = MockTransactionRepository();
      totalUniqueCustomersMonthBloc = TotalUniqueCustomersMonthBloc(transactionRepository: transactionRepository);
    });

    tearDown(() {
      totalUniqueCustomersMonthBloc.close();
    });

    test("Initial state of TotalUniqueCustomersMonthBloc is TotalUniqueCustomersInitial()", () {
      expect(totalUniqueCustomersMonthBloc.state, TotalUniqueCustomersInitial());
    });

    blocTest<TotalUniqueCustomersMonthBloc, TotalUniqueCustomersMonthState>(
      "FetchTotalUniqueCustomersMonth event changes state: [Loading()], [TotalUniqueCustomersLoaded()]",
      build: () {
        _totalUniqueCustomers = faker.randomGenerator.integer(100);
        when(() => transactionRepository.fetchTotalUniqueCustomersMonth()).thenAnswer((_) async => _totalUniqueCustomers);
        return totalUniqueCustomersMonthBloc;
      },
      act: (bloc) => bloc.add(FetchTotalUniqueCustomersMonth()),
      expect: () => [Loading(), TotalUniqueCustomersLoaded(totalUniqueCustomers: _totalUniqueCustomers)]
    );

    blocTest<TotalUniqueCustomersMonthBloc, TotalUniqueCustomersMonthState>(
      "FetchTotalUniqueCustomersMonth event calls transactionRepository.fetchTotalUniqueCustomersMonth()",
      build: () {
        _totalUniqueCustomers = faker.randomGenerator.integer(100);
        when(() => transactionRepository.fetchTotalUniqueCustomersMonth()).thenAnswer((_) async => _totalUniqueCustomers);
        return totalUniqueCustomersMonthBloc;
      },
      act: (bloc) => bloc.add(FetchTotalUniqueCustomersMonth()),
      verify: (_) {
        verify(() => transactionRepository.fetchTotalUniqueCustomersMonth()).called(1);
      }
    );

    blocTest<TotalUniqueCustomersMonthBloc, TotalUniqueCustomersMonthState>(
      "FetchTotalUniqueCustomersMonth event on error changes state: [Loading()], [FetchTotalUniqueCustomersFailed()]",
      build: () {
        when(() => transactionRepository.fetchTotalUniqueCustomersMonth()).thenThrow(ApiException(error: "error"));
        return totalUniqueCustomersMonthBloc;
      },
      act: (bloc) => bloc.add(FetchTotalUniqueCustomersMonth()),
      expect: () => [Loading(), FetchTotalUniqueCustomersFailed(error: "error")]
    );
  });
}