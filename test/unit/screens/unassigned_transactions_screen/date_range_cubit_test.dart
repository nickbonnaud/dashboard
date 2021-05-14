import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/screens/unassigned_transactions_screen/cubit/date_range_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Date Range Cubit Tests", () {
    late DateRangeCubit dateRangeCubit;

    late DateTimeRange _dateRange;

    setUp(() {
      dateRangeCubit = DateRangeCubit();
    });

    tearDown(() {
      dateRangeCubit.close();
    });

    test("Initial state of DateRangeCubit is null", () {
      expect(dateRangeCubit.state, null);
    });

    blocTest<DateRangeCubit, DateTimeRange?>(
      "DateRangeChanged event changes state to DateTimeRange",
      build: () => dateRangeCubit,
      act: (cubit) {
        _dateRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());
        return cubit.dateRangeChanged(dateRange: _dateRange);
      },
      expect: () => [_dateRange]
    );
  });
}