import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/quick_dashboard_screen/blocs/last_month/total_taxes_month_bloc/total_taxes_month_bloc.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  group("Total Taxes Month Bloc Tests", () {
    late TransactionRepository transactionRepository;
    late TotalTaxesMonthBloc totalTaxesMonthBloc;

    late int _totalTaxes;

    setUp(() {
      transactionRepository = MockTransactionRepository();
      totalTaxesMonthBloc = TotalTaxesMonthBloc(transactionRepository: transactionRepository);
    });
    
    tearDown(() {
      totalTaxesMonthBloc.close();
    });

    test("Initial state of TotalTaxesMonthBloc is TotalTaxesInitial()", () {
      expect(totalTaxesMonthBloc.state, TotalTaxesInitial());
    });

    blocTest<TotalTaxesMonthBloc, TotalTaxesMonthState>(
      "FetchTotalTaxesMonth event changes state: [Loading()], [TotalTaxesLoaded()]",
      build: () {
        _totalTaxes = faker.randomGenerator.integer(1000);
        when(() => transactionRepository.fetchTotalTaxesMonth()).thenAnswer((_) async => _totalTaxes);
        return totalTaxesMonthBloc;
      },
      act: (bloc) => bloc.add(FetchTotalTaxesMonth()),
      expect: () => [Loading(), TotalTaxesLoaded(totalTaxes: _totalTaxes)]
    );

    blocTest<TotalTaxesMonthBloc, TotalTaxesMonthState>(
      "FetchTotalTaxesMonth event calls transactionRepository.fetchTotalTaxesMonth()",
      build: () {
        _totalTaxes = faker.randomGenerator.integer(1000);
        when(() => transactionRepository.fetchTotalTaxesMonth()).thenAnswer((_) async => _totalTaxes);
        return totalTaxesMonthBloc;
      },
      act: (bloc) => bloc.add(FetchTotalTaxesMonth()),
      verify: (_) {
        verify(() => transactionRepository.fetchTotalTaxesMonth()).called(1);
      }
    );

    blocTest<TotalTaxesMonthBloc, TotalTaxesMonthState>(
      "FetchTotalTaxesMonth event on error changes state: [Loading()], [FetchTotalTaxesFailed()]",
      build: () {
        when(() => transactionRepository.fetchTotalTaxesMonth()).thenThrow(ApiException(error: "error"));
        return totalTaxesMonthBloc;
      },
      act: (bloc) => bloc.add(FetchTotalTaxesMonth()),
      expect: () => [Loading(), FetchTotalTaxesFailed(error: "error")]
    );
  });
}