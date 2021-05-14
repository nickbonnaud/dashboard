import 'package:bloc/bloc.dart';


class PhotosScreenCubit extends Cubit<int> {
  PhotosScreenCubit() : super(0);

  void next() => emit(state + 1);
  void previous() => emit(state - 1);
}
