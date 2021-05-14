part of 'photos_form_bloc.dart';

abstract class PhotosFormEvent extends Equatable {
  const PhotosFormEvent();

  @override
  List<Object> get props => [];
}

class LogoFilePicked extends PhotosFormEvent {
  final PickedFile logo;

  const LogoFilePicked({required this.logo});

  @override
  List<Object> get props => [logo];

  @override
  String toString() => "LogoFilePicked { logo: $logo }";
}

class BannerFilePicked extends PhotosFormEvent {
  final PickedFile banner;

  const BannerFilePicked({required this.banner});

  @override
  List<Object> get props => [banner];

  @override
  String toString() => "BannerFilePicked { banner: $banner }";
}

class Submitted extends PhotosFormEvent {
  final String identifier;

  const Submitted({required this.identifier});

  @override
  List<Object> get props => [identifier];

  @override
  String toString() => "Submitted { identifier: $identifier }";
}

class Reset extends PhotosFormEvent {}