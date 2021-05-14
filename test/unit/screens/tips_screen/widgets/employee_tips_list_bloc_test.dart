import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/models/business/employee_tip.dart';
import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/repositories/tips_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/tips_screen/cubits/date_range_cubit.dart';
import 'package:dashboard/screens/tips_screen/widgets/widgets/employee_tips_list/bloc/employee_tips_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTipsRepository extends Mock implements TipsRepository {}
class MockEmployeeTip extends Mock implements EmployeeTip {}

void main() {
  group("Employee Tips List Bloc Tests", () {
    late TipsRepository tipsRepository;
    late DateRangeCubit dateRangeCubit;
    late EmployeeTipsListBloc employeeTipsListBloc;

    late EmployeeTipsListState _baseState;
    late List<EmployeeTip> _tips;
    late List<EmployeeTip> _paginatedTips;
    late DateTimeRange _dateRange;

    setUp(() {
      tipsRepository = MockTipsRepository();
      dateRangeCubit = DateRangeCubit();
      employeeTipsListBloc = EmployeeTipsListBloc(dateRangeCubit: dateRangeCubit, tipsRepository: tipsRepository);
      
      _baseState = employeeTipsListBloc.state;
    });

    tearDown(() {
      dateRangeCubit.close();
      employeeTipsListBloc.close();
    });

    test("Initial state of EmployeeTipsListBloc is EmployeeTipsListState.initial()", () {
      expect(employeeTipsListBloc.state, EmployeeTipsListState.initial(currentDateRange: dateRangeCubit.state));
    });

    blocTest<EmployeeTipsListBloc, EmployeeTipsListState>(
      "InitTipList event changes state: [loading: true], [loading: false, tips: tips, nextUrl: null, hasReachedEnd: true]",
      build: () {
        _tips = List.generate(10, (index) => MockEmployeeTip());
        when(() => tipsRepository.fetchAll()).thenAnswer((_) async => PaginateDataHolder(data: _tips, next: null));
        return employeeTipsListBloc;
      },
      act: (bloc) => bloc.add(InitTipList()),
      expect: () => [_baseState.update(loading: true), _baseState.update(loading: false, tips: _tips, nextUrl: null, hasReachedEnd: true)]
    );

    blocTest<EmployeeTipsListBloc, EmployeeTipsListState>(
      "InitTipList event calls tipsRepository.fetchAll()",
      build: () {
        _tips = List.generate(10, (index) => MockEmployeeTip());
        when(() => tipsRepository.fetchAll()).thenAnswer((_) async => PaginateDataHolder(data: _tips, next: null));
        return employeeTipsListBloc;
      },
      act: (bloc) => bloc.add(InitTipList()),
      verify: (_) {
        verify(() => tipsRepository.fetchAll()).called(1);
      }
    );

    blocTest<EmployeeTipsListBloc, EmployeeTipsListState>(
      "InitTipList event on error changes state: [loading: true], [loading: false, errorMessage: error]",
      build: () {
        _tips = List.generate(10, (index) => MockEmployeeTip());
        when(() => tipsRepository.fetchAll()).thenThrow(ApiException(error: "error"));
        return employeeTipsListBloc;
      },
      act: (bloc) => bloc.add(InitTipList()),
      expect: () => [_baseState.update(loading: true), _baseState.update(loading: false, errorMessage: "error")]
    );

    blocTest<EmployeeTipsListBloc, EmployeeTipsListState>(
      "FetchAll event changes state: [loading: true, tips: [], nextUrl: null, hasReachedEnd: false, errorMessage: ''], [loading: false, tips: tips, nextUrl: null, hasReachedEnd: true]",
      build: () {
        _tips = List.generate(10, (index) => MockEmployeeTip());
        when(() => tipsRepository.fetchAll()).thenAnswer((_) async => PaginateDataHolder(data: _tips, next: null));
        return employeeTipsListBloc;
      },
      seed: () => _baseState.update(tips: List.generate(4, (index) => MockEmployeeTip()), nextUrl: "next-url", hasReachedEnd: false, errorMessage: "error"),
      act: (bloc) => bloc.add(FetchAll()),
      expect: () => [_baseState.update(loading: true, tips: [], nextUrl: null, hasReachedEnd: true, errorMessage: ''), _baseState.update(loading: false, tips: _tips, nextUrl: null, hasReachedEnd: true)]
    );

    blocTest<EmployeeTipsListBloc, EmployeeTipsListState>(
      "FetchAll event calls tipsRepository.fetchAll()",
      build: () {
        _tips = List.generate(10, (index) => MockEmployeeTip());
        when(() => tipsRepository.fetchAll()).thenAnswer((_) async => PaginateDataHolder(data: _tips, next: null));
        return employeeTipsListBloc;
      },
      seed: () => _baseState.update(tips: List.generate(4, (index) => MockEmployeeTip()), nextUrl: "next-url", hasReachedEnd: false, errorMessage: "error"),
      act: (bloc) => bloc.add(FetchAll()),
      verify: (_) {
        verify(() => tipsRepository.fetchAll()).called(1);
      }
    );

    blocTest<EmployeeTipsListBloc, EmployeeTipsListState>(
      "FetchAll event on error changes state: [loading: true, tips: [], nextUrl: null, hasReachedEnd: false, errorMessage: ''], [loading: false, tips: tips, nextUrl: null, hasReachedEnd: true]",
      build: () {
        _tips = List.generate(10, (index) => MockEmployeeTip());
        when(() => tipsRepository.fetchAll()).thenThrow(ApiException(error: "error"));
        return employeeTipsListBloc;
      },
      seed: () => _baseState.update(tips: List.generate(4, (index) => MockEmployeeTip()), nextUrl: "next-url", hasReachedEnd: false, errorMessage: "error"),
      act: (bloc) => bloc.add(FetchAll()),
      expect: () => [_baseState.update(loading: true, tips: [], nextUrl: null, hasReachedEnd: true, errorMessage: ''), _baseState.update(loading: false, errorMessage: "error", hasReachedEnd: true)]
    );

    blocTest<EmployeeTipsListBloc, EmployeeTipsListState>(
      "FetchMore event changes state: [loading: false, tips: moreTips, nextUrl: null, hasReachedEnd: true]",
      build: () {
        _paginatedTips = List.generate(5, (index) => MockEmployeeTip());
        when(() => tipsRepository.paginate(url: any(named: "url"))).thenAnswer((_) async => PaginateDataHolder(data: _paginatedTips, next: null));
        return employeeTipsListBloc;
      },
      seed: () {
        _tips = List.generate(10, (index) => MockEmployeeTip());
        return _baseState.update(tips: _tips, nextUrl: "next-url", hasReachedEnd: false);
      },
      act: (bloc) => bloc.add(FetchMore()),
      expect: () => [_baseState.update(loading: false, tips: _tips + _paginatedTips, nextUrl: null, hasReachedEnd: true)]
    );

    blocTest<EmployeeTipsListBloc, EmployeeTipsListState>(
      "FetchMore event calls tipsRepository.paginate()",
      build: () {
        _paginatedTips = List.generate(5, (index) => MockEmployeeTip());
        when(() => tipsRepository.paginate(url: any(named: "url"))).thenAnswer((_) async => PaginateDataHolder(data: _paginatedTips, next: null));
        return employeeTipsListBloc;
      },
      seed: () {
        _tips = List.generate(10, (index) => MockEmployeeTip());
        return _baseState.update(tips: _tips, nextUrl: "next-url", hasReachedEnd: false);
      },
      act: (bloc) => bloc.add(FetchMore()),
      verify: (_) {
        verify(() => tipsRepository.paginate(url: any(named: "url"))).called(1);
      }
    );

    blocTest<EmployeeTipsListBloc, EmployeeTipsListState>(
      "FetchMore event on error changes state: [loading: false, tips: moreTips, nextUrl: null, hasReachedEnd: true]",
      build: () {
        when(() => tipsRepository.paginate(url: any(named: "url"))).thenThrow(ApiException(error: "error"));
        return employeeTipsListBloc;
      },
      seed: () {
        _tips = List.generate(10, (index) => MockEmployeeTip());
        _baseState = _baseState.update(tips: _tips, nextUrl: "next-url", hasReachedEnd: false);
        return _baseState;
      },
      act: (bloc) => bloc.add(FetchMore()),
      expect: () => [_baseState.update(loading: false, errorMessage: "error")]
    );

    blocTest<EmployeeTipsListBloc, EmployeeTipsListState>(
      "FetchMore event never calls tipsRepository.paginate() if loading",
      build: () {
        _paginatedTips = List.generate(5, (index) => MockEmployeeTip());
        when(() => tipsRepository.paginate(url: any(named: "url"))).thenAnswer((_) async => PaginateDataHolder(data: _paginatedTips, next: null));
        return employeeTipsListBloc;
      },
      seed: () {
        _tips = List.generate(10, (index) => MockEmployeeTip());
        return _baseState.update(loading: true, tips: _tips, nextUrl: "next-url", hasReachedEnd: false);
      },
      act: (bloc) => bloc.add(FetchMore()),
      verify: (_) {
        verifyNever(() => tipsRepository.paginate(url: any(named: "url")));
      }
    );

    blocTest<EmployeeTipsListBloc, EmployeeTipsListState>(
      "FetchMore event never calls tipsRepository.paginate() if hasReachedEnd",
      build: () {
        _paginatedTips = List.generate(5, (index) => MockEmployeeTip());
        when(() => tipsRepository.paginate(url: any(named: "url"))).thenAnswer((_) async => PaginateDataHolder(data: _paginatedTips, next: null));
        return employeeTipsListBloc;
      },
      seed: () {
        _tips = List.generate(10, (index) => MockEmployeeTip());
        return _baseState.update(tips: _tips, nextUrl: "next-url", hasReachedEnd: true);
      },
      act: (bloc) => bloc.add(FetchMore()),
      verify: (_) {
        verifyNever(() => tipsRepository.paginate(url: any(named: "url")));
      }
    );

    blocTest<EmployeeTipsListBloc, EmployeeTipsListState>(
      "DateRangeChanged event changes state: [currentDateRange: dateRange, isDateReset: false], [loading: true, tips: [], nextUrl: null, hasReachedEnd: true], [loading: false, tips: tips, nextUrl: nextUrl, hasReachedEnd: false]",
      build: () => employeeTipsListBloc,
      seed: () {
        _baseState = _baseState.update(tips: List.generate(10, (index) => MockEmployeeTip()), nextUrl: "next-url", hasReachedEnd: false);
        return _baseState;
      },
      act: (bloc) {
        _dateRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());
        _tips = List.generate(5, (index) => MockEmployeeTip());
        when(() => tipsRepository.fetchAll(dateRange: _dateRange)).thenAnswer((_) async => PaginateDataHolder(data: _tips, next: "next"));
        return bloc.add(DateRangeChanged(dateRange: _dateRange));
      },
      expect: () {
        EmployeeTipsListState firstState = _baseState.update(currentDateRange: _dateRange, isDateReset: false);
        EmployeeTipsListState secondState = _baseState.update(currentDateRange: _dateRange, loading: true, tips: [], nextUrl: null, hasReachedEnd: true);
        EmployeeTipsListState thirdState = _baseState.update(currentDateRange: _dateRange, loading: false, tips: _tips, nextUrl: "next", hasReachedEnd: false);

        return [firstState, secondState, thirdState ];
      }
    );

    blocTest<EmployeeTipsListBloc, EmployeeTipsListState>(
      "DateRangeChanged event calls tipsRepository.fetchAll()",
      build: () => employeeTipsListBloc,
      seed: () {
        _baseState = _baseState.update(tips: List.generate(10, (index) => MockEmployeeTip()), nextUrl: "next-url", hasReachedEnd: false);
        return _baseState;
      },
      act: (bloc) {
        _dateRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());
        _tips = List.generate(5, (index) => MockEmployeeTip());
        when(() => tipsRepository.fetchAll(dateRange: _dateRange)).thenAnswer((_) async => PaginateDataHolder(data: _tips, next: "next"));
        return bloc.add(DateRangeChanged(dateRange: _dateRange));
      },
      verify: (_) {
        verify(() => tipsRepository.fetchAll(dateRange: _dateRange)).called(1);
      }
    );

    blocTest<EmployeeTipsListBloc, EmployeeTipsListState>(
      "DateRangeChanged event on error changes state: [currentDateRange: dateRange, isDateReset: false], [loading: true, tips: [], nextUrl: null, hasReachedEnd: true], [loading: false, tips: [], nextUrl: nextUrl, hasReachedEnd: false, errorMessage: error]",
      build: () => employeeTipsListBloc,
      seed: () {
        _baseState = _baseState.update(tips: List.generate(10, (index) => MockEmployeeTip()), nextUrl: "next-url", hasReachedEnd: false);
        return _baseState;
      },
      act: (bloc) {
        _dateRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());
        when(() => tipsRepository.fetchAll(dateRange: _dateRange)).thenThrow(ApiException(error: "error"));
        return bloc.add(DateRangeChanged(dateRange: _dateRange));
      },
      expect: () {
        EmployeeTipsListState firstState = _baseState.update(currentDateRange: _dateRange, isDateReset: false);
        EmployeeTipsListState secondState = _baseState.update(currentDateRange: _dateRange, loading: true, tips: [], nextUrl: null, hasReachedEnd: true);
        EmployeeTipsListState thirdState = _baseState.update(currentDateRange: _dateRange, loading: false, tips: [], nextUrl: null, hasReachedEnd: true, errorMessage: "error");

        return [firstState, secondState, thirdState ];
      }
    );

    blocTest<EmployeeTipsListBloc, EmployeeTipsListState>(
      "DateRangeChanged event never calls tipsRepository.fetchAll() if dateRange does not change",
      build: () => employeeTipsListBloc,
      seed: () {
        _dateRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());
        _baseState = _baseState.update(currentDateRange: _dateRange, tips: List.generate(10, (index) => MockEmployeeTip()), nextUrl: "next-url", hasReachedEnd: false);
        return _baseState;
      },
      act: (bloc) {
        _tips = List.generate(5, (index) => MockEmployeeTip());
        when(() => tipsRepository.fetchAll(dateRange: _dateRange)).thenAnswer((_) async => PaginateDataHolder(data: _tips, next: "next"));
        return bloc.add(DateRangeChanged(dateRange: _dateRange));
      },
      verify: (_) {
        verifyNever(() => tipsRepository.fetchAll(dateRange: _dateRange));
      }
    );
  });
}