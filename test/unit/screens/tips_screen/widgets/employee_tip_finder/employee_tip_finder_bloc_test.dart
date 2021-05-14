import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/models/business/employee_tip.dart';
import 'package:dashboard/repositories/tips_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/tips_screen/cubits/date_range_cubit.dart';
import 'package:dashboard/screens/tips_screen/widgets/widgets/employee_tip_finder/bloc/employee_tip_finder_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTipsRepository extends Mock implements TipsRepository {}
class MockEmployeeTip extends Mock implements EmployeeTip {}

void main() {
  group("Employee Tip Finder Bloc Tests", () {
    late TipsRepository tipsRepository;
    late EmployeeTipFinderBloc employeeTipFinderBloc;
    late DateRangeCubit dateRangeCubit;

    late EmployeeTipFinderState _baseState;
    late String _firstName;
    late String _lastName;
    late List<EmployeeTip> _tips;
    late List<EmployeeTip> _previousTips;
    late DateTimeRange _dateRange;

    setUp(() {
      tipsRepository = MockTipsRepository();
      dateRangeCubit = DateRangeCubit();
      employeeTipFinderBloc = EmployeeTipFinderBloc(tipsRepository: tipsRepository, dateRangeCubit: dateRangeCubit);
      _baseState = employeeTipFinderBloc.state;
    });

    tearDown(() {
      dateRangeCubit.close();
      employeeTipFinderBloc.close();
    });

    test("Initial state of EmployeeTipFinderBloc is EmployeeTipFinderState.initial(currentDateRange: dateRangeCubit.state)", () {
      expect(employeeTipFinderBloc.state, EmployeeTipFinderState.initial(currentDateRange: dateRangeCubit.state));
    });

    blocTest<EmployeeTipFinderBloc, EmployeeTipFinderState>(
      "Fetch event changes state: [loading: true, currentFirstName: firstName, currentLastName: lastName], [loading: false, tips: _tips, currentFirstName: _firstName, currentLastName: _lastName]",
      build: () {
        _firstName = "first";
        _lastName = "last";
        _tips = List.generate(10, (index) => MockEmployeeTip());
        when(() => tipsRepository.fetchByCustomerName(firstName: _firstName, lastName: _lastName))
          .thenAnswer((_) async => _tips);
        return employeeTipFinderBloc;
      },
      act: (bloc) => bloc.add(Fetch(firstName: _firstName, lastName: _lastName)),
      expect: () => [_baseState.update(loading: true, currentFirstName: _firstName, currentLastName: _lastName), _baseState.update(loading: false, tips: _tips, currentFirstName: _firstName, currentLastName: _lastName)]
    );

    blocTest<EmployeeTipFinderBloc, EmployeeTipFinderState>(
      "Fetch event calls tipsRepository.fetchByCustomerName()",
      build: () {
        _firstName = "first";
        _lastName = "last";
        _tips = List.generate(10, (index) => MockEmployeeTip());
        when(() => tipsRepository.fetchByCustomerName(firstName: _firstName, lastName: _lastName))
          .thenAnswer((_) async => _tips);
        return employeeTipFinderBloc;
      },
      act: (bloc) => bloc.add(Fetch(firstName: _firstName, lastName: _lastName)),
      verify: (_) {
        verify(() => tipsRepository.fetchByCustomerName(firstName: any(named: "firstName"), lastName: any(named: "lastName"))).called(1);
      }
    );

    blocTest<EmployeeTipFinderBloc, EmployeeTipFinderState>(
      "Fetch event on error changes state: [loading: true, currentFirstName: firstName, currentLastName: lastName]",
      build: () {
        _firstName = "first";
        _lastName = "last";
        _tips = List.generate(10, (index) => MockEmployeeTip());
        when(() => tipsRepository.fetchByCustomerName(firstName: _firstName, lastName: _lastName))
          .thenThrow(ApiException(error: "error"));
        return employeeTipFinderBloc;
      },
      act: (bloc) => bloc.add(Fetch(firstName: _firstName, lastName: _lastName)),
      expect: () => [_baseState.update(loading: true, currentFirstName: _firstName, currentLastName: _lastName), _baseState.update(loading: false, errorMessage: "error", currentFirstName: _firstName, currentLastName: _lastName)]
    );

    blocTest<EmployeeTipFinderBloc, EmployeeTipFinderState>(
      "DateRangeChanged event changes state: [currentDateRange: dateRange, isDateReset: false] [loading: true, currentFirstName: firstName, currentLastName: lastName], [loading: false, tips: _tips, currentFirstName: _firstName, currentLastName: _lastName]",
      build: () {
        _tips = List.generate(10, (index) => MockEmployeeTip());
        when(() => tipsRepository.fetchByCustomerName(firstName: any(named: "firstName"), lastName: any(named: "lastName"), dateRange: any(named: "dateRange")))
          .thenAnswer((_) async => _tips);
        return employeeTipFinderBloc;
      },
      seed: () {
        _firstName = "First";
        _lastName = "Last";
        _previousTips = List.generate(5, (index) => MockEmployeeTip());
        return _baseState.update(currentFirstName: _firstName, currentLastName: _lastName, tips: _previousTips);
      },
      act: (bloc) {
        _dateRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());
        return bloc.add(DateRangeChanged(dateRange: _dateRange));
      },
      expect: () => [
        _baseState.update(currentDateRange: _dateRange, tips: _previousTips, isDateReset: false, currentFirstName: _firstName, currentLastName: _lastName),
        _baseState.update(loading: true, tips: [], currentDateRange: _dateRange, isDateReset: false, currentFirstName: _firstName, currentLastName: _lastName),
        _baseState.update(loading: false, tips: _tips, currentDateRange: _dateRange, isDateReset: false, currentFirstName: _firstName, currentLastName: _lastName),
      ]
    );

    blocTest<EmployeeTipFinderBloc, EmployeeTipFinderState>(
      "DateRangeChanged event calls _tipsRepository.fetchByCustomerName()",
      build: () {
        _tips = List.generate(10, (index) => MockEmployeeTip());
        when(() => tipsRepository.fetchByCustomerName(firstName: any(named: "firstName"), lastName: any(named: "lastName"), dateRange: any(named: "dateRange")))
          .thenAnswer((_) async => _tips);
        return employeeTipFinderBloc;
      },
      seed: () {
        _firstName = "First";
        _lastName = "Last";
        _previousTips = List.generate(5, (index) => MockEmployeeTip());
        return _baseState.update(currentFirstName: _firstName, currentLastName: _lastName, tips: _previousTips);
      },
      act: (bloc) {
        _dateRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());
        return bloc.add(DateRangeChanged(dateRange: _dateRange));
      },
      verify: (_) {
        verify(() => tipsRepository.fetchByCustomerName(firstName: any(named: "firstName"), lastName: any(named: "lastName"), dateRange: any(named: "dateRange"))).called(1);
      }
    );

    blocTest<EmployeeTipFinderBloc, EmployeeTipFinderState>(
      "DateRangeChanged event on error changes state: [currentDateRange: dateRange, isDateReset: false] [loading: true, currentFirstName: firstName, currentLastName: lastName], [loading: false, tips: _tips, currentFirstName: _firstName, currentLastName: _lastName]",
      build: () {
        _tips = List.generate(10, (index) => MockEmployeeTip());
        when(() => tipsRepository.fetchByCustomerName(firstName: any(named: "firstName"), lastName: any(named: "lastName"), dateRange: any(named: "dateRange")))
          .thenThrow(ApiException(error: "error"));
        return employeeTipFinderBloc;
      },
      seed: () {
        _firstName = "First";
        _lastName = "Last";
        _previousTips = List.generate(5, (index) => MockEmployeeTip());
        return _baseState.update(currentFirstName: _firstName, currentLastName: _lastName, tips: _previousTips);
      },
      act: (bloc) {
        _dateRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());
        return bloc.add(DateRangeChanged(dateRange: _dateRange));
      },
      expect: () => [
        _baseState.update(currentDateRange: _dateRange, tips: _previousTips, isDateReset: false, currentFirstName: _firstName, currentLastName: _lastName),
        _baseState.update(loading: true, tips: [], currentDateRange: _dateRange, isDateReset: false, currentFirstName: _firstName, currentLastName: _lastName),
        _baseState.update(loading: false, tips: [], errorMessage: "error", currentDateRange: _dateRange, isDateReset: false, currentFirstName: _firstName, currentLastName: _lastName),
      ]
    );

    blocTest<EmployeeTipFinderBloc, EmployeeTipFinderState>(
      "DateRangeChanged event does not call _tipsRepository.fetchByCustomerName() if dateRange not change",
      build: () {
        _tips = List.generate(10, (index) => MockEmployeeTip());
        when(() => tipsRepository.fetchByCustomerName(firstName: any(named: "firstName"), lastName: any(named: "lastName"), dateRange: any(named: "dateRange")))
          .thenAnswer((_) async => _tips);
        return employeeTipFinderBloc;
      },
      seed: () {
        _firstName = "First";
        _lastName = "Last";
        _previousTips = List.generate(5, (index) => MockEmployeeTip());
        _dateRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());
        return _baseState.update(currentFirstName: _firstName, currentLastName: _lastName, tips: _previousTips, currentDateRange: _dateRange);
      },
      act: (bloc) {
        return bloc.add(DateRangeChanged(dateRange: _dateRange));
      },
      verify: (_) {
        verifyNever(() => tipsRepository.fetchByCustomerName(firstName: any(named: "firstName"), lastName: any(named: "lastName"), dateRange: any(named: "dateRange")));
      }
    );

    blocTest<EmployeeTipFinderBloc, EmployeeTipFinderState>(
      "DateRangeChanged event does not call _tipsRepository.fetchByCustomerName() if customerName is empty",
      build: () {
        _tips = List.generate(10, (index) => MockEmployeeTip());
        when(() => tipsRepository.fetchByCustomerName(firstName: any(named: "firstName"), lastName: any(named: "lastName"), dateRange: any(named: "dateRange")))
          .thenAnswer((_) async => _tips);
        return employeeTipFinderBloc;
      },
      seed: () {
        _firstName = "";
        _lastName = "";
        _previousTips = List.generate(5, (index) => MockEmployeeTip());
        _dateRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());
        return _baseState.update(currentFirstName: _firstName, currentLastName: _lastName, tips: _previousTips, currentDateRange: _dateRange);
      },
      act: (bloc) {
        return bloc.add(DateRangeChanged(dateRange: DateTimeRange(start: DateTime.now(), end: DateTime.now())));
      },
      verify: (_) {
        verifyNever(() => tipsRepository.fetchByCustomerName(firstName: any(named: "firstName"), lastName: any(named: "lastName"), dateRange: any(named: "dateRange")));
      }
    );
  });
}