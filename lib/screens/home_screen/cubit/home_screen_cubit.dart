import 'package:bloc/bloc.dart';

class HomeScreenCubit extends Cubit<int> {
  HomeScreenCubit() : super(0);

  void tabChanged({required int currentTab}) => emit(currentTab);
}
