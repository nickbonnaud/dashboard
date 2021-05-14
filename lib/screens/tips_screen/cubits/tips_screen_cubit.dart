import 'package:bloc/bloc.dart';

class TipsScreenCubit extends Cubit<bool> {
  TipsScreenCubit() : super(true);

  void toggle() => emit(!state);
}