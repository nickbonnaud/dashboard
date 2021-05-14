import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/screens/customers_screen/cubit/date_range_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Date Range Cubit Tests", () {
    late DateRangeCubit dateRangeCubit;
    late DateTimeRange baseDateRange;
    
    setUp(() {
      dateRangeCubit = DateRangeCubit();
      baseDateRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());
    });

    tearDown(() {
      dateRangeCubit.close();
    });

    test("Initial state of DateRangeCubit is null", () {
      expect(dateRangeCubit.state, null);
    });

    blocTest<DateRangeCubit, DateTimeRange?>(
      "DateRangeChanged event emits a DateTimeRange", 
      build: () => dateRangeCubit,
      act: (cubit) => cubit.dateRangeChanged(dateRange: baseDateRange),
      expect: () => [baseDateRange]
    );
  });
}