part of 'banner_form_bloc.dart';

abstract class BannerFormEvent extends Equatable {
  const BannerFormEvent();

  @override
  List<Object> get props => [];
}

class BannerPicked extends BannerFormEvent {
  final PickedFile bannerFile;

  const BannerPicked({required this.bannerFile});

  @override
  List<Object> get props => [bannerFile];

  @override
  String toString() => 'BannerPicked { bannerFile: $bannerFile }';
}
