import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/models/refund/refund_resource.dart';
import 'package:dashboard/models/transaction_filter.dart';
import 'package:dashboard/repositories/refund_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/historic_refunds_screen/cubits/date_range_cubit.dart';
import 'package:dashboard/screens/historic_refunds_screen/cubits/filter_button_cubit.dart';
import 'package:dashboard/screens/historic_refunds_screen/widgets/bloc/refunds_list_bloc.dart';
import 'package:dashboard/screens/historic_refunds_screen/widgets/models/full_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRefundRepository extends Mock implements RefundRepository {}
class MockRefund extends Mock implements RefundResource {}

void main() {
  group("Refunds List Bloc Tests", () {
    late RefundRepository refundRepository;
    late FilterButtonCubit filterButtonCubit;
    late DateRangeCubit dateRangeCubit;
    late RefundsListBloc refundsListBloc;

    late RefundsListState baseState;

    List<RefundResource> _generateRefunds({int numRefunds = 10}) {
      return List.generate(numRefunds, (index) => MockRefund());
    }

    late List<RefundResource> _refundsList;
    late List<RefundResource> _previousRefundsList;
    late DateTimeRange _dateRange;

    setUp(() {
      refundRepository = MockRefundRepository();
      filterButtonCubit = FilterButtonCubit();
      dateRangeCubit = DateRangeCubit();
      baseState = RefundsListState.initial(currentFilter: filterButtonCubit.state, currentDateRange: dateRangeCubit.state);
      refundsListBloc = RefundsListBloc(
        refundRepository: refundRepository,
        filterButtonCubit: filterButtonCubit,
        dateRangeCubit: dateRangeCubit,
      );
    });

    tearDown(() {
      filterButtonCubit.close();
      dateRangeCubit.close();
      refundsListBloc.close();
    });

    test("Initial state of RefundsListBloc is RefundsListState.initial()", () {
      expect(refundsListBloc.state, RefundsListState.initial(currentFilter: filterButtonCubit.state, currentDateRange: dateRangeCubit.state));
    });

    blocTest<RefundsListBloc, RefundsListState>(
      "Init event changes state: [loading: true], [loading: false, refunds: List<MockRefunds>, nextUrl: next, hasReachedEnd: hasReachedEnd]",
      build: () => refundsListBloc,
      act: (bloc) {
        _refundsList = _generateRefunds();
        when(() => refundRepository.fetchAll()).thenAnswer((_) async => PaginateDataHolder(data: _refundsList, next: "next"));
        bloc.add(Init());
      },
      expect: () => [baseState.update(loading: true), baseState.update(loading: false, refunds: _refundsList, nextUrl: "next", hasReachedEnd: false)]
    );

    blocTest<RefundsListBloc, RefundsListState>(
      "Init event calls refundRepository.fetchAll()",
      build: () => refundsListBloc,
      act: (bloc) {
        _refundsList = _generateRefunds();
        when(() => refundRepository.fetchAll()).thenAnswer((_) async => PaginateDataHolder(data: _refundsList, next: "next"));
        bloc.add(Init());
      },
      verify: (_) {
        verify(() => refundRepository.fetchAll()).called(1);
      }
    );

    blocTest<RefundsListBloc, RefundsListState>(
      "Init event on error changes state: [loading: true], [loading: false, errorMessage: error]",
      build: () => refundsListBloc,
      act: (bloc) {
        when(() => refundRepository.fetchAll()).thenThrow(const ApiException(error: "error"));
        bloc.add(Init());
      },
      expect: () => [baseState.update(loading: true), baseState.update(loading: false, errorMessage: "error")]
    );

    blocTest<RefundsListBloc, RefundsListState>(
      "FetchAll event changes state: [RefundsListState.reset()], [loading: false, refunds: List<MockRefunds>, nextUrl: next, hasReachedEnd: hasReachedEnd]",
      build: () => refundsListBloc,
      seed: () => baseState.update(refunds: _generateRefunds(), nextUrl: "nextUrl", hasReachedEnd: false, errorMessage: "error"),
      act: (bloc) {
        _refundsList = _generateRefunds();
        when(() => refundRepository.fetchAll(dateRange: baseState.currentDateRange))
          .thenAnswer((_) async => PaginateDataHolder(data: _refundsList, next: "next"));
        bloc.add(FetchAll());
      },
      expect: () {
        RefundsListState firstState = baseState.update(loading: true, refunds: [], nextUrl: null, hasReachedEnd: false, errorMessage: "");
        RefundsListState secondState = firstState.update(loading: false, refunds: _refundsList, nextUrl: 'next', hasReachedEnd: false);
        return [firstState, secondState];
      }
    );

    blocTest<RefundsListBloc, RefundsListState>(
      "FetchAll event calls RefundRepository.fetchAll()",
      build: () => refundsListBloc,
      seed: () => baseState.update(refunds: _generateRefunds(), nextUrl: "nextUrl", hasReachedEnd: false, errorMessage: "error"),
      act: (bloc) {
        _refundsList = _generateRefunds();
        when(() => refundRepository.fetchAll(dateRange: baseState.currentDateRange))
          .thenAnswer((_) async => PaginateDataHolder(data: _refundsList, next: "next"));
        bloc.add(FetchAll());
      },
      verify: (_) {
        verify(() => refundRepository.fetchAll(dateRange: baseState.currentDateRange)).called(1);
      }
    );

    blocTest<RefundsListBloc, RefundsListState>(
      "FetchAll event on error changes state: [RefundsListState.reset()], [loading: false, errorMessage: error]",
      build: () => refundsListBloc,
      seed: () => baseState.update(refunds: _generateRefunds(), nextUrl: "nextUrl", hasReachedEnd: false, errorMessage: "error"),
      act: (bloc) {
        when(() => refundRepository.fetchAll(dateRange: baseState.currentDateRange))
          .thenThrow(const ApiException(error: "error"));
        bloc.add(FetchAll());
      },
      expect: () {
        RefundsListState firstState = baseState.update(loading: true, refunds: [], nextUrl: null, hasReachedEnd: false, errorMessage: "");
        RefundsListState secondState = firstState.update(loading: false, errorMessage: "error");
        return [firstState, secondState];
      }
    );

    blocTest<RefundsListBloc, RefundsListState>(
      "FetchMore event changes state: [paginating: true] [loading: false, refunds: List<MockRefunds>, nextUrl: next, hasReachedEnd: hasReachedEnd, paginating: false]",
      build: () => refundsListBloc,
      seed: () {
        _refundsList = _generateRefunds();
        baseState = baseState.update(refunds: _refundsList, nextUrl: "nextUrl", hasReachedEnd: false);
        return baseState;
      },
      act: (bloc) {
        List<RefundResource> paginateRefunds = _generateRefunds();
        _refundsList = _refundsList + paginateRefunds;
        when(() => refundRepository.paginate(url: any(named: "url")))
          .thenAnswer((_) async => PaginateDataHolder(data: paginateRefunds, next: "next"));
        bloc.add(FetchMore());
      },
      expect: () {
        var firstState = baseState.update(paginating: true);
        var secondState = firstState.update(refunds: _refundsList, nextUrl: 'next', hasReachedEnd: false, paginating: false);
        return [firstState, secondState];
      }
    );

    blocTest<RefundsListBloc, RefundsListState>(
      "FetchMore event calls RefundsRepository.paginate()",
      build: () => refundsListBloc,
      seed: () {
        _refundsList = _generateRefunds();
        return baseState.update(refunds: _refundsList, nextUrl: "nextUrl", hasReachedEnd: false);
      },
      act: (bloc) {
        List<RefundResource> paginateRefunds = _generateRefunds();
        _refundsList = _refundsList + paginateRefunds;
        when(() => refundRepository.paginate(url: any(named: "url")))
          .thenAnswer((_) async => PaginateDataHolder(data: paginateRefunds, next: "next"));
        bloc.add(FetchMore());
      },
      verify: (_) {
        verify(() => refundRepository.paginate(url: any(named: "url"))).called(1);
      }
    );

    blocTest<RefundsListBloc, RefundsListState>(
      "FetchMore event on error changes state: [paginating: true], [loading: false, errorMessage: error, paginating: false]",
      build: () => refundsListBloc,
      seed: () {
        _refundsList = _generateRefunds();
        baseState = baseState.update(refunds: _refundsList, nextUrl: "nextUrl", hasReachedEnd: false);
        return baseState;
      },
      act: (bloc) {
        when(() => refundRepository.paginate(url: any(named: "url")))
          .thenThrow(const ApiException(error: "error"));
        bloc.add(FetchMore());
      },
      expect: () {
        var firstState = baseState.update(paginating: true);
        var secondState = firstState.update(refunds: _refundsList, nextUrl: 'nextUrl', hasReachedEnd: false, errorMessage: "error", paginating: false);
        return [firstState, secondState];
      }
    );

    blocTest<RefundsListBloc, RefundsListState>(
      "FetchByRefundId event changes state: [RefundsListState.reset(refundId)], [loading: false, refunds: List<MockRefunds>, nextUrl: next, hasReachedEnd: hasReachedEnd]",
      build: () => refundsListBloc,
      seed: () => baseState.update(refunds: _generateRefunds(), nextUrl: "nextUrl", hasReachedEnd: false, errorMessage: "error"),
      act: (bloc) {
        _refundsList = _generateRefunds();
        when(() => refundRepository.fetchByRefundId(refundId: any(named: "refundId")))
          .thenAnswer((_) async => PaginateDataHolder(data: _refundsList, next: "next"));
        bloc.add(const FetchByRefundId(refundId: "refundId"));
      },
      expect: () {
        RefundsListState firstState = baseState.update(loading: true, refunds: [], nextUrl: null, hasReachedEnd: false, errorMessage: "", currentIdQuery: "refundId");
        RefundsListState secondState = firstState.update(loading: false, refunds: _refundsList, nextUrl: 'next', hasReachedEnd: false);
        return [firstState, secondState];
      }
    );

    blocTest<RefundsListBloc, RefundsListState>(
      "FetchByRefundId event calls refundRepository.fetchByRefundId()",
      build: () => refundsListBloc,
      seed: () => baseState.update(refunds: _generateRefunds(), nextUrl: "nextUrl", hasReachedEnd: false, errorMessage: "error"),
      act: (bloc) {
        _refundsList = _generateRefunds();
        when(() => refundRepository.fetchByRefundId(refundId: any(named: "refundId")))
          .thenAnswer((_) async => PaginateDataHolder(data: _refundsList, next: "next"));
        bloc.add(const FetchByRefundId(refundId: "refundId"));
      },
      verify: (_) {
        verify(() => refundRepository.fetchByRefundId(refundId: any(named: "refundId"))).called(1);
      }
    );

    blocTest<RefundsListBloc, RefundsListState>(
      "FetchByRefundId event on error changes state: [RefundsListState.reset(refundId)], [loading: false, errorMessage: error]",
      build: () => refundsListBloc,
      seed: () => baseState.update(refunds: _generateRefunds(), nextUrl: "nextUrl", hasReachedEnd: false, errorMessage: "error"),
      act: (bloc) {
        when(() => refundRepository.fetchByRefundId(refundId: any(named: "refundId")))
          .thenThrow(const ApiException(error: "error"));
        bloc.add(const FetchByRefundId(refundId: "refundId"));
      },
      expect: () {
        RefundsListState firstState = baseState.update(loading: true, refunds: [], nextUrl: null, hasReachedEnd: false, errorMessage: "", currentIdQuery: "refundId");
        RefundsListState secondState = firstState.update(loading: false, errorMessage: "error");
        return [firstState, secondState];
      }
    );

    blocTest<RefundsListBloc, RefundsListState>(
      "FetchByTransactionId event changes state: [RefundsListState.reset(transactionId)], [loading: false, refunds: List<MockRefunds>, nextUrl: next, hasReachedEnd: hasReachedEnd]",
      build: () => refundsListBloc,
      seed: () => baseState.update(refunds: _generateRefunds(), nextUrl: "nextUrl", hasReachedEnd: false, errorMessage: "error"),
      act: (bloc) {
        _refundsList = _generateRefunds();
        when(() => refundRepository.fetchByTransactionId(transactionId: any(named: "transactionId")))
          .thenAnswer((_) async => PaginateDataHolder(data: _refundsList, next: "next"));
        bloc.add(const FetchByTransactionId(transactionId: "transactionId"));
      },
      expect: () {
        RefundsListState firstState = baseState.update(loading: true, refunds: [], nextUrl: null, hasReachedEnd: false, errorMessage: "", currentIdQuery: "transactionId");
        RefundsListState secondState = firstState.update(loading: false, refunds: _refundsList, nextUrl: 'next', hasReachedEnd: false);
        return [firstState, secondState];
      }
    );

    blocTest<RefundsListBloc, RefundsListState>(
      "FetchByTransactionId event calls RefundRepository.fetchByTransactionId()",
      build: () => refundsListBloc,
      seed: () => baseState.update(refunds: _generateRefunds(), nextUrl: "nextUrl", hasReachedEnd: false, errorMessage: "error"),
      act: (bloc) {
        _refundsList = _generateRefunds();
        when(() => refundRepository.fetchByTransactionId(transactionId: any(named: "transactionId")))
          .thenAnswer((_) async => PaginateDataHolder(data: _refundsList, next: "next"));
        bloc.add(const FetchByTransactionId(transactionId: "transactionId"));
      },
      verify: (_) {
        verify(() => refundRepository.fetchByTransactionId(transactionId: any(named: "transactionId"))).called(1);
      }
    );

    blocTest<RefundsListBloc, RefundsListState>(
      "FetchByTransactionId event on error changes state: [RefundsListState.reset(transactionId)], [loading: false, errorMessage: error]",
      build: () => refundsListBloc,
      seed: () => baseState.update(refunds: _generateRefunds(), nextUrl: "nextUrl", hasReachedEnd: false, errorMessage: "error"),
      act: (bloc) {
        when(() => refundRepository.fetchByTransactionId(transactionId: any(named: "transactionId")))
          .thenThrow(const ApiException(error: "error"));
        bloc.add(const FetchByTransactionId(transactionId: "transactionId"));
      },
      expect: () {
        RefundsListState firstState = baseState.update(loading: true, refunds: [], nextUrl: null, hasReachedEnd: false, errorMessage: "", currentIdQuery: "transactionId");
        RefundsListState secondState = firstState.update(loading: false, errorMessage: "error");
        return [firstState, secondState];
      }
    );

    blocTest<RefundsListBloc, RefundsListState>(
      "FetchByCustomerId event changes state: [RefundsListState.reset(customerId)], [loading: false, refunds: List<MockRefunds>, nextUrl: next, hasReachedEnd: hasReachedEnd]",
      build: () => refundsListBloc,
      seed: () => baseState.update(refunds: _generateRefunds(), nextUrl: "nextUrl", hasReachedEnd: false, errorMessage: "error"),
      act: (bloc) {
        _refundsList = _generateRefunds();
        when(() => refundRepository.fetchByCustomerId(customerId: any(named: "customerId")))
          .thenAnswer((_) async => PaginateDataHolder(data: _refundsList, next: "next"));
        bloc.add(const FetchByCustomerId(customerId: "customerId"));
      },
      expect: () {
        RefundsListState firstState = baseState.update(loading: true, refunds: [], nextUrl: null, hasReachedEnd: false, errorMessage: "", currentIdQuery: "customerId");
        RefundsListState secondState = firstState.update(loading: false, refunds: _refundsList, nextUrl: 'next', hasReachedEnd: false);
        return [firstState, secondState];
      }
    );

    blocTest<RefundsListBloc, RefundsListState>(
      "FetchByCustomerId event calls RefundRepository.fetchByCustomerId()",
      build: () => refundsListBloc,
      seed: () => baseState.update(refunds: _generateRefunds(), nextUrl: "nextUrl", hasReachedEnd: false, errorMessage: "error"),
      act: (bloc) {
        _refundsList = _generateRefunds();
        when(() => refundRepository.fetchByCustomerId(customerId: any(named: "customerId")))
          .thenAnswer((_) async => PaginateDataHolder(data: _refundsList, next: "next"));
        bloc.add(const FetchByCustomerId(customerId: "customerId"));
      },
      verify: (_) {
        verify(() => refundRepository.fetchByCustomerId(customerId: any(named: "customerId"))).called(1);
      }
    );

    blocTest<RefundsListBloc, RefundsListState>(
      "FetchByCustomerId event on error changes state: [RefundsListState.reset(customerId)], [loading: false, errorMessage: error]",
      build: () => refundsListBloc,
      seed: () => baseState.update(refunds: _generateRefunds(), nextUrl: "nextUrl", hasReachedEnd: false, errorMessage: "error"),
      act: (bloc) {
        when(() => refundRepository.fetchByCustomerId(customerId: any(named: "customerId")))
          .thenThrow(const ApiException(error: "error"));
        bloc.add(const FetchByCustomerId(customerId: "customerId"));
      },
      expect: () {
        RefundsListState firstState = baseState.update(loading: true, refunds: [], nextUrl: null, hasReachedEnd: false, errorMessage: "", currentIdQuery: "customerId");
        RefundsListState secondState = firstState.update(loading: false, errorMessage: "error");
        return [firstState, secondState];
      }
    );

    blocTest<RefundsListBloc, RefundsListState>(
      "FetchByCustomerName event changes state: [RefundsListState.reset(customerName)], [loading: false, refunds: List<MockRefunds>, nextUrl: next, hasReachedEnd: hasReachedEnd]",
      build: () => refundsListBloc,
      seed: () => baseState.update(refunds: _generateRefunds(), nextUrl: "nextUrl", hasReachedEnd: false, errorMessage: "error"),
      act: (bloc) {
        _refundsList = _generateRefunds();
        when(() => refundRepository.fetchByCustomerName(firstName: any(named: "firstName"), lastName: any(named: "lastName")))
          .thenAnswer((_) async => PaginateDataHolder(data: _refundsList, next: "next"));
        bloc.add(const FetchByCustomerName(firstName: "first", lastName: 'last'));
      },
      expect: () {
        RefundsListState firstState = baseState.update(loading: true, refunds: [], nextUrl: null, hasReachedEnd: false, errorMessage: "", currentNameQuery:  const FullName(first: "first", last: "last"));
        RefundsListState secondState = firstState.update(loading: false, refunds: _refundsList, nextUrl: 'next', hasReachedEnd: false);
        return [firstState, secondState];
      }
    );

    blocTest<RefundsListBloc, RefundsListState>(
      "FetchByCustomerName event calls refundRepository.fetchByCustomerName()",
      build: () => refundsListBloc,
      seed: () => baseState.update(refunds: _generateRefunds(), nextUrl: "nextUrl", hasReachedEnd: false, errorMessage: "error"),
      act: (bloc) {
        _refundsList = _generateRefunds();
        when(() => refundRepository.fetchByCustomerName(firstName: any(named: "firstName"), lastName: any(named: "lastName")))
          .thenAnswer((_) async => PaginateDataHolder(data: _refundsList, next: "next"));
        bloc.add(const FetchByCustomerName(firstName: "first", lastName: 'last'));
      },
      verify: (_) {
        verify(() => refundRepository.fetchByCustomerName(firstName: any(named: "firstName"), lastName: any(named: "lastName"))).called(1);
      }
    );

    blocTest<RefundsListBloc, RefundsListState>(
      "FetchByCustomerName event on error changes state: [RefundsListState.reset(customerName)], [loading: false, errorMessage: error]",
      build: () => refundsListBloc,
      seed: () => baseState.update(refunds: _generateRefunds(), nextUrl: "nextUrl", hasReachedEnd: false, errorMessage: "error"),
      act: (bloc) {
        when(() => refundRepository.fetchByCustomerName(firstName: any(named: "firstName"), lastName: any(named: "lastName")))
          .thenThrow(const ApiException(error: "error"));
        bloc.add(const FetchByCustomerName(firstName: "first", lastName: 'last'));
      },
      expect: () {
        RefundsListState firstState = baseState.update(loading: true, refunds: [], nextUrl: null, hasReachedEnd: false, errorMessage: "", currentNameQuery:  const FullName(first: "first", last: "last"));
        RefundsListState secondState = firstState.update(loading: false, errorMessage: "error");
        return [firstState, secondState];
      }
    );

    blocTest<RefundsListBloc, RefundsListState>(
      "DateRangeChanged event changes state: [RefundsListState.reset()], [loading: false, refunds: List<MockRefunds>, nextUrl: next, hasReachedEnd: hasReachedEnd]",
      build: () => refundsListBloc,
      seed: () {
        _previousRefundsList = _generateRefunds(numRefunds: 3);
        return baseState.update(refunds: _previousRefundsList, nextUrl: "nextUrl", hasReachedEnd: false, errorMessage: "error");
      },
      act: (bloc) {
        _refundsList = _generateRefunds();
        _dateRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());
        when(() => refundRepository.fetchAll(dateRange: _dateRange))
          .thenAnswer((_) async => PaginateDataHolder(data: _refundsList, next: "next"));
        bloc.add(DateRangeChanged(dateRange: _dateRange));
      },
      expect: () {
        RefundsListState firstState = baseState.update(refunds: _previousRefundsList, nextUrl: "nextUrl", hasReachedEnd: false, errorMessage: "error", currentDateRange: _dateRange);
        RefundsListState secondState = baseState.update(loading: true, refunds: [], nextUrl: null, hasReachedEnd: false, errorMessage: "", currentDateRange: _dateRange);
        RefundsListState thirdState = secondState.update(loading: false, refunds: _refundsList, nextUrl: 'next', hasReachedEnd: false);
        return [firstState, secondState, thirdState];
      }
    );

    blocTest<RefundsListBloc, RefundsListState>(
      "FilterChanged event not FilterType.All changes state: [currentFilter: filter]",
      build: () => refundsListBloc,
      act: (bloc) => bloc.add(const FilterChanged(filter: FilterType.customerName)),
      expect: () => [baseState.update(currentFilter: FilterType.customerName)]
    );

    blocTest<RefundsListBloc, RefundsListState>(
      "FilterChanged event FilterType.All changes state: [currentFilter: FilterType.All], [RefundsListState.reset()], [loading: false, refunds: List<MockRefunds>, nextUrl: next, hasReachedEnd: hasReachedEnd]",
      build: () => refundsListBloc,
      seed: () {
        _previousRefundsList = _generateRefunds();
        return baseState.update(currentFilter: FilterType.refundId, refunds: _previousRefundsList, nextUrl: "nextUrl", hasReachedEnd: false, errorMessage: "error");
      },
      act: (bloc) {
        _refundsList = _generateRefunds();
        when(() => refundRepository.fetchAll(dateRange: baseState.currentDateRange))
          .thenAnswer((_) async => PaginateDataHolder(data: _refundsList, next: "next"));
        bloc.add(const FilterChanged(filter: FilterType.all));
      },
      expect: () {
        RefundsListState firstState = baseState.update(currentFilter: FilterType.all, refunds: _previousRefundsList, nextUrl: "nextUrl", hasReachedEnd: false, errorMessage: "error");
        RefundsListState secondState = baseState.update(loading: true, refunds: [], nextUrl: null, hasReachedEnd: false, errorMessage: "");
        RefundsListState thirdState = secondState.update(loading: false, refunds: _refundsList, nextUrl: 'next', hasReachedEnd: false);
        return [firstState, secondState, thirdState];
      }
    );
  });
}