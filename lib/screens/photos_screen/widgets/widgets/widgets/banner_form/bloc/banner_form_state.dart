part of 'banner_form_bloc.dart';

@immutable
class BannerFormState extends Equatable {
  final Photo initialBanner;
  final PickedFile? bannerFile;

  const BannerFormState({required this.initialBanner, required this.bannerFile});

  factory BannerFormState.initial({required Photo banner}) {
    return BannerFormState(initialBanner: banner, bannerFile: null);
  }

  BannerFormState update({required PickedFile bannerFile}) {
    return BannerFormState(initialBanner: this.initialBanner, bannerFile: bannerFile);
  }
  
  @override
  List<Object?> get props => [initialBanner, bannerFile];

  @override
  String toString() => 'BannerFormState: { initialBanner: $initialBanner, bannerFile: $bannerFile }';
}
