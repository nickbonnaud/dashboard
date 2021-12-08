part of 'photos_form_bloc.dart';

@immutable
class PhotosFormState extends Equatable {
  final XFile? logoFile;
  final XFile? bannerFile;
  final bool isSubmitting;
  final bool isSuccess;
  final String errorMessage;
  final CustomAnimationControl errorButtonControl;

  const PhotosFormState({
    required this.logoFile,
    required this.bannerFile,
    required this.isSubmitting,
    required this.isSuccess,
    required this.errorMessage,
    required this.errorButtonControl
  });

  bool get photosValid => logoFile != null && bannerFile != null;

  factory PhotosFormState.intial() {
    return PhotosFormState(
      logoFile: null,
      bannerFile: null,
      isSubmitting: false,
      isSuccess: false,
      errorMessage: "",
      errorButtonControl: CustomAnimationControl.stop,
    );
  }

  PhotosFormState update({
    XFile? logoFile,
    XFile? bannerFile,
    bool? photosValid,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
    CustomAnimationControl? errorButtonControl
  }) {
    return _copyWith(
      logoFile: logoFile,
      bannerFile: bannerFile,
      photosValid: photosValid,
      isSubmitting: isSubmitting,
      isSuccess: isSuccess,
      errorMessage: errorMessage,
      errorButtonControl: errorButtonControl
    );
  }

  PhotosFormState _copyWith({
    XFile? logoFile,
    XFile? bannerFile,
    bool? photosValid,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
    CustomAnimationControl? errorButtonControl
  }) {
    return PhotosFormState(
      logoFile: logoFile ?? this.logoFile,
      bannerFile: bannerFile ?? this.bannerFile,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      errorButtonControl: errorButtonControl ?? this.errorButtonControl
    );
  }
  
  @override
  List<Object?> get props => [
    logoFile,
    bannerFile,
    isSubmitting,
    isSuccess,
    errorMessage,
    errorButtonControl
  ];

  @override
  String toString() => 'PhotosFormState { logoFile: $logoFile, bannerFile: $bannerFile, isSubmitting: $isSubmitting, isSuccess: $isSuccess, errorMessage: $errorMessage, errorButtonControl: $errorButtonControl }';
}
