import 'package:bloc/bloc.dart';

class UnlockedFormCubit extends Cubit<int> {
  UnlockedFormCubit() : super(0);

  void next() => emit(state + 1);
  void previous() => emit(state - 1);
}
