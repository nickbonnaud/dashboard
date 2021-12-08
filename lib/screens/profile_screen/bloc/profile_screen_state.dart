part of 'profile_screen_bloc.dart';

@immutable
class ProfileScreenState extends Equatable {
  final PlaceDetails? selectedPrediction;
  final List<Prediction> predictions;
  final bool isNameValid;
  final bool isWebsiteValid;
  final bool isDescriptionValid;
  final bool isPhoneValid;
  final bool isSubmitting;
  final bool isSuccess;
  final String errorMessage;
  final CustomAnimationControl errorButtonControl;

  bool get isFormValid => isNameValid && isWebsiteValid && isDescriptionValid && isPhoneValid;

  const ProfileScreenState({
    this.selectedPrediction,
    required this.predictions,
    required this.isNameValid,
    required this.isWebsiteValid,
    required this.isDescriptionValid,
    required this.isPhoneValid,
    required this.isSubmitting,
    required this.isSuccess,
    required this.errorMessage,
    required this.errorButtonControl,
  });

  factory ProfileScreenState.empty() {
    return ProfileScreenState(
      selectedPrediction: null,
      predictions: [],
      isNameValid: true,
      isWebsiteValid: true,
      isDescriptionValid: true,
      isPhoneValid: true,
      isSubmitting: false,
      isSuccess: false,
      errorMessage: '',
      errorButtonControl: CustomAnimationControl.stop,
    );
  }

  ProfileScreenState update({
    PlaceDetails? selectedPrediction,
    List<Prediction>? predictions,
    bool? isNameValid,
    bool? isWebsiteValid,
    bool? isDescriptionValid,
    bool? isPhoneValid,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
    CustomAnimationControl? errorButtonControl,
  }) {
    return ProfileScreenState(
      selectedPrediction: selectedPrediction ?? this.selectedPrediction,
      predictions: predictions ?? this.predictions,
      isNameValid: isNameValid ?? this.isNameValid,
      isWebsiteValid: isWebsiteValid ?? this.isWebsiteValid,
      isDescriptionValid: isDescriptionValid ?? this.isDescriptionValid,
      isPhoneValid: isPhoneValid ?? this.isPhoneValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      errorButtonControl: errorButtonControl ?? this.errorButtonControl,
    );
  }

  @override
  List<Object?> get props => [
    selectedPrediction,
    predictions,
    isNameValid,
    isWebsiteValid,
    isDescriptionValid,
    isPhoneValid,
    isSubmitting,
    isSuccess,
    errorMessage,
    errorButtonControl,
  ];
  
  @override
  String toString() {
    return '''ProfileScreenState {
      selectedPrediction: $selectedPrediction,
      predictions: $predictions,
      isNameValid: $isNameValid,
      isWebsiteValid: $isWebsiteValid,
      isDescriptionValid: $isDescriptionValid,
      isPhoneValid: $isPhoneValid,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      errorMessage: $errorMessage,
      errorButtonControl: $errorButtonControl,
    }''';
  }
}
