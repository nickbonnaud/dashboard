part of 'profile_screen_bloc.dart';

@immutable
class ProfileScreenState extends Equatable {
  final String placeQuery;

  final PlaceDetails? selectedPrediction;
  final List<Prediction> predictions;

  final String name;
  final String website;
  final String description;
  final String phone;

  final bool isNameValid;
  final bool isWebsiteValid;
  final bool isDescriptionValid;
  final bool isPhoneValid;
  final bool isSubmitting;
  final bool isSuccess;
  final String errorMessage;
  final CustomAnimationControl errorButtonControl;

  bool get isFormValid => 
    isNameValid && name.isNotEmpty && 
    isWebsiteValid && website.isNotEmpty && 
    isDescriptionValid && description.isNotEmpty && 
    isPhoneValid && phone.isNotEmpty;

  const ProfileScreenState({
    required this.placeQuery,

    this.selectedPrediction,
    required this.predictions,

    required this.name,
    required this.website,
    required this.description,
    required this.phone,

    required this.isNameValid,
    required this.isWebsiteValid,
    required this.isDescriptionValid,
    required this.isPhoneValid,
    required this.isSubmitting,
    required this.isSuccess,
    required this.errorMessage,
    required this.errorButtonControl,
  });

  factory ProfileScreenState.empty({required Profile profile}) {
    return ProfileScreenState(
      placeQuery: "",

      selectedPrediction: null,
      predictions: const [],

      name: profile.name,
      website: profile.website,
      description: profile.description,
      phone: profile.phone,

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
    String? placeQuery,

    PlaceDetails? selectedPrediction,
    List<Prediction>? predictions,

    String? name,
    String? website,
    String? description,
    String? phone,

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
      placeQuery: placeQuery ?? this.placeQuery,

      selectedPrediction: selectedPrediction ?? this.selectedPrediction,
      predictions: predictions ?? this.predictions,

      name: name ?? this.name,
      website: website ?? this.website,
      description: description ?? this.description,
      phone: phone ?? this.phone,

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
    placeQuery,

    selectedPrediction,
    predictions,

    name,
    website,
    description,
    phone,

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
      placeQuery: $placeQuery,
      
      selectedPrediction: $selectedPrediction,
      predictions: $predictions,

      name: $name,
      website: $website,
      description: $description,
      phone: $phone,

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
