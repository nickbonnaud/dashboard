import 'package:bloc/bloc.dart';
import 'package:dashboard/models/transaction_filter.dart';

class FilterButtonCubit extends Cubit<FilterType> {
  FilterButtonCubit() : super(FilterType.all);

  void filterChanged({required FilterType filter}) => emit(filter);
}
