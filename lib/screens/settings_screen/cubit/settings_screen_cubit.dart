import 'package:bloc/bloc.dart';


class SettingsScreenCubit extends Cubit<bool> {
  SettingsScreenCubit() : super(true);

  void unlock() => emit(false);
  void lock() => emit(true);
}
