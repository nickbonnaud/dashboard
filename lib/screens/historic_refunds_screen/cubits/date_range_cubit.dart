import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class DateRangeCubit extends Cubit<DateTimeRange?> {
  DateRangeCubit() : super(null);

  void dateRangeChanged({@required DateTimeRange? dateRange}) => emit(dateRange);
}
